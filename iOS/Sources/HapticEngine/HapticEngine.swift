// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreHaptics

struct HapticEngine: HapticEngineProtocol {
    var isHapticsSupported: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

    func startSimpleHaptic() {
        print("Test startSimpleHaptic()")
    }

    func startComplexHaptic() {
        print("Test startComplexHaptic()")
    }
}
