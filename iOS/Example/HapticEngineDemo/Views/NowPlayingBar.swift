//
// NowPlayingBar.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// A floating bar pinned to the bottom, like the mini player in Music. It always shows one of:
///
/// - **A tip**, before anything is played: how to play a pattern and how to keep one.
/// - **The pattern last played**, with buttons to star it and play it again. It stays after the pattern
///   ends, so the pattern can still be starred or replayed. The icon alone shows the state: filled in the
///   pattern's color while it plays, light when it's done, with a ring that fills around it as it plays. It opens to three sizes, like a sheet: see `Size`.
/// - **A warning**, on a device without haptic hardware, where nothing can play.
///
/// Collapsed, the bar is one height in every state, so switching between them never moves the patterns.
struct NowPlayingBar: View {
    /// How much of the pattern the bar shows, like a sheet's detents.
    enum Size: CaseIterable {
        /// One row: what's playing, with star and replay.
        case collapsed
        /// Adds the description and timeline: enough to compare what's felt with what's drawn.
        case summary
        /// Adds the numbers, each event, and similar patterns to try next. Scrolls when it's too tall.
        case full

        var larger: Size? { Self.allCases.firstIndex(of: self).flatMap { Self.allCases.dropFirst($0 + 1).first } }
        var smaller: Size? { Self.allCases.firstIndex(of: self).flatMap { $0 > 0 ? Self.allCases[$0 - 1] : nil } }
    }

    static let collapsedHeight: CGFloat = 64
    /// The gap to the screen's sides and bottom. Equal on all three, so the bar's lower corners run
    /// parallel to the screen's.
    static let margin: CGFloat = 12
    /// The bar's padding above and below its content.
    fileprivate static let verticalPadding: CGFloat = 10

    /// The screen's bottom safe area, such as the home indicator's. The bar moves down into it.
    var bottomInset: CGFloat = 0
    /// The tallest the bar may grow, so the navigation bar stays in sight above it.
    var maxHeight: CGFloat = .infinity
    /// Called with the height of the bar's own content when collapsed, padding included, for the room
    /// the patterns leave it. Open, it grows over them instead, so they never move.
    var onCollapsedHeightChange: (CGFloat) -> Void = { _ in }
    /// Called with the top of the bar, in global coordinates, so the patterns can fade out across it.
    var onTopChange: (CGFloat) -> Void = { _ in }

    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var size = Size.collapsed

    private var isPlayer: Bool { model.isHapticsSupported && model.lastPlayed != nil }

    /// Fixed for the tip and the warning, except at accessibility text sizes, where text must never be
    /// cut off. The player sets its own height, which follows the finger while it's dragged.
    private var fixedHeight: CGFloat? {
        isPlayer || dynamicTypeSize.isAccessibilitySize ? nil : Self.collapsedHeight
    }

    var body: some View {
        // One container, so there's one bar whose contents change. A `Group` would give each state its
        // own padding and glass: switching from the tip to the player drew two bars at once, both blurring.
        ZStack(alignment: .topLeading) {
            if !model.isHapticsSupported {
                MessageRow(
                    systemImage: "exclamationmark.triangle.fill",
                    tint: .orange,
                    title: "No Haptics on This Device",
                    message: "Patterns only play on an iPhone."
                )
            } else if let pattern = model.lastPlayed {
                PlayerRow(
                    pattern: pattern,
                    playback: model.nowPlaying,
                    size: $size,
                    maxHeight: maxHeight - Self.verticalPadding * 2
                )
                // The tip and the player share a layout, so only their contents change: the tip leaves
                // quickly, then the player fades in, so their text never shows on top of each other.
                .transition(.asymmetric(
                    insertion: .opacity.animation(.easeOut(duration: 0.2).delay(0.1)),
                    removal: .opacity.animation(.easeIn(duration: 0.1))
                ))
            } else {
                MessageRow(
                    systemImage: "hand.tap.fill",
                    tint: .accentColor,
                    title: "Tap Any Pattern to Feel It",
                    message: "Touch and hold one to add it to Favorites."
                )
                .transition(.asymmetric(
                    insertion: .opacity.animation(.easeOut(duration: 0.2).delay(0.1)),
                    removal: .opacity.animation(.easeIn(duration: 0.1))
                ))
            }
        }
        // The buttons bring their own 44 point targets, so the trailing edge needs less.
        .padding(.leading, 12)
        .padding(.trailing, 6)
        .padding(.vertical, Self.verticalPadding)
        .frame(height: fixedHeight, alignment: .top)
        .frame(minHeight: Self.collapsedHeight)
        .barBackground(tint: model.isHapticsSupported ? nil : .orange)
        .contentShape(.rect(cornerRadius: 24))
        .onGeometryChange(for: CGFloat.self) { $0.frame(in: .global).minY } action: { onTopChange($0) }
        // A light tap each time it settles on a size, as a haptics demo should.
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.6), trigger: size)
        // As wide as a phone at most, centered on iPad and in landscape, like Music's mini player.
        .frame(maxWidth: 500)
        // Measures the collapsed bar whatever the state, from a stand-in laid out like it, so the room
        // the patterns leave follows the text size but never the bar's resizing.
        .background(alignment: .bottom) {
            MessageRow(systemImage: "hand.tap.fill", tint: .clear, title: "Tap Any Pattern to Feel It", message: "Touch and hold one to add it to Favorites.")
                .padding(.leading, 12)
                .padding(.trailing, 6)
                .padding(.vertical, Self.verticalPadding)
                .frame(minHeight: Self.collapsedHeight)
                .fixedSize(horizontal: false, vertical: true)
                .hidden()
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { onCollapsedHeightChange($0) }
        }
        .padding(.horizontal, Self.margin)
        // Room above, so the bar floats clear of the patterns rather than touching them.
        .padding(.top, 12)
        // Down into the home indicator's safe area, the same distance from the bottom as from the sides.
        // A negative padding rather than `ignoresSafeArea`, which iOS 26 doesn't apply inside a bar.
        .padding(.bottom, Self.margin - bottomInset)
        .animation(.easeInOut(duration: 0.25), value: model.lastPlayed == nil)
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

/// The pattern last played: one row collapsed, which grows into its details. Dragging anywhere on it
/// resizes it under the finger, and letting go settles on the nearest size, carried by the flick.
private struct PlayerRow: View {
    static let snap = Animation.spring(duration: 0.42, bounce: 0.18)
    /// Between the row and the details.
    private static let detailsGap: CGFloat = 16
    /// How far past the top of the full details a pull drops to the summary.
    private static let pullToShrink: CGFloat = 64

    let pattern: HapticPattern
    let playback: HapticDemoModel.Playback?
    @Binding var size: NowPlayingBar.Size
    /// The tallest the row may grow, inside the bar's padding.
    let maxHeight: CGFloat

    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    /// How far the finger has moved since the drag began: negative is up.
    @State private var dragTranslation: CGFloat = 0
    @State private var rowHeight: CGFloat = 44
    /// Where the summary ends in the details, and where they all end.
    @State private var summaryEnd: CGFloat = 0
    @State private var detailsEnd: CGFloat = 0
    /// How far the full details are pulled down past their top.
    @State private var overscroll: CGFloat = 0
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
        case .full: max(min(rowHeight + Self.detailsGap + detailsEnd, maxHeight), height(of: .summary))
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
        .onChange(of: size) { _, size in
            if size != .full { withAnimation(Self.snap) { scrollPosition.scrollTo(edge: .top) } }
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
        .scrollDisabled(size != .full)
        .scrollIndicators(size == .full ? .automatic : .hidden)
        .onScrollGeometryChange(for: CGFloat.self) { -($0.contentOffset.y + $0.contentInsets.top) } action: { _, pull in
            overscroll = pull
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
                showsDetails = true
                dragTranslation = drag.translation.height
            }
            .onEnded { drag in
                let projected = height(of: size) - drag.predictedEndTranslation.height
                let nearest = NowPlayingBar.Size.allCases.min {
                    abs(height(of: $0) - projected) < abs(height(of: $1) - projected)
                } ?? size
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
                // Open, the full description is below, so this line shows the facts instead.
                Text(openness > 0.5 ? "\(pattern.category.title) · \(pattern.durationText)" : pattern.subtitle)
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

    private var icon: some View {
        Image(systemName: pattern.systemImage)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(isPlaying ? .white : pattern.tint)
            .frame(width: 40, height: 40)
            .background(isPlaying ? pattern.tint : pattern.tint.opacity(0.15), in: .rect(cornerRadius: 11))
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

/// What the open bar adds. The summary first: the full description, and a timeline to compare with
/// what's felt. Then, in the full size: the numbers, each event, and similar patterns to try next.
private struct PatternDetails: View {
    let pattern: HapticPattern
    let playback: HapticDemoModel.Playback?
    let isFull: Bool
    let toggleFull: () -> Void
    /// Where the summary ends, with the button that opens the rest: the summary size's height.
    @Binding var summaryEnd: CGFloat

    private static let space = "details"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(pattern.subtitle)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)

            PatternTimeline(pattern: pattern, playback: playback)

            Text("\(eventSummary). Taller is stronger; deeper color is sharper.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // Peeks out at the bottom of the summary, so there's plainly more, and one tap reaches it.
            Button(action: toggleFull) {
                HStack(spacing: 6) {
                    Text(isFull ? "Fewer Details" : "More Details")
                    Image(systemName: "chevron.up")
                        .imageScale(.small)
                        .rotationEffect(.degrees(isFull ? 180 : 0))
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(pattern.tint)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(pattern.tint.opacity(0.12), in: .capsule)
                .contentShape(.capsule)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("toggleFullDetails")
            .onGeometryChange(for: CGFloat.self) { $0.frame(in: .named(Self.space)).maxY + 12 } action: {
                summaryEnd = $0
            }

            PatternStats(pattern: pattern)
            EventList(pattern: pattern)
            SimilarPatterns(pattern: pattern)
        }
        .padding(.trailing, 6)
        .padding(.bottom, 16)
        .coordinateSpace(.named(Self.space))
    }

    /// Such as "3 taps", "1 hold" or "8 taps, 1 hold".
    private var eventSummary: String {
        let taps = pattern.events.filter { $0.kind == .tap }.count
        let holds = pattern.events.count - taps
        var parts: [String] = []
        if taps > 0 { parts.append(taps == 1 ? "1 tap" : "\(taps) taps") }
        if holds > 0 { parts.append(holds == 1 ? "1 hold" : "\(holds) holds") }
        return parts.joined(separator: ", ")
    }
}

/// The pattern in four numbers, as tiles.
private struct PatternStats: View {
    let pattern: HapticPattern

    private var events: [HapticPatternEvent] { pattern.events }

    var body: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
                tile("Length", pattern.durationText)
                tile("Events", "\(events.count)")
            }
            GridRow {
                tile("Strongest", percent(events.map(\.intensity).max() ?? 0))
                tile("Average Sharpness", percent(events.isEmpty ? 0 : events.map(\.sharpness).reduce(0, +) / Float(events.count)))
            }
        }
    }

    private func tile(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title3.weight(.semibold).monospacedDigit())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        // In the pattern's color, like the buttons around them. A gray fill turns dark on glass.
        .background(pattern.tint.opacity(0.08), in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
    }
}

/// Every event in order: when it starts, what it is, and how strong, drawn as on the timeline.
private struct EventList: View {
    let pattern: HapticPattern

    /// Long textures have dozens; past this, the timeline tells the story better than rows.
    private static let limit = 24

    var body: some View {
        let events = pattern.events
        VStack(alignment: .leading, spacing: 0) {
            SectionTitle("Events", trailing: "\(events.count)")
            ForEach(Array(events.prefix(Self.limit).enumerated()), id: \.offset) { index, event in
                if index > 0 { Divider() }
                row(event)
            }
            if events.count > Self.limit {
                Divider()
                Text("And \(events.count - Self.limit) more")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
            }
        }
    }

    private func row(_ event: HapticPatternEvent) -> some View {
        HStack(spacing: 12) {
            Text(seconds(event.time))
                .font(.footnote.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(minWidth: 52, alignment: .leading)
            Label(
                event.kind == .tap ? "Tap" : "Hold \(seconds(event.duration))",
                systemImage: event.kind == .tap ? "circle.fill" : "capsule.fill"
            )
            .font(.subheadline)
            .labelStyle(EventLabelStyle())
            Spacer(minLength: 8)
            // Like the timeline: the bar's length is strength, its color depth sharpness.
            Capsule()
                .fill(.primary.opacity(0.08))
                .frame(width: 56, height: 6)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(pattern.tint.opacity(0.3 + 0.7 * Double(event.sharpness)))
                        .frame(width: max(6, 56 * CGFloat(event.intensity)))
                }
            Text(percent(event.intensity))
                .font(.footnote.monospacedDigit())
                .frame(minWidth: 38, alignment: .trailing)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(event.kind == .tap ? "Tap" : "Hold for \(seconds(event.duration))") at \(seconds(event.time)), "
                + "strength \(percent(event.intensity)), sharpness \(percent(event.sharpness))"
        )
    }

    private func seconds(_ time: TimeInterval) -> String {
        "\(time.formatted(.number.precision(.fractionLength(2)))) s"
    }
}

private struct EventLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.icon
                .font(.system(size: 7))
                .foregroundStyle(.secondary)
            configuration.title
        }
    }
}

/// Others from the same category, to feel side by side. A tap plays one, and the bar shows it.
private struct SimilarPatterns: View {
    let pattern: HapticPattern

    @Environment(HapticDemoModel.self) private var model

    var body: some View {
        let similar = pattern.category.patterns.filter { $0 != pattern }
        if !similar.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                SectionTitle("More in \(pattern.category.title)")
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(similar, id: \.self) { similar in
                            Button {
                                model.play(similar)
                            } label: {
                                Label(similar.title, systemImage: similar.systemImage)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(similar.tint)
                                    .padding(.horizontal, 12)
                                    .frame(minHeight: 36)
                                    .background(similar.tint.opacity(0.12), in: .capsule)
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint("Plays it")
                        }
                    }
                }
                .scrollIndicators(.hidden)
                // To the bar's edges, so chips scroll out under its corners rather than stopping short.
                .padding(.horizontal, -12)
                .contentMargins(.horizontal, 12, for: .scrollContent)
            }
        }
    }
}

private struct SectionTitle: View {
    let title: String
    var trailing: String?

    init(_ title: String, trailing: String? = nil) {
        self.title = title
        self.trailing = trailing
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .accessibilityAddTraits(.isHeader)
    }
}

/// Such as "80%".
private func percent(_ value: Float) -> String {
    Double(value).formatted(.percent.precision(.fractionLength(0)))
}

/// The pattern drawn over time: taps as thin bars, holds as blocks as long as they last. Height is
/// strength and color depth is sharpness. While the pattern plays, a playhead crosses it.
private struct PatternTimeline: View {
    let pattern: HapticPattern
    let playback: HapticDemoModel.Playback?

    private static let tapWidth: CGFloat = 4

    var body: some View {
        VStack(spacing: 4) {
            Canvas { context, size in
                draw(in: &context, size: size)
            }
            .frame(height: 88)
            .overlay {
                if let playback, pattern.duration > 0 {
                    Playhead(duration: pattern.duration)
                        // A new ID restarts it when the same pattern plays again.
                        .id(playback.id)
                        .transition(.opacity)
                }
            }

            HStack {
                Text("0 s")
                Spacer()
                Text(pattern.durationText)
            }
            .font(.caption2.monospacedDigit())
            .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Timeline")
        .accessibilityValue("\(pattern.events.count) events over \(pattern.durationText)")
    }

    private func draw(in context: inout GraphicsContext, size: CGSize) {
        let usableWidth = size.width - Self.tapWidth
        let total = pattern.duration

        // A faint baseline, so a quiet pattern still reads as a timeline.
        let baseline = CGRect(x: 0, y: size.height - 1, width: size.width, height: 1)
        context.fill(Path(baseline), with: .color(.primary.opacity(0.1)))

        for event in pattern.events {
            // A pattern with no length, such as a single tap, sits in the middle.
            let x = total > 0 ? usableWidth * event.time / total : usableWidth / 2
            let width: CGFloat = switch event.kind {
            case .tap: Self.tapWidth
            // One point short, so back-to-back holds stay distinct.
            case .hold: max(Self.tapWidth, usableWidth * event.duration / total - 1)
            }
            let height = max(3, size.height * CGFloat(event.intensity))
            let rect = CGRect(x: x, y: size.height - height, width: width, height: height)
            let color = pattern.tint.opacity(0.3 + 0.7 * Double(event.sharpness))
            context.fill(Path(roundedRect: rect, cornerRadius: min(2, width / 2)), with: .color(color))
        }
    }
}

/// A line that crosses the timeline over the pattern's duration.
private struct Playhead: View {
    let duration: TimeInterval
    @State private var progress: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Capsule()
                .fill(.primary)
                .frame(width: 2)
                .offset(x: (geometry.size.width - 2) * progress)
        }
        .onAppear {
            withAnimation(.linear(duration: duration)) { progress = 1 }
        }
        .accessibilityHidden(true)
    }
}

/// An icon, a title and a one-line message, styled like the player so the bar keeps one shape in every
/// state.
private struct MessageRow: View {
    let systemImage: String
    let tint: Color
    let title: String
    let message: String

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(tint.opacity(0.15), in: .rect(cornerRadius: 11))
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    // One line, like the player, so every state is the same height.
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 3 : 1)
                    .minimumScaleFactor(0.85)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
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

/// A ring around the icon that fills over the pattern's duration.
private struct ProgressRing: View {
    /// The quickest the ring fills, so a pattern over in a blink still shows a sweep rather than a flash.
    /// Shorter than how long a playback shows, so the ring is seen full before it fades.
    static let minimumSweep: TimeInterval = 0.35

    let duration: TimeInterval
    let tint: Color

    @State private var progress: CGFloat = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .trim(from: 0, to: progress)
            .stroke(tint, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
            .onAppear {
                withAnimation(.linear(duration: duration)) { progress = 1 }
            }
    }
}

private extension View {
    /// Liquid Glass where available, to match the system toolbar; a material on earlier versions.
    /// Content is clipped to the same shape.
    /// `tint` colors it lightly, to mark a warning.
    ///
    /// On iOS 26, the bottom corners are concentric with the screen's, so they follow its curve whatever
    /// the device. The top corners keep a fixed radius, as they're far from any screen corner.
    @ViewBuilder
    func barBackground(tint: Color? = nil) -> some View {
        let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)
        if #available(iOS 26, *) {
            let shape = ConcentricRectangle(uniformTopCorners: .fixed(24), uniformBottomCorners: .concentric(minimum: .fixed(24)))
            // Clipped, so details scrolled to its edges stay within its corners.
            clipShape(shape)
                .glassEffect(.regular.tint(tint?.opacity(0.2)), in: shape)
                // A steady backdrop for the glass. Glass restyles what's on it to stay legible over what's
                // behind, and behind the bar changes as it's resized: white patterns, the gray background,
                // patterns fading out. Over that, its icon, star and gray text switched colors mid-resize.
                .background(Color(.systemBackground).opacity(0.85), in: shape)
        } else {
            clipShape(shape)
                .background(.regularMaterial, in: shape)
                .background((tint ?? .clear).opacity(0.12), in: shape)
                .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
        }
    }
}

#Preview("First Open") {
    VStack {
        Spacer()
        NowPlayingBar()
    }
    .background(Color(.systemGroupedBackground))
    .environment(HapticDemoModel(engine: MockHapticEngine()))
}

#Preview("Played") {
    let model = HapticDemoModel(engine: MockHapticEngine())
    model.play(.thunder)
    return VStack {
        Spacer()
        NowPlayingBar()
    }
    .background(Color(.systemGroupedBackground))
    .environment(model)
}

#Preview("Unavailable") {
    VStack {
        Spacer()
        NowPlayingBar()
    }
    .background(Color(.systemGroupedBackground))
    .environment(HapticDemoModel(engine: MockHapticEngine(isHapticsSupported: false)))
}
