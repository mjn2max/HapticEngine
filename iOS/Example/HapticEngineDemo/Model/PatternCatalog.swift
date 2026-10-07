//
// PatternCatalog.swift
// HapticEngineDemo
//

import Foundation
import HapticEngine

/// The patterns to show together, under an optional heading.
struct PatternSection: Identifiable, Equatable {
    let id: String
    let title: String?
    let patterns: [HapticPattern]
}

/// Which patterns the browser shows, for a filter or a search. Plain functions of their inputs, kept out
/// of the views so they can be unit tested and computed once per update.
enum PatternCatalog {
    /// A search shows every category with a match, whatever the filter: someone searching wants a pattern
    /// wherever it is. Otherwise the filter's patterns show, under category headings only for all.
    static func sections(
        filter: PatternFilter,
        search: PatternSearch,
        favorites: [HapticPattern],
        recents: [HapticPattern] = []
    ) -> [PatternSection] {
        if !search.isEmpty {
            return categorySections(where: search.matches)
        }
        switch filter {
        case .all:
            return categorySections { _ in true }
        case .favorites:
            return favorites.isEmpty ? [] : [PatternSection(id: "favorites", title: nil, patterns: favorites)]
        case .recent:
            return recents.isEmpty ? [] : [PatternSection(id: "recent", title: nil, patterns: recents)]
        case .category(let category):
            return [PatternSection(id: category.rawValue, title: nil, patterns: category.patterns)]
        }
    }

    /// How many patterns `filter` shows.
    static func count(of filter: PatternFilter, favorites: [HapticPattern], recents: [HapticPattern] = []) -> Int {
        switch filter {
        case .all: HapticPattern.allCases.count
        case .favorites: favorites.count
        case .recent: recents.count
        case .category(let category): category.patterns.count
        }
    }

    /// One section per category with a pattern that passes `include`, headed by its name and count.
    private static func categorySections(where include: (HapticPattern) -> Bool) -> [PatternSection] {
        HapticPattern.Category.allCases.compactMap { category in
            let patterns = category.patterns.filter(include)
            guard !patterns.isEmpty else { return nil }
            return PatternSection(id: category.rawValue, title: "\(category.title) · \(patterns.count)", patterns: patterns)
        }
    }
}

/// What's typed in the search field, ready to match patterns.
///
/// A pattern matches when every word typed starts a word in its name, description or category, ignoring
/// case and accents. Matching word starts, not any fragment, keeps "rain" from finding "fine-grained".
/// Text with no letters or digits, such as "-", searches for nothing, so the patterns stay in view.
struct PatternSearch: Equatable {
    private let words: [String]

    init(_ query: String) {
        words = Self.words(in: query)
    }

    /// Whether nothing searchable was typed.
    var isEmpty: Bool { words.isEmpty }

    func matches(_ pattern: HapticPattern) -> Bool {
        let patternWords = Self.index[pattern, default: []]
        return words.allSatisfy { word in
            patternWords.contains { $0.hasPrefix(word) }
        }
    }

    /// Each pattern's words, folded once rather than on every keystroke for all hundred patterns.
    private static let index: [HapticPattern: [String]] = Dictionary(
        uniqueKeysWithValues: HapticPattern.allCases.map { pattern in
            (pattern, words(in: "\(pattern.title) \(pattern.subtitle) \(pattern.category.title)"))
        }
    )

    /// The words in `text`, folded for comparison: "Fade-Out" gives "fade" and "out".
    private static func words(in text: String) -> [String] {
        text.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .split { !$0.isLetter && !$0.isNumber }
            .map(String.init)
    }
}
