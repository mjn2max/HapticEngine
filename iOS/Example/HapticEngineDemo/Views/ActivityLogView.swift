//
// ActivityLogView.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Patterns the user switched between, newest first. Tapping one plays it again without changing the list;
/// swiping one away deletes it.
struct ActivityLogView: View {
    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    @State private var isConfirmingClear = false
    /// The row swiped open to show its delete button. Only one is open at a time.
    @State private var openEntryID: HapticDemoModel.LogEntry.ID?

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
                    SwipeToDelete(
                        isOpen: Binding(
                            get: { openEntryID == entry.id },
                            set: { openEntryID = $0 ? entry.id : nil }
                        ),
                        onDelete: {
                            withAnimation(.snappy) { model.deleteEntry(entry) }
                        }
                    ) {
                        ActivityRow(
                            entry: entry,
                            isPlaying: model.nowPlaying?.entryID == entry.id,
                            onPlay: {
                                // A tap on an open row closes it, rather than playing it by surprise.
                                if openEntryID != nil {
                                    openEntryID = nil
                                } else {
                                    model.replay(entry)
                                }
                            }
                        )
                    }
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
        // Scrolling closes an open row, as in system lists.
        .onScrollPhaseChange { _, phase in
            if phase != .idle, openEntryID != nil { openEntryID = nil }
        }
    }

    private var emptyState: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 10) {
                    EmptyActivityBadge()
                        .padding(.bottom, 6)
                    Text("No Activity Yet")
                        .font(.title2.bold())
                    Text("Patterns you play show up here, so you can feel them again with one tap.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }

                // Starts the log from here rather than sending the user back: playing one of these adds
                // it, and the list below replaces this view with that entry already playing.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Try one")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .padding(.leading, 12)
                    VStack(spacing: 0) {
                        ForEach(Self.suggestions, id: \.self) { pattern in
                            SuggestionRow(pattern: pattern) {
                                withAnimation(.snappy) { model.play(pattern) }
                            }
                            if pattern != Self.suggestions.last {
                                Divider()
                                    .padding(.leading, 64)
                            }
                        }
                    }
                    .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20))
                    .clipShape(.rect(cornerRadius: 20))
                }

                Button("See All Patterns") { dismiss() }
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal)
            .padding(.vertical, 32)
            .frame(maxWidth: 500)
            .frame(maxWidth: .infinity)
        }
        // Centers the content vertically while it fits, and lets it scroll at large text sizes.
        .defaultScrollAnchor(.center)
        .scrollBounceBehavior(.basedOnSize)
        .transition(.opacity)
    }

    /// One pattern from each category, so the suggestions feel distinct from one another.
    private static let suggestions: [HapticPattern] = [.success, .heartbeat, .rumble]
}

/// The clock symbol inside soft rings, echoing a vibration spreading out.
private struct EmptyActivityBadge: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Circle()
                .fill(.tint.opacity(0.06))
                .frame(width: 128, height: 128)
            Circle()
                .fill(.tint.opacity(0.12))
                .frame(width: 92, height: 92)
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(.tint)
                .symbolEffect(.pulse, options: .repeat(2), isActive: !reduceMotion)
        }
        .accessibilityHidden(true)
    }
}

/// A suggested pattern: its icon, name and feel, with a play affordance.
private struct SuggestionRow: View {
    let pattern: HapticPattern
    let onPlay: () -> Void

    var body: some View {
        Button(action: onPlay) {
            HStack(spacing: 12) {
                PatternIcon(pattern: pattern, isPlaying: false, size: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(pattern.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(pattern.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 8)

                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(pattern.tint)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
        }
        .buttonStyle(RowPressStyle())
        .accessibilityLabel("Play \(pattern.title)")
        .accessibilityHint(pattern.subtitle)
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
