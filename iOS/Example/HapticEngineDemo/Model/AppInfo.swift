//
// AppInfo.swift
// HapticEngineDemo
//

import UIKit

/// What the menu says about the app: its version, and where the project lives.
enum AppInfo {
    /// Such as "Version 1.0 (1)", from the bundle's marketing version and build number.
    static let version = version(from: Bundle.main.infoDictionary)

    static func version(from info: [String: Any]?) -> String {
        let marketing = info?["CFBundleShortVersionString"] as? String ?? "–"
        guard let build = info?["CFBundleVersion"] as? String, build != marketing else {
            return "Version \(marketing)"
        }
        return "Version \(marketing) (\(build))"
    }

    static let sourceCode = URL(string: "https://github.com/mjn2max/HapticEngine")!
    /// What Xcode's Add Package Dependencies asks for: the repository.
    static let packageURL = sourceCode

    // MARK: Reporting an issue

    /// A new issue on GitHub, its description started with what a haptics bug depends on: the device, its
    /// system, the app's version, and whether it has haptic hardware. The reporter sees all of it before
    /// posting, and can change it.
    @MainActor
    static func newIssue(isHapticsSupported: Bool) -> URL {
        let device = UIDevice.current
        return newIssue(body: issueBody(
            device: deviceModel,
            system: "\(device.systemName) \(device.systemVersion)",
            appVersion: version,
            isHapticsSupported: isHapticsSupported
        ))
    }

    static func newIssue(body: String) -> URL {
        var components = URLComponents(url: sourceCode.appending(path: "issues/new"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "body", value: body)]
        return components.url!
    }

    static func issueBody(device: String, system: String, appVersion: String, isHapticsSupported: Bool) -> String {
        """
        **What happened?**


        **What did you expect?**


        ---
        Device: \(device)
        System: \(system)
        Demo app: \(appVersion)
        Haptics: \(isHapticsSupported ? "Supported" : "Not supported")
        """
    }

    /// The hardware model, such as "iPhone15,2": the marketing name ("iPhone") doesn't say which Taptic
    /// Engine it has. In the Simulator, the simulated model.
    static var deviceModel: String {
        if let simulated = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return "\(simulated) (Simulator)"
        }
        var system = utsname()
        uname(&system)
        return withUnsafeBytes(of: system.machine) { bytes in
            String(decoding: bytes.prefix { $0 != 0 }, as: UTF8.self)
        }
    }
}
