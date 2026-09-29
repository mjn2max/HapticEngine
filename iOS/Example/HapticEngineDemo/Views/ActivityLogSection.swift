//
// ActivityLogSection.swift
// HapticEngineDemo
//

import SwiftUI

struct ActivityLogSection: View {
    let entries: [HapticDemoModel.LogEntry]
    let onClear: () -> Void

    var body: some View {
        Section {
            if entries.isEmpty {
                Text("Play a preset, then background and reopen the app to check the engine recovers.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            ForEach(entries) { entry in
                LabeledContent(entry.message) {
                    Text(entry.date, format: .dateTime.hour().minute().second())
                        .monospacedDigit()
                }
                .font(.callout)
            }
        } header: {
            HStack {
                Text("Activity")
                Spacer()
                if !entries.isEmpty {
                    Button("Clear", action: onClear)
                        .font(.caption)
                }
            }
        }
    }
}
