//
// PlayerRow.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// The pattern last played: one row collapsed, which grows into its details. Dragging anywhere on it
/// resizes it under the finger, and letting go settles on the nearest size, carried by the flick.
struct PlayerRow: View {
    static let snap = Animation.spring(duration: 0.42, bounce: 0.18)
    /// For scrolling the details to an edge: as long as `snap`, but without its bounce. A scroll view
    /// can't overshoot its edge, so a bouncing scroll there stopped short of it, cutting off the timeline.
    private static let scrollSnap = Animation.spring(duration: 0.42, bounce: 0)
    /// Between the row and the details.
    private static let detailsGap: CGFloat = 16
    /// How far past the top of the full details a pull drops to the summary.
    private static let pullToShrink: CGFloat = 64

    let pattern: HapticPattern
    let playback: HapticDemoModel.Playback?
    @Binding var size: NowPlayingBar.Size
    /// The tallest the row may grow, inside the bar's padding.
    let maxHeight: CGFloat
    let layout: NowPlayingLayout

    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    /// How far the finger has moved since the drag began: negative is up.
    @State private var dragTranslation: CGFloat = 0
    @State private var rowHeight: CGFloat = 44
    /// Where the summary ends in the details, and where they all end.
    @State private var summaryEnd: CGFloat = 0
    @State private var detailsEnd: CGFloat = 0
    /// The similar patterns pinned along the full size's bottom.
    @State private var footerHeight: CGFloat = 0
    /// How far the full details are pulled down past their top.
    @State private var overscroll: CGFloat = 0
    /// How far the details are scrolled from their top, as `ScrollPosition` measures it, and whether to
    /// their end.
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolledToEnd = false
    /// How far the details were scrolled when a resize from the full size began, which they give up as
    /// the bar shrinks. `nil` while not resizing, or when it began smaller.
    @State private var resizeStartScroll: CGFloat?
    @State private var scrollPosition = ScrollPosition(edge: .top)
    /// Whether the details are built. Only while open or opening: built collapsed, they cost the first
    /// play a frame, and every play after it a rebuild nobody sees.
    @State private var showsDetails = false
    /// A size to open to once the details have been measured, the first time they're built.
    @State private var pendingSize: NowPlayingBar.Size?

    private var isPlaying: Bool { playback != nil }

    private func height(of size: NowPlayingBar.Size) -> CGFloat {
        switch size {
        case .collapsed: rowHeight
        case .summary: min(rowHeight + Self.detailsGap + summaryEnd, maxHeight)
        // As tall as it may grow whatever the pattern, like a sheet's large size, so playing another from
        // the patterns at its bottom never resizes it. Only without a limit, in previews, does it fit.
        case .full: max(maxHeight.isFinite ? maxHeight : rowHeight + Self.detailsGap + detailsEnd + footerHeight, height(of: .summary))
        }
    }

    /// The settled size's height, moved by the finger. Past the smallest or largest size it gives less
    /// and less, as a sheet does.
    private var height: CGFloat {
        let proposed = height(of: size) - dragTranslation
        let low = height(of: .collapsed)
        let high = height(of: .full)
        if proposed < low { return low - (low - proposed) * 0.2 }
        if proposed > high { return high + (proposed - high) * 0.3 }
        return proposed
    }

    /// How far the details have opened, from 0 collapsed to 1 at the summary.
    private var openness: CGFloat {
        let range = height(of: .summary) - height(of: .collapsed)
        guard range > 0 else { return 0 }
        return min(max((height - height(of: .collapsed)) / range, 0), 1)
    }

    /// How far the bar has opened past the summary, from 0 there to 1 at the full size.
    private var fullness: CGFloat { fullness(at: height) }

    private func fullness(at barHeight: CGFloat) -> CGFloat {
        let range = height(of: .full) - height(of: .summary)
        guard range > 0 else { return size == .full ? 1 : 0 }
        return min(max((barHeight - height(of: .summary)) / range, 0), 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                header
                favoriteButton
                replayButton
            }
            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { rowHeight = $0 }
            // Out to the bar's edges, so a tap or drag anywhere on the collapsed bar works, as in Music.
            .contentShape(Rectangle().inset(by: -NowPlayingBar.verticalPadding))
            .gesture(resize)

            if showsDetails || size != .collapsed {
                details
            }
        }
        .frame(height: max(height, rowHeight), alignment: .top)
        .overlay(alignment: .top) {
            Grabber { setSize(size == .full ? .collapsed : size.larger ?? .collapsed) }
                .offset(y: -NowPlayingBar.verticalPadding)
                .gesture(resize)
        }
        .animation(.snappy, value: playback?.id)
        // The settled size's height, which changes as soon as a resize settles, not with the finger.
        .onChange(of: height(of: size) - height(of: .collapsed), initial: true) { _, openHeight in
            layout.openHeight = max(openHeight, 0)
        }
        // With the finger, so the bar's surface turns solid as it opens.
        .onChange(of: openness, initial: true) { _, openness in
            layout.openness = openness
        }
        // Smaller than full, the details show from their top, so the summary shows its whole timeline.
        .onChange(of: size) { _, size in
            if size != .full { withAnimation(Self.scrollSnap) { scrollPosition.scrollTo(edge: .top) } }
        }
        // Another pattern, from the row along the bottom. Scrolled to the end, as trying one after another
        // leaves them, the details stay at their end whatever the new pattern's length, so the row and the
        // events just above it stay put. Anywhere else, they keep their place.
        .onChange(of: pattern) {
            if size == .full, isScrolledToEnd { scrollPosition.scrollTo(edge: .bottom) }
        }
    }

    /// The details, in a scroll view the bar's height reveals. Only the full size scrolls: smaller, a drag
    /// on them resizes the bar instead.
    private var details: some View {
        ScrollView {
            PatternDetails(
                pattern: pattern,
                playback: playback,
                isFull: size == .full,
                toggleFull: { setSize(size == .full ? .summary : .full) },
                summaryEnd: $summaryEnd
            )
            // Unchanged while the bar is resized, so it isn't rebuilt on every frame of a drag.
            .equatable()
            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { detailsEnd = $0 }
            // Measured: open to the size that was waiting for it.
            .onChange(of: summaryEnd) {
                guard let pendingSize else { return }
                self.pendingSize = nil
                setSize(pendingSize)
            }
        }
        .scrollPosition($scrollPosition)
        .contentMargins(.top, Self.detailsGap, for: .scrollContent)
        // Room to scroll the last details clear of the footer.
        .contentMargins(.bottom, footerHeight, for: .scrollContent)
        .scrollDisabled(size != .full)
        .scrollIndicators(size == .full ? .automatic : .hidden)
        .onScrollGeometryChange(for: CGFloat.self) { -($0.contentOffset.y + $0.contentInsets.top) } action: { _, pull in
            overscroll = pull
        }
        .onScrollGeometryChange(for: CGFloat.self) { $0.contentOffset.y + $0.contentInsets.top } action: { _, offset in
            scrollOffset = offset
        }
        .onScrollGeometryChange(for: Bool.self) { geometry in
            geometry.contentOffset.y + geometry.containerSize.height
                >= geometry.contentSize.height + geometry.contentInsets.bottom - 8
        } action: { _, isAtEnd in
            isScrolledToEnd = isAtEnd
        }
        // Pulled down well past the top, as if to close a sheet: back to the summary.
        .onScrollPhaseChange { old, _ in
            if old == .interacting, overscroll > Self.pullToShrink { setSize(.summary) }
        }
        .frame(height: max(height - rowHeight, 0))
        // Scrolled details fade out beneath the row rather than cut off against it.
        .mask {
            VStack(spacing: 0) {
                LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                    .frame(height: Self.detailsGap)
                Color.black
            }
        }
        // Pinned rather than at the end of the details, so it stays in one place whichever pattern plays.
        .overlay(alignment: .bottom) {
            SimilarPatterns(pattern: pattern)
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { footerHeight = $0 }
                // Only over the last part of the way, so it never shows faintly at the summary, as the
                // bar's spring settles there.
                .opacity(max(fullness - 0.4, 0) / 0.6)
                .allowsHitTesting(size == .full)
                .accessibilityHidden(size != .full)
        }
        .opacity(openness)
        .allowsHitTesting(size != .collapsed)
        .accessibilityHidden(size == .collapsed)
        .gesture(resize, isEnabled: size != .full)
    }

    /// Follows the finger, then settles where the flick would carry the bar. In global coordinates, as
    /// the bar moves under the finger as it grows.
    private var resize: some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .global)
            .onChanged { drag in
                if dragTranslation == 0, size == .full { resizeStartScroll = scrollOffset }
                showsDetails = true
                dragTranslation = drag.translation.height
                // Shrinking from the full size, the details scroll back to their top in step with the bar,
                // reaching it at the summary, so the summary comes into view as it does opening from
                // the collapsed bar. Left scrolled, its timeline was out of sight the whole way down.
                // Setting the offset also stops details still coasting from a flick.
                if let start = resizeStartScroll, start > 0 {
                    scrollPosition.scrollTo(y: start * fullness(at: height(of: size) - drag.translation.height))
                }
            }
            .onEnded { drag in
                let projected = height(of: size) - drag.predictedEndTranslation.height
                let nearest = NowPlayingBar.Size.allCases.min {
                    abs(height(of: $0) - projected) < abs(height(of: $1) - projected)
                } ?? size
                // Back to full: to where the details were. Smaller, `onChange(of: size)` scrolls the rest
                // of the way to their top.
                if nearest == .full, let start = resizeStartScroll, start > 0 {
                    withAnimation(Self.scrollSnap) { scrollPosition.scrollTo(y: start) }
                }
                resizeStartScroll = nil
                withAnimation(Self.snap) {
                    size = nearest
                    dragTranslation = 0
                } completion: {
                    releaseDetailsIfCollapsed()
                }
            }
    }

    private func setSize(_ size: NowPlayingBar.Size) {
        // Never built: build them, and open once they're measured, so the bar knows how far to go.
        if size != .collapsed, summaryEnd == 0 {
            showsDetails = true
            pendingSize = size
            return
        }
        showsDetails = showsDetails || size != .collapsed
        withAnimation(Self.snap) {
            self.size = size
        } completion: {
            releaseDetailsIfCollapsed()
        }
    }

    private func releaseDetailsIfCollapsed() {
        if size == .collapsed, dragTranslation == 0 { showsDetails = false }
    }

    /// A tap on it shows or hides the details: never a replay, so a tap that misses the star can't play
    /// the pattern by surprise.
    private var header: some View {
        HStack(spacing: 12) {
            icon
            VStack(alignment: .leading, spacing: 1) {
                Text(pattern.title)
                    .font(.headline)
                    .lineLimit(1)
                // Open, the full description is below, so this line shows the facts instead. Follows the
                // settled size, not the finger, so the header holds still while the bar is resized:
                // switching halfway, it flickered as a drag crossed back and forth.
                Text(size != .collapsed ? "\(pattern.category.title) · \(pattern.durationText)" : pattern.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    // One line keeps the bar one height; large text needs the room to wrap.
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 3 : 1)
                    .contentTransition(.opacity)
            }
            Spacer(minLength: 0)
        }
        .contentShape(Rectangle().inset(by: -NowPlayingBar.verticalPadding))
        .onTapGesture { setSize(size == .collapsed ? .summary : .collapsed) }
        .accessibilityElement(children: .combine)
        .accessibilityValue(isPlaying ? "Playing" : "")
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("nowPlaying")
        .accessibilityHint(size == .collapsed ? "Shows the details. Swipe up or down to resize." : "Hides the details. Swipe up or down to resize.")
        .accessibilityAction { setSize(size == .collapsed ? .summary : .collapsed) }
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: if let larger = size.larger { setSize(larger) }
            case .decrement: if let smaller = size.smaller { setSize(smaller) }
            @unknown default: break
            }
        }
    }

    /// The same colors whether the pattern is playing or not. It used to fill solid while playing, for at
    /// least `Playback.minimumDisplayDuration`, then turn light again: every play, a chip tap included,
    /// flashed it for a second. The ring and the bounce show a play instead.
    ///
    /// A circle, concentric with the bar's corners: 12 points in from a 32 point curve, a radius of 20.
    /// A rounded square there, and the ring around it, made three curves that didn't line up.
    private var icon: some View {
        Image(systemName: pattern.systemImage)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(pattern.tint)
            .frame(width: 40, height: 40)
            .background(pattern.tint.opacity(0.15), in: .circle)
            .contentTransition(.symbolEffect(.replace))
            // Bounces on every play, including a replay of the same pattern.
            .symbolEffect(.bounce, value: playback?.id)
            .overlay {
                // Every play gets the ring, so every pattern looks alike while it plays: long ones fill it
                // over their length, and ones over in a blink sweep it at a glance.
                if let playback {
                    ProgressRing(duration: max(pattern.duration, ProgressRing.minimumSweep), tint: pattern.tint)
                        .padding(-4)
                        // A new ID restarts the ring when the same pattern plays again.
                        .id(playback.id)
                        .transition(.opacity)
                }
            }
            .accessibilityHidden(true)
    }

    private var favoriteButton: some View {
        let isFavorite = model.isFavorite(pattern)
        return Button {
            withAnimation(.snappy) { model.toggleFavorite(pattern) }
        } label: {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundStyle(isFavorite ? AnyShapeStyle(.yellow) : AnyShapeStyle(.secondary))
                .contentTransition(.symbolEffect(.replace))
                .symbolEffect(.bounce, value: isFavorite)
        }
        .buttonStyle(BarButtonStyle())
        .accessibilityLabel(isFavorite ? "Remove from Favorites" : "Add to Favorites")
    }

    private var replayButton: some View {
        Button {
            model.play(pattern)
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .foregroundStyle(.primary)
        }
        .buttonStyle(BarButtonStyle())
        .accessibilityLabel("Play Again")
    }
}

/// The handle along the bar's top edge, hinting that it can be resized. Tapping it steps to the next
/// size, as a sheet's grabber does.
private struct Grabber: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Capsule()
                .fill(.secondary.opacity(0.4))
                .frame(width: 36, height: 4)
                .padding(.top, 4)
                // Taller than it looks, so it's easy to hit.
                .frame(width: 72, height: 20, alignment: .top)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityHidden(true)
    }
}

/// A plain symbol with a 44 point target, like the controls in Music's mini player.
private struct BarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.weight(.semibold))
            .frame(width: 44, height: 44)
            .contentShape(.rect)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

/// A ring around the icon that fills over the pattern's duration, clockwise from the top. A circle 4
/// points out from the icon: 8 points in from the bar's 32 point curve, so a radius of 24, concentric
/// with both.
private struct ProgressRing: View {
    /// The quickest the ring fills, so a pattern over in a blink still shows a sweep rather than a flash.
    /// Shorter than how long a playback shows, so the ring is seen full before it fades.
    static let minimumSweep: TimeInterval = 0.35

    let duration: TimeInterval
    let tint: Color

    @State private var progress: CGFloat = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(tint, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .onAppear {
                withAnimation(.linear(duration: duration)) { progress = 1 }
            }
    }
}
