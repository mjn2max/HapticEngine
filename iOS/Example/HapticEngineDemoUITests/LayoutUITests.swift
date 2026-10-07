//
// LayoutUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// Where the home screen puts things, on every device the demo runs on: iPhone and iPad, portrait and
/// landscape. iPads have no haptic hardware, so they also show the demo as it is without it.
final class LayoutUITests: DemoUITestCase {
    override func tearDown() async throws {
        XCUIDevice.shared.orientation = .portrait
        try await super.tearDown()
    }

    func testTheFirstSectionStartsBelowTheNavigationBar() {
        launch()
        assertFirstSectionClearsTheBar()
    }

    func testTheFirstSectionStartsBelowTheNavigationBarInTheGrid() {
        launch(DemoUITestCase.cleanState.map { $0 == "list" ? "grid" : $0 })
        assertFirstSectionClearsTheBar()
    }

    /// As on an iPad, which has no haptic hardware: the patterns are dimmed, and the bar is a warning.
    func testTheFirstSectionStartsBelowTheNavigationBarWithoutHaptics() {
        launch(["-ActivityInMemory", "YES", "-patternFilter", "all", "-patternLayout", "list", "-favorites", "()"])
        assertFirstSectionClearsTheBar()
    }

    func testTheFirstSectionStartsBelowTheNavigationBarInTheGridWithoutHaptics() {
        launch(["-ActivityInMemory", "YES", "-patternFilter", "all", "-patternLayout", "grid", "-favorites", "()"])
        assertFirstSectionClearsTheBar()
    }

    func testLandscapeKeepsTheHeaderAndBar() throws {
        launch()
        XCUIDevice.shared.orientation = .landscapeLeft
        // iPhones without landscape support stay as they are.
        let window = app.windows.firstMatch.frame
        try XCTSkipIf(window.width < window.height, "This device keeps portrait")
        attachScreenshot("landscape")

        XCTAssertTrue(appMenu.isHittable && filterButton.isHittable && searchButton.isHittable)
        XCTAssertTrue(nowPlaying.waitForExistence(timeout: 2) || app.staticTexts["Tap Any Pattern to Feel It"].exists)
        assertFirstSectionClearsTheBar()
        play("tick")
    }

    /// A list row is read across: on a wide screen it stops at a readable width rather than spanning it.
    func testTheListKeepsAReadableWidth() {
        launch()
        let tick = pattern("tick")
        XCTAssertTrue(tick.waitForExistence(timeout: 2))
        let window = app.windows.firstMatch.frame
        XCTAssertLessThanOrEqual(tick.frame.width, 700, "Row: \(tick.frame)")
        XCTAssertEqual(tick.frame.midX, window.midX, accuracy: 2, "Centered: \(tick.frame) in \(window)")
        attachScreenshot("list width")
    }

    /// The full size is one height for every pattern, but no taller than its details need on a tall screen.
    func testTheFullSizeLeavesNoLargeGapOnTallScreens() {
        launch()
        play("error")
        nowPlaying.tap()
        let toggle = app.buttons["Fewer Details"].exists ? app.buttons["Fewer Details"] : app.buttons["More Details"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 3))
        toggle.tap()
        XCTAssertTrue(app.buttons["Fewer Details"].waitForExistence(timeout: 3))
        Thread.sleep(forTimeInterval: 0.8)
        attachScreenshot("full size")

        let similar = app.buttons["similar.error"]
        XCTAssertTrue(similar.waitForExistence(timeout: 2))
        let top = nowPlaying.frame.minY
        XCTAssertLessThanOrEqual(similar.frame.maxY - top, 840, "The full size stays phone-tall: from \(top) to \(similar.frame.maxY)")
    }

    /// Every place to go is in sight as the filter panel opens, with its count: no submenu, no scrolling.
    func testTheFilterPanelShowsEveryChoiceAtOnce() {
        launch()
        filterButton.tap()
        let done = app.buttons["filter.done"]
        XCTAssertTrue(done.waitForExistence(timeout: 2))
        attachScreenshot("filter panel")
        let tiles = ["all", "favorites", "recent"] + ["feedback", "alerts", "rhythm", "texture", "nature", "mechanical", "game",
                     "impacts", "tapCounts", "signals", "meters", "surfaces", "waves", "dynamics", "weather", "machines", "arcade"]
            .map { "category.\($0)" }
        for id in tiles {
            XCTAssertTrue(app.buttons["filter.\(id)"].isHittable, "\(id) is in sight")
        }
        XCTAssertEqual(app.buttons["filter.category.weather"].value as? String, "90 patterns")
        XCTAssertTrue(app.buttons["filter.all"].isSelected)

        app.buttons["filter.category.weather"].tap()
        XCTAssertTrue(done.waitForNonExistence(timeout: 2), "Picking closes the panel")
        XCTAssertTrue(pattern("faintDrizzle").waitForExistence(timeout: 3))
        XCTAssertFalse(pattern("tick").exists)
        XCTAssertEqual(filterButton.value as? String, "Weather")

        // Opened again, the choice showing is marked.
        filterButton.tap()
        XCTAssertTrue(app.buttons["filter.category.weather"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["filter.category.weather"].isSelected)
        done.tap()
    }

    private func assertFirstSectionClearsTheBar(file: StaticString = #filePath, line: UInt = #line) {
        let header = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Feedback'")).firstMatch
        XCTAssertTrue(header.waitForExistence(timeout: 3), "The first section's header shows", file: file, line: line)
        let barBottom = max(filterButton.frame.maxY, appMenu.frame.maxY)
        let message = "Header \(header.frame), bar buttons end at \(barBottom), list \(app.scrollViews["patternList"].frame), tick \(pattern("tick").frame)"
        print("LAYOUT:", message)
        XCTAssertGreaterThanOrEqual(header.frame.minY, barBottom, message, file: file, line: line)
        XCTAssertGreaterThanOrEqual(pattern("tick").frame.minY, header.frame.maxY, message, file: file, line: line)
        attachScreenshot("top of the list")
    }
}
