//
// DemoUITestCase.swift
// HapticEngineDemoUITests
//

import XCTest

/// What the end-to-end suites share: launching from a known state, and the elements every screen uses.
///
/// Launch arguments override saved preferences without replacing them, so each launch starts the same
/// whatever an earlier run saved. A suite that checks what's saved launches again without them.
@MainActor
class DemoUITestCase: XCTestCase {
    var app: XCUIApplication!

    /// Every pattern, as a list, no favorites, haptics mocked, activity kept in memory.
    static let cleanState = [
        "-MockHaptics", "YES", "-ActivityInMemory", "YES",
        "-patternFilter", "all",
        "-patternLayout", "list",
        "-favorites", "()",
    ]

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    /// Launches, first ending any earlier launch.
    func launch(_ arguments: [String] = DemoUITestCase.cleanState) {
        app.terminate()
        app.launchArguments = arguments
        app.launch()
        XCTAssertTrue(appMenu.waitForExistence(timeout: 5), "The home screen appears")
    }

    // MARK: Elements

    var appMenu: XCUIElement { app.buttons["appMenu"] }
    var filterButton: XCUIElement { app.buttons["filterButton"] }
    var searchButton: XCUIElement { app.buttons["searchButton"] }
    var searchField: XCUIElement { app.textFields["searchField"] }
    var clearFilterToken: XCUIElement { app.buttons["clearFilter"] }
    var nowPlaying: XCUIElement { app.descendants(matching: .any)["nowPlaying"] }
    var menuBack: XCUIElement { app.buttons["menu.done"] }
    var menuActivity: XCUIElement { app.buttons["menu.activity"] }

    func pattern(_ rawValue: String) -> XCUIElement { app.buttons["pattern.\(rawValue)"] }

    /// A row of the menu page. Links read as links, not buttons, so match either.
    func menuRow(_ title: String) -> XCUIElement {
        app.descendants(matching: .any).matching(NSPredicate(
            format: "label BEGINSWITH %@ AND (elementType == %d OR elementType == %d)",
            title, XCUIElement.ElementType.button.rawValue, XCUIElement.ElementType.link.rawValue
        )).firstMatch
    }

    /// A row of the activity log, which reads as the pattern's name, then the time.
    func activityRow(_ title: String) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "\(title),")).firstMatch
    }

    var activityRows: XCUIElementQuery {
        app.buttons.matching(NSPredicate(format: "label MATCHES %@", "^[A-Z][A-Za-z ]+, .*[0-9].*"))
    }

    // MARK: Actions

    /// Scrolls the patterns until one is on screen: they're drawn lazily, so those further down don't
    /// exist until scrolled to. Scrolls from near the top, clear of the now-playing bar and the keyboard.
    @discardableResult
    func reveal(_ rawValue: String, file: StaticString = #filePath, line: UInt = #line) -> XCUIElement {
        let button = pattern(rawValue)
        // Up the list, then down: the hundred built by hand, which tests use, are near the top, and at the
        // top the first scroll finds the edge. Each way stops at the list's edge, found when a scroll no
        // longer changes which patterns are laid out: a thousand patterns are too many to cross blindly.
        let patterns = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'pattern.'"))
        func laidOut() -> [String] { patterns.allElementsBoundByIndex.map(\.identifier) }
        for distance: CGFloat in [220, -220] {
            var scrolls = 0
            while !(button.exists && button.isHittable) && scrolls < 80 {
                let before = laidOut()
                let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: distance < 0 ? 0.45 : 0.25))
                start.press(forDuration: 0.05, thenDragTo: start.withOffset(CGVector(dx: 0, dy: distance)), withVelocity: .fast, thenHoldForDuration: 0.1)
                scrolls += 1
                if !button.exists, laidOut() == before { break }
            }
        }
        XCTAssertTrue(button.isHittable, "pattern.\(rawValue) scrolled into view", file: file, line: line)
        return button
    }

    /// Plays a pattern on the home screen, and waits for the bar to name it: the bar alone shows only
    /// that something played.
    func play(_ rawValue: String, file: StaticString = #filePath, line: UInt = #line) {
        let button = reveal(rawValue, file: file, line: line)
        // The list reads the name, then the description: the name is what the bar shows.
        let name = String(button.label.split(separator: ",").first ?? "")
        button.tap()
        let named = NSPredicate(format: "label CONTAINS %@", name)
        XCTAssertEqual(
            XCTWaiter.wait(for: [expectation(for: named, evaluatedWith: nowPlaying)], timeout: 3), .completed,
            "The bar shows \(name), not \(nowPlaying.label)", file: file, line: line
        )
    }

    /// Deletes an activity row with a long, fast swipe across it, as a person deletes in one move.
    func swipeToDelete(_ row: XCUIElement) {
        let start = row.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        let end = row.coordinate(withNormalizedOffset: CGVector(dx: 0.05, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end, withVelocity: .fast, thenHoldForDuration: 0)
    }

    /// Picks a filter, or a layout, from the menu beside search.
    func chooseInFilterMenu(_ title: String) {
        filterButton.tap()
        let item = app.buttons[title].firstMatch
        XCTAssertTrue(item.waitForExistence(timeout: 2), "\(title) is in the filter menu")
        item.tap()
        // Filters and layouts alike close the menu.
        let closed = NSPredicate(format: "exists == false OR hittable == false")
        XCTAssertEqual(XCTWaiter.wait(for: [expectation(for: closed, evaluatedWith: item)], timeout: 2), .completed,
                       "The filter menu closes after picking \(title)")
    }

    /// Stars a pattern from its context menu.
    func toggleFavoriteFromContextMenu(_ rawValue: String, expecting title: String = "Add to Favorites") {
        reveal(rawValue).press(forDuration: 1.0)
        let item = app.buttons[title]
        XCTAssertTrue(item.waitForExistence(timeout: 3), "The context menu offers \(title)")
        item.tap()
        XCTAssertTrue(item.waitForNonExistence(timeout: 3))
    }

    func openMenu() {
        appMenu.tap()
        XCTAssertTrue(menuBack.waitForExistence(timeout: 3), "The menu page opens")
    }

    func openActivity() {
        openMenu()
        XCTAssertTrue(menuActivity.waitForExistence(timeout: 2))
        menuActivity.tap()
        XCTAssertTrue(app.navigationBars["Activity"].waitForExistence(timeout: 3), "Activity opens")
    }

    func leaveActivity() {
        app.navigationBars["Activity"].buttons.firstMatch.tap()
        XCTAssertTrue(appMenu.waitForExistence(timeout: 3))
    }

    /// Empties the log through the screen, as a person would: for suites using the log saved on disk.
    func clearActivityIfAny() {
        openActivity()
        let clear = app.navigationBars["Activity"].buttons["Clear"]
        if clear.isEnabled {
            clear.tap()
            let confirm = app.buttons["Clear Activity"]
            XCTAssertTrue(confirm.waitForExistence(timeout: 2))
            confirm.tap()
            XCTAssertTrue(app.staticTexts["No Activity Yet"].waitForExistence(timeout: 3))
        }
        leaveActivity()
    }

    func attachScreenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
