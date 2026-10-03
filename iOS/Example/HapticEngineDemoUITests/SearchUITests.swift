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
            "-MockHaptics", "YES", "-ActivityInMemory", "YES",
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
        attachScreenshot("launch")
    }

    func testOpeningSearchWidensItInTheNavigationBar() {
        let buttonWidth = searchButton.frame.width
        openSearch()
        XCTAssertTrue(keyboard.waitForExistence(timeout: 2))
        attachScreenshot("search open")
        XCTAssertFalse(filterButton.exists)
        XCTAssertGreaterThan(searchField.frame.width, buttonWidth * 2)
        // Up to the menu, which stays.
        XCTAssertTrue(appMenu.isHittable)
        XCTAssertLessThan(appMenu.frame.maxX, searchField.frame.minX)
        // In the navigation bar, in a row with it, so it takes no room from the patterns.
        XCTAssertEqual(searchField.frame.midY, appMenu.frame.midY, accuracy: 4)
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
    }

    // MARK: Scrolling

    func testScrollingPutsTheKeyboardAwayButKeepsTheSearch() {
        openSearch()
        searchField.typeText("tap")
        XCTAssertTrue(pattern("tick").waitForExistence(timeout: 2))

        scrollList(.up)

        XCTAssertTrue(keyboard.waitForNonExistence(timeout: 2))
        XCTAssertEqual(searchField.value as? String, "tap", "The field stays, saying what the results are for")
        // Still results, not the full browse: the filter stays away and a non-match stays hidden.
        XCTAssertFalse(filterButton.exists)
        XCTAssertFalse(pattern("rain").exists)
        attachScreenshot("scrolled results")
    }

    func testTappingTheFieldAfterScrollingBringsTheKeyboardBack() {
        openSearch()
        searchField.typeText("tap")
        scrollList(.up)
        XCTAssertTrue(keyboard.waitForNonExistence(timeout: 2))

        searchField.tap()

        XCTAssertTrue(keyboard.waitForExistence(timeout: 2))
        XCTAssertEqual(searchField.value as? String, "tap")
    }

    func testScrollingWithNothingTypedClosesSearch() {
        openSearch()
        scrollList(.up)
        XCTAssertTrue(searchField.waitForNonExistence(timeout: 2))
        XCTAssertTrue(filterButton.waitForExistence(timeout: 2))
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

    func testTheWholeFilterButtonOpensItsMenu() {
        // The icon alone is about 27 by 17 points, too small a target.
        XCTAssertGreaterThanOrEqual(filterButton.frame.width, 44)
        XCTAssertGreaterThanOrEqual(filterButton.frame.height, 44)
        // Near the edges, well clear of the icon, as a quick thumb lands.
        for (dx, dy) in [(0.15, 0.5), (0.5, 0.15)] {
            filterButton.coordinate(withNormalizedOffset: CGVector(dx: dx, dy: dy)).tap()
            XCTAssertTrue(app.buttons["Nature"].firstMatch.waitForExistence(timeout: 2), "Tapped at \(dx), \(dy)")
            if dx == 0.15 { attachScreenshot("filter menu") }
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9)).tap()
            XCTAssertTrue(app.buttons["Nature"].firstMatch.waitForNonExistence(timeout: 2))
        }
    }

    func testSearchHidesTheFilter() {
        openSearch()
        XCTAssertFalse(filterButton.exists)
        searchField.typeText("tap")
        scrollList(.up)
        XCTAssertTrue(keyboard.waitForNonExistence(timeout: 2))
        XCTAssertFalse(filterButton.exists, "Results ignore the filter, so it isn't offered")
        app.buttons["Cancel"].tap()
        XCTAssertTrue(filterButton.waitForExistence(timeout: 2))
    }

    func testTheTitleTokenClearsTheFilter() {
        XCTAssertFalse(clearFilterToken.exists, "Nothing to clear while showing all")
        pickFilter("Nature")
        XCTAssertTrue(clearFilterToken.waitForExistence(timeout: 2))
        attachScreenshot("filter token")

        clearFilterToken.tap()

        XCTAssertTrue(pattern("tick").waitForExistence(timeout: 2))
        XCTAssertTrue(clearFilterToken.waitForNonExistence(timeout: 2))
        XCTAssertEqual(filterButton.value as? String, "All")
    }

    func testShowAllEndsAFilteredList() {
        XCTAssertFalse(app.buttons["showAll"].exists)
        pickFilter("Nature")
        XCTAssertTrue(pattern("thunder").waitForExistence(timeout: 2))
        let showAll = app.buttons["showAll"]
        for _ in 0..<4 where !showAll.isHittable { list.swipeUp() }
        attachScreenshot("show all")

        showAll.tap()

        XCTAssertTrue(pattern("tick").waitForExistence(timeout: 2))
        XCTAssertEqual(filterButton.value as? String, "All")
    }

    // MARK: Menu

    func testTheFilterMenuSwitchesLayout() {
        // The list shows each pattern's description; the grid doesn't.
        let description = app.staticTexts["One light, crisp tap"]
        XCTAssertTrue(description.exists)

        filterButton.tap()
        attachScreenshot("filter menu")
        app.buttons["Grid"].firstMatch.tap()

        XCTAssertTrue(description.waitForNonExistence(timeout: 2))
        XCTAssertTrue(pattern("tick").exists)
    }

    func testTheMenuClosesWithItsButtonOrASwipeBack() {
        let close = app.buttons["menu.done"]
        appMenu.tap()
        XCTAssertTrue(close.waitForExistence(timeout: 2))
        attachScreenshot("menu page")
        close.tap()
        XCTAssertTrue(close.waitForNonExistence(timeout: 2))

        appMenu.tap()
        XCTAssertTrue(close.waitForExistence(timeout: 2))
        app.collectionViews.firstMatch.swipeLeft()
        XCTAssertTrue(close.waitForNonExistence(timeout: 2))
        XCTAssertTrue(appMenu.isHittable)
    }

    func testTheMenuCopiesThePackageURL() {
        appMenu.tap()
        let row = app.buttons["menu.package"]
        XCTAssertTrue(row.waitForExistence(timeout: 2))
        row.tap()
        XCTAssertTrue(app.staticTexts["Copied. Paste it in Add Package Dependencies."].waitForExistence(timeout: 1))
        attachScreenshot("package copied")
    }

    func testTheMenuOpensActivity() {
        openActivity()
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(appMenu.waitForExistence(timeout: 2))
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

        openActivity()
        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        XCTAssertEqual(searchField.value as? String, "rain")
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
    private var clearFilterToken: XCUIElement { app.buttons["clearFilter"] }
    private var appMenu: XCUIElement { app.buttons["appMenu"] }
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

    private func openActivity() {
        appMenu.tap()
        let item = app.buttons["menu.activity"]
        XCTAssertTrue(item.waitForExistence(timeout: 2))
        item.tap()
        XCTAssertTrue(app.navigationBars["Activity"].waitForExistence(timeout: 2))
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
