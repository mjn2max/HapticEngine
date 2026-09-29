//
// ContentView.swift
// HapticEngineDemo
//

import SwiftUI

struct ContentView: View {
    @Environment(HapticDemoModel.self) private var model
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            List {
                StatusSection(isHapticsSupported: model.isHapticsSupported)
                PresetsSection { model.play($0) }
                ActivityLogSection(entries: model.log, onClear: model.clearLog)
            }
            .navigationTitle("HapticEngine")
        }
        .onChange(of: scenePhase) { _, phase in
            model.record("Scene phase: \(String(describing: phase))")
        }
    }
}

#Preview("Supported") {
    ContentView()
        .environment(HapticDemoModel(engine: MockHapticEngine()))
}

#Preview("Unsupported") {
    ContentView()
        .environment(HapticDemoModel(engine: MockHapticEngine(isHapticsSupported: false)))
}
