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
///   ends, so the pattern can still be starred or replayed. While it plays, the icon bounces and a ring
///   fills around it; its colors never change. It opens to three sizes, like a sheet: see `Size`.
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
    /// Half the collapsed height, so collapsed the bar is a capsule, like the system's bars in iOS 26.
    /// Everything along its leading end is drawn concentric with it, `inset` in from its edge with a
    /// radius of `cornerRadius - inset`: the icon, a circle 12 points in, and the ring, a circle 8 in.
    static let cornerRadius: CGFloat = collapsedHeight / 2
    /// The gap to the screen's sides and bottom. Equal on all three, so the bar's lower corners run
    /// parallel to the screen's.
    static let margin: CGFloat = 12
    /// The room above the bar, so it floats clear of the patterns, and of the navigation bar at its tallest.
    static let topSpacing: CGFloat = 12
    /// The bar's padding above and below its content.
    static let verticalPadding: CGFloat = 10

    /// Where the bar reports its top and heights, for the patterns laid out around it.
    let layout: NowPlayingLayout
    /// The screen's bottom safe area, such as the home indicator's. The bar moves down into it.
    var bottomInset: CGFloat = 0
    /// The tallest the bar may grow, so the navigation bar stays in sight above it.
    var maxHeight: CGFloat = .infinity

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
                MessageRow.unsupported
            } else if let pattern = model.lastPlayed {
                PlayerRow(
                    pattern: pattern,
                    playback: model.nowPlaying,
                    size: $size,
                    maxHeight: maxHeight - Self.verticalPadding * 2,
                    layout: layout
                )
                .onDisappear { layout.openHeight = 0 }
                // The tip and the player share a layout, so only their contents change: the tip leaves
                // quickly, then the player fades in, so their text never shows on top of each other.
                .transition(.asymmetric(
                    insertion: .opacity.animation(.easeOut(duration: 0.2).delay(0.1)),
                    removal: .opacity.animation(.easeIn(duration: 0.1))
                ))
            } else {
                MessageRow.tip(tint: .accentColor)
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
        .contentShape(.rect(cornerRadius: Self.cornerRadius))
        .onGeometryChange(for: CGFloat.self) { $0.frame(in: .global).minY } action: { layout.top = $0 }
        // A light tap each time it settles on a size, as a haptics demo should.
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.6), trigger: size)
        // As wide as a phone at most, centered on iPad and in landscape, like Music's mini player.
        .frame(maxWidth: 500)
        // Measures the collapsed bar whatever the state, from a stand-in laid out like it, so the room
        // the patterns leave follows the text size but never the bar's resizing.
        .background(alignment: .bottom) {
            MessageRow.tip(tint: .clear)
                .padding(.leading, 12)
                .padding(.trailing, 6)
                .padding(.vertical, Self.verticalPadding)
                .frame(minHeight: Self.collapsedHeight)
                .fixedSize(horizontal: false, vertical: true)
                .hidden()
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { layout.collapsedHeight = $0 }
        }
        .padding(.horizontal, Self.margin)
        .padding(.top, Self.topSpacing)
        // Down into the home indicator's safe area, the same distance from the bottom as from the sides.
        // A negative padding rather than `ignoresSafeArea`, which iOS 26 doesn't apply inside a bar.
        .padding(.bottom, Self.margin - bottomInset)
        .animation(.easeInOut(duration: 0.25), value: model.lastPlayed == nil)
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

    /// Before anything is played.
    static func tip(tint: Color) -> MessageRow {
        MessageRow(
            systemImage: "hand.tap.fill",
            tint: tint,
            title: "Tap Any Pattern to Feel It",
            message: "Touch and hold one to add it to Favorites."
        )
    }

    /// On a device without haptic hardware.
    static let unsupported = MessageRow(
        systemImage: "exclamationmark.triangle.fill",
        tint: .orange,
        title: "No Haptics on This Device",
        message: "Patterns only play on an iPhone."
    )

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(tint.opacity(0.15), in: .circle)
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

extension Color {
    /// The bar's surface: raised over the patterns' background in both light and dark.
    static let barSurface = Color(.secondarySystemGroupedBackground)
}

private extension View {
    /// An opaque surface, the same at every size. Liquid Glass changes with its size and with what's
    /// behind it: it drew a gray, glossy rim on the collapsed bar that flattened to white as the bar
    /// grew, and restyled the icon, star and gray text over the changing patterns, so the row flickered
    /// mid-resize. A solid surface keeps them steady, as a sheet's does. Content is clipped to the shape.
    /// `tint` colors it lightly, to mark a warning.
    ///
    /// The corners are `NowPlayingBar.cornerRadius`: collapsed, a capsule. On iOS 26 the bottom corners
    /// are concentric with the screen's where that's rounder, so they follow its curve whatever the
    /// device; collapsed, the bar's height caps them, so it stays a capsule. The top corners keep a fixed
    /// radius, as they're far from any screen corner.
    @ViewBuilder
    func barBackground(tint: Color? = nil) -> some View {
        let radius = NowPlayingBar.cornerRadius
        if #available(iOS 26, *) {
            surface(tint: tint, in: ConcentricRectangle(uniformTopCorners: .fixed(radius), uniformBottomCorners: .concentric(minimum: .fixed(radius))))
        } else {
            surface(tint: tint, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
    }

    private func surface(tint: Color?, in shape: some Shape) -> some View {
        clipShape(shape)
            .background((tint ?? .clear).opacity(0.12), in: shape)
            // The shadow on the surface alone: on the whole view, every icon and line of text cast one.
            .background {
                shape.fill(Color.barSurface)
                    .shadow(color: .black.opacity(0.12), radius: 16, y: 4)
            }
            .overlay(shape.stroke(Color(.separator).opacity(0.5), lineWidth: 1))
    }
}

#Preview("First Open") {
    VStack {
        Spacer()
        NowPlayingBar(layout: NowPlayingLayout())
    }
    .background(Color(.systemGroupedBackground))
    .environment(HapticDemoModel(engine: MockHapticEngine()))
}

#Preview("Played") {
    let model = HapticDemoModel(engine: MockHapticEngine())
    model.play(.thunder)
    return VStack {
        Spacer()
        NowPlayingBar(layout: NowPlayingLayout())
    }
    .background(Color(.systemGroupedBackground))
    .environment(model)
}

#Preview("Unavailable") {
    VStack {
        Spacer()
        NowPlayingBar(layout: NowPlayingLayout())
    }
    .background(Color(.systemGroupedBackground))
    .environment(HapticDemoModel(engine: MockHapticEngine(isHapticsSupported: false)))
}
