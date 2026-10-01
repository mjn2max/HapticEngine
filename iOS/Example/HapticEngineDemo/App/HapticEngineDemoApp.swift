//
// HapticEngineDemoApp.swift
// HapticEngineDemo
//
// Demo app for manually testing the HapticEngine library on a real device.
//

import HapticEngine
import SwiftUI

@main
struct HapticEngineDemoApp: App {
    @State private var model = HapticDemoModel(engine: Self.makeEngine())

    private static func makeEngine() -> any HapticEngineProtocol {
        #if DEBUG
        // Launch with `-MockHaptics YES` to try the UI in the Simulator, which has no haptic hardware.
        if UserDefaults.standard.bool(forKey: "MockHaptics") { return MockHapticEngine() }
        #endif
        return HapticEngine()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}
