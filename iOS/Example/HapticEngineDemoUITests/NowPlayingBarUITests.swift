//
// NowPlayingBarUITests.swift
// HapticEngineDemoUITests
//

import XCTest

/// Drives the now-playing bar through its three sizes, by tap, swipe and button. Runs in the Simulator
/// with `-MockHaptics YES`, so patterns can be played without haptic hardware.
@MainActor
final class NowPlayingBarUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [
            "-MockHaptics", "YES",
            "-patternFilter", "all",
            "-patternLayout", "list",
            "-favorites", "()",
        ]
        app.launch()
        app.buttons["pattern.error"].tap()
        XCTAssertTrue(header.waitForExistence(timeout: 2))
    }

    func testTapOpensTheSummaryAndTapsAgainToClose() {
        let collapsedTop = header.frame.minY
        header.tap()
        XCTAssertTrue(toggleFull.waitForExistence(timeout: 2))
        settle()
        attachScreenshot("summary")
        XCTAssertLessThan(header.frame.minY, collapsedTop - 100)
        XCTAssertEqual(toggleFull.label, "More Details")

        header.tap()
        settle()
        XCTAssertEqual(header.frame.minY, collapsedTop, accuracy: 2)
        XCTAssertTrue(app.buttons["pattern.tick"].isHittable)
    }

    func testMoreDetailsOpensTheFullSizeBelowTheNavigationBar() {
        header.tap()
        settle()
        let summaryTop = header.frame.minY
        toggleFull.tap()
        settle()
        attachScreenshot("full")
        XCTAssertLessThan(header.frame.minY, summaryTop - 100)
        XCTAssertEqual(toggleFull.label, "Fewer Details")
        // The navigation bar stays in sight and in reach.
        XCTAssertTrue(app.buttons["appMenu"].isHittable)
        XCTAssertGreaterThan(header.frame.minY, app.buttons["appMenu"].frame.maxY)
        XCTAssertTrue(app.staticTexts["Events"].exists)
        // No room is left for the patterns, so they fade out rather than showing as a strip under the
        // status bar, and can't be tapped by accident.
        XCTAssertFalse(app.buttons["pattern.tick"].isHittable)

        toggleFull.tap()
        settle()
        XCTAssertEqual(header.frame.minY, summaryTop, accuracy: 2)
    }

    func testSwipesStepThroughTheSizes() {
        let collapsedTop = header.frame.minY
        drag(header, by: -140)
        settle()
        let summaryTop = header.frame.minY
        XCTAssertLessThan(summaryTop, collapsedTop - 100)
        attachScreenshot("swiped to summary")

        drag(header, by: -220)
        settle()
        XCTAssertLessThan(header.frame.minY, summaryTop - 100)
        attachScreenshot("swiped to full")

        // A slow drag down from full settles on the summary, the nearest size.
        drag(header, by: summaryTop - header.frame.minY)
        settle()
        XCTAssertEqual(header.frame.minY, summaryTop, accuracy: 4)

        drag(header, by: collapsedTop - summaryTop)
        settle()
        XCTAssertEqual(header.frame.minY, collapsedTop, accuracy: 4)
    }

    func testFullDetailsScrollWithoutResizing() {
        header.tap()
        settle()
        toggleFull.tap()
        settle()
        let fullTop = header.frame.minY
        let similar = app.staticTexts["More in Feedback"]
        drag(app.staticTexts["Events"].firstMatch, by: -300)
        settle()
        attachScreenshot("full scrolled")
        XCTAssertEqual(header.frame.minY, fullTop, accuracy: 2)
        XCTAssertTrue(similar.exists)
    }

    func testOpeningAndClosingLeavesAFilteredListInPlace() {
        app.terminate()
        app.launchArguments = ["-MockHaptics", "YES", "-patternFilter", "category.game", "-patternLayout", "grid", "-favorites", "()"]
        app.launch()
        let first = app.buttons["pattern.coin"]
        XCTAssertTrue(first.waitForExistence(timeout: 2))
        first.tap()
        settle()
        let top = first.frame.minY
        // By tap and button.
        for _ in 1...3 {
            header.tap()
            settle()
            toggleFull.tap()
            settle()
            header.tap()
            settle()
            XCTAssertEqual(first.frame.minY, top, accuracy: 1)
        }
        // By dragging, up past the full size and back down past the collapsed one.
        let collapsedTop = header.frame.minY
        for _ in 1...3 {
            drag(header, by: -600)
            settle()
            drag(header, by: collapsedTop - header.frame.minY + 80)
            settle()
            XCTAssertEqual(header.frame.minY, collapsedTop, accuracy: 4)
            XCTAssertEqual(first.frame.minY, top, accuracy: 1)
        }
        attachScreenshot("filtered after resizing")
        XCTAssertTrue(first.isHittable)
    }

    // MARK: Helpers

    private var header: XCUIElement { app.descendants(matching: .any)["nowPlaying"] }
    private var toggleFull: XCUIElement { app.buttons["toggleFullDetails"] }

    /// A slow drag, so the bar settles on the size nearest where it's let go, not where a flick goes.
    private func drag(_ element: XCUIElement, by distance: CGFloat) {
        let start = element.coordinate(withNormalizedOffset: CGVector(dx: 0.3, dy: 0.5))
        let end = start.withOffset(CGVector(dx: 0, dy: distance))
        start.press(forDuration: 0.05, thenDragTo: end, withVelocity: .slow, thenHoldForDuration: 0.3)
    }

    private func settle() {
        Thread.sleep(forTimeInterval: 0.8)
    }

    private func attachScreenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
