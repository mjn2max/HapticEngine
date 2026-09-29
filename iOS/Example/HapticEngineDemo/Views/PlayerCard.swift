//
// PlayerCard.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Pinned above the patterns: shows what's playing, then keeps showing that pattern once it ends so
/// its description can be read, and tapping it plays that pattern again. Before anything is played,
/// it shows a prompt.
///
/// Styled like a pattern tile, and it changes in place rather than appearing and disappearing,
/// so tapping doesn't make the layout jump.
struct PlayerCard: View {
    let playback: HapticDemoModel.Playback?
    let lastPlayed: HapticPattern?
    let isHapticsSupported: Bool

    private var pattern: HapticPattern? { playback?.pattern ?? lastPlayed }
    private var isPlaying: Bool { playback != nil }
    /// Without haptic hardware nothing can play, so the card becomes a warning instead of a prompt.
    private var isUnavailable: Bool { !isHapticsSupported && pattern == nil }
    private var tint: Color { pattern?.tint ?? (isUnavailable ? .orange : .accentColor) }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: pattern?.systemImage ?? (isUnavailable ? "iphone.slash" : "hand.tap"))
                .font(.title3.weight(.semibold))
                .foregroundStyle(isPlaying ? .white : tint)
                .frame(width: 44, height: 44)
                .background(
                    isPlaying ? AnyShapeStyle(tint) : AnyShapeStyle(tint.opacity(0.15)),
                    in: .rect(cornerRadius: 12)
                )
                .contentTransition(.symbolEffect(.replace))
                // Bounces on every tap, including repeat taps of the same pattern.
                .symbolEffect(.bounce, value: playback?.id)

            VStack(alignment: .leading, spacing: 2) {
                Text(pattern?.title ?? (isUnavailable ? "Haptics unavailable" : "Tap a pattern"))
                    .font(.headline)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    // Two lines are always reserved, so the card keeps one height for every description.
                    .lineLimit(2, reservesSpace: true)
            }

            Spacer(minLength: 8)

            if isPlaying {
                Image(systemName: "waveform")
                    .foregroundStyle(tint)
                    .symbolEffect(.variableColor.iterative, isActive: true)
                    .transition(.scale.combined(with: .opacity))
            } else if pattern != nil {
                // Shows the card can be tapped to play the pattern again.
                Image(systemName: "arrow.counterclockwise")
                    .foregroundStyle(.secondary)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(12)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemGroupedBackground))
                if isUnavailable {
                    // A tint over the card color, so the warning stands out from the pattern tiles.
                    RoundedRectangle(cornerRadius: 20)
                        .fill(tint.opacity(0.12))
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let playback {
                PlaybackProgress(playback: playback, tint: tint)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 4)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(tint, lineWidth: isPlaying ? 2 : isUnavailable ? 1.5 : 0)
        }
        .animation(.snappy, value: playback?.id)
        .animation(.snappy, value: pattern)
        .accessibilityElement(children: .combine)
    }

    private var subtitle: String {
        if let pattern { return pattern.subtitle }
        return isUnavailable
            ? "No haptic hardware here. Run on an iPhone to feel the patterns."
            : "Haptics are on"
    }
}

/// A thin bar along the card's bottom edge that fills over the pattern's duration.
private struct PlaybackProgress: View {
    let playback: HapticDemoModel.Playback
    let tint: Color

    var body: some View {
        ProgressView(timerInterval: playback.start...playback.end, countsDown: false) {
            EmptyView()
        } currentValueLabel: {
            EmptyView()
        }
        .tint(tint)
        .scaleEffect(y: 0.75)
        // A new ID restarts the bar when the same pattern is tapped again.
        .id(playback.id)
    }
}

#Preview("Idle") {
    PlayerCard(playback: nil, lastPlayed: nil, isHapticsSupported: true)
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Playing") {
    PlayerCard(playback: .init(pattern: .heartbeat), lastPlayed: .heartbeat, isHapticsSupported: false)
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Finished") {
    PlayerCard(playback: nil, lastPlayed: .knock, isHapticsSupported: true)
        .padding()
        .background(Color(.systemGroupedBackground))
}
