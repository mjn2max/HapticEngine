//
// AccessibilityUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// What VoiceOver reads, the size of things to tap, and the home screen at the largest text sizes.
final class AccessibilityUITests: DemoUITestCase {
    private static let largestText = DemoUITestCase.cleanState
        + ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXL"]

    // MARK: VoiceOver

    func testPatternsReadAsTheirNameNotTheirIcon() {
        launch()
        let success = pattern("success")
        XCTAssertTrue(success.waitForExistence(timeout: 2))
        let spoken = "\(success.label) \(success.value as? String ?? "")"
        // The icon's symbol is `checkmark.circle`, which VoiceOver would read as "Selected".
        XCTAssertFalse(spoken.contains("Selected"), spoken)
        XCTAssertTrue(success.label.contains("Success"), spoken)
    }

    func testAFavoriteSaysSo() {
        launch()
        reveal("rain")
        XCTAssertFalse((pattern("rain").value as? String ?? "").contains("Favorite"))
        toggleFavoriteFromContextMenu("rain")
        XCTAssertTrue((pattern("rain").value as? String ?? "").contains("Favorite"), "The star is read out")
    }

    func testThePlayingPatternSaysSo() {
        launch()
        play("complex")
        // Complex plays for six seconds, plenty to read it while playing.
        XCTAssertTrue((pattern("complex").value as? String ?? "").contains("Playing"))
    }

    func testTheHeaderButtonsAreBigEnoughToTap() {
        launch()
        for (name, button) in [("filter", filterButton), ("search", searchButton)] {
            XCTAssertGreaterThanOrEqual(button.frame.width, 44, name)
            XCTAssertGreaterThanOrEqual(button.frame.height, 44, name)
        }
        XCTExpectFailure("Known issue from the pre-release review: the menu button is 36 by 36 points.", options: .nonStrict())
        XCTAssertGreaterThanOrEqual(appMenu.frame.height, 44, "menu")
    }

    // MARK: Largest text

    func testTheHeaderFitsItsBarAtTheLargestText() {
        launch(Self.largestText)
        // The navigation bar holds a hidden copy of the title, to keep its place: take the one drawn.
        let title = app.staticTexts.matching(identifier: "Haptic Engine").allElementsBoundByIndex
            .first { $0.isHittable } ?? app.staticTexts["Haptic Engine"].firstMatch
        let count = app.staticTexts["All · 100"]
        XCTAssertTrue(title.waitForExistence(timeout: 2) && count.exists)
        attachScreenshot("largest text, list")

        // Within the 44 points the search capsule takes in the bar, give or take a few: not up in the
        // status bar, nor down in the list.
        let bar = searchButton.frame
        XCTAssertGreaterThanOrEqual(title.frame.minY, bar.minY - 6, "Title: \(title.frame), bar: \(bar)")
        XCTAssertLessThanOrEqual(count.frame.maxY, bar.maxY + 6, "Count: \(count.frame), bar: \(bar)")
        XCTAssertFalse(filterButton.frame.intersects(searchButton.frame.insetBy(dx: 1, dy: 1)), "Filter and search don't overlap")
        XCTAssertFalse(title.frame.intersects(filterButton.frame), "The title clears the buttons")

        // The first section starts below the header.
        let firstSection = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Feedback'")).firstMatch
        XCTAssertTrue(firstSection.exists)
        XCTAssertGreaterThan(firstSection.frame.minY, count.frame.maxY, "The count doesn't run into the list")
    }

    func testTheGridHasWiderTilesAtTheLargestText() {
        launch(Self.largestText.map { $0 == "list" ? "grid" : $0 })
        XCTAssertTrue(pattern("tick").waitForExistence(timeout: 2))
        attachScreenshot("largest text, grid")

        let tiles = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'pattern.'")).allElementsBoundByIndex
            .filter { $0.isHittable }
        let columns = Set(tiles.map { Int($0.frame.minX.rounded()) })
        // As many 160-point tiles as fit across, less the 16-point margins: two on an iPhone, more on an
        // iPad. Three or more on an iPhone would cut the names short.
        let width = app.windows.firstMatch.frame.width - 32
        let expected = max(Int((width + 12) / (160 + 12)), 1)
        XCTAssertEqual(columns.count, expected, "Tiles start at \(columns.sorted())")
    }

    func testTheTipStaysShortAtTheLargestText() {
        launch(Self.largestText)
        let tip = app.staticTexts["Tap Any Pattern to Feel It"]
        XCTAssertTrue(tip.waitForExistence(timeout: 2))
        let screen = app.windows.firstMatch.frame
        let bar = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label CONTAINS 'Tap Any Pattern to Feel It'")).firstMatch
        XCTAssertLessThan(bar.frame.height, screen.height * 0.2, "The tip leaves the patterns the screen: \(bar.frame)")
    }
}
