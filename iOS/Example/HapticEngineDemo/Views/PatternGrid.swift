//
// PatternGrid.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Every pattern as a compact tile, grouped by category.
struct PatternGrid: View {
    let nowPlaying: HapticDemoModel.Playback?
    let onPlay: (HapticPattern) -> Void

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(HapticPattern.Category.allCases, id: \.self) { category in
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.leading, 4)
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(category.patterns, id: \.self) { pattern in
                            PatternTile(
                                pattern: pattern,
                                isPlaying: nowPlaying?.pattern == pattern,
                                onPlay: { onPlay(pattern) }
                            )
                        }
                    }
                }
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
                Image(systemName: pattern.systemImage)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(isPlaying ? .white : pattern.tint)
                    .frame(width: 44, height: 44)
                    .background(
                        isPlaying ? AnyShapeStyle(pattern.tint) : AnyShapeStyle(pattern.tint.opacity(0.15)),
                        in: .rect(cornerRadius: 12)
                    )
                Text(pattern.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(pattern.tint, lineWidth: isPlaying ? 2 : 0)
            }
        }
        .buttonStyle(PressableStyle())
        .animation(.snappy, value: isPlaying)
        .accessibilityHint(pattern.subtitle)
        .accessibilityValue(isPlaying ? "Playing" : "")
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
