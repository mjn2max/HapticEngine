//
// HapticEngineDemoApp.swift
// HapticEngineDemo
//
// Demo app for manually testing the HapticEngine library on a real device.
//

import SwiftUI

@main
struct HapticEngineDemoApp: App {
    @State private var model = HapticDemoModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}
