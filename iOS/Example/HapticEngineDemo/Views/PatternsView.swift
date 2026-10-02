//
// PatternsView.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// How the patterns are laid out. Remembered between launches.
///
/// A saved value from a removed layout (such as the old "compact" or "cards") falls back to the default.
enum PatternLayout: String, CaseIterable {
    private static let storageKey = "patternLayout"

    /// The layout saved last time, or the default.
    static var saved: PatternLayout {
        UserDefaults.standard.string(forKey: storageKey).flatMap(PatternLayout.init) ?? .grid
    }

    func save() {
        UserDefaults.standard.set(rawValue, forKey: Self.storageKey)
    }

    /// Icon and name, three or more to a row: for tapping quickly.
    case grid
    /// One row per pattern with description and length: for reading what each one does.
    case list

    var title: String {
        switch self {
        case .grid: "Grid"
        case .list: "List"
        }
    }

    var systemImage: String {
        switch self {
        case .grid: "square.grid.2x2"
        case .list: "list.bullet"
        }
    }
}

/// The patterns to show together, under an optional heading.
private struct PatternSection: Identifiable {
    let id: String
    let title: String?
    let patterns: [HapticPattern]
}

/// Every pattern, filtered from the toolbar or by a search, in the layout the user picked.
///
/// Search opens in the navigation bar, and looks through every pattern whatever the filter: someone
/// searching wants a pattern wherever it is.
struct PatternsView: View {
    @Binding var filter: PatternFilter
    let layout: PatternLayout
    @Binding var query: String
    /// Whether the search field is open in the navigation bar.
    @Binding var isSearchFieldOpen: Bool
    /// Where the now-playing bar starts, in global coordinates. The patterns fade out across it.
    var fadeTop: CGFloat = .infinity
    /// How much of the patterns shows, from 0 to 1. The background stays.
    var visibility: Double = 1

    @Environment(HapticDemoModel.self) private var model
    @State private var scrollPosition = ScrollPosition(edge: .top)

    /// Results replace the browsing sections once something is typed; until then, the filter's patterns
    /// stay in view.
    private var hasQuery: Bool { !query.trimmingCharacters(in: .whitespaces).isEmpty }

    private var sections: [PatternSection] {
        if hasQuery {
            return categorySections { $0.matches(query) }
        }
        switch filter {
        case .all:
            return categorySections { _ in true }
        case .favorites:
            return model.favorites.isEmpty ? [] : [PatternSection(id: "favorites", title: nil, patterns: model.favorites)]
        case .category(let category):
            return [PatternSection(id: category.rawValue, title: nil, patterns: category.patterns)]
        }
    }

    /// One section per category with a pattern that passes `include`, headed by its name and count.
    private func categorySections(_ include: (HapticPattern) -> Bool) -> [PatternSection] {
        HapticPattern.Category.allCases.compactMap { category in
            let patterns = category.patterns.filter(include)
            guard !patterns.isEmpty else { return nil }
            return PatternSection(id: category.rawValue, title: "\(category.title) · \(patterns.count)", patterns: patterns)
        }
    }

    var body: some View {
        ScrollView {
            content
                .padding([.horizontal, .bottom])
                .padding(.top, 8)
        }
        .scrollPosition($scrollPosition)
        .scrollDismissesKeyboard(.immediately)
        .accessibilityIdentifier("patternList")
        // Scrolling puts the keyboard away. The field stays, since it costs the patterns no room, and
        // shows what the results are for; with nothing typed, search simply closes.
        .onScrollPhaseChange { _, phase in
            guard phase == .interacting, isSearchFieldOpen, !hasQuery else { return }
            withAnimation(.snappy) { isSearchFieldOpen = false }
        }
        // The patterns melt into the bar instead of meeting it at a line. The system's soft edge
        // effect stays on beneath it, adding a gentle blur as they fade.
        .mask { BottomFade(fadeTop: fadeTop).ignoresSafeArea() }
        .opacity(visibility)
        // The bar reports where it will settle as soon as it starts moving, so the fade eases there
        // alongside it rather than jumping ahead.
        .animation(.easeInOut(duration: 0.3), value: visibility)
        .allowsHitTesting(visibility > 0.5)
        // The edge effect under the navigation bar draws the patterns again itself, which the fade above
        // doesn't reach: hidden while they're faded, or a strip of them stays under the status bar.
        .topEdgeEffectHidden(visibility < 1)
        // A new filter, or a search, starts at the top, not partway down, as a new mailbox does in Mail:
        // at once, since the patterns are all new. Scrolling to the edge rather than to a view at the top keeps the navigation bar settled: scrolling to a view
        // left the large title stranded beneath the toolbar buttons.
        .onChange(of: filter) { scrollPosition.scrollTo(edge: .top) }
        .onChange(of: query) { scrollPosition.scrollTo(edge: .top) }
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private var content: some View {
        if sections.isEmpty {
            emptyState
                .padding(.top, 40)
        } else {
            VStack(spacing: 24) {
                patterns
                if !hasQuery && filter != .all {
                    ShowAllFooter(shown: sections.reduce(0) { $0 + $1.patterns.count }) {
                        withAnimation(.snappy) { filter = .all }
                    }
                }
            }
        }
    }

    private var patterns: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(sections) { section in
                VStack(alignment: .leading, spacing: 8) {
                    if let title = section.title {
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)
                            .accessibilityAddTraits(.isHeader)
                    }
                    switch layout {
                    case .grid: PatternGrid(patterns: section.patterns)
                    case .list: PatternList(patterns: section.patterns)
                    }
                }
            }
        }
        .disabled(!model.isHapticsSupported)
        // The custom button styles don't dim when disabled, so dim here.
        .opacity(model.isHapticsSupported ? 1 : 0.4)
        // The old layout leaves at once and the new one fades in from slightly smaller, so the eye can
        // follow a pattern across: every layout keeps the same order and colors.
        .id(layout)
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.98, anchor: .top)),
            removal: .identity
        ))
    }

    @ViewBuilder
    private var emptyState: some View {
        if hasQuery {
            ContentUnavailableView.search(text: query)
        } else {
            // Only favorites can be empty: every category has patterns.
            ContentUnavailableView {
                Label("No Favorites Yet", systemImage: "star")
            } description: {
                Text("Touch and hold a pattern, or tap the star after playing one, to keep it here.")
            }
        }
    }
}

/// At the end of a filtered list, how much of the whole it is and the way back to everything: someone who
/// scrolled through a category finishes here, far from the filter at the top.
private struct ShowAllFooter: View {
    let shown: Int
    let showAll: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text("Showing \(shown) of \(HapticPattern.allCases.count)")
                .foregroundStyle(.secondary)
            Text("·")
                .foregroundStyle(.tertiary)
            Button("Show All", action: showAll)
                .fontWeight(.semibold)
                .accessibilityIdentifier("showAll")
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

/// Opaque down to above the now-playing bar, then fading to clear across its top edge. Used as a mask,
/// it fades the patterns out as they reach the bar, so nothing shows through behind its text.
///
/// The fade eases in and out rather than running straight, like light falling off: a straight fade
/// starts and stops abruptly, which shows as lines while scrolling.
private struct BottomFade: View {
    let fadeTop: CGFloat

    /// How far above and below the bar's top edge the fade runs.
    private static let above: CGFloat = 56
    private static let below: CGFloat = 20
    /// Enough stops that the eased curve shows no steps.
    private static let steps = 12

    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .global)
            let height = max(frame.height, 1)
            let top = fadeTop - frame.minY
            let start = min(max((top - Self.above) / height, 0), 1)
            let end = min(max((top + Self.below) / height, start), 1)
            let fade = (0...Self.steps).map { step in
                let progress = Double(step) / Double(Self.steps)
                // Smoothstep: slow at both ends, so the fade has no visible start or end.
                let eased = progress * progress * (3 - 2 * progress)
                return Gradient.Stop(
                    color: .black.opacity(1 - eased),
                    location: start + (end - start) * progress
                )
            }
            LinearGradient(
                stops: [.init(color: .black, location: 0)] + fade,
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview {
    @Previewable @State var filter = PatternFilter.all
    NavigationStack {
        PatternsView(
            filter: $filter,
            layout: .grid,
            query: .constant(""),
            isSearchFieldOpen: .constant(false)
        )
    }
    .environment(HapticDemoModel(engine: MockHapticEngine()))
}

private extension View {
    /// On iOS 26, hides the scroll edge effect under the navigation bar. Earlier, there's none.
    @ViewBuilder
    func topEdgeEffectHidden(_ isHidden: Bool) -> some View {
        if #available(iOS 26, *) {
            scrollEdgeEffectHidden(isHidden, for: .top)
        } else {
            self
        }
    }
}
