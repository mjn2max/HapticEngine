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
    struct LogEntry: Identifiable, Equatable {
        let id: UUID
        let date: Date
        let pattern: HapticPattern

        init(id: UUID = UUID(), date: Date = .now, pattern: HapticPattern) {
            self.id = id
            self.date = date
            self.pattern = pattern
        }
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

        var displayDuration: TimeInterval { max(pattern.duration, Self.minimumDisplayDuration) }
    }

    /// The most entries the log keeps; the oldest go first.
    static let logLimit = ActivityStore.limit

    private let engine: any HapticEngineProtocol
    private let preferences: Preferences
    /// Where the log is saved between launches.
    private let activity: ActivityStore
    /// Where patterns are handed to the engine. Off the main thread: starting the engine again after the
    /// system idled it can take long enough to drop frames just as a tapped pattern starts animating.
    /// Serial, so patterns still play in the order they were tapped.
    @ObservationIgnored private let playbackQueue: DispatchQueue

    /// Patterns the user starred, in the order they were starred. Saved between launches.
    private(set) var favorites: [HapticPattern] {
        didSet { preferences.favorites = favorites }
    }
    /// What the browser shows. Saved between launches.
    var filter: PatternFilter {
        didSet { preferences.filter = filter }
    }
    /// How the browser lays out the patterns. Saved between launches.
    var layout: PatternLayout {
        didSet { preferences.layout = layout }
    }
    /// Newest first. Only records a pattern when it differs from the one before, so replays don't add entries.
    /// Saved between launches.
    private(set) var log: [LogEntry] {
        didSet { logDays = ActivityDay.group(log) }
    }
    /// The log split into days, for the activity screen. Grouped when the log changes, not on every
    /// redraw: a thousand entries were regrouped each time a replay started or stopped.
    private(set) var logDays: [ActivityDay] = []
    private(set) var nowPlaying: Playback?
    /// Stays set after the pattern finishes, so its description can still be read.
    private(set) var lastPlayed: HapticPattern?
    @ObservationIgnored private var playbackEndTask: Task<Void, Never>?

    var isHapticsSupported: Bool { engine.isHapticsSupported }

    init(
        engine: any HapticEngineProtocol = HapticEngine(),
        preferences: Preferences = Preferences(),
        activity: ActivityStore? = nil,
        playbackQueue: DispatchQueue = DispatchQueue(label: "dev.codepassion.HapticEngineDemo.playback", qos: .userInteractive)
    ) {
        self.engine = engine
        self.preferences = preferences
        // In memory unless given one, so tests and previews start empty and save nothing.
        self.activity = activity ?? .inMemory()
        self.playbackQueue = playbackQueue
        favorites = preferences.favorites
        filter = preferences.filter
        layout = preferences.layout
        log = self.activity.load()
        logDays = ActivityDay.group(log)
    }

    /// Whether the launch reveal's haptic ripple should play: once, on the first launch, where haptics play.
    /// Asking counts as playing it, so it never plays again.
    func claimLaunchRipple() -> Bool {
        guard isHapticsSupported, !preferences.hasFeltLaunchRipple else { return false }
        preferences.hasFeltLaunchRipple = true
        return true
    }

    func isFavorite(_ pattern: HapticPattern) -> Bool {
        favorites.contains(pattern)
    }

    func toggleFavorite(_ pattern: HapticPattern) {
        if let index = favorites.firstIndex(of: pattern) {
            favorites.remove(at: index)
        } else {
            favorites.append(pattern)
        }
    }

    /// Plays a pattern chosen on the home screen, logging it if it differs from the last one logged.
    func play(_ pattern: HapticPattern) {
        if log.first?.pattern != pattern {
            let entry = LogEntry(pattern: pattern)
            log.insert(entry, at: 0)
            if log.count > Self.logLimit { log.removeLast(log.count - Self.logLimit) }
            activity.add(entry)
        }
        startPlayback(pattern, entryID: log.first?.id)
    }

    /// Plays a pattern from the activity log without logging it again, so the list doesn't change
    /// under the user's finger.
    func replay(_ entry: LogEntry) {
        startPlayback(entry.pattern, entryID: entry.id)
    }

    private func startPlayback(_ pattern: HapticPattern, entryID: LogEntry.ID?) {
        let engine = engine
        playbackQueue.async { engine.play(pattern) }

        // The engine doesn't report when a pattern finishes, so clear it once its duration has passed.
        // A new tap replaces the one before it.
        let playback = Playback(pattern: pattern, entryID: entryID)
        nowPlaying = playback
        lastPlayed = pattern
        playbackEndTask?.cancel()
        playbackEndTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(playback.displayDuration))
            guard !Task.isCancelled else { return }
            self?.nowPlaying = nil
        }
        AccessibilityNotification.Announcement("Playing \(pattern.title)").post()
    }

    func deleteEntry(_ entry: LogEntry) {
        log.removeAll { $0.id == entry.id }
        activity.delete(entry.id)
    }

    func clearLog() {
        log.removeAll()
        activity.deleteAll()
    }
}
