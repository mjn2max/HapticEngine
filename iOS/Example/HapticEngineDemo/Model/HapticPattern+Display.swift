//
// HapticPattern+Display.swift
// HapticEngineDemo
//

import HapticEngine

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

    var subtitle: String {
        switch self {
        case .simple: "Sharp tap followed by a rising ramp"
        case .complex: "Medium → hard → soft → hard, 6 seconds"
        case .tick: "One light, crisp tap"
        case .success: "Soft tap, then a strong tap"
        case .warning: "Strong tap, then a weaker tap"
        case .error: "Three strong taps in quick succession"
        case .heartbeat: "Two lub-dub beats"
        case .knock: "Three firm, dull taps"
        case .rumble: "Low, strong vibration, 0.8 seconds"
        case .pulse: "Five short bursts"
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
}
