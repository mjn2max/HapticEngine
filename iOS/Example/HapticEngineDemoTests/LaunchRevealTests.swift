//
// LaunchRevealTests.swift
// HapticEngineDemoTests
//

import HapticEngine
import Testing
@testable import HapticEngineDemo

@Suite("Launch reveal")
struct LaunchRevealTests {
    @Test func startsAtTheCorner() {
        #expect(LaunchReveal.delay(row: 0) == LaunchReveal.start)
    }

    /// Tiles along a diagonal arrive together, as one sweep.
    @Test func spreadsDiagonally() {
        #expect(LaunchReveal.delay(row: 1, column: 2) == LaunchReveal.delay(row: 3))
        #expect(LaunchReveal.delay(row: 2, column: 1) == LaunchReveal.delay(row: 1, column: 2))
    }

    /// The wave gathers speed: each row further out waits less after the one before.
    @Test func easesOut() {
        let delays = (0...10).map { LaunchReveal.delay(row: Double($0)) }
        let gaps = zip(delays.dropFirst(), delays).map { $0 - $1 }
        #expect(gaps.allSatisfy { $0 > 0 })
        #expect(zip(gaps.dropFirst(), gaps).allSatisfy { $0 < $1 })
    }

    /// Patterns past a screenful join the last of it rather than queueing up offscreen.
    @Test func endsAfterAScreenful() {
        let last = LaunchReveal.start + LaunchReveal.spread
        #expect(abs(LaunchReveal.delay(row: LaunchReveal.reach) - last) < 1e-9)
        #expect(LaunchReveal.delay(row: 40, column: 3) == LaunchReveal.delay(row: LaunchReveal.reach))
        #expect(LaunchReveal.barDelay < last)
    }

    @Test(arguments: [(0, 1), (99, 1), (100, 1), (211, 1), (212, 2), (343, 3), (390, 3), (500, 4)])
    func fitsTilesAsTheGridDoes(width: Double, columns: Int) {
        #expect(PatternGrid.columnCount(width: width) == columns)
    }

    @Test func titledSectionsTakeHalfARowForTheTitleAndARowPerLineOfTiles() {
        let sections = [
            PatternSection(id: "a", title: "A", patterns: [.tick, .coin, .rain, .knock]),
            PatternSection(id: "b", title: "B", patterns: [.pulse]),
        ]
        let rows = WaveRows(sections: sections, columnCount: 3)
        #expect(rows.first == [0.5, 3])
        #expect(rows.end == 4)
    }

    @Test func untitledListRowsTakeARowEach() {
        let sections = [PatternSection(id: "results", title: nil, patterns: [.tick, .coin, .rain])]
        let rows = WaveRows(sections: sections, columnCount: 1)
        #expect(rows.first == [0])
        #expect(rows.end == 3)
    }
}
