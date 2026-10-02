//
// PatternList.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Patterns as rows with their description and length: for reading what each one does.
struct PatternList: View {
    let patterns: [HapticPattern]
    @Environment(HapticDemoModel.self) private var model

    var body: some View {
        let playing = model.nowPlaying?.pattern
        LazyVStack(spacing: 0) {
            ForEach(patterns, id: \.self) { pattern in
                PatternRow(pattern: pattern, isPlaying: pattern == playing, isFavorite: model.isFavorite(pattern))
                if pattern != patterns.last {
                    // Inset to line up with the text, as in system lists.
                    Divider()
                        .padding(.leading, GroupedCard.dividerInset)
                }
            }
        }
        .groupedCard()
    }
}

/// Only plain values come in, so on each play only the rows that start or stop playing update.
private struct PatternRow: View {
    let pattern: HapticPattern
    let isPlaying: Bool
    let isFavorite: Bool

    @Environment(HapticDemoModel.self) private var model

    var body: some View {
        Button {
            model.play(pattern)
        } label: {
            HStack(spacing: 12) {
                PatternIcon(pattern: pattern, isPlaying: isPlaying, isFavorite: isFavorite, size: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(pattern.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(pattern.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                if isPlaying {
                    PlayingIndicator(tint: pattern.tint)
                } else {
                    Text(pattern.durationText)
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
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
        .accessibilityValue(isPlaying ? "Playing" : pattern.durationText)
        .patternActions(pattern, isFavorite: isFavorite)
    }
}
