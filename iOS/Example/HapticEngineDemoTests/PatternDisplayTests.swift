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

    /// The generator's descriptions give counts, tempos and lengths; each must match what plays.
    @Test(arguments: HapticPattern.allCases.filter { [.tapCounts, .meters, .dynamics].contains($0.category) })
    func familyDescriptionsMatchWhatPlays(pattern: HapticPattern) throws {
        let words = pattern.subtitle.split(separator: " ").map(String.init)
        switch pattern.category {
        case .tapCounts:
            // "Five taps at a brisk pace, the last strongest"
            let counts = ["Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven"]
            let count = try #require(counts.firstIndex(of: words[0])) + 2
            #expect(pattern.events.count == count)
        case .meters:
            // "One bar of waltz at 135 BPM": every tap lands on a twelfth of a beat, which holds straight and
            // swung eighths and sixteenths alike.
            let bpm = try #require(Double(words[words.count - 2]))
            let step = 60 / bpm / 12
            for event in pattern.events {
                #expect(abs((event.time / step).rounded() * step - event.time) < 0.0005, "\(event.time) s at \(bpm) BPM")
            }
        default:
            // "Growing steadily stronger over 0.4 s"
            let seconds = try #require(Double(words[words.count - 2]))
            #expect(abs(pattern.duration - seconds) < 0.0005)
        }
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
