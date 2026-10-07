//
// EndToEndJourneyUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// One person's session from launch to leaving, crossing every feature in turn: the pre-release check
/// that the flows still join up, where the other suites each look at one feature closely.
final class EndToEndJourneyUITests: DemoUITestCase {
    func testAFullSessionFromFirstTapToActivity() {
        launch()
        attachScreenshot("1 launch")

        // The tip shows until something plays.
        XCTAssertTrue(app.staticTexts["Tap Any Pattern to Feel It"].exists)

        // Play from the list; the bar takes over from the tip.
        play("success")
        XCTAssertFalse(app.staticTexts["Tap Any Pattern to Feel It"].exists)
        XCTAssertTrue(nowPlaying.label.contains("Success"), "The bar names the pattern: \(nowPlaying.label)")

        // Open the summary, star it from the bar, close it.
        nowPlaying.tap()
        let star = app.buttons["Add to Favorites"]
        XCTAssertTrue(star.waitForExistence(timeout: 3))
        star.tap()
        XCTAssertTrue(app.buttons["Remove from Favorites"].waitForExistence(timeout: 2))
        attachScreenshot("2 starred from the bar")
        nowPlaying.tap()

        // Favorites shows just that pattern, then the token clears the filter.
        chooseInFilterMenu("Favorites")
        XCTAssertTrue(pattern("success").waitForExistence(timeout: 2))
        XCTAssertFalse(pattern("tick").exists)
        XCTAssertTrue(clearFilterToken.waitForExistence(timeout: 2))
        clearFilterToken.tap()
        XCTAssertTrue(pattern("tick").waitForExistence(timeout: 2))

        // Search across everything and play a result.
        searchButton.tap()
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.typeText("thunder")
        play("thunder")
        app.buttons["Cancel"].tap()
        XCTAssertTrue(filterButton.waitForExistence(timeout: 2))

        // Switch to the grid; patterns still play from it.
        chooseLayout("Grid")
        XCTAssertTrue(app.staticTexts["One light, crisp tap"].waitForNonExistence(timeout: 2), "The grid has no descriptions")
        play("tick")
        attachScreenshot("3 grid")

        // The menu counts what was played, and Activity lists it newest first.
        openMenu()
        XCTAssertTrue(menuActivity.label.contains("3") || menuActivity.value as? String == "3",
                      "The menu shows 3 entries: \(menuActivity.label)")
        menuActivity.tap()
        XCTAssertTrue(app.navigationBars["History"].waitForExistence(timeout: 3))
        let tick = activityRow("Tick"), thunder = activityRow("Thunder"), success = activityRow("Success")
        XCTAssertTrue(tick.waitForExistence(timeout: 2))
        XCTAssertTrue(thunder.exists && success.exists)
        XCTAssertLessThan(tick.frame.minY, thunder.frame.minY, "Newest first")
        XCTAssertLessThan(thunder.frame.minY, success.frame.minY, "Newest first")
        attachScreenshot("4 activity")

        // Replay from the log, then delete an entry.
        thunder.tap()
        swipeToDelete(thunder)
        XCTAssertTrue(thunder.waitForNonExistence(timeout: 3), "A full swipe deletes")
        XCTAssertTrue(tick.exists && success.exists)

        // Back home, the grid and the bar are as they were left.
        leaveActivity()
        XCTAssertTrue(pattern("tick").exists)
        XCTAssertTrue(app.buttons["Play Again"].exists)
        attachScreenshot("5 back home")
    }
}
