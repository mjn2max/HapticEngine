//
// HapticPatternsTests.swift
// HapticEngineTests
//

import CoreHaptics
import Testing
@testable import HapticEngine

/// The feel each pattern is meant to have. Exact values are checked in `HapticPatternSpecTests`.
@Suite("Haptic pattern intent")
struct HapticPatternIntentTests {
    @Test func simpleStartsWithFullStrengthSharpTap() throws {
        let first = try #require(HapticPatterns.events(for: .simple).first)
        #expect(first.type == .hapticTransient)
        #expect(first.value(of: .hapticIntensity) == 1)
        #expect(first.value(of: .hapticSharpness) == 1)
    }

    @Test func simpleRampRisesAfterTheFirstTap() {
        let ramp = HapticPatterns.events(for: .simple).dropFirst().compactMap { $0.value(of: .hapticIntensity) }
        #expect(ramp.count == 9)
        #expect(ramp == ramp.sorted())
    }

    @Test func simpleAndComplexSharpnessTracksStrength() {
        for event in HapticPatterns.events(for: .simple) + HapticPatterns.events(for: .complex) {
            #expect(event.value(of: .hapticSharpness) == event.value(of: .hapticIntensity))
        }
    }

    @Test func successRisesAndWarningFalls() throws {
        let success = HapticPatterns.events(for: .success).compactMap { $0.value(of: .hapticIntensity) }
        let warning = HapticPatterns.events(for: .warning).compactMap { $0.value(of: .hapticIntensity) }
        #expect(try #require(success.first) < #require(success.last))
        #expect(try #require(warning.first) > #require(warning.last))
    }

    @Test func pulseGapsMatchBurstLength() {
        let events = HapticPatterns.events(for: .pulse)
        for (burst, next) in zip(events, events.dropFirst()) {
            let gap = next.relativeTime - (burst.relativeTime + burst.duration)
            #expect(abs(gap - burst.duration) < 0.0001)
        }
    }
}

/// The patterns the Android library has too, in the same order.
let sharedWithAndroid: [HapticPattern] = [
    .simple, .complex, .tick, .success, .warning, .error, .heartbeat, .knock, .rumble, .pulse,
]

@Suite("Haptic pattern specs")
struct HapticPatternSpecTests {
    /// The exact events of the patterns shared with Android. Keep in step with `HapticPatterns.kt` there.
    /// The iOS-only patterns are held to the rules in `HapticPatternRuleTests` instead.
    static let specs: [HapticPattern: [EventSpec]] = [
        .simple: [.tap(1, 1, at: 0)] + (1...9).map { step in
            let level = Float(step) / 10
            return .tap(level, level, at: Double(step) / 10)
        },
        .complex: [
            .hold(0.5, 0.5, at: 0, for: 1.5),
            .hold(1.0, 1.0, at: 1.5, for: 1.5),
            .hold(0.2, 0.2, at: 3.0, for: 1.5),
            .hold(1.0, 1.0, at: 4.5, for: 1.5),
        ],
        .tick: [.tap(0.5, 1, at: 0)],
        .success: [.tap(0.6, 0.5, at: 0), .tap(1, 1, at: 0.15)],
        .warning: [.tap(1, 0.6, at: 0), .tap(0.6, 0.6, at: 0.25)],
        .error: [.tap(1, 1, at: 0), .tap(1, 1, at: 0.1), .tap(1, 1, at: 0.2)],
        .heartbeat: [
            .tap(1, 0.3, at: 0), .tap(0.6, 0.3, at: 0.15),
            .tap(1, 0.3, at: 0.8), .tap(0.6, 0.3, at: 0.95),
        ],
        .knock: [.tap(0.8, 0.2, at: 0), .tap(0.8, 0.2, at: 0.25), .tap(0.8, 0.2, at: 0.5)],
        .rumble: [.hold(0.8, 0.1, at: 0, for: 0.8)],
        .pulse: (0..<5).map { .hold(1, 0.5, at: Double($0) * 0.2, for: 0.1) },
    ]

    /// How long each pattern plays, in seconds.
    static let durations: [HapticPattern: TimeInterval] = [
        .simple: 0.9, .complex: 6.0, .tick: 0, .success: 0.15, .warning: 0.25,
        .error: 0.2, .heartbeat: 0.95, .knock: 0.5, .rumble: 0.8, .pulse: 0.9,
    ]

    @Test func everySharedPatternHasASpec() {
        #expect(Array(HapticPattern.allCases.prefix(sharedWithAndroid.count)) == sharedWithAndroid)
        #expect(Set(Self.specs.keys) == Set(sharedWithAndroid))
        #expect(Set(Self.durations.keys) == Set(sharedWithAndroid))
    }

    @Test(arguments: sharedWithAndroid)
    func eventsMatchSpec(pattern: HapticPattern) throws {
        let expected = try #require(Self.specs[pattern])
        #expect(HapticPatterns.events(for: pattern).map(EventSpec.init) == expected)
    }

    @Test(arguments: sharedWithAndroid)
    func durationMatchesSpec(pattern: HapticPattern) throws {
        let expected = try #require(Self.durations[pattern])
        let hapticPattern = try CHHapticPattern(events: HapticPatterns.events(for: pattern), parameters: [])
        #expect(abs(hapticPattern.duration - expected) < 0.0001)
        #expect(abs(pattern.duration - expected) < 0.0001)
    }
}

@Suite("Haptic pattern rules")
struct HapticPatternRuleTests {
    @Test(arguments: HapticPattern.allCases)
    func isValidForCoreHaptics(pattern: HapticPattern) throws {
        let events = HapticPatterns.events(for: pattern)
        #expect(!events.isEmpty)
        // A single transient at time 0 (tick) has a duration of 0, which is still valid.
        _ = try CHHapticPattern(events: events, parameters: [])
    }

    @Test(arguments: HapticPattern.allCases)
    func startsImmediately(pattern: HapticPattern) {
        #expect(HapticPatterns.events(for: pattern).first?.relativeTime == 0)
    }

    @Test(arguments: HapticPattern.allCases)
    func eventsAreInTimeOrder(pattern: HapticPattern) {
        let times = HapticPatterns.events(for: pattern).map(\.relativeTime)
        #expect(times == times.sorted())
    }

    @Test(arguments: HapticPattern.allCases)
    func everyEventSetsOnlyIntensityAndSharpness(pattern: HapticPattern) {
        for event in HapticPatterns.events(for: pattern) {
            #expect(event.eventParameters.map(\.parameterID) == [.hapticIntensity, .hapticSharpness])
        }
    }

    @Test(arguments: HapticPattern.allCases)
    func levelsAreInRange(pattern: HapticPattern) {
        for event in HapticPatterns.events(for: pattern) {
            let intensity = event.value(of: .hapticIntensity) ?? .nan
            let sharpness = event.value(of: .hapticSharpness) ?? .nan
            // Zero strength is silent, so it would only add latency. Zero sharpness is a valid, rounded feel.
            #expect(intensity > 0 && intensity <= 1)
            #expect(sharpness >= 0 && sharpness <= 1)
        }
    }

    @Test(arguments: HapticPattern.allCases)
    func usesOnlyHapticEventTypes(pattern: HapticPattern) {
        let events = HapticPatterns.events(for: pattern)
        #expect(events.allSatisfy { $0.type == .hapticTransient || $0.type == .hapticContinuous })
    }

    @Test(arguments: HapticPattern.allCases)
    func continuousEventsDoNotOverlap(pattern: HapticPattern) {
        let holds = HapticPatterns.events(for: pattern).filter { $0.type == .hapticContinuous }
        for (hold, next) in zip(holds, holds.dropFirst()) {
            #expect(hold.duration > 0)
            #expect(hold.relativeTime + hold.duration <= next.relativeTime + 0.0001)
        }
    }

    @Test(arguments: HapticPattern.allCases)
    func durationMatchesCoreHaptics(pattern: HapticPattern) throws {
        let hapticPattern = try CHHapticPattern(events: HapticPatterns.events(for: pattern), parameters: [])
        #expect(abs(pattern.duration - hapticPattern.duration) < 0.0001)
    }

    @Test(arguments: HapticPattern.allCases)
    func publicEventsMatchTheCoreHapticsEvents(pattern: HapticPattern) {
        let expected = HapticPatterns.events(for: pattern).map(EventSpec.init)
        let actual = pattern.events.map { event in
            EventSpec(
                type: event.kind == .tap ? .hapticTransient : .hapticContinuous,
                time: event.time,
                intensity: event.intensity,
                sharpness: event.sharpness,
                duration: event.duration
            )
        }
        #expect(actual == expected)
    }

    @Test(arguments: HapticPattern.allCases)
    func durationIsTheEndOfTheLastEvent(pattern: HapticPattern) throws {
        let end = try #require(pattern.events.map { $0.time + $0.duration }.max())
        #expect(abs(pattern.duration - end) < 0.0001)
    }

    @Test(arguments: HapticPattern.allCases)
    func isShortEnoughForFeedback(pattern: HapticPattern) {
        // The longest, complex, is 6 seconds. Anything longer is likely a typo in a timing.
        #expect(pattern.duration <= 6)
    }

    @Test func patternsAreDistinct() {
        let signatures = HapticPattern.allCases.map { HapticPatterns.events(for: $0).map(EventSpec.init).description }
        #expect(Set(signatures).count == HapticPattern.allCases.count)
    }
}
