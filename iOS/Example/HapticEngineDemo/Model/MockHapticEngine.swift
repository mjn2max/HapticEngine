//
// MockHapticEngine.swift
// HapticEngineDemo
//

import HapticEngine

/// A no-op engine for SwiftUI previews, where CoreHaptics is unavailable.
struct MockHapticEngine: HapticEngineProtocol {
    var isHapticsSupported: Bool = true

    func startSimpleHaptic() {}
    func startComplexHaptic() {}
}
