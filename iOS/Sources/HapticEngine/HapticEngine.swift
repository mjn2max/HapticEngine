//
// HapticEngine.swift
// HapticEngine
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

import CoreHaptics
import Foundation
import os

/// Plays haptic patterns with Core Haptics.
///
/// Create one instance and keep it for as long as you need haptics, for example
/// in your app's model. On devices without haptic hardware every method is a no-op.
///
/// Safe to share and call from any thread or actor: calls to ``play(_:)`` are serialized, so one
/// always finishes stopping the previous pattern before the next starts.
///
/// ```swift
/// let haptics = HapticEngine()
/// haptics.play(.success)
/// ```
// `@unchecked` because `CHHapticEngine` and its players aren't marked `Sendable`. The engine and
// patterns are set once in `init` and only read after; the mutable player is guarded by `lock`.
public final class HapticEngine: HapticEngineProtocol, @unchecked Sendable {
    // Messages mark their values `.public`: none are user data, and the default `.private` hides them in
    // release logs, which is where they are needed.
    private static let logger = Logger(subsystem: "dev.codepassion.HapticEngine", category: "HapticEngine")

    private let engine: CHHapticEngine?

    /// Every pattern, built once up front since they never change. Empty without an engine.
    private let patterns: [HapticPattern: CHHapticPattern]

    /// The player for the last pattern played, kept so the next `play(_:)` can stop it. Guarded by `lock`.
    private var currentPlayer: CHHapticPatternPlayer?

    /// Serializes `play(_:)`, so stopping the previous pattern and starting the next can't interleave.
    private let lock = NSLock()

    public init() {
        engine = Self.makeEngine()
        patterns = engine == nil ? [:] : Self.makePatterns()
    }

    public var isHapticsSupported: Bool {
        engine != nil
    }

    /// Plays `pattern`, stopping any pattern that is still playing, as Android's vibrator does.
    public func play(_ pattern: HapticPattern) {
        guard let engine, let hapticPattern = patterns[pattern] else { return }

        lock.lock()
        defer { lock.unlock() }

        // Throws if the player already finished or the engine was reset since; either way it's silent.
        try? currentPlayer?.stop(atTime: CHHapticTimeImmediate)
        currentPlayer = nil

        do {
            // Starting a running engine is a no-op; this also recovers after a stop or reset.
            try engine.start()
            let player = try engine.makePlayer(with: hapticPattern)
            try player.start(atTime: CHHapticTimeImmediate)
            currentPlayer = player
        } catch {
            Self.logger.error("Failed to play haptic pattern \(pattern.rawValue, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    private static func makeEngine() -> CHHapticEngine? {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return nil }

        do {
            let engine = try CHHapticEngine()
            engine.playsHapticsOnly = true
            // Let the system shut the engine down when idle to save power; `play(_:)` restarts it.
            engine.isAutoShutdownEnabled = true
            engine.stoppedHandler = { reason in
                logger.info("Haptic engine stopped (reason \(reason.rawValue))")
            }
            engine.resetHandler = {
                // The system reset the haptic server, e.g. after the app was backgrounded.
                // Nothing to rebuild: `play(_:)` starts the engine and creates a new player each time.
                logger.info("Haptic engine reset")
            }
            return engine
        } catch {
            logger.error("Failed to create haptic engine: \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }

    private static func makePatterns() -> [HapticPattern: CHHapticPattern] {
        var patterns: [HapticPattern: CHHapticPattern] = [:]
        for pattern in HapticPattern.allCases {
            do {
                patterns[pattern] = try CHHapticPattern(events: HapticPatterns.events(for: pattern), parameters: [])
            } catch {
                logger.error("Failed to build haptic pattern \(pattern.rawValue, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }
        }
        return patterns
    }
}
