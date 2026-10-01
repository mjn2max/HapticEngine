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
///   pattern's color while it plays, light when it's done, with a ring that fills around it for patterns
///   long enough to follow. Tapping the bar, or swiping it up, expands it to show the pattern's details.
/// - **A warning**, on a device without haptic hardware, where nothing can play.
///
/// Collapsed, the bar is one height in every state, so switching between them never moves the patterns.
struct NowPlayingBar: View {
    static let collapsedHeight: CGFloat = 64
    /// The gap to the screen's sides and bottom. Equal on all three, so the bar's lower corners run
    /// parallel to the screen's.
    static let margin: CGFloat = 12

    /// The screen's bottom safe area, such as the home indicator's. The bar moves down into it.
    var bottomInset: CGFloat = 0
    /// Called with the top of the bar, in global coordinates, so the patterns can fade out across it.
    var onTopChange: (CGFloat) -> Void = { _ in }

    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isExpanded = false

    /// Fixed while collapsed, except at accessibility text sizes, where text must never be cut off.
    private var fixedHeight: CGFloat? {
        isExpanded || dynamicTypeSize.isAccessibilitySize ? nil : Self.collapsedHeight
    }

    var body: some View {
        Group {
            if !model.isHapticsSupported {
                MessageRow(
                    systemImage: "exclamationmark.triangle.fill",
                    tint: .orange,
                    title: "No Haptics on This Device",
                    message: "Patterns only play on an iPhone."
                )
            } else if let pattern = model.lastPlayed {
                PlayerRow(pattern: pattern, playback: model.nowPlaying, isExpanded: $isExpanded)
                    .transition(.blurReplace)
            } else {
                MessageRow(
                    systemImage: "hand.tap.fill",
                    tint: .accentColor,
                    title: "Tap Any Pattern to Feel It",
                    message: "Touch and hold one to add it to Favorites."
                )
                .transition(.blurReplace)
            }
        }
        // The buttons bring their own 44 point targets, so the trailing edge needs less.
        .padding(.leading, 12)
        .padding(.trailing, 6)
        .padding(.vertical, 10)
        .frame(height: fixedHeight, alignment: .top)
        .frame(minHeight: Self.collapsedHeight)
        .overlay(alignment: .top) {
            if model.lastPlayed != nil {
                Grabber()
            }
        }
        .barBackground(tint: model.isHapticsSupported ? nil : .orange)
        .contentShape(.rect(cornerRadius: 24))
        // A tap anywhere shows or hides the details. The star and replay buttons take their own taps first.
        .onTapGesture {
            guard model.lastPlayed != nil else { return }
            isExpanded.toggle()
        }
        .onGeometryChange(for: CGFloat.self) { $0.frame(in: .global).minY } action: { onTopChange($0) }
        // Swipe up to expand and down to collapse, as with a sheet.
        .gesture(
            DragGesture(minimumDistance: 16).onEnded { drag in
                guard model.lastPlayed != nil else { return }
                if drag.translation.height < -30 { isExpanded = true }
                if drag.translation.height > 30 { isExpanded = false }
            }
        )
        // As wide as a phone at most, centered on iPad and in landscape, like Music's mini player.
        .frame(maxWidth: 500)
        .padding(.horizontal, Self.margin)
        // Room above, so the bar floats clear of the patterns rather than touching them.
        .padding(.top, 12)
        // Down into the home indicator's safe area, the same distance from the bottom as from the sides.
        // A negative padding rather than `ignoresSafeArea`, which iOS 26 doesn't apply inside a bar.
        .padding(.bottom, Self.margin - bottomInset)
        .animation(.snappy, value: model.lastPlayed == nil)
        .animation(.spring(duration: 0.45, bounce: 0.2), value: isExpanded)
    }
}

/// The handle along the bar's top edge, hinting that it can be swiped up for more.
private struct Grabber: View {
    var body: some View {
        Capsule()
            .fill(.secondary.opacity(0.4))
            .frame(width: 36, height: 4)
            .padding(.top, 4)
            .accessibilityHidden(true)
    }
}

private struct PlayerRow: View {
    let pattern: HapticPattern
    let playback: HapticDemoModel.Playback?
    @Binding var isExpanded: Bool

    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var isPlaying: Bool { playback != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                header
                favoriteButton
                replayButton
            }
            if isExpanded {
                PatternDetails(pattern: pattern, playback: playback)
                    .padding(.top, 20)
                    .padding(.trailing, 6)
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.snappy, value: playback?.id)
    }

    /// A tap on it, as anywhere on the bar, shows or hides the details: never a replay, so a tap that
    /// misses the star can't play the pattern by surprise.
    private var header: some View {
        HStack(spacing: 12) {
            icon
            VStack(alignment: .leading, spacing: 1) {
                Text(pattern.title)
                    .font(.headline)
                    .lineLimit(1)
                // Expanded, the full description is below, so this line shows the facts instead.
                Text(isExpanded ? "\(pattern.category.title) · \(pattern.durationText)" : pattern.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    // One line keeps the bar one height; large text needs the room to wrap.
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 3 : 1)
                    .contentTransition(.opacity)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(isPlaying ? "Playing" : "")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(isExpanded ? "Hides the details" : "Shows the details")
        .accessibilityAction { isExpanded.toggle() }
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
                // Most patterns are over in a blink, where progress would only flicker; the filled icon
                // already says "playing". Long ones get a ring to follow.
                if let playback, pattern.duration >= ProgressRing.minimumDuration {
                    ProgressRing(duration: pattern.duration, tint: pattern.tint)
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

/// What the expanded bar adds: the full description, and a timeline to compare with what's felt.
private struct PatternDetails: View {
    let pattern: HapticPattern
    let playback: HapticDemoModel.Playback?

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
        }
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
    /// Patterns shorter than this end before a ring could be followed.
    static let minimumDuration: TimeInterval = 1

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
    /// `tint` colors it lightly, to mark a warning.
    ///
    /// On iOS 26, the bottom corners are concentric with the screen's, so they follow its curve whatever
    /// the device. The top corners keep a fixed radius, as they're far from any screen corner.
    @ViewBuilder
    func barBackground(tint: Color? = nil) -> some View {
        let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)
        if #available(iOS 26, *) {
            glassEffect(
                .regular.tint(tint?.opacity(0.2)),
                in: ConcentricRectangle(uniformTopCorners: .fixed(24), uniformBottomCorners: .concentric(minimum: .fixed(24)))
            )
        } else {
            background(.regularMaterial, in: shape)
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
