//
// HapticPattern+Display.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Display text and icons for the library's built-in patterns.
extension HapticPattern {
    var title: String {
        switch self {
        case .simple: "Simple"
        case .complex: "Complex"
        case .tick: "Tick"
        case .success: "Success"
        case .warning: "Warning"
        case .error: "Error"
        case .heartbeat: "Heartbeat"
        case .knock: "Knock"
        case .rumble: "Rumble"
        case .pulse: "Pulse"
        }
    }

    /// Written to fit two lines of the status card on the smallest supported iPhone.
    var subtitle: String {
        switch self {
        case .simple: "Sharp tap, then a rising ramp of taps"
        case .complex: "Medium, hard, soft, hard over 6 seconds"
        case .tick: "One light, crisp tap"
        case .success: "Soft tap, then a strong tap"
        case .warning: "Strong tap, then a weaker tap"
        case .error: "Three strong taps in quick succession"
        case .heartbeat: "Two lub-dub beats, like a pulse"
        case .knock: "Three firm, dull taps, like a door knock"
        case .rumble: "Low, strong vibration for 0.8 seconds"
        case .pulse: "Five short bursts over one second"
        }
    }

    var systemImage: String {
        switch self {
        case .simple: "hand.tap"
        case .complex: "waveform.path"
        case .tick: "hand.point.up"
        case .success: "checkmark.circle"
        case .warning: "exclamationmark.triangle"
        case .error: "xmark.octagon"
        case .heartbeat: "heart"
        case .knock: "door.left.hand.closed"
        case .rumble: "water.waves"
        case .pulse: "dot.radiowaves.left.and.right"
        }
    }

    /// Roughly how long the pattern plays, from its first event to the end of its last.
    /// Keep in step with the timings in the library's `HapticPatterns.swift`.
    var duration: TimeInterval {
        switch self {
        case .simple: 0.9
        case .complex: 6
        case .tick: 0
        case .success: 0.15
        case .warning: 0.25
        case .error: 0.2
        case .heartbeat: 0.95
        case .knock: 0.5
        case .rumble: 0.8
        case .pulse: 0.9
        }
    }

    /// `duration` for display, such as "Instant", "250 ms" or "6 s".
    var durationText: String {
        switch duration {
        case ..<0.05: "Instant"
        case ..<1: "\(Int((duration * 1000).rounded())) ms"
        default: "\(duration.formatted(.number.precision(.fractionLength(0...1)))) s"
        }
    }

    /// Groups related patterns by color: feedback in traffic-light colors, rhythms in warm tones.
    var tint: Color {
        switch self {
        case .simple: .blue
        case .complex: .indigo
        case .tick: .teal
        case .success: .green
        case .warning: .orange
        case .error: .red
        case .heartbeat: .pink
        case .knock: .brown
        case .rumble: .purple
        case .pulse: .cyan
        }
    }

    /// The section the demo lists the pattern under.
    var category: Category {
        switch self {
        case .tick, .success, .warning, .error: .feedback
        case .heartbeat, .knock, .pulse: .rhythm
        case .simple, .complex, .rumble: .texture
        }
    }

    /// Groups the patterns on the home screen, so the list stays easy to scan as more are added.
    enum Category: CaseIterable {
        /// Short responses to something the user did.
        case feedback
        /// Repeating beats.
        case rhythm
        /// Longer vibrations that build or sustain.
        case texture

        var title: String {
            switch self {
            case .feedback: "Feedback"
            case .rhythm: "Rhythm"
            case .texture: "Texture"
            }
        }

        var patterns: [HapticPattern] {
            HapticPattern.allCases.filter { $0.category == self }
        }
    }
}
