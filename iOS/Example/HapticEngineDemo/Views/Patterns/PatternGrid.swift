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
        let playing = model.nowPlaying?.pattern
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(patterns, id: \.self) { pattern in
                PatternTile(pattern: pattern, isPlaying: pattern == playing, isFavorite: model.isFavorite(pattern))
            }
        }
    }
}

/// The description isn't shown here; the now-playing bar shows it for the pattern last played.
///
/// Only plain values come in, so on each play only the tiles that start or stop playing update.
private struct PatternTile: View {
    let pattern: HapticPattern
    let isPlaying: Bool
    let isFavorite: Bool

    @Environment(HapticDemoModel.self) private var model

    var body: some View {
        Button {
            model.play(pattern)
        } label: {
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
                RoundedRectangle(cornerRadius: GroupedCard.cornerRadius)
                    .strokeBorder(pattern.tint, lineWidth: isPlaying ? 2 : 0)
            }
        }
        .buttonStyle(CardPressStyle())
        .animation(.snappy, value: isPlaying)
        .accessibilityHint(pattern.subtitle)
        .accessibilityValue(isPlaying ? "Playing" : "")
        .patternActions(pattern, isFavorite: isFavorite)
    }
}
