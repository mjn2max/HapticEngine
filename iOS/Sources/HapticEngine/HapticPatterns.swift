//
// HapticPatterns.swift
// HapticEngine
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

import CoreHaptics

/// The events that make up each ``HapticPattern``.
///
/// Kept separate from playback so they can be unit tested without haptic hardware.
/// Keep these in step with `HapticPatterns.kt` in the Android library.
enum HapticPatterns {
    // Timings in seconds. Each pattern has its own, so tuning one can't change another.
    static let simpleTapInterval: TimeInterval = 0.1
    static let complexSegmentDuration: TimeInterval = 1.5
    static let successGap: TimeInterval = 0.15
    static let warningGap: TimeInterval = 0.25
    static let errorTapInterval: TimeInterval = 0.1
    static let heartbeatInterval: TimeInterval = 0.8
    static let heartbeatDubDelay: TimeInterval = 0.15
    static let knockInterval: TimeInterval = 0.25
    static let rumbleDuration: TimeInterval = 0.8
    static let pulseBurstDuration: TimeInterval = 0.1

    /// The only way in, so playback and tests always build patterns the same way.
    static func events(for pattern: HapticPattern) -> [CHHapticEvent] {
        switch pattern {
        case .simple: simple()
        case .complex: complex()
        case .tick: tick()
        case .success: success()
        case .warning: warning()
        case .error: error()
        case .heartbeat: heartbeat()
        case .knock: knock()
        case .rumble: rumble()
        case .pulse: pulse()
        }
    }

    /// How long each pattern plays, worked out once from its events so it can't drift from them.
    static let durations: [HapticPattern: TimeInterval] = Dictionary(
        uniqueKeysWithValues: HapticPattern.allCases.map { pattern in
            let ends = events(for: pattern).map { event in
                event.relativeTime + (event.type == .hapticContinuous ? event.duration : 0)
            }
            return (pattern, ends.max() ?? 0)
        }
    )

    /// A full-strength tap, then taps every 100 ms rising from 10% to 90% strength.
    private static func simple() -> [CHHapticEvent] {
        let firstTap = transient(intensity: 1, sharpness: 1, at: 0)
        let ramp = (1...9).map { step in
            let level = Float(step) / 10
            return transient(intensity: level, sharpness: level, at: Double(step) * simpleTapInterval)
        }
        return [firstTap] + ramp
    }

    /// Medium (0.5), hard (1.0), soft (0.2), hard (1.0); 1.5 seconds each.
    private static func complex() -> [CHHapticEvent] {
        let levels: [Float] = [0.5, 1.0, 0.2, 1.0]
        return levels.enumerated().map { index, level in
            continuous(
                intensity: level,
                sharpness: level,
                at: Double(index) * complexSegmentDuration,
                duration: complexSegmentDuration
            )
        }
    }

    /// One light, crisp tap, like a picker detent.
    private static func tick() -> [CHHapticEvent] {
        [transient(intensity: 0.5, sharpness: 1, at: 0)]
    }

    /// A soft tap, then a strong sharp tap 150 ms later.
    private static func success() -> [CHHapticEvent] {
        [
            transient(intensity: 0.6, sharpness: 0.5, at: 0),
            transient(intensity: 1, sharpness: 1, at: successGap),
        ]
    }

    /// A strong tap, then a weaker tap 250 ms later.
    private static func warning() -> [CHHapticEvent] {
        [
            transient(intensity: 1, sharpness: 0.6, at: 0),
            transient(intensity: 0.6, sharpness: 0.6, at: warningGap),
        ]
    }

    /// Three strong, sharp taps 100 ms apart.
    private static func error() -> [CHHapticEvent] {
        (0..<3).map { index in
            transient(intensity: 1, sharpness: 1, at: Double(index) * errorTapInterval)
        }
    }

    /// Two "lub-dub" beats 800 ms apart: a strong dull tap, then a softer one 150 ms later.
    private static func heartbeat() -> [CHHapticEvent] {
        (0..<2).flatMap { beat in
            let start = Double(beat) * heartbeatInterval
            return [
                transient(intensity: 1, sharpness: 0.3, at: start),
                transient(intensity: 0.6, sharpness: 0.3, at: start + heartbeatDubDelay),
            ]
        }
    }

    /// Three firm, dull taps 250 ms apart, like knocking on a door.
    private static func knock() -> [CHHapticEvent] {
        (0..<3).map { index in
            transient(intensity: 0.8, sharpness: 0.2, at: Double(index) * knockInterval)
        }
    }

    /// A strong, low-sharpness vibration for 800 ms.
    private static func rumble() -> [CHHapticEvent] {
        [continuous(intensity: 0.8, sharpness: 0.1, at: 0, duration: rumbleDuration)]
    }

    /// Five 100 ms bursts with 100 ms gaps between them.
    private static func pulse() -> [CHHapticEvent] {
        (0..<5).map { index in
            // Each gap is as long as a burst.
            continuous(
                intensity: 1,
                sharpness: 0.5,
                at: Double(index) * 2 * pulseBurstDuration,
                duration: pulseBurstDuration
            )
        }
    }

    private static func transient(intensity: Float, sharpness: Float, at time: TimeInterval) -> CHHapticEvent {
        CHHapticEvent(
            eventType: .hapticTransient,
            parameters: parameters(intensity: intensity, sharpness: sharpness),
            relativeTime: time
        )
    }

    private static func continuous(
        intensity: Float,
        sharpness: Float,
        at time: TimeInterval,
        duration: TimeInterval
    ) -> CHHapticEvent {
        CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: parameters(intensity: intensity, sharpness: sharpness),
            relativeTime: time,
            duration: duration
        )
    }

    private static func parameters(intensity: Float, sharpness: Float) -> [CHHapticEventParameter] {
        [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
        ]
    }
}
