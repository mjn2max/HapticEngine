//
// LaunchReveal.swift
// HapticEngineDemo
//

import SwiftUI
import UIKit

/// How the home screen first appears: a ripple. The patterns come into focus in a wave spreading
/// diagonally from the top-leading corner, each icon landing with a little bounce, then the now-playing
/// bar docks below them. On the first launch the wave can be felt too: see `LaunchRipple`. Once per launch;
/// afterwards everything shows at once.
///
/// Brief by design, the whole screen settled about half a second after launch. Each pattern sharpens and
/// grows into place where it sits rather than sliding up: it reads as arriving, not as a list scrolling in.
/// The wave runs from row and column together, so a grid's tiles along each diagonal arrive together, as
/// one sweep rather than a scan line along each row. And it eases: the wave sets out from the corner and
/// gathers speed, the last of the screenful landing almost together. Only the first screenful takes part.
/// Patterns further down appear as they're scrolled to, with nothing to wait for.
///
/// Timed from when the wave starts, rather than switched on for everything at once, because the patterns
/// are built lazily: some are only built once the wave is under way. Switched on, those popped in at once,
/// ahead of patterns above them still waiting their turn. Timed, each takes its turn whenever it's built.
enum LaunchReveal {
    /// A beat after the wave starts.
    static let start: TimeInterval = 0.03
    /// From the first pattern's turn to the last's.
    static let spread: TimeInterval = 0.32
    /// About a screenful, in rows and columns from the corner. Patterns further out join the last of them
    /// rather than queueing up offscreen.
    static let reach: Double = 10
    /// The bar docks as the wave's tail lands.
    static let barDelay = start + spread * 0.85
    /// Each pattern coming into focus: quick, with a hint of settle.
    static let duration: TimeInterval = 0.45
    static let animation = Animation.spring(duration: duration, bounce: 0.2)
    /// The icon lands a moment after its pattern, with more bounce: the pattern arrives, then its icon pops.
    static let accentLag: TimeInterval = 0.04
    static let accentAnimation = Animation.spring(duration: 0.4, bounce: 0.38)

    /// When the pattern `row` rows down and `column` columns across takes its turn. Rows needn't be whole:
    /// a section's title takes half of one.
    static func delay(row: Double, column: Int = 0) -> TimeInterval {
        let progress = min(max(row + Double(column), 0) / reach, 1)
        // Eased out: long gaps near the corner, short ones further out.
        return start + spread * (1 - (1 - progress) * (1 - progress))
    }
}

/// A tap at the patterns' first turns, fading as the wave spreads, like a pebble dropped in water: what the
/// haptic engine is for, felt before anything's read. Only on the first launch, and soft: a hint, not a buzz.
///
/// Played with the system's feedback generator rather than the engine: the engine only plays the library's
/// patterns, and this one belongs to the demo.
@MainActor
enum LaunchRipple {
    /// Where the wave is when each tap lands, in rows from the corner, and the tap's strength.
    private static let taps: [(row: Double, intensity: CGFloat)] = [(0, 0.45), (2, 0.32), (4.5, 0.22), (8, 0.14)]
    /// Taps land as their patterns are partway into focus rather than as they start.
    private static let lag: TimeInterval = 0.06

    static func play() async {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        let start = ContinuousClock.now
        for tap in taps {
            let offset = LaunchReveal.delay(row: tap.row) + lag
            try? await Task.sleep(until: start + .seconds(offset), clock: .continuous)
            guard !Task.isCancelled else { return }
            generator.impactOccurred(intensity: tap.intensity)
        }
    }
}

extension EnvironmentValues {
    /// When the home screen's wave started, or `nil` until it does. Long ago by default, so other screens
    /// and previews show at once.
    @Entry var launchRevealStart: Date? = .distantPast
    /// The turn of the pattern around this view, for its icon to land just after: see `launchRevealAccent()`.
    /// `nil` outside the wave, such as in the now-playing bar, which takes no part in it.
    @Entry fileprivate var launchRevealItemDelay: TimeInterval?
}

extension View {
    /// Comes into focus where it sits as the home screen first appears, `row` rows down and `column`
    /// columns across from the wave's corner.
    func launchReveal(row: Double, column: Int = 0) -> some View {
        let delay = LaunchReveal.delay(row: row, column: column)
        return modifier(LaunchRevealModifier(delay: delay, style: .focus))
            .environment(\.launchRevealItemDelay, delay)
    }

    /// Rises `distance` points and fades in as the home screen first appears, `delay` seconds after the
    /// wave starts.
    func launchReveal(delay: TimeInterval, distance: CGFloat) -> some View {
        modifier(LaunchRevealModifier(delay: delay, style: .rise(distance)))
    }

    /// Pops into place just after the pattern around it, as the home screen first appears. For a pattern's
    /// icon; anywhere outside the wave it does nothing.
    func launchRevealAccent() -> some View {
        modifier(LaunchRevealAccent())
    }
}

private struct LaunchRevealAccent: ViewModifier {
    @Environment(\.launchRevealItemDelay) private var delay

    func body(content: Content) -> some View {
        if let delay {
            content.modifier(LaunchRevealModifier(delay: delay + LaunchReveal.accentLag, style: .pop))
        } else {
            content
        }
    }
}

private struct LaunchRevealModifier: ViewModifier {
    enum Style {
        /// Sharpens and grows into place: a pattern.
        case focus
        /// Rises from below: the now-playing bar.
        case rise(CGFloat)
        /// Grows into place with a bounce, inside a pattern coming into focus: its icon.
        case pop

        var offset: CGFloat {
            switch self {
            case .focus: 4
            case .rise(let distance): distance
            case .pop: 0
            }
        }

        var scale: CGFloat {
            switch self {
            case .focus: 0.94
            case .rise: 1
            case .pop: 0.8
            }
        }

        /// Only for a pattern: its icon sharpens with it, and the bar's glass would lose its look.
        var blur: CGFloat {
            switch self {
            case .focus: 6
            case .rise, .pop: 0
            }
        }

        /// The pattern around an icon already fades it in.
        var fades: Bool {
            switch self {
            case .focus, .rise: true
            case .pop: false
            }
        }

        var animation: Animation {
            switch self {
            case .focus, .rise: LaunchReveal.animation
            case .pop: LaunchReveal.accentAnimation
            }
        }
    }

    let delay: TimeInterval
    let style: Style

    @Environment(\.launchRevealStart) private var start
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    /// Set when this view's turn comes, animating it in.
    @State private var isShown = false

    /// Shown, or built after its turn was over, such as a pattern scrolled to later: no animation then.
    private var isVisible: Bool {
        guard let start else { return false }
        return isShown || Date.now.timeIntervalSince(start) >= delay + LaunchReveal.duration
    }

    /// With Reduce Motion, only a quick fade in place.
    private var isMoved: Bool { !isVisible && !reduceMotion }

    func body(content: Content) -> some View {
        content
            .scaleEffect(isMoved ? style.scale : 1)
            .blur(radius: isMoved ? style.blur : 0)
            .opacity(isVisible || !style.fades ? 1 : 0)
            .offset(y: isMoved ? style.offset : 0)
            .onChange(of: start, initial: true) { _, start in
                guard let start, !isShown else { return }
                // What's left of the wait for its turn: all of it if built early, none if built late.
                let wait = max(delay - Date.now.timeIntervalSince(start), 0)
                withAnimation(reduceMotion ? .easeOut(duration: 0.2) : style.animation.delay(wait)) {
                    isShown = true
                }
            }
    }
}
