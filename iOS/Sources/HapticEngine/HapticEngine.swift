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
/// Safe to share and call from any thread or actor: calls to ``play(_:)`` and ``stop()`` are serialized,
/// so one always finishes stopping the previous pattern before the next starts.
///
/// ```swift
/// let haptics = HapticEngine()
/// haptics.play(.success)
/// ```
// `@unchecked` because `CHHapticEngine` and its players aren't marked `Sendable`. The engine is set once in
// `init` and only read after; the pattern cache and the current player are guarded by `lock`.
public final class HapticEngine: HapticEngineProtocol, @unchecked Sendable {
    // Messages mark their values `.public`: none are user data, and the default `.private` hides them in
    // release logs, which is where they are needed.
    private static let logger = Logger(subsystem: "dev.codepassion.HapticEngine", category: "HapticEngine")

    private let engine: CHHapticEngine?

    /// Patterns already built, each the first time it plays: there are too many to build up front for an
    /// app that plays a few. Guarded by `lock`.
    private var patterns: [HapticPattern: CHHapticPattern] = [:]

    /// The player for the last pattern played, kept so the next `play(_:)` can stop it. Guarded by `lock`.
    private var currentPlayer: CHHapticPatternPlayer?

    /// Serializes `play(_:)` and `stop()`, so stopping the previous pattern and starting the next can't interleave, and
    /// guards the pattern cache.
    private let lock = NSLock()

    public init() {
        engine = Self.makeEngine()
    }

    public var isHapticsSupported: Bool {
        engine != nil
    }

    /// Plays `pattern`, stopping any pattern that is still playing, as Android's vibrator does.
    public func play(_ pattern: HapticPattern) {
        guard let engine else { return }

        lock.lock()
        defer { lock.unlock() }

        guard let hapticPattern = hapticPattern(for: pattern) else { return }

        stopCurrentPlayer()

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

    /// Stops the pattern that is playing, if any.
    public func stop() {
        guard engine != nil else { return }

        lock.lock()
        defer { lock.unlock() }

        stopCurrentPlayer()
    }

    /// Call with `lock` held.
    private func stopCurrentPlayer() {
        // Throws if the player already finished or the engine was reset since; either way it's silent.
        try? currentPlayer?.stop(atTime: CHHapticTimeImmediate)
        currentPlayer = nil
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

    /// The built pattern, from the cache or built now. Call with `lock` held.
    private func hapticPattern(for pattern: HapticPattern) -> CHHapticPattern? {
        if let built = patterns[pattern] { return built }
        do {
            let built = try CHHapticPattern(events: HapticPatterns.events(for: pattern), parameters: [])
            patterns[pattern] = built
            return built
        } catch {
            Self.logger.error("Failed to build haptic pattern \(pattern.rawValue, privacy: .public): \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
}
