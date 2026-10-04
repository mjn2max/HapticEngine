//
// PatternCatalogTests.swift
// HapticEngineDemoTests
//

import HapticEngine
import Testing
@testable import HapticEngineDemo

@Suite("Pattern catalog")
struct PatternCatalogTests {
    private func sections(_ filter: PatternFilter = .all, query: String = "", favorites: [HapticPattern] = []) -> [PatternSection] {
        PatternCatalog.sections(filter: filter, search: PatternSearch(query), favorites: favorites)
    }

    private func patterns(_ sections: [PatternSection]) -> [HapticPattern] {
        sections.flatMap(\.patterns)
    }

    @Test func allShowsEveryPatternOnceUnderItsCategory() {
        let sections = sections()
        #expect(sections.map(\.id) == HapticPattern.Category.allCases.map(\.rawValue))
        #expect(Set(patterns(sections)) == Set(HapticPattern.allCases))
        #expect(patterns(sections).count == HapticPattern.allCases.count)
        #expect(sections.first?.title == "Feedback · \(HapticPattern.Category.feedback.patterns.count)")
    }

    @Test(arguments: HapticPattern.Category.allCases)
    func aCategoryShowsOnlyItsPatternsWithoutAHeading(category: HapticPattern.Category) {
        let sections = sections(.category(category))
        #expect(sections.count == 1)
        #expect(sections.first?.title == nil)
        #expect(patterns(sections) == category.patterns)
    }

    @Test func favoritesShowInTheOrderStarred() {
        #expect(sections(.favorites).isEmpty)
        #expect(patterns(sections(.favorites, favorites: [.thunder, .tick, .coin])) == [.thunder, .tick, .coin])
    }

    @Test(arguments: PatternFilter.allFilters)
    func countMatchesWhatTheFilterShows(filter: PatternFilter) {
        let favorites: [HapticPattern] = [.rain, .knock]
        #expect(PatternCatalog.count(of: filter, favorites: favorites) == patterns(sections(filter, favorites: favorites)).count)
    }

    // MARK: Search

    @Test func searchMatchesTheStartOfWordsOnly() {
        let found = patterns(sections(query: "rain"))
        #expect(found.contains(.rain))
        #expect(found.contains(.raindrop))
        // Its description says "fine-grained", which contains "rain" but doesn't start with it.
        #expect(!found.contains(.sandpaper))
    }

    @Test func searchIgnoresCaseAndAccents() {
        #expect(patterns(sections(query: "RÁIN")) == patterns(sections(query: "rain")))
    }

    @Test func everyWordMustMatch() {
        let found = patterns(sections(query: "heavy dull"))
        #expect(found.contains(.heavyImpact))
        #expect(!found.contains(.lightImpact))
    }

    @Test func searchMatchesTheCategoryName() {
        #expect(Set(patterns(sections(query: "game"))).isSuperset(of: HapticPattern.Category.game.patterns))
    }

    @Test func searchLooksBeyondTheFilter() {
        #expect(patterns(sections(.favorites, query: "thunder")).contains(.thunder))
        #expect(patterns(sections(.category(.game), query: "thunder")).contains(.thunder))
    }

    @Test func searchWithNoMatchesShowsNothing() {
        #expect(sections(query: "zzzz").isEmpty)
    }

    @Test(arguments: ["", "   ", "-", " · ", "!!"])
    func textWithoutLettersOrDigitsIsNotASearch(query: String) {
        #expect(PatternSearch(query).isEmpty)
        #expect(sections(.category(.nature), query: query) == sections(.category(.nature)))
    }

    @Test(arguments: HapticPattern.allCases)
    func everyPatternIsFoundByItsName(pattern: HapticPattern) {
        #expect(PatternSearch(pattern.title).matches(pattern))
    }
}
