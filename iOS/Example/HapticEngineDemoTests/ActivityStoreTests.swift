//
// ActivityStoreTests.swift
// HapticEngineDemoTests
//

import Foundation
import HapticEngine
import SwiftData
import Testing
@testable import HapticEngineDemo

@MainActor
@Suite("Activity store")
struct ActivityStoreTests {
    private typealias Entry = HapticDemoModel.LogEntry

    /// A store in a file of its own, so reopening it is like launching again.
    private func makeStore(at url: URL) throws -> ActivityStore {
        ActivityStore(container: try ModelContainer(for: ActivityRecord.self, configurations: ModelConfiguration(url: url)))
    }

    private func temporaryURL() -> URL {
        FileManager.default.temporaryDirectory.appending(path: "ActivityStoreTests-\(UUID().uuidString).store")
    }

    @Test func keepsEntriesOnDisk() throws {
        let url = temporaryURL()
        let now = Date.now
        let entries = [
            Entry(date: now, pattern: .coin),
            Entry(date: now.addingTimeInterval(-60), pattern: .rain),
            Entry(date: now.addingTimeInterval(-120), pattern: .tick),
        ]
        let store = try makeStore(at: url)
        // Oldest first, as they'd be played.
        entries.reversed().forEach(store.add)
        store.delete(entries[1].id)

        let reopened = try makeStore(at: url)
        #expect(reopened.load() == [entries[0], entries[2]])
    }

    @Test func keepsOnlyTheNewestUpToTheLimit() {
        let store = ActivityStore.inMemory()
        let start = Date.now
        let entries = (0..<ActivityStore.limit + 3).map {
            Entry(date: start.addingTimeInterval(Double($0)), pattern: $0.isMultiple(of: 2) ? .tick : .coin)
        }
        entries.forEach(store.add)

        let loaded = store.load()
        #expect(loaded.count == ActivityStore.limit)
        #expect(loaded.first == entries.last)
        #expect(loaded.last == entries[3], "The three oldest are gone")
    }

    @Test func clearsEverything() {
        let store = ActivityStore.inMemory()
        store.add(Entry(pattern: .tick))
        store.add(Entry(pattern: .coin))
        store.deleteAll()
        #expect(store.load().isEmpty)
    }

    /// Saved by an older version, for a pattern since renamed or removed.
    @Test func skipsPatternsThatNoLongerExist() throws {
        let container = try ModelContainer(for: ActivityRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = ModelContext(container)
        context.insert(ActivityRecord(id: UUID(), date: .now, pattern: "noSuchPattern"))
        try context.save()

        let store = ActivityStore(container: container)
        store.add(Entry(pattern: .tick))
        #expect(store.load().map(\.pattern) == [.tick])
    }
}

@Suite("Activity days")
struct ActivityDayTests {
    private typealias Entry = HapticDemoModel.LogEntry

    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    private func date(_ day: Int, _ hour: Int, month: Int = 10, year: Int = 2026) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
    }

    @Test func groupsRunsOfTheSameDay() {
        let log = [
            Entry(date: date(2, 15), pattern: .tick),
            Entry(date: date(2, 9), pattern: .coin),
            Entry(date: date(1, 22), pattern: .rain),
        ]
        let days = ActivityDay.group(log, calendar: calendar)
        #expect(days.map(\.entries.count) == [2, 1])
        #expect(days.map(\.id) == [date(2, 0), date(1, 0)])
    }

    @Test func namesRecentDaysInWords() {
        let now = date(2, 12)
        #expect(ActivityDay.title(for: date(2, 0), now: now, calendar: calendar) == "Today")
        #expect(ActivityDay.title(for: date(1, 0), now: now, calendar: calendar) == "Yesterday")
        // Within the week, the weekday; older, the date.
        #expect(ActivityDay.title(for: date(28, 0, month: 9), now: now, calendar: calendar) == date(28, 0, month: 9).formatted(.dateTime.weekday(.wide)))
        #expect(ActivityDay.title(for: date(1, 12, month: 9), now: now, calendar: calendar).contains("Sep"))
        #expect(ActivityDay.title(for: date(1, 12, month: 9, year: 2025), now: now, calendar: calendar).contains("2025"))
    }
}
