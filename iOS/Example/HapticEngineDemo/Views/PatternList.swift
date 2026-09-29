//
// PatternList.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Patterns as rows with their description and length: the list layout of ``PatternsView``.
struct PatternList: View {
    let patterns: [HapticPattern]
    let nowPlaying: HapticDemoModel.Playback?
    let onPlay: (HapticPattern) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(patterns, id: \.self) { pattern in
                PatternRow(
                    pattern: pattern,
                    isPlaying: nowPlaying?.pattern == pattern,
                    onPlay: { onPlay(pattern) }
                )
                if pattern != patterns.last {
                    // Inset to line up with the text, as in system lists.
                    Divider()
                        .padding(.leading, 64)
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20))
        .clipShape(.rect(cornerRadius: 20))
    }
}

private struct PatternRow: View {
    let pattern: HapticPattern
    let isPlaying: Bool
    let onPlay: () -> Void

    var body: some View {
        Button(action: onPlay) {
            HStack(spacing: 12) {
                PatternIcon(pattern: pattern, isPlaying: isPlaying, size: 40)

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
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isPlaying ? pattern.tint.opacity(0.08) : .clear)
            .contentShape(.rect)
        }
        .buttonStyle(RowPressStyle())
        .animation(.snappy, value: isPlaying)
        .accessibilityValue(isPlaying ? "Playing" : pattern.durationText)
    }
}

/// Highlights a row while pressed, like a system list row, rather than shrinking it as tiles do.
struct RowPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(.systemFill) : .clear)
    }
}
