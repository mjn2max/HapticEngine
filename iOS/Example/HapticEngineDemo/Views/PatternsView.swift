//
// PatternsView.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// How the patterns are laid out. Remembered between launches.
///
/// Each layout has a distinct job, ordered from quickest to tap to most detailed. A saved value from
/// a removed layout (such as the old "compact") falls back to the default.
enum PatternLayout: String, CaseIterable {
    private static let storageKey = "patternLayout"

    /// The layout saved last time, or the default.
    static var saved: PatternLayout {
        UserDefaults.standard.string(forKey: storageKey).flatMap(PatternLayout.init) ?? .grid
    }

    func save() {
        UserDefaults.standard.set(rawValue, forKey: Self.storageKey)
    }

    /// Icon and name, three to a row: for tapping quickly.
    case grid
    /// Two-column cards with description and length: for browsing.
    case cards
    /// One row per pattern with description and length: for scanning details.
    case list

    var title: String {
        switch self {
        case .grid: "Grid"
        case .cards: "Cards"
        case .list: "List"
        }
    }

    var systemImage: String {
        switch self {
        case .grid: "square.grid.3x3.fill"
        case .cards: "rectangle.grid.2x2.fill"
        case .list: "list.bullet"
        }
    }
}

/// Every pattern, grouped by category, in the layout the user picked.
struct PatternsView: View {
    let nowPlaying: HapticDemoModel.Playback?
    /// False without haptic hardware: the patterns are dimmed and can't be tapped, but the layout can
    /// still be changed.
    var canPlay = true
    let onPlay: (HapticPattern) -> Void

    /// Plain state rather than `@AppStorage`: changes to `@AppStorage` arrive outside the switcher's
    /// `withAnimation`, which made layout changes instant. Saved on every change instead.
    @State private var layout = PatternLayout.saved

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Patterns")
                    .font(.title3.weight(.bold))
                Spacer()
                LayoutSwitcher(selection: $layout)
            }
            .padding(.leading, 4)

            VStack(alignment: .leading, spacing: 20) {
                ForEach(HapticPattern.Category.allCases, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(category.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)
                        Group {
                            switch layout {
                            case .grid:
                                PatternGrid(patterns: category.patterns, nowPlaying: nowPlaying, onPlay: onPlay)
                            case .cards:
                                PatternCards(patterns: category.patterns, nowPlaying: nowPlaying, onPlay: onPlay)
                            case .list:
                                PatternList(patterns: category.patterns, nowPlaying: nowPlaying, onPlay: onPlay)
                            }
                        }
                        .disabled(!canPlay)
                        // The custom button styles don't dim when disabled, so dim here.
                        .opacity(canPlay ? 1 : 0.4)
                    }
                }
            }
            // All sections, headings included, change as one block: the old layout leaves at once and the
            // new one fades in from slightly smaller. Nothing slides or shows on top of anything else, and
            // every layout keeps the same order and colors, so the eye can follow a pattern across.
            .id(layout)
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .scale(scale: 0.98, anchor: .top))
                    .animation(.easeOut(duration: 0.25)),
                removal: .identity
            ))
        }
        // A light tick on each change, fitting for a haptics demo.
        .sensoryFeedback(.selection, trigger: layout)
        .onChange(of: layout) { _, layout in layout.save() }
    }
}

/// Picks the layout. The selected option shows its icon and name, the others only their icon, and the
/// highlight slides between them, so it's always clear which layout is showing.
private struct LayoutSwitcher: View {
    @Binding var selection: PatternLayout

    @Namespace private var highlight
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 2) {
            ForEach(PatternLayout.allCases, id: \.self) { layout in
                let isSelected = layout == selection
                Button {
                    withAnimation(reduceMotion ? .easeInOut(duration: 0.2) : .smooth(duration: 0.4)) {
                        selection = layout
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: layout.systemImage)
                        if isSelected {
                            Text(layout.title)
                                // Never truncated; the capsule grows to fit the name.
                                .fixedSize()
                                .transition(.opacity.combined(with: .scale(scale: 0.8, anchor: .leading)))
                        }
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isSelected ? Color.white : .secondary)
                    .padding(.horizontal, isSelected ? 14 : 11)
                    .frame(height: 34)
                    .background {
                        if isSelected {
                            Capsule()
                                .fill(.tint)
                                .matchedGeometryEffect(id: "highlight", in: highlight)
                        }
                    }
                    .contentShape(.capsule)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(layout.title)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(3)
        .background(Color(.tertiarySystemFill), in: .capsule)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Layout")
    }
}

#Preview {
    ScrollView {
        PatternsView(nowPlaying: .init(pattern: .knock), onPlay: { _ in })
            .padding()
    }
    .background(Color(.systemGroupedBackground))
}
