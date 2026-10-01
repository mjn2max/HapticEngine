//
// PatternGrid.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Patterns as compact tiles, three or more to a row: the quickest to tap.
struct PatternGrid: View {
    let patterns: [HapticPattern]
    @Environment(HapticDemoModel.self) private var model

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(patterns, id: \.self) { pattern in
                PatternTile(
                    pattern: pattern,
                    isPlaying: model.nowPlaying?.pattern == pattern,
                    isFavorite: model.isFavorite(pattern),
                    onPlay: { model.play(pattern) }
                )
                .patternActions(pattern, model: model)
            }
        }
    }
}

/// The description isn't shown here; the status card shows it for the pattern that's playing.
private struct PatternTile: View {
    let pattern: HapticPattern
    let isPlaying: Bool
    let isFavorite: Bool
    let onPlay: () -> Void

    var body: some View {
        Button(action: onPlay) {
            VStack(spacing: 8) {
                PatternIcon(pattern: pattern, isPlaying: isPlaying, isFavorite: isFavorite)
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
