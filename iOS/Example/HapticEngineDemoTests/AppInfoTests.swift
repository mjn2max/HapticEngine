//
// AppInfoTests.swift
// HapticEngineDemoTests
//

import Foundation
import Testing
@testable import HapticEngineDemo

@Suite("AppInfo")
struct AppInfoTests {
    @Test func showsTheVersionAndBuild() {
        let info = ["CFBundleShortVersionString": "1.2", "CFBundleVersion": "34"]
        #expect(AppInfo.version(from: info) == "Version 1.2 (34)")
    }

    /// "Version 1.0 (1.0)" says nothing more than "Version 1.0".
    @Test func leavesOutABuildThatRepeatsTheVersion() {
        let info = ["CFBundleShortVersionString": "1.0", "CFBundleVersion": "1.0"]
        #expect(AppInfo.version(from: info) == "Version 1.0")
    }

    @Test func survivesAMissingVersion() {
        #expect(AppInfo.version(from: nil) == "Version –")
    }

    @Test func reportsAnIssueOnTheRepository() {
        let url = AppInfo.newIssue(body: "Hi & bye")
        #expect(url.absoluteString.hasPrefix("https://github.com/mjn2max/HapticEngine/issues/new?body="))
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems?.first { $0.name == "body" }?.value == "Hi & bye")
    }

    /// What a haptics bug depends on, below the questions the reporter answers.
    @Test func startsAnIssueWithTheDevice() {
        let body = AppInfo.issueBody(device: "iPhone15,2", system: "iOS 26.0", appVersion: "Version 1.0 (1)", isHapticsSupported: false)
        #expect(body.hasPrefix("**What happened?**"))
        #expect(body.contains("Device: iPhone15,2"))
        #expect(body.contains("System: iOS 26.0"))
        #expect(body.contains("Demo app: Version 1.0 (1)"))
        #expect(body.contains("Haptics: Not supported"))
    }

    @Test func knowsTheDeviceModel() {
        // A model identifier, such as "iPhone15,2", not the marketing name.
        #expect(AppInfo.deviceModel.contains(","))
    }
}
