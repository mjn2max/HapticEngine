//
// MenuUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// The menu page: what it says about the app, and where each row leads.
final class MenuUITests: DemoUITestCase {
    override func setUp() async throws {
        try await super.setUp()
        launch()
    }

    func testTheHeaderShowsTheVersionAndHapticsStatus() {
        openMenu()
        let header = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS 'Version '")).firstMatch
        XCTAssertTrue(header.waitForExistence(timeout: 2))
        XCTAssertTrue(header.label.contains("Haptic Engine"), header.label)
        XCTAssertNotNil(header.label.range(of: #"Version \d+\.\d+"#, options: .regularExpression), header.label)
        XCTAssertTrue(app.staticTexts["Made with care by Huy D. · MIT License"].exists)
        XCTAssertFalse(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'This device has no Taptic Engine'")).firstMatch.exists)
        attachScreenshot("menu")
    }

    func testEveryRowIsThere() {
        openMenu()
        for row in ["History", "Use in Your App", "Source Code", "Report an Issue", "License"] {
            let element = menuRow(row)
            XCTAssertTrue(element.exists, "\(row) row")
            XCTAssertTrue(element.isHittable, "\(row) row can be tapped")
        }
        XCTAssertTrue(menuActivity.isEnabled, "History opens where haptics play")
    }

    func testTheLicenseOpensAndGoesBackToTheMenu() {
        openMenu()
        menuRow("License").tap()
        XCTAssertTrue(app.navigationBars["License"].waitForExistence(timeout: 2))
        let text = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'MIT License'")).firstMatch
        XCTAssertTrue(text.exists)
        XCTAssertTrue(text.label.contains("Copyright (c) 2025 Huy D."))
        XCTAssertTrue(text.label.contains("Permission is hereby granted"))
        attachScreenshot("license")

        app.navigationBars["License"].buttons.firstMatch.tap()
        XCTAssertTrue(app.navigationBars["License"].waitForNonExistence(timeout: 2))
        XCTAssertTrue(menuBack.exists, "Back on the menu, not home")
    }

    /// Known issue from the pre-release review: the menu's swipe back reacts on the License page too.
    func testSwipingLeftOnTheLicenseStaysOnTheLicense() {
        openMenu()
        menuRow("License").tap()
        XCTAssertTrue(app.navigationBars["License"].waitForExistence(timeout: 2))

        app.swipeLeft()

        XCTExpectFailure("The menu's swipe back is attached to its whole NavigationStack, so it closes the menu from the License page.", options: .nonStrict())
        XCTAssertTrue(app.navigationBars["License"].waitForExistence(timeout: 2))
    }

    func testSourceCodeOpensSafari() {
        openMenu()
        menuRow("Source Code").tap()
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        XCTAssertTrue(safari.wait(for: .runningForeground, timeout: 10), "The link opens in Safari")
        app.activate()
        XCTAssertTrue(menuBack.waitForExistence(timeout: 3), "Coming back finds the menu still open")
    }

    func testTheMenuKeepsTheSearchUnderneath() {
        searchButton.tap()
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.typeText("rain")
        openMenu()
        XCTAssertFalse(app.keyboards.firstMatch.exists, "Opening the menu puts the keyboard away")
        menuBack.tap()
        XCTAssertTrue(menuBack.waitForNonExistence(timeout: 2))
        XCTAssertEqual(searchField.value as? String, "rain")
        XCTAssertTrue(pattern("rain").exists)
    }
}
