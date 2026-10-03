//
// PatternGrid.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Patterns as compact tiles, three or more to a row: the quickest to tap.
struct PatternGrid: View {
    let patterns: [HapticPattern]
    /// The row of the launch wave the first of them is in.
    var firstRow: Double = 0
    /// How many tiles fit across, for where each one comes in the launch wave: see `columnCount(width:)`.
    var columnCount = 1
    @Environment(HapticDemoModel.self) private var model

    private static let minimumWidth: CGFloat = 100
    private static let spacing: CGFloat = 12
    private let columns = [GridItem(.adaptive(minimum: Self.minimumWidth), spacing: Self.spacing)]

    /// How many tiles the grid fits across `width`, as its adaptive column does.
    static func columnCount(width: CGFloat) -> Int {
        max(Int((width + spacing) / (minimumWidth + spacing)), 1)
    }

    var body: some View {
        let playing = model.nowPlaying?.pattern
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(Array(patterns.enumerated()), id: \.element) { offset, pattern in
                PatternTile(pattern: pattern, isPlaying: pattern == playing, isFavorite: model.isFavorite(pattern))
                    .launchReveal(row: firstRow + Double(offset / columnCount), column: offset % columnCount)
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
