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

    @Test func stopsWithoutCrashing() {
        let engine = HapticEngine()
        // With nothing playing, then while a pattern plays.
        engine.stop()
        engine.play(.complex)
        engine.stop()
        engine.stop()
    }

    @Test func canBeSharedAcrossTasks() async {
        // Compiles only because the engine is `Sendable`; on an iPhone the calls also race for real.
        let engine = HapticEngine()
        await withTaskGroup(of: Void.self) { group in
            for pattern in HapticPattern.allCases {
                group.addTask { engine.play(pattern) }
                group.addTask { engine.stop() }
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

    @Test func stopDefaultsToDoingNothing() {
        // Types written before `stop()` existed still conform, and calling it is safe.
        let spy = SpyEngine()
        spy.play(.tick)
        spy.stop()
        #expect(spy.played == [.tick])
    }

    @Test func patternRawValuesAreStable() {
        // Raw values appear in logs and may be persisted by apps, so renaming a case must be deliberate.
        #expect(HapticPattern.allCases.prefix(100).map(\.rawValue) == [
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

    @Test func familyRawValuesAreStable() {
        // The 900 family patterns' names, all at once: any rename changes this. If one was meant, update it
        // to the value the failure shows, and note the rename in CHANGELOG.md.
        let names = HapticPattern.allCases.dropFirst(100).map(\.rawValue).joined(separator: ",")
        #expect(fingerprint(names) == 12_892_458_424_837_815_209)
        // And the ends of each family, readably.
        let families = Array(HapticPattern.allCases.dropFirst(100)).chunked(into: 90)
        #expect(families.map { [$0.first!.rawValue, $0.last!.rawValue] } == [
            ["featherWoodHit", "crushingCeramicHit"],
            ["twoTapsLazy", "elevenTapsRapid"],
            ["calmPing", "criticalHorn"],
            ["marchLargo", "bossaNovaPresto"],
            ["crawlOverSand", "rushOverCarpet"],
            ["glacialSwell", "franticWobble"],
            ["flashCrescendo", "sustainedPlateau"],
            ["faintDrizzle", "extremeSleet"],
            ["idleMotor", "redlineSewingMachine"],
            ["tinyJump", "epicShield"],
        ])
    }

    @Test func hasOneThousandPatterns() {
        #expect(HapticPattern.allCases.count == 1000)
    }

    @Test func theHandWrittenHundredComeFirstThenTheFamiliesInOrder() {
        #expect(HapticPattern.allCases.prefix(100).allSatisfy { $0.variant == nil })
        // Family by family, each variant through its nine levels, as the generator writes them.
        let expected = PatternFamily.allCases.flatMap { family in
            (0..<PatternFamily.variantCount).flatMap { variant in
                (0..<PatternFamily.levelCount).map { PatternVariant(family, variant, $0) }
            }
        }
        #expect(HapticPattern.allCases.dropFirst(100).map(\.variant) == expected)
    }

    /// FNV-1a: stable across runs and platforms, unlike `hashValue`.
    private func fingerprint(_ text: String) -> UInt64 {
        text.utf8.reduce(0xcbf2_9ce4_8422_2325) { ($0 ^ UInt64($1)) &* 0x100_0000_01b3 }
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { Array(self[$0..<Swift.min($0 + size, count)]) }
    }
}
