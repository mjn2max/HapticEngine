//
// PatternTimeline.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// The pattern drawn over time: taps as thin bars, holds as blocks as long as they last. Height is
/// strength and color depth is sharpness. While the pattern plays, a playhead crosses it.
struct PatternTimeline: View {
    let pattern: HapticPattern
    let playback: HapticDemoModel.Playback?

    private static let tapWidth: CGFloat = 4

    var body: some View {
        VStack(spacing: 4) {
            Canvas { context, size in
                draw(in: &context, size: size)
            }
            .frame(height: 88)
            .overlay {
                if let playback, pattern.duration > 0 {
                    Playhead(duration: pattern.duration)
                        // A new ID restarts it when the same pattern plays again.
                        .id(playback.id)
                        .transition(.opacity)
                }
            }

            HStack {
                Text("0 s")
                Spacer()
                Text(pattern.durationText)
            }
            .font(.caption2.monospacedDigit())
            .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Timeline")
        .accessibilityValue("\(pattern.events.count) events over \(pattern.durationText)")
    }

    private func draw(in context: inout GraphicsContext, size: CGSize) {
        let usableWidth = size.width - Self.tapWidth
        let total = pattern.duration

        // A faint baseline, so a quiet pattern still reads as a timeline.
        let baseline = CGRect(x: 0, y: size.height - 1, width: size.width, height: 1)
        context.fill(Path(baseline), with: .color(.primary.opacity(0.1)))

        for event in pattern.events {
            // A pattern with no length, such as a single tap, sits in the middle.
            let x = total > 0 ? usableWidth * event.time / total : usableWidth / 2
            let width: CGFloat = switch event.kind {
            case .tap: Self.tapWidth
            // One point short, so back-to-back holds stay distinct.
            case .hold: max(Self.tapWidth, usableWidth * event.duration / total - 1)
            }
            let height = max(3, size.height * CGFloat(event.intensity))
            let rect = CGRect(x: x, y: size.height - height, width: width, height: height)
            let color = pattern.tint.opacity(0.3 + 0.7 * Double(event.sharpness))
            context.fill(Path(roundedRect: rect, cornerRadius: min(2, width / 2)), with: .color(color))
        }
    }
}

/// A line that crosses the timeline over the pattern's duration.
private struct Playhead: View {
    let duration: TimeInterval
    @State private var progress: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Capsule()
                .fill(.primary)
                .frame(width: 2)
                .offset(x: (geometry.size.width - 2) * progress)
        }
        .onAppear {
            withAnimation(.linear(duration: duration)) { progress = 1 }
        }
        .accessibilityHidden(true)
    }
}
