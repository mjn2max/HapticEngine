//
// SearchUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// Drives search the way people use it: tapping, typing, scrolling and navigating, alone and mixed
/// together. Runs in the Simulator with `-MockHaptics YES`, so patterns can be tapped without haptic
/// hardware.
@MainActor
final class SearchUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // A known starting point, whatever an earlier run saved: every pattern, as a list, no favorites.
        app.launchArguments = [
            "-MockHaptics", "YES",
            "-patternFilter", "all",
            "-patternLayout", "list",
            "-favorites", "()",
        ]
        app.launch()
    }

    // MARK: Single actions

    func testSearchStartsAsOnlyAButton() {
        XCTAssertTrue(searchButton.exists)
        XCTAssertFalse(searchField.exists)
        XCTAssertTrue(filterButton.exists)
        XCTAssertEqual(searchButton.value as? String, "")
    }

    func testOpeningSearchFocusesTheFieldAndHidesTheFilter() {
        openSearch()
        XCTAssertTrue(keyboard.waitForExistence(timeout: 2))
        XCTAssertFalse(filterButton.exists)
        XCTAssertFalse(searchButton.exists)
        attachScreenshot("search open")
    }

    func testTypingFindsPatternsByTheStartOfAWord() {
        openSearch()
        searchField.typeText("rain")
        XCTAssertTrue(pattern("rain").waitForExistence(timeout: 2))
        XCTAssertTrue(pattern("raindrop").exists)
        // Its description says "fine-grained", which contains "rain" but doesn't start with it.
        XCTAssertFalse(pattern("sandpaper").exists)
    }

    func testNoMatchesSaysSo() {
        openSearch()
        searchField.typeText("zzzz")
        let noResults = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'No Results'")).firstMatch
        XCTAssertTrue(noResults.waitForExistence(timeout: 2))
        attachScreenshot("no results")
    }

    func testClearingKeepsSearchOpenAndFocused() {
        openSearch()
        searchField.typeText("rain")
        app.buttons["Clear Search"].tap()
        XCTAssertTrue(searchField.exists)
        XCTAssertTrue(keyboard.exists)
        // With nothing typed, the patterns show again.
        XCTAssertTrue(pattern("tick").waitForExistence(timeout: 2))
    }

    func testCancelReturnsToBrowsing() {
        openSearch()
        searchField.typeText("rain")
        app.buttons["Cancel"].tap()
        XCTAssertTrue(searchField.waitForNonExistence(timeout: 2))
        XCTAssertTrue(filterButton.exists)
        XCTAssertTrue(pattern("tick").exists)
        XCTAssertFalse(keyboard.exists)
        XCTAssertEqual(searchButton.value as? String, "")
    }

    // MARK: Scrolling

    func testScrollingMinimizesSearchButKeepsTheResults() {
        openSearch()
        searchField.typeText("tap")
        XCTAssertTrue(pattern("tick").waitForExistence(timeout: 2))

        scrollList(.up)

        XCTAssertTrue(searchField.waitForNonExistence(timeout: 2), "The field closes into its button")
        XCTAssertFalse(keyboard.exists)
        XCTAssertTrue(searchButton.exists)
        XCTAssertEqual(searchButton.value as? String, "tap", "The button says a search is active")
        // Still results, not the full browse: the filter stays away and a non-match stays hidden.
        XCTAssertFalse(filterButton.exists)
        XCTAssertFalse(pattern("rain").exists)
        attachScreenshot("minimized with results")
    }

    func testReopeningAMinimizedSearchKeepsTheQuery() {
        openSearch()
        searchField.typeText("tap")
        scrollList(.up)
        XCTAssertTrue(searchField.waitForNonExistence(timeout: 2))

        searchButton.tap()

        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        XCTAssertEqual(searchField.value as? String, "tap")
        XCTAssertTrue(keyboard.waitForExistence(timeout: 2))
    }

    func testScrollingWithNothingTypedClosesSearch() {
        openSearch()
        scrollList(.up)
        XCTAssertTrue(searchField.waitForNonExistence(timeout: 2))
        XCTAssertTrue(filterButton.waitForExistence(timeout: 2))
        XCTAssertEqual(searchButton.value as? String, "")
    }

    func testScrollingBackDownDoesNotReopenSearch() {
        openSearch()
        searchField.typeText("tap")
        scrollList(.up)
        scrollList(.down)
        scrollList(.down)
        XCTAssertFalse(searchField.exists)
        XCTAssertEqual(searchButton.value as? String, "tap")
    }

    // MARK: Filters

    func testTheFilterStaysInTheToolbarWhileScrolling() {
        XCTAssertTrue(filterButton.exists)
        XCTAssertEqual(filterButton.value as? String, "All")
        scrollList(.up)
        XCTAssertTrue(filterButton.exists)
        attachScreenshot("browsing")
    }

    func testPickingAFilterShowsItsPatterns() {
        scrollList(.up)
        pickFilter("Nature")
        XCTAssertTrue(pattern("thunder").waitForExistence(timeout: 2))
        XCTAssertFalse(pattern("tick").exists)
        XCTAssertEqual(filterButton.value as? String, "Nature")
        attachScreenshot("nature")
    }

    func testSearchHidesTheFilter() {
        openSearch()
        XCTAssertFalse(filterButton.exists)
        searchField.typeText("tap")
        scrollList(.up)
        XCTAssertTrue(searchField.waitForNonExistence(timeout: 2))
        XCTAssertFalse(filterButton.exists, "Results ignore the filter, so it isn't offered")
        app.buttons["searchButton"].tap()
        app.buttons["Cancel"].tap()
        XCTAssertTrue(filterButton.waitForExistence(timeout: 2))
    }

    // MARK: Mixed actions

    func testPlayingAResultKeepsTheSearch() {
        openSearch()
        searchField.typeText("rain")
        pattern("rain").tap()
        XCTAssertTrue(keyboard.waitForNonExistence(timeout: 2), "Playing puts the keyboard away")
        XCTAssertTrue(app.buttons["Play Again"].waitForExistence(timeout: 2), "The bar shows the pattern")
        XCTAssertEqual(searchField.value as? String, "rain", "The search stays")
        XCTAssertTrue(pattern("raindrop").exists)
        XCTAssertFalse(pattern("tick").exists)
    }

    func testSearchSurvivesAVisitToActivity() {
        openSearch()
        searchField.typeText("rain")
        pattern("rain").tap()
        scrollList(.up)
        XCTAssertTrue(searchField.waitForNonExistence(timeout: 2))

        app.buttons["Activity"].tap()
        XCTAssertTrue(app.navigationBars["Activity"].waitForExistence(timeout: 2))
        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertTrue(searchButton.waitForExistence(timeout: 2))
        XCTAssertEqual(searchButton.value as? String, "rain")
        XCTAssertTrue(pattern("rain").exists)
        XCTAssertFalse(pattern("tick").exists)
    }

    func testRapidOpenAndCancelEndsCleanly() {
        for _ in 0..<4 {
            searchButton.tap()
            XCTAssertTrue(app.buttons["Cancel"].waitForExistence(timeout: 2))
            app.buttons["Cancel"].tap()
            XCTAssertTrue(searchButton.waitForExistence(timeout: 2))
        }
        XCTAssertFalse(searchField.exists)
        XCTAssertTrue(filterButton.exists)
        XCTAssertFalse(keyboard.exists)
    }

    func testFilteringAfterASearchShowsTheCategory() {
        openSearch()
        searchField.typeText("rain")
        app.buttons["Cancel"].tap()
        XCTAssertTrue(filterButton.waitForExistence(timeout: 2))
        pickFilter("Nature")
        XCTAssertTrue(pattern("thunder").waitForExistence(timeout: 2))
        XCTAssertFalse(pattern("tick").exists)
    }

    func testSearchLooksBeyondTheSelectedFilter() {
        pickFilter("Favorites")
        openSearch()
        searchField.typeText("rain")
        // Nothing is a favorite, yet search still finds patterns.
        XCTAssertTrue(pattern("rain").waitForExistence(timeout: 2))
    }

    // MARK: Helpers

    private var searchButton: XCUIElement { app.buttons["searchButton"] }
    private var searchField: XCUIElement { app.textFields["searchField"] }
    private var filterButton: XCUIElement { app.buttons["filterButton"] }
    private var keyboard: XCUIElement { app.keyboards.firstMatch }
    private var list: XCUIElement { app.scrollViews["patternList"] }

    private func pattern(_ rawValue: String) -> XCUIElement { app.buttons["pattern.\(rawValue)"] }

    private enum Direction { case up, down }

    /// Drags the list like a finger, in its upper half. `swipeUp()` aims at the middle of the whole list,
    /// which the keyboard covers while searching, so it doesn't scroll.
    private func scrollList(_ direction: Direction) {
        let (from, to): (CGFloat, CGFloat) = direction == .up ? (0.5, 0.2) : (0.2, 0.5)
        let start = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: from))
        let end = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: to))
        start.press(forDuration: 0.05, thenDragTo: end)
    }

    private func pickFilter(_ title: String) {
        filterButton.tap()
        let item = app.buttons[title].firstMatch
        XCTAssertTrue(item.waitForExistence(timeout: 2))
        item.tap()
    }

    private func openSearch() {
        searchButton.tap()
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
    }

    /// Kept in the test results, to look at how each state renders.
    private func attachScreenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
