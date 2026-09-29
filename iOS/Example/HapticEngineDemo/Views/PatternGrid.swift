//
// PatternGrid.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Patterns as compact tiles: the grid layout of ``PatternsView``.
struct PatternGrid: View {
    let patterns: [HapticPattern]
    let nowPlaying: HapticDemoModel.Playback?
    let onPlay: (HapticPattern) -> Void

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(patterns, id: \.self) { pattern in
                PatternTile(
                    pattern: pattern,
                    isPlaying: nowPlaying?.pattern == pattern,
                    onPlay: { onPlay(pattern) }
                )
            }
        }
    }
}

/// The description isn't shown here; the status card shows it for the pattern that's playing.
private struct PatternTile: View {
    let pattern: HapticPattern
    let isPlaying: Bool
    let onPlay: () -> Void

    var body: some View {
        Button(action: onPlay) {
            VStack(spacing: 8) {
                PatternIcon(pattern: pattern, isPlaying: isPlaying)
                Text(pattern.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(isPlaying ? pattern.tint.opacity(0.08) : .clear)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(pattern.tint, lineWidth: isPlaying ? 2 : 0)
            }
        }
        .buttonStyle(CardPressStyle())
        .animation(.snappy, value: isPlaying)
        .accessibilityHint(pattern.subtitle)
        .accessibilityValue(isPlaying ? "Playing" : "")
    }
}

/// Highlights a card while pressed, like the rows in the list layout and on the Activity screen, so a
/// pattern responds the same way in every layout. Draws the card's background too, so the highlight
/// sits behind its content.
struct CardPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(.systemFill) : .clear)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 20))
    }
}

/// Shrinks a card slightly while pressed, so a tap feels physical even without haptics.
struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}
