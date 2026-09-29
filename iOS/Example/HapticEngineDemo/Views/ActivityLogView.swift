//
// ActivityLogView.swift
// HapticEngineDemo
//

import SwiftUI

/// Patterns played and app lifecycle changes, newest first.
struct ActivityLogView: View {
    @Environment(HapticDemoModel.self) private var model

    var body: some View {
        List(model.log) { entry in
            LabeledContent(entry.message) {
                Text(entry.date, format: .dateTime.hour().minute().second())
                    .monospacedDigit()
            }
            .font(.callout)
        }
        .overlay {
            if model.log.isEmpty {
                ContentUnavailableView(
                    "No Activity",
                    systemImage: "clock.arrow.circlepath",
                    description: Text("Play a preset, then background and reopen the app to check the engine recovers.")
                )
            }
        }
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Clear", role: .destructive, action: model.clearLog)
                .disabled(model.log.isEmpty)
        }
    }
}

#Preview("Empty") {
    NavigationStack {
        ActivityLogView()
    }
    .environment(HapticDemoModel(engine: MockHapticEngine()))
}

#Preview("With entries") {
    let model = HapticDemoModel(engine: MockHapticEngine())
    model.play(.heartbeat)
    model.record("Scene phase: active")
    return NavigationStack {
        ActivityLogView()
    }
    .environment(model)
}
