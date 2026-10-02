//
// PatternDetails.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// What the open bar adds. The summary first: the full description, and a timeline to compare with
/// what's felt. Then, in the full size: the numbers, each event, and similar patterns to try next.
///
/// Equatable on what it shows, so dragging the bar, which updates its container every frame, leaves the
/// timeline, numbers and events alone. The action and binding always lead to the same place.
struct PatternDetails: View, Equatable {
    let pattern: HapticPattern
    let playback: HapticDemoModel.Playback?
    let isFull: Bool
    let toggleFull: () -> Void
    /// Where the summary ends, with the button that opens the rest: the summary size's height.
    @Binding var summaryEnd: CGFloat

    nonisolated private static let space = "details"

    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.pattern == rhs.pattern && lhs.playback?.id == rhs.playback?.id && lhs.isFull == rhs.isFull
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(pattern.subtitle)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)

            PatternTimeline(pattern: pattern, playback: playback)

            Text("\(eventSummary). Taller is stronger; deeper color is sharper.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // Peeks out at the bottom of the summary, so there's plainly more, and one tap reaches it.
            Button(action: toggleFull) {
                HStack(spacing: 6) {
                    Text(isFull ? "Fewer Details" : "More Details")
                    Image(systemName: "chevron.up")
                        .imageScale(.small)
                        .rotationEffect(.degrees(isFull ? 180 : 0))
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(pattern.tint)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(pattern.tint.opacity(0.12), in: .capsule)
                .contentShape(.capsule)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("toggleFullDetails")
            .onGeometryChange(for: CGFloat.self) { $0.frame(in: .named(Self.space)).maxY + 12 } action: {
                summaryEnd = $0
            }

            PatternStats(pattern: pattern)
            EventList(pattern: pattern)
        }
        .padding(.trailing, 6)
        .padding(.bottom, 16)
        .coordinateSpace(.named(Self.space))
    }

    /// Such as "3 taps", "1 hold" or "8 taps, 1 hold".
    private var eventSummary: String {
        let taps = pattern.events.filter { $0.kind == .tap }.count
        let holds = pattern.events.count - taps
        var parts: [String] = []
        if taps > 0 { parts.append(taps == 1 ? "1 tap" : "\(taps) taps") }
        if holds > 0 { parts.append(holds == 1 ? "1 hold" : "\(holds) holds") }
        return parts.joined(separator: ", ")
    }
}

/// The pattern in four numbers, as tiles.
private struct PatternStats: View {
    let pattern: HapticPattern

    private var events: [HapticPatternEvent] { pattern.events }

    var body: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
                tile("Length", pattern.durationText)
                tile("Events", "\(events.count)")
            }
            GridRow {
                tile("Strongest", percent(events.map(\.intensity).max() ?? 0))
                tile("Average Sharpness", percent(events.isEmpty ? 0 : events.map(\.sharpness).reduce(0, +) / Float(events.count)))
            }
        }
    }

    private func tile(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title3.weight(.semibold).monospacedDigit())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        // In the pattern's color, like the buttons around them. A gray fill turns dark on glass.
        .background(pattern.tint.opacity(0.08), in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
    }
}

/// Every event in order: when it starts, what it is, and how strong, drawn as on the timeline.
private struct EventList: View {
    let pattern: HapticPattern

    /// Long textures have dozens; past this, the timeline tells the story better than rows.
    private static let limit = 24

    var body: some View {
        let events = pattern.events
        VStack(alignment: .leading, spacing: 0) {
            SectionTitle("Events", trailing: "\(events.count)")
            ForEach(Array(events.prefix(Self.limit).enumerated()), id: \.offset) { index, event in
                if index > 0 { Divider() }
                row(event)
            }
            if events.count > Self.limit {
                Divider()
                Text("And \(events.count - Self.limit) more")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
            }
        }
    }

    private func row(_ event: HapticPatternEvent) -> some View {
        HStack(spacing: 12) {
            Text(seconds(event.time))
                .font(.footnote.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(minWidth: 52, alignment: .leading)
            Label(
                event.kind == .tap ? "Tap" : "Hold \(seconds(event.duration))",
                systemImage: event.kind == .tap ? "circle.fill" : "capsule.fill"
            )
            .font(.subheadline)
            .labelStyle(EventLabelStyle())
            Spacer(minLength: 8)
            // Like the timeline: the bar's length is strength, its color depth sharpness.
            Capsule()
                .fill(.primary.opacity(0.08))
                .frame(width: 56, height: 6)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(pattern.tint.opacity(0.3 + 0.7 * Double(event.sharpness)))
                        .frame(width: max(6, 56 * CGFloat(event.intensity)))
                }
            Text(percent(event.intensity))
                .font(.footnote.monospacedDigit())
                .frame(minWidth: 38, alignment: .trailing)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(event.kind == .tap ? "Tap" : "Hold for \(seconds(event.duration))") at \(seconds(event.time)), "
                + "strength \(percent(event.intensity)), sharpness \(percent(event.sharpness))"
        )
    }

    private func seconds(_ time: TimeInterval) -> String {
        "\(time.formatted(.number.precision(.fractionLength(2)))) s"
    }
}

private struct EventLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.icon
                .font(.system(size: 7))
                .foregroundStyle(.secondary)
            configuration.title
        }
    }
}

struct SectionTitle: View {
    let title: String
    var trailing: String?

    init(_ title: String, trailing: String? = nil) {
        self.title = title
        self.trailing = trailing
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .accessibilityAddTraits(.isHeader)
    }
}

/// Such as "80%".
private func percent(_ value: Float) -> String {
    Double(value).formatted(.percent.precision(.fractionLength(0)))
}
