//
// PatternCards.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Patterns as two-column cards with their description and length: the cards layout of ``PatternsView``.
struct PatternCards: View {
    let patterns: [HapticPattern]
    let nowPlaying: HapticDemoModel.Playback?
    let onPlay: (HapticPattern) -> Void

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 12)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(patterns, id: \.self) { pattern in
                PatternCard(
                    pattern: pattern,
                    isPlaying: nowPlaying?.pattern == pattern,
                    onPlay: { onPlay(pattern) }
                )
            }
        }
    }
}

private struct PatternCard: View {
    let pattern: HapticPattern
    let isPlaying: Bool
    let onPlay: () -> Void

    var body: some View {
        Button(action: onPlay) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    PatternIcon(pattern: pattern, isPlaying: isPlaying)
                    Spacer()
                    if isPlaying {
                        Image(systemName: "waveform")
                            .foregroundStyle(pattern.tint)
                            .symbolEffect(.variableColor.iterative, isActive: true)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Text(pattern.durationText)
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
                Text(pattern.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(pattern.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    // Reserved so every card in a row is the same height.
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.leading)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(pattern.tint, lineWidth: isPlaying ? 2 : 0)
            }
        }
        .buttonStyle(PressableStyle())
        .animation(.snappy, value: isPlaying)
        .accessibilityValue(isPlaying ? "Playing" : pattern.durationText)
    }
}
