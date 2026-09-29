//
// HapticPreset.swift
// HapticEngineDemo
//

import HapticEngine

/// The library's built-in patterns, described for display in the demo.
enum HapticPreset: String, CaseIterable, Identifiable {
    case simple
    case complex

    var id: String { rawValue }

    var title: String {
        switch self {
        case .simple: "Simple"
        case .complex: "Complex"
        }
    }

    var subtitle: String {
        switch self {
        case .simple: "Sharp tap followed by a rising ramp"
        case .complex: "Medium → hard → soft → hard, 6 seconds"
        }
    }

    var systemImage: String {
        switch self {
        case .simple: "hand.tap"
        case .complex: "waveform.path"
        }
    }

    func play(on engine: any HapticEngineProtocol) {
        switch self {
        case .simple: engine.startSimpleHaptic()
        case .complex: engine.startComplexHaptic()
        }
    }
}
