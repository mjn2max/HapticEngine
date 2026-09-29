//
// HapticEngine.swift
// HapticEngine
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

import CoreHaptics
import os

/// Plays haptic patterns with Core Haptics.
///
/// Create one instance and keep it for as long as you need haptics, for example
/// in your app's model. On devices without haptic hardware every method is a no-op.
///
/// ```swift
/// let haptics = HapticEngine()
/// haptics.startSimpleHaptic()
/// ```
public final class HapticEngine: HapticEngineProtocol {
    private static let logger = Logger(subsystem: "dev.codepassion.HapticEngine", category: "HapticEngine")

    private let engine: CHHapticEngine?

    public init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            engine = nil
            return
        }

        do {
            let engine = try CHHapticEngine()
            engine.playsHapticsOnly = true
            // Let the system shut the engine down when idle to save power; `play(_:)` restarts it.
            engine.isAutoShutdownEnabled = true
            engine.stoppedHandler = { reason in
                Self.logger.info("Haptic engine stopped (reason \(reason.rawValue))")
            }
            engine.resetHandler = {
                // The system reset the haptic server, e.g. after the app was backgrounded.
                // Nothing to rebuild: `play(_:)` starts the engine and creates a new player each time.
                Self.logger.info("Haptic engine reset")
            }
            self.engine = engine
        } catch {
            Self.logger.error("Failed to create haptic engine: \(error.localizedDescription)")
            engine = nil
        }
    }

    public var isHapticsSupported: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

    public func startSimpleHaptic() {
        play(HapticPatterns.simple())
    }

    public func startComplexHaptic() {
        play(HapticPatterns.complex())
    }

    private func play(_ events: [CHHapticEvent]) {
        guard let engine else { return }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            // Starting a running engine is a no-op; this also recovers after a stop or reset.
            try engine.start()
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            Self.logger.error("Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }
}
