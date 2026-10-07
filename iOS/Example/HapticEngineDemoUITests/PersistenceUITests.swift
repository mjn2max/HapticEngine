//
// PersistenceUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// What the demo remembers between launches: favorites, the filter and the layout.
///
/// Each test starts from the clean state, changes things through the screen, which saves them, then
/// launches again without the overrides, so the app reads only what it saved.
final class PersistenceUITests: DemoUITestCase {
    private static let savedOnly = ["-MockHaptics", "YES", "-ActivityInMemory", "YES"]

    func testFavoritesAreKeptInTheOrderStarred() {
        launch()
        toggleFavoriteFromContextMenu("thunder")
        toggleFavoriteFromContextMenu("tick")

        launch(Self.savedOnly)
        chooseInFilterMenu("Favorites")
        let thunder = pattern("thunder"), tick = pattern("tick")
        XCTAssertTrue(thunder.waitForExistence(timeout: 2))
        XCTAssertTrue(tick.exists)
        XCTAssertFalse(pattern("rain").exists)
        // Reading order, row by row, in either layout: the saved one may be the grid.
        XCTAssertTrue(
            (thunder.frame.minY, thunder.frame.minX) < (tick.frame.minY, tick.frame.minX),
            "In the order they were starred: \(thunder.frame) before \(tick.frame)"
        )
        attachScreenshot("favorites after relaunch")
    }

    func testUnstarringRemovesItFromFavoritesAtOnceAndAfterRelaunch() {
        launch()
        toggleFavoriteFromContextMenu("knock")
        chooseInFilterMenu("Favorites")
        XCTAssertTrue(pattern("knock").waitForExistence(timeout: 2))

        toggleFavoriteFromContextMenu("knock", expecting: "Remove from Favorites")
        XCTAssertTrue(pattern("knock").waitForNonExistence(timeout: 2), "Gone from Favorites straight away")

        launch(Self.savedOnly + ["-patternFilter", "favorites"])
        XCTAssertFalse(pattern("knock").exists)
    }

    func testTheFilterAndLayoutAreKept() {
        launch()
        chooseInFilterMenu("Nature")
        chooseLayout("Grid")
        XCTAssertTrue(pattern("thunder").waitForExistence(timeout: 2))

        launch(Self.savedOnly)
        XCTAssertTrue(pattern("thunder").waitForExistence(timeout: 2))
        XCTAssertFalse(pattern("tick").exists, "Still filtered to Nature")
        XCTAssertEqual(filterButton.value as? String, "Nature")
        XCTAssertFalse(app.staticTexts["A sharp crack, then a rolling rumble"].exists, "Still the grid, which has no descriptions")
        attachScreenshot("nature grid after relaunch")
    }
}
