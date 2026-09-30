//
// HapticEngineTests.swift
// HapticEngineTests
//

import CoreHaptics
import Testing
@testable import HapticEngine

// CI machines, Macs and the Simulator have no haptic hardware, so these tests check that playback
// is a safe no-op there. On an iPhone they also play every pattern for real.
@Suite("HapticEngine")
struct HapticEngineTests {
    @Test func isHapticsSupportedMatchesHardware() {
        let hasHardware = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        #expect(HapticEngine().isHapticsSupported == hasHardware)
    }

    @Test(arguments: HapticPattern.allCases)
    func playsEachPatternWithoutCrashing(pattern: HapticPattern) {
        HapticEngine().play(pattern)
    }

    @Test func canBeSharedAcrossTasks() async {
        // Compiles only because the engine is `Sendable`; on an iPhone the calls also race for real.
        let engine = HapticEngine()
        await withTaskGroup(of: Void.self) { group in
            for pattern in HapticPattern.allCases {
                group.addTask { engine.play(pattern) }
            }
        }
    }
}

@Suite("HapticEngineProtocol")
struct HapticEngineProtocolTests {
    // Only used from one test at a time, so it skips the locking a shared engine would need.
    final class SpyEngine: HapticEngineProtocol, @unchecked Sendable {
        var isHapticsSupported: Bool { true }
        private(set) var played: [HapticPattern] = []

        func play(_ pattern: HapticPattern) {
            played.append(pattern)
        }
    }

    @Test func shorthandsPlayTheirPattern() {
        let spy = SpyEngine()
        spy.startSimpleHaptic()
        spy.startComplexHaptic()
        spy.startTickHaptic()
        spy.startSuccessHaptic()
        spy.startWarningHaptic()
        spy.startErrorHaptic()
        spy.startHeartbeatHaptic()
        spy.startKnockHaptic()
        spy.startRumbleHaptic()
        spy.startPulseHaptic()
        // Shorthands exist for the ten patterns shared with Android.
        #expect(spy.played == sharedWithAndroid)
    }

    @Test func patternRawValuesAreStable() {
        // Raw values appear in logs and may be persisted by apps, so renaming a case must be deliberate.
        #expect(HapticPattern.allCases.map(\.rawValue) == [
            // Shared with Android
            "simple", "complex", "tick", "success", "warning",
            "error", "heartbeat", "knock", "rumble", "pulse",
            // Feedback
            "selection", "lightImpact", "mediumImpact", "heavyImpact", "softImpact", "rigidImpact",
            "toggleOn", "toggleOff", "buttonPress", "longPress", "dragStart", "drop",
            "snap", "swipe", "refresh", "delete", "undo", "doubleTap",
            // Alerts
            "notification", "message", "mention", "reminder", "alarm", "ring",
            "doorbell", "siren", "countdown", "timerDone", "lowBattery", "sos",
            // Rhythm
            "drumroll", "gallop", "march", "waltz", "clockTick", "metronome", "racingHeart",
            "restingHeart", "footsteps", "clap", "bounce", "echo", "syncopation",
            // Texture
            "buzz", "hum", "purr", "zipper", "sandpaper", "gravel",
            "bubbles", "sparkle", "crescendo", "fadeOut", "wobble", "throb",
            // Nature
            "raindrop", "rain", "thunder", "earthquake", "oceanWave", "gust",
            "breathe", "crickets", "woodpecker", "campfire", "hail", "avalanche",
            // Mechanical
            "typewriter", "ratchet", "dial", "spring", "engineStart", "engineRev",
            "shutter", "lock", "unlock", "gears", "drill",
            // Game
            "coin", "powerUp", "levelUp", "jump", "landing", "hit",
            "criticalHit", "explosion", "laser", "shield", "gameOver", "victory",
        ])
    }

    @Test func hasOneHundredPatterns() {
        #expect(HapticPattern.allCases.count == 100)
    }
}
