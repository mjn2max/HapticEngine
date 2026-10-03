//
// HapticEngineProtocol.swift
// HapticEngine
//
// Created by Huy D. on 4/8/25
// mjn2max.github.io 😜
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

/// Plays the library's haptic patterns.
///
/// Depend on this protocol rather than ``HapticEngine`` so you can substitute a
/// mock in tests and SwiftUI previews, where haptic hardware is unavailable.
/// A conforming type only needs ``isHapticsSupported`` and ``play(_:)``; ``stop()`` and the
/// `start…Haptic()` methods are provided for you.
///
/// Conforming types are `Sendable`, so an engine can be shared across actors and tasks.
public protocol HapticEngineProtocol: Sendable {
    /// Whether haptics can play on this device.
    ///
    /// This is `false` in the Simulator, on most Macs, and on iPads, and also if the
    /// system couldn't create a haptic engine.
    var isHapticsSupported: Bool { get }

    /// Plays a built-in pattern, stopping any pattern that is still playing.
    /// Does nothing when ``isHapticsSupported`` is `false`.
    func play(_ pattern: HapticPattern)

    /// Stops the pattern that is playing, if any. Does nothing when no pattern is playing or
    /// ``isHapticsSupported`` is `false`.
    ///
    /// Has a default implementation that does nothing, so mocks and other conforming types don't
    /// need to implement it.
    func stop()
}

public extension HapticEngineProtocol {
    func stop() {}
}

// Shorthands for each pattern. Android's `HapticEngine` interface has the same ones, as default methods.
public extension HapticEngineProtocol {
    /// Plays ``HapticPattern/simple``.
    func startSimpleHaptic() { play(.simple) }

    /// Plays ``HapticPattern/complex``.
    func startComplexHaptic() { play(.complex) }

    /// Plays ``HapticPattern/tick``.
    func startTickHaptic() { play(.tick) }

    /// Plays ``HapticPattern/success``.
    func startSuccessHaptic() { play(.success) }

    /// Plays ``HapticPattern/warning``.
    func startWarningHaptic() { play(.warning) }

    /// Plays ``HapticPattern/error``.
    func startErrorHaptic() { play(.error) }

    /// Plays ``HapticPattern/heartbeat``.
    func startHeartbeatHaptic() { play(.heartbeat) }

    /// Plays ``HapticPattern/knock``.
    func startKnockHaptic() { play(.knock) }

    /// Plays ``HapticPattern/rumble``.
    func startRumbleHaptic() { play(.rumble) }

    /// Plays ``HapticPattern/pulse``.
    func startPulseHaptic() { play(.pulse) }
}
