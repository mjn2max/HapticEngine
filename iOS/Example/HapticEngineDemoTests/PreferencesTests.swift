//
// PreferencesTests.swift
// HapticEngineDemoTests
//

import HapticEngine
import Testing
@testable import HapticEngineDemo

@Suite("Preferences")
struct PreferencesTests {
    @Test func startsWithTheDefaults() {
        let preferences = Preferences(defaults: makeDefaults())
        #expect(preferences.favorites.isEmpty)
        #expect(preferences.filter == .all)
        #expect(preferences.layout == .grid)
    }

    @Test func remembersWhatWasSaved() {
        let defaults = makeDefaults()
        let preferences = Preferences(defaults: defaults)
        preferences.favorites = [.coin, .rain]
        preferences.filter = .category(.nature)
        preferences.layout = .list

        let reopened = Preferences(defaults: defaults)
        #expect(reopened.favorites == [.coin, .rain])
        #expect(reopened.filter == .category(.nature))
        #expect(reopened.layout == .list)
    }

    /// Saved by an older version, such as a renamed pattern, a removed category or the old cards layout.
    @Test func dropsValuesThatNoLongerExist() {
        let defaults = makeDefaults()
        defaults.set(["coin", "noSuchPattern", "rain"], forKey: "favorites")
        defaults.set("category.noSuchCategory", forKey: "patternFilter")
        defaults.set("cards", forKey: "patternLayout")

        let preferences = Preferences(defaults: defaults)
        #expect(preferences.favorites == [.coin, .rain])
        #expect(preferences.filter == .all)
        #expect(preferences.layout == .grid)
    }

    /// UI tests pass these as launch arguments, so they must keep their names.
    @Test func keysAreStable() {
        let defaults = makeDefaults()
        let preferences = Preferences(defaults: defaults)
        preferences.favorites = [.tick]
        preferences.filter = .favorites
        preferences.layout = .list
        #expect(defaults.stringArray(forKey: "favorites") == ["tick"])
        #expect(defaults.string(forKey: "patternFilter") == "favorites")
        #expect(defaults.string(forKey: "patternLayout") == "list")
    }

    @Test(arguments: PatternFilter.allFilters)
    func everyFilterSurvivesSaving(filter: PatternFilter) {
        #expect(PatternFilter(storageValue: filter.storageValue) == filter)
    }

    @Test func filterIDsAreUnique() {
        let ids = PatternFilter.allFilters.map(\.id)
        #expect(Set(ids).count == ids.count)
    }
}
