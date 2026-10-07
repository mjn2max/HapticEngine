//
// ActivityUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// The activity log: what's recorded, the empty state, deleting, clearing, and keeping it across launches.
final class ActivityUITests: DemoUITestCase {
    func testStartsEmptyAndASuggestionFillsIt() {
        launch()
        openActivity()

        XCTAssertTrue(app.staticTexts["No History Yet"].exists)
        XCTAssertFalse(app.navigationBars["History"].buttons["Clear"].isEnabled, "Nothing to clear")
        attachScreenshot("empty")

        let suggestion = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Play '")).firstMatch
        XCTAssertTrue(suggestion.waitForExistence(timeout: 2), "The empty state suggests patterns")
        let title = String(suggestion.label.dropFirst("Play ".count))
        suggestion.tap()

        XCTAssertTrue(activityRow(title).waitForExistence(timeout: 3), "Playing a suggestion logs it")
        XCTAssertFalse(app.staticTexts["No History Yet"].exists)
        XCTAssertTrue(app.navigationBars["History"].buttons["Clear"].isEnabled)
    }

    func testEntriesAreGroupedUnderTodayNewestFirst() {
        launch()
        play("tick")
        play("success")
        play("warning")
        openActivity()

        let today = app.staticTexts.matching(NSPredicate(format: "label ==[c] 'today'")).firstMatch
        XCTAssertTrue(today.waitForExistence(timeout: 2), "Today's entries have a header")
        let warning = activityRow("Warning"), success = activityRow("Success"), tick = activityRow("Tick")
        XCTAssertTrue(warning.exists && success.exists && tick.exists)
        XCTAssertLessThan(today.frame.minY, warning.frame.minY)
        XCTAssertLessThan(warning.frame.minY, success.frame.minY)
        XCTAssertLessThan(success.frame.minY, tick.frame.minY)
        attachScreenshot("three entries")
    }

    func testPlayingTheSamePatternAgainAddsNoEntry() {
        launch()
        play("tick")
        play("tick")
        app.buttons["Play Again"].tap()
        openActivity()

        XCTAssertTrue(activityRow("Tick").waitForExistence(timeout: 2))
        XCTAssertEqual(activityRows.count, 1, "Replays aren't logged again")
    }

    func testReplayingAnEntryKeepsTheLogAsItIs() {
        launch()
        play("tick")
        play("success")
        openActivity()

        activityRow("Tick").tap()
        // The row plays in place; the log doesn't grow or reorder.
        XCTAssertTrue(activityRow("Tick").waitForExistence(timeout: 2))
        XCTAssertEqual(activityRows.count, 2)
        XCTAssertLessThan(activityRow("Success").frame.minY, activityRow("Tick").frame.minY)
    }

    func testAFullSwipeDeletesOneEntry() {
        launch()
        play("tick")
        play("success")
        openActivity()

        let success = activityRow("Success")
        XCTAssertTrue(success.waitForExistence(timeout: 2))
        swipeToDelete(success)

        XCTAssertTrue(success.waitForNonExistence(timeout: 3))
        XCTAssertTrue(activityRow("Tick").exists, "Only the swiped entry goes")
        XCTAssertEqual(activityRows.count, 1)
    }

    func testClearingAsksFirstAndCanBeCancelled() {
        launch()
        play("tick")
        play("success")
        openActivity()

        app.navigationBars["History"].buttons["Clear"].tap()
        let message = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '2 entries'")).firstMatch
        XCTAssertTrue(message.waitForExistence(timeout: 2), "The dialog says how many entries go")
        attachScreenshot("confirm clear")

        // Cancelling keeps everything.
        let cancel = app.buttons["Cancel"]
        if cancel.exists {
            cancel.tap()
        } else {
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
        XCTAssertTrue(app.buttons["Clear History"].waitForNonExistence(timeout: 2))
        XCTAssertEqual(activityRows.count, 2)

        app.navigationBars["History"].buttons["Clear"].tap()
        app.buttons["Clear History"].tap()
        XCTAssertTrue(app.staticTexts["No History Yet"].waitForExistence(timeout: 3))
    }

    func testTheMenuBadgeFollowsTheLog() {
        launch()
        play("tick")
        play("success")
        openMenu()
        XCTAssertTrue(menuActivity.label.contains("2"), "Badge shows 2: \(menuActivity.label)")
        menuActivity.tap()
        XCTAssertTrue(app.navigationBars["History"].waitForExistence(timeout: 3))

        swipeToDelete(activityRow("Tick"))
        XCTAssertTrue(activityRow("Tick").waitForNonExistence(timeout: 3))
        leaveActivity()

        openMenu()
        XCTAssertTrue(menuActivity.label.contains("1"), "Badge shows 1: \(menuActivity.label)")
    }

    /// Uses the log saved on disk, emptied through the screen first and last.
    func testTheLogIsKeptAcrossLaunches() {
        let onDisk = ["-MockHaptics", "YES", "-patternFilter", "all", "-patternLayout", "list", "-favorites", "()"]
        launch(onDisk)
        clearActivityIfAny()
        play("rain")
        play("thunder")

        launch(onDisk)
        openActivity()
        XCTAssertTrue(activityRow("Thunder").waitForExistence(timeout: 3), "Saved entries load on launch")
        XCTAssertTrue(activityRow("Rain").exists)
        XCTAssertLessThan(activityRow("Thunder").frame.minY, activityRow("Rain").frame.minY, "Still newest first")
        attachScreenshot("after relaunch")

        // A deletion is saved too.
        swipeToDelete(activityRow("Rain"))
        XCTAssertTrue(activityRow("Rain").waitForNonExistence(timeout: 3))
        leaveActivity()
        launch(onDisk)
        openActivity()
        XCTAssertTrue(activityRow("Thunder").waitForExistence(timeout: 3))
        XCTAssertFalse(activityRow("Rain").exists, "The deleted entry stays deleted")
        leaveActivity()

        clearActivityIfAny()
    }
}
