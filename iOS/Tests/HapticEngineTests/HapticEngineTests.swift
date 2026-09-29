//
// HapticEngineTests.swift
// HapticEngineTests
//

import CoreHaptics
import Testing
@testable import HapticEngine

@Suite("Haptic patterns")
struct HapticPatternsTests {
    @Test func simpleStartsWithFullStrengthSharpTap() throws {
        let first = try #require(HapticPatterns.simple().first)
        #expect(first.type == .hapticTransient)
        #expect(first.relativeTime == 0)
        #expect(first.value(of: .hapticIntensity) == 1)
        #expect(first.value(of: .hapticSharpness) == 1)
    }

    @Test func simplePlaysTenTapsEvery100Milliseconds() {
        let events = HapticPatterns.simple()
        #expect(events.count == 10)
        #expect(events.allSatisfy { $0.type == .hapticTransient })
        for (index, event) in events.enumerated() {
            #expect(abs(event.relativeTime - Double(index) * 0.1) < 0.0001)
        }
    }

    @Test func simpleRampRisesAfterTheFirstTap() {
        let ramp = HapticPatterns.simple().dropFirst().compactMap { $0.value(of: .hapticIntensity) }
        #expect(ramp.count == 9)
        #expect(ramp == ramp.sorted())
        #expect(ramp.allSatisfy { $0 > 0 })
    }

    @Test func complexMatchesTheAndroidSegments() {
        let events = HapticPatterns.complex()
        #expect(events.map(\.type) == Array(repeating: .hapticContinuous, count: 4))
        #expect(events.compactMap { $0.value(of: .hapticIntensity) } == [0.5, 1.0, 0.2, 1.0])
        #expect(events.map(\.relativeTime) == [0, 1.5, 3.0, 4.5])
        #expect(events.allSatisfy { $0.duration == 1.5 })
    }

    enum Preset: CaseIterable, Sendable {
        case simple, complex

        var events: [CHHapticEvent] {
            switch self {
            case .simple: HapticPatterns.simple()
            case .complex: HapticPatterns.complex()
            }
        }
    }

    @Test(arguments: Preset.allCases)
    func patternsAreValidForCoreHaptics(preset: Preset) throws {
        let pattern = try CHHapticPattern(events: preset.events, parameters: [])
        #expect(pattern.duration > 0)
    }
}

@Suite("HapticEngine")
struct HapticEngineTests {
    @Test func playingIsSafeWithoutHapticHardware() {
        // CI machines and the Simulator have no haptic hardware; playback must be a silent no-op.
        let engine = HapticEngine()
        engine.startSimpleHaptic()
        engine.startComplexHaptic()
        #expect(engine.isHapticsSupported == CHHapticEngine.capabilitiesForHardware().supportsHaptics)
    }
}

private extension CHHapticEvent {
    func value(of parameter: CHHapticEvent.ParameterID) -> Float? {
        eventParameters.first { $0.parameterID == parameter }?.value
    }
}
