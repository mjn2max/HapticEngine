//
// HapticPatterns.swift
// HapticEngine
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

import CoreHaptics

/// The library's built-in patterns.
///
/// Kept separate from playback so they can be unit tested without haptic hardware.
/// Keep these in step with `HapticPatterns.kt` in the Android library.
enum HapticPatterns {
    static let tapInterval: TimeInterval = 0.1
    static let segmentDuration: TimeInterval = 1.5

    /// A full-strength tap, then taps every 100 ms rising from 10% to 90% strength.
    static func simple() -> [CHHapticEvent] {
        let firstTap = transient(intensity: 1, sharpness: 1, at: 0)
        let ramp = (1...9).map { step in
            let level = Float(step) / 10
            return transient(intensity: level, sharpness: level, at: Double(step) * tapInterval)
        }
        return [firstTap] + ramp
    }

    /// Medium (0.5), hard (1.0), soft (0.2), hard (1.0); 1.5 seconds each.
    static func complex() -> [CHHapticEvent] {
        let levels: [Float] = [0.5, 1.0, 0.2, 1.0]
        return levels.enumerated().map { index, level in
            CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: parameters(intensity: level, sharpness: level),
                relativeTime: Double(index) * segmentDuration,
                duration: segmentDuration
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

    private static func parameters(intensity: Float, sharpness: Float) -> [CHHapticEventParameter] {
        [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
        ]
    }
}
