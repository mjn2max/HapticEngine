//
// HapticDemoModel.swift
// HapticEngineDemo
//

import Foundation
import HapticEngine
import Observation
import SwiftUI

@MainActor
@Observable
final class HapticDemoModel {
    struct LogEntry: Identifiable {
        let id = UUID()
        let date = Date()
        let message: String
    }

    /// The pattern most recently played, while it's still playing.
    struct Playback: Identifiable {
        /// Keeps very short patterns, like `.tick`, on screen long enough to notice.
        static let minimumDisplayDuration: TimeInterval = 0.6

        let id = UUID()
        let pattern: HapticPattern
        let start = Date()

        var end: Date { start.addingTimeInterval(max(pattern.duration, Self.minimumDisplayDuration)) }
    }

    private let engine: any HapticEngineProtocol
    private(set) var log: [LogEntry] = []
    private(set) var nowPlaying: Playback?
    /// Stays set after the pattern finishes, so its description can still be read.
    private(set) var lastPlayed: HapticPattern?
    private var playbackEndTask: Task<Void, Never>?

    var isHapticsSupported: Bool { engine.isHapticsSupported }

    init(engine: any HapticEngineProtocol = HapticEngine()) {
        self.engine = engine
    }

    func play(_ pattern: HapticPattern) {
        engine.play(pattern)
        record("Played \(pattern.title)" + (isHapticsSupported ? "" : " (no haptic hardware)"))

        // The engine doesn't report when a pattern finishes, so clear it once its duration has passed.
        // A new tap replaces the one before it.
        let playback = Playback(pattern: pattern)
        nowPlaying = playback
        lastPlayed = pattern
        playbackEndTask?.cancel()
        playbackEndTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(playback.end.timeIntervalSince(playback.start)))
            guard !Task.isCancelled else { return }
            self?.nowPlaying = nil
        }
        AccessibilityNotification.Announcement("Playing \(pattern.title)").post()
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
