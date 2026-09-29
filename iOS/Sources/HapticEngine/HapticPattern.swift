//
// HapticPattern.swift
// HapticEngine
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

/// A built-in haptic pattern. Pass one to ``HapticEngineProtocol/play(_:)``.
///
/// ```swift
/// haptics.play(.success)
/// ```
public enum HapticPattern: String, CaseIterable, Sendable {
    /// One sharp tap followed by nine taps of rising strength over about one second.
    case simple

    /// Four 1.5 second segments: medium, hard, soft, hard.
    case complex

    /// One light, crisp tap. Similar to, but not the same as, `UISelectionFeedbackGenerator`.
    case tick

    /// A soft tap followed by a strong sharp tap, to confirm something worked.
    /// Similar to, but not the same as, `UINotificationFeedbackGenerator`'s `.success`.
    case success

    /// A strong tap followed by a weaker one, to draw attention.
    /// Similar to, but not the same as, `UINotificationFeedbackGenerator`'s `.warning`.
    case warning

    /// Three strong, sharp taps in quick succession, to signal a failure.
    /// Similar to, but not the same as, `UINotificationFeedbackGenerator`'s `.error`.
    case error

    /// Two "lub-dub" heartbeats over about one second.
    case heartbeat

    /// Three firm, dull taps, like knocking on a door.
    case knock

    /// A strong, low rumble for 0.8 seconds.
    case rumble

    /// Five short bursts over about one second.
    case pulse
}
