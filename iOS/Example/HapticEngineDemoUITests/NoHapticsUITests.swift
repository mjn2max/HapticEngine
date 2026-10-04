//
// NoHapticsUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// The demo on a device without haptic hardware, as an iPad is, and the Simulator without `-MockHaptics`:
/// it says so, and patterns still show how they play, marked as not felt.
final class NoHapticsUITests: DemoUITestCase {
    override func setUp() async throws {
        try await super.setUp()
        launch(["-ActivityInMemory", "YES", "-patternFilter", "all", "-patternLayout", "list", "-favorites", "()"])
    }

    func testTheBarWarnsInsteadOfTheTip() {
        XCTAssertTrue(app.staticTexts["No Haptics on This Device"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Tap a pattern to see how it plays."].exists)
        XCTAssertFalse(app.staticTexts["Tap Any Pattern to Feel It"].exists)
        attachScreenshot("no haptics")
    }

    func testPatternsShowHowTheyPlayMarkedAsNotFelt() {
        let error = pattern("error")
        XCTAssertTrue(error.waitForExistence(timeout: 2))
        XCTAssertTrue(error.isEnabled, "Patterns can be tapped to see them")
        error.tap()

        // The player takes over from the warning, and says the pattern isn't felt here.
        XCTAssertTrue(nowPlaying.waitForExistence(timeout: 3))
        XCTAssertTrue(nowPlaying.label.contains("Error"), nowPlaying.label)
        XCTAssertTrue(nowPlaying.label.contains("Not felt on this device"), nowPlaying.label)
        XCTAssertFalse(app.staticTexts["No Haptics on This Device"].exists)

        // Its details and timeline open as on an iPhone.
        nowPlaying.tap()
        XCTAssertTrue(app.descendants(matching: .any)["Timeline"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Three strong taps in quick succession"].exists)
        attachScreenshot("pattern shown without haptics")
    }

    func testTheMenuExplainsAndActivityRecordsWhatWasShown() {
        play("tick")
        openMenu()
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'This device has no Taptic Engine'")).firstMatch.exists)
        XCTAssertTrue(menuActivity.isEnabled)
        attachScreenshot("menu without haptics")
        menuActivity.tap()
        XCTAssertTrue(app.navigationBars["Activity"].waitForExistence(timeout: 3))
        XCTAssertTrue(activityRow("Tick").waitForExistence(timeout: 2))
    }

    func testSearchAndFiltersStillWork() {
        chooseInFilterMenu("Nature")
        XCTAssertTrue(pattern("thunder").waitForExistence(timeout: 2))
        clearFilterToken.tap()
        searchButton.tap()
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.typeText("coin")
        XCTAssertTrue(pattern("coin").waitForExistence(timeout: 2))
    }
}
