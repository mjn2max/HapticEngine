//
// TestSupport.swift
// HapticEngineTests
//

import CoreHaptics
@testable import HapticEngine

/// A plain description of one event, for comparing patterns against their spec.
struct EventSpec: Equatable, CustomStringConvertible {
    let type: CHHapticEvent.EventType
    let time: TimeInterval
    let intensity: Float
    let sharpness: Float
    let duration: TimeInterval

    static func tap(_ intensity: Float, _ sharpness: Float, at time: TimeInterval) -> EventSpec {
        EventSpec(type: .hapticTransient, time: time, intensity: intensity, sharpness: sharpness, duration: 0)
    }

    static func hold(
        _ intensity: Float,
        _ sharpness: Float,
        at time: TimeInterval,
        for duration: TimeInterval
    ) -> EventSpec {
        EventSpec(type: .hapticContinuous, time: time, intensity: intensity, sharpness: sharpness, duration: duration)
    }

    init(type: CHHapticEvent.EventType, time: TimeInterval, intensity: Float, sharpness: Float, duration: TimeInterval) {
        self.type = type
        self.time = time
        self.intensity = intensity
        self.sharpness = sharpness
        self.duration = duration
    }

    init(_ event: CHHapticEvent) {
        self.init(
            type: event.type,
            time: event.relativeTime,
            intensity: event.value(of: .hapticIntensity) ?? .nan,
            sharpness: event.value(of: .hapticSharpness) ?? .nan,
            duration: event.type == .hapticTransient ? 0 : event.duration
        )
    }

    /// Equal within a small tolerance, since times and levels are computed in floating point.
    static func == (lhs: EventSpec, rhs: EventSpec) -> Bool {
        lhs.type == rhs.type
            && abs(lhs.time - rhs.time) < 0.0001
            && abs(lhs.intensity - rhs.intensity) < 0.0001
            && abs(lhs.sharpness - rhs.sharpness) < 0.0001
            && abs(lhs.duration - rhs.duration) < 0.0001
    }

    var description: String {
        "\(type.rawValue) t=\(time) i=\(intensity) s=\(sharpness) d=\(duration)"
    }
}

extension CHHapticEvent {
    func value(of parameter: CHHapticEvent.ParameterID) -> Float? {
        eventParameters.first { $0.parameterID == parameter }?.value
    }
}
