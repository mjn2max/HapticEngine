//
// HapticDemoModel.swift
// HapticEngineDemo
//

import Foundation
import HapticEngine
import Observation

@MainActor
@Observable
final class HapticDemoModel {
    struct LogEntry: Identifiable {
        let id = UUID()
        let date = Date()
        let message: String
    }

    private let engine: any HapticEngineProtocol
    private(set) var log: [LogEntry] = []

    var isHapticsSupported: Bool { engine.isHapticsSupported }

    init(engine: any HapticEngineProtocol = HapticEngine()) {
        self.engine = engine
    }

    func play(_ preset: HapticPreset) {
        preset.play(on: engine)
        record("Played \(preset.title)" + (isHapticsSupported ? "" : " (no haptic hardware)"))
    }

    /// Records app lifecycle changes, useful for checking the engine recovers after backgrounding.
    func record(_ message: String) {
        log.insert(LogEntry(message: message), at: 0)
        if log.count > 50 { log.removeLast() }
    }

    func clearLog() {
        log.removeAll()
    }
}
