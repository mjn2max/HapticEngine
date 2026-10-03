//
// PatternDisplayTests.swift
// HapticEngineDemoTests
//

import HapticEngine
import Testing
import UIKit
@testable import HapticEngineDemo

/// What the demo shows for each pattern. A new pattern in the library must be described here too.
@Suite("Pattern display")
struct PatternDisplayTests {
    @Test func titlesAreUnique() {
        let titles = HapticPattern.allCases.map(\.title)
        #expect(Set(titles).count == titles.count)
    }

    @Test(arguments: HapticPattern.allCases)
    func everyPatternIsDescribed(pattern: HapticPattern) {
        #expect(!pattern.title.isEmpty)
        #expect(!pattern.subtitle.isEmpty)
        #expect(!pattern.durationText.isEmpty)
    }

    /// A misspelled symbol name draws nothing, silently. Checked for everything the demo names.
    @Test func everySymbolExists() {
        let symbols = HapticPattern.allCases.map(\.systemImage)
            + HapticPattern.Category.allCases.map(\.systemImage)
            + PatternFilter.allFilters.map(\.systemImage)
            + PatternLayout.allCases.map(\.systemImage)
        for symbol in symbols {
            #expect(UIImage(systemName: symbol) != nil, "No SF Symbol named \(symbol)")
        }
    }

    @Test func everyCategoryHasPatterns() {
        for category in HapticPattern.Category.allCases {
            #expect(!category.patterns.isEmpty, "\(category) is empty")
            #expect(category.patterns.allSatisfy { $0.category == category })
        }
    }

    @Test func categoryPatternsKeepTheLibrarysOrder() {
        for category in HapticPattern.Category.allCases {
            #expect(category.patterns == HapticPattern.allCases.filter { $0.category == category })
        }
    }

    @Test func durationText() {
        #expect(HapticPattern.tick.durationText == "Instant")
        #expect(HapticPattern.success.durationText == "150 ms")
        #expect(HapticPattern.complex.durationText == 6.formatted(.number.precision(.fractionLength(0...1))) + " s")
    }

    /// VoiceOver reads this after the name, in place of the hidden icon.
    @Test func accessibilityValueSaysWhatTheIconShows() {
        #expect(PatternIcon.accessibilityValue(isPlaying: false, isFavorite: false) == "")
        #expect(PatternIcon.accessibilityValue(isPlaying: true, isFavorite: false) == "Playing")
        #expect(PatternIcon.accessibilityValue(isPlaying: true, isFavorite: true) == "Favorite, Playing")
        #expect(PatternIcon.accessibilityValue(isPlaying: false, isFavorite: true, detail: "150 ms") == "Favorite, 150 ms")
        #expect(PatternIcon.accessibilityValue(isPlaying: true, isFavorite: false, detail: "150 ms") == "Playing")
    }
}
