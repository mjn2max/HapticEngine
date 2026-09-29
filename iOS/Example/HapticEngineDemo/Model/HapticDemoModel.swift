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
    /// A pattern the user switched to.
    struct LogEntry: Identifiable {
        let id = UUID()
        let date = Date()
        let pattern: HapticPattern
    }

    /// The pattern most recently played, while it's still playing.
    struct Playback: Identifiable {
        /// Keeps very short patterns, like `.tick`, on screen long enough to notice.
        static let minimumDisplayDuration: TimeInterval = 0.6

        let id = UUID()
        let pattern: HapticPattern
        /// The log entry this playback belongs to, so the activity screen highlights the right row.
        var entryID: LogEntry.ID?
        let start = Date()

        var end: Date { start.addingTimeInterval(max(pattern.duration, Self.minimumDisplayDuration)) }
    }

    private let engine: any HapticEngineProtocol
    /// Newest first. Only records a pattern when it differs from the one before, so replays don't add entries.
    private(set) var log: [LogEntry] = []
    private(set) var nowPlaying: Playback?
    /// Stays set after the pattern finishes, so its description can still be read.
    private(set) var lastPlayed: HapticPattern?
    private var playbackEndTask: Task<Void, Never>?

    var isHapticsSupported: Bool { engine.isHapticsSupported }

    init(engine: any HapticEngineProtocol = HapticEngine()) {
        self.engine = engine
    }

    /// Plays a pattern chosen on the home screen, logging it if it differs from the last one logged.
    func play(_ pattern: HapticPattern) {
        if log.first?.pattern != pattern {
            log.insert(LogEntry(pattern: pattern), at: 0)
            if log.count > 50 { log.removeLast() }
        }
        startPlayback(pattern, entryID: log.first?.id)
    }

    /// Plays a pattern from the activity log without logging it again, so the list doesn't change
    /// under the user's finger.
    func replay(_ entry: LogEntry) {
        startPlayback(entry.pattern, entryID: entry.id)
    }

    private func startPlayback(_ pattern: HapticPattern, entryID: LogEntry.ID?) {
        engine.play(pattern)

        // The engine doesn't report when a pattern finishes, so clear it once its duration has passed.
        // A new tap replaces the one before it.
        let playback = Playback(pattern: pattern, entryID: entryID)
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

    func clearLog() {
        log.removeAll()
    }
}
