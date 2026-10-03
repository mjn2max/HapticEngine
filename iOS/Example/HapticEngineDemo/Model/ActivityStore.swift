//
// ActivityStore.swift
// HapticEngineDemo
//

import Foundation
import HapticEngine
import SwiftData

/// One pattern played, as saved: see `ActivityStore`.
@Model
final class ActivityRecord {
    #Index<ActivityRecord>([\.date])

    @Attribute(.unique) var id: UUID
    var date: Date
    /// The pattern's raw value. A pattern renamed or removed since is skipped on loading, rather than
    /// failing the whole log.
    var pattern: String

    init(id: UUID, date: Date, pattern: String) {
        self.id = id
        self.date = date
        self.pattern = pattern
    }
}

/// Where the activity log is saved between launches, with SwiftData: the newest `limit` entries, the
/// oldest going first.
///
/// `HapticDemoModel` keeps the log in memory too, for the screen to read, and writes each change through.
/// Saved at once, so a quit or a crash loses nothing.
@MainActor
final class ActivityStore {
    static let limit = 1000

    private let context: ModelContext

    init(container: ModelContainer) {
        context = ModelContext(container)
        context.autosaveEnabled = false
    }

    /// In the app's Application Support folder. Should that fail, as when the disk is full, in memory:
    /// the log then lasts until the app quits, as it used to, rather than the app failing to launch.
    static func onDisk() -> ActivityStore {
        do {
            return ActivityStore(container: try ModelContainer(for: ActivityRecord.self))
        } catch {
            return inMemory()
        }
    }

    /// For tests, previews and UI tests, which start empty and save nothing.
    static func inMemory() -> ActivityStore {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        // An in-memory store has no file to fail on.
        return ActivityStore(container: try! ModelContainer(for: ActivityRecord.self, configurations: configuration))
    }

    /// Newest first.
    func load() -> [HapticDemoModel.LogEntry] {
        var newestFirst = FetchDescriptor<ActivityRecord>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        newestFirst.fetchLimit = Self.limit
        let records = (try? context.fetch(newestFirst)) ?? []
        return records.compactMap { record in
            HapticPattern(rawValue: record.pattern).map {
                HapticDemoModel.LogEntry(id: record.id, date: record.date, pattern: $0)
            }
        }
    }

    func add(_ entry: HapticDemoModel.LogEntry) {
        context.insert(ActivityRecord(id: entry.id, date: entry.date, pattern: entry.pattern.rawValue))
        removeOldest()
        save()
    }

    func delete(_ id: UUID) {
        try? context.delete(model: ActivityRecord.self, where: #Predicate { $0.id == id })
        save()
    }

    func deleteAll() {
        try? context.delete(model: ActivityRecord.self)
        save()
    }

    /// Down to the limit.
    private func removeOldest() {
        let count = (try? context.fetchCount(FetchDescriptor<ActivityRecord>())) ?? 0
        guard count > Self.limit else { return }
        var oldestFirst = FetchDescriptor<ActivityRecord>(sortBy: [SortDescriptor(\.date)])
        oldestFirst.fetchLimit = count - Self.limit
        for record in (try? context.fetch(oldestFirst)) ?? [] {
            context.delete(record)
        }
    }

    private func save() {
        // Nothing to recover: the log in memory is still right, and the next change tries again.
        try? context.save()
    }
}
