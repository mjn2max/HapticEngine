//
// ActivityLogView.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Patterns the user switched between, newest first. Tapping one plays it again without changing the list.
struct ActivityLogView: View {
    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    @State private var isConfirmingClear = false

    var body: some View {
        Group {
            if model.log.isEmpty {
                emptyState
            } else {
                entryList
            }
        }
        // Fills the screen whatever the content, so an empty or short log can't shrink the view.
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .animation(.snappy, value: model.log.isEmpty)
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Clear", role: .destructive) {
                isConfirmingClear = true
            }
            .disabled(model.log.isEmpty)
            // Attached to the button so it appears anchored to it.
            .confirmationDialog(
                "Clear all activity?",
                isPresented: $isConfirmingClear,
                titleVisibility: .visible
            ) {
                Button("Clear Activity", role: .destructive) {
                    withAnimation(.snappy) { model.clearLog() }
                }
            } message: {
                // `inflect` gives "1 entry" and "3 entries".
                Text("This removes ^[\(model.log.count) entry](inflect: true). It can't be undone.")
            }
        }
    }

    private var entryList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(model.log) { entry in
                    ActivityRow(
                        entry: entry,
                        isPlaying: model.nowPlaying?.entryID == entry.id,
                        onPlay: { model.replay(entry) }
                    )
                    if entry.id != model.log.last?.id {
                        Divider()
                            .padding(.leading, 64)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20))
            .clipShape(.rect(cornerRadius: 20))
            .padding()
            .animation(.snappy, value: model.log.first?.id)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Activity Yet", systemImage: "clock.arrow.circlepath")
        } description: {
            Text("Patterns you switch between show up here, so you can play them again with one tap.")
        } actions: {
            Button("Browse Patterns") { dismiss() }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
        }
    }
}

private struct ActivityRow: View {
    let entry: HapticDemoModel.LogEntry
    let isPlaying: Bool
    let onPlay: () -> Void

    private var pattern: HapticPattern { entry.pattern }

    var body: some View {
        Button(action: onPlay) {
            HStack(spacing: 12) {
                PatternIcon(pattern: pattern, isPlaying: isPlaying, size: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(pattern.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(entry.date, format: .dateTime.hour().minute().second())
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                if isPlaying {
                    Image(systemName: "waveform")
                        .foregroundStyle(pattern.tint)
                        .symbolEffect(.variableColor.iterative, isActive: true)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "play.fill")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isPlaying ? pattern.tint.opacity(0.08) : .clear)
            .contentShape(.rect)
        }
        .buttonStyle(RowPressStyle())
        .animation(.snappy, value: isPlaying)
        .accessibilityHint("Plays it again")
        .accessibilityValue(isPlaying ? "Playing" : "")
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
    model.play(.success)
    model.play(.knock)
    return NavigationStack {
        ActivityLogView()
    }
    .environment(model)
}
