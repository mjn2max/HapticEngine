//
// HapticDemoModelTests.swift
// HapticEngineDemoTests
//

import Foundation
import HapticEngine
import Testing
@testable import HapticEngineDemo

@MainActor
@Suite("Demo model")
struct HapticDemoModelTests {
    private let engine = SpyEngine()
    private let defaults = makeDefaults()
    private let queue = DispatchQueue(label: "HapticDemoModelTests.playback")

    private func makeModel() -> HapticDemoModel {
        HapticDemoModel(engine: engine, preferences: Preferences(defaults: defaults), playbackQueue: queue)
    }

    /// What the engine was asked to play, once the playback queue has caught up.
    private var plays: [HapticPattern] {
        queue.sync {}
        return engine.plays
    }

    // MARK: Playing

    @Test func playsOnTheEngineInOrder() {
        let model = makeModel()
        model.play(.tick)
        model.play(.coin)
        model.play(.coin)
        #expect(plays == [.tick, .coin, .coin])
    }

    @Test func showsWhatsPlaying() throws {
        let model = makeModel()
        model.play(.thunder)
        let playback = try #require(model.nowPlaying)
        #expect(playback.pattern == .thunder)
        #expect(playback.entryID == model.log.first?.id)
        #expect(model.lastPlayed == .thunder)
    }

    @Test func aShortPatternShowsLongEnoughToNotice() {
        let model = makeModel()
        model.play(.tick)
        #expect(model.nowPlaying?.displayDuration == HapticDemoModel.Playback.minimumDisplayDuration)
    }

    @Test func playbackEndsAfterThePattern() async throws {
        let model = makeModel()
        model.play(.tick)
        let deadline = Date().addingTimeInterval(HapticDemoModel.Playback.minimumDisplayDuration + 2)
        while model.nowPlaying != nil, Date() < deadline {
            try await Task.sleep(for: .milliseconds(50))
        }
        #expect(model.nowPlaying == nil)
        // Kept, so its description can still be read and it can be played again.
        #expect(model.lastPlayed == .tick)
    }

    @Test func anotherPlayReplacesTheOneBefore() async throws {
        let model = makeModel()
        model.play(.complex)
        model.play(.tick)
        #expect(model.nowPlaying?.pattern == .tick)
        // The first play's end must not clear the second.
        try await Task.sleep(for: .milliseconds(100))
        #expect(model.nowPlaying?.pattern == .tick)
    }

    // MARK: Log

    @Test func logsOnlyChangesOfPattern() {
        let model = makeModel()
        model.play(.tick)
        model.play(.tick)
        model.play(.coin)
        model.play(.tick)
        #expect(model.log.map(\.pattern) == [.tick, .coin, .tick])
    }

    @Test func logKeepsTheNewestUpToItsLimit() {
        let model = makeModel()
        let patterns = Array(HapticPattern.allCases.prefix(HapticDemoModel.logLimit + 5))
        patterns.forEach(model.play)
        #expect(model.log.count == HapticDemoModel.logLimit)
        #expect(model.log.first?.pattern == patterns.last)
    }

    @Test func replayPlaysWithoutLogging() throws {
        let model = makeModel()
        model.play(.tick)
        model.play(.coin)
        let entry = try #require(model.log.last)
        model.replay(entry)
        #expect(model.log.map(\.pattern) == [.coin, .tick])
        #expect(model.nowPlaying?.entryID == entry.id)
        #expect(plays == [.tick, .coin, .tick])
    }

    @Test func deletesAndClearsEntries() throws {
        let model = makeModel()
        model.play(.tick)
        model.play(.coin)
        model.deleteEntry(try #require(model.log.first))
        #expect(model.log.map(\.pattern) == [.tick])
        model.clearLog()
        #expect(model.log.isEmpty)
    }

    // MARK: Saved between launches

    @Test func favoritesAreSaved() {
        let model = makeModel()
        model.toggleFavorite(.rain)
        model.toggleFavorite(.coin)
        model.toggleFavorite(.rain)
        #expect(model.favorites == [.coin])
        #expect(model.isFavorite(.coin))
        #expect(!model.isFavorite(.rain))
        #expect(makeModel().favorites == [.coin])
    }

    @Test func filterAndLayoutAreSaved() {
        let model = makeModel()
        model.filter = .category(.mechanical)
        model.layout = .list
        let reopened = makeModel()
        #expect(reopened.filter == .category(.mechanical))
        #expect(reopened.layout == .list)
    }

    @Test func reportsWhetherHapticsAreSupported() {
        #expect(makeModel().isHapticsSupported)
        let unsupported = HapticDemoModel(engine: SpyEngine(isHapticsSupported: false), preferences: Preferences(defaults: defaults))
        #expect(!unsupported.isHapticsSupported)
    }

    // MARK: Launch ripple

    @Test func claimsTheLaunchRippleOnlyOnTheFirstLaunch() {
        #expect(makeModel().claimLaunchRipple())
        #expect(!makeModel().claimLaunchRipple())
    }

    @Test func neverClaimsTheLaunchRippleWithoutHaptics() {
        let unsupported = HapticDemoModel(engine: SpyEngine(isHapticsSupported: false), preferences: Preferences(defaults: defaults))
        #expect(!unsupported.claimLaunchRipple())
        // Still to come, should haptics play here later.
        #expect(!Preferences(defaults: defaults).hasFeltLaunchRipple)
    }
}
