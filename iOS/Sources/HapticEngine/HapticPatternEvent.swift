//
// HapticPatternEvent.swift
// HapticEngine
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

import CoreHaptics

/// One event in a ``HapticPattern``: a tap or a held vibration, with its timing, strength and feel.
///
/// For showing or inspecting a pattern, such as drawing its timeline. Playing a pattern doesn't need
/// these; use ``HapticEngineProtocol/play(_:)``.
///
/// ```swift
/// for event in HapticPattern.heartbeat.events {
///     print(event.kind, event.time, event.intensity)
/// }
/// ```
public struct HapticPatternEvent: Equatable, Sendable {
    public enum Kind: Equatable, Sendable {
        /// A momentary tap.
        case tap
        /// A vibration held for ``HapticPatternEvent/duration``.
        case hold
    }

    public let kind: Kind

    /// When the event starts, in seconds from the start of the pattern.
    public let time: TimeInterval

    /// How long the event lasts, in seconds. `0` for a tap.
    public let duration: TimeInterval

    /// How strong the event is, from 0 to 1.
    public let intensity: Float

    /// How crisp the event feels, from 0 (round and dull) to 1 (sharp).
    public let sharpness: Float
}

extension HapticPatternEvent {
    init(_ event: CHHapticEvent) {
        let isHold = event.type == .hapticContinuous
        self.init(
            kind: isHold ? .hold : .tap,
            time: event.relativeTime,
            duration: isHold ? event.duration : 0,
            intensity: event.value(of: .hapticIntensity) ?? 0,
            sharpness: event.value(of: .hapticSharpness) ?? 0
        )
    }
}

extension CHHapticEvent {
    /// The value of `parameter`, or `nil` if the event doesn't set it.
    func value(of parameter: CHHapticEvent.ParameterID) -> Float? {
        eventParameters.first { $0.parameterID == parameter }?.value
    }
}
