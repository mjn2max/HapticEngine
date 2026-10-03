//
// NoHapticsUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// The demo on a device without haptic hardware, as the Simulator is without `-MockHaptics`: it says
/// so, and nothing pretends to play.
final class NoHapticsUITests: DemoUITestCase {
    override func setUp() async throws {
        try await super.setUp()
        launch(["-ActivityInMemory", "YES", "-patternFilter", "all", "-patternLayout", "list", "-favorites", "()"])
    }

    func testTheBarWarnsInsteadOfTheTip() {
        XCTAssertTrue(app.staticTexts["No Haptics on This Device"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Patterns only play on an iPhone."].exists)
        XCTAssertFalse(app.staticTexts["Tap Any Pattern to Feel It"].exists)
        attachScreenshot("no haptics")
    }

    func testPatternsCantBePlayed() {
        let tick = pattern("tick")
        XCTAssertTrue(tick.waitForExistence(timeout: 2))
        XCTAssertFalse(tick.isEnabled)
        tick.tap()
        XCTAssertFalse(app.buttons["Play Again"].waitForExistence(timeout: 1), "Nothing plays")
    }

    func testTheMenuExplainsAndDisablesActivity() {
        openMenu()
        XCTAssertTrue(app.staticTexts["This device has no Taptic Engine, so patterns can't be felt here. Try the demo on an iPhone."].exists)
        XCTAssertFalse(menuActivity.isEnabled)
        // The rest of the menu still works.
        XCTAssertTrue(app.buttons["menu.package"].isEnabled)
        attachScreenshot("menu without haptics")
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
