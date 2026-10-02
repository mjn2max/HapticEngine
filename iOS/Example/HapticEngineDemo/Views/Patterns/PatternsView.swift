//
// PatternsView.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

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
    /// The now-playing bar, which the patterns fade out across and can scroll clear of.
    let nowPlaying: NowPlayingLayout
    /// The bottom of the navigation bar, in global coordinates. As the now-playing bar grows up to it,
    /// the patterns recede.
    var navigationBarBottom: CGFloat?

    @Environment(HapticDemoModel.self) private var model
    @State private var scrollPosition = ScrollPosition(edge: .top)
    /// Whether the end of the patterns is in sight.
    @State private var isEndVisible = false

    var body: some View {
        let search = PatternSearch(query)
        // Worked out once per update, here, rather than in each place that needs them.
        let sections = PatternCatalog.sections(filter: filter, search: search, favorites: model.favorites)
        // Results replace the browsing sections once something is typed; until then, the filter's patterns
        // stay in view.
        let showsFooter = search.isEmpty && filter != .all && !sections.isEmpty

        ScrollView {
            PatternSections(
                sections: sections,
                layout: layout,
                emptyState: search.isEmpty ? .noFavorites : .noResults(query),
                footerCount: showsFooter ? sections.reduce(0) { $0 + $1.patterns.count } : nil,
                showAll: { withAnimation(.snappy) { filter = .all } }
            )
            .equatable()
            .padding([.horizontal, .bottom])
            .padding(.top, 8)
            Color.clear
                .frame(height: 1)
                .onScrollVisibilityChange(threshold: 0.01) { isEndVisible = $0 }
        }
        .scrollPosition($scrollPosition)
        // Only scroll room, never layout: the patterns stay where they are as the bar opens over them.
        .contentMargins(.bottom, nowPlaying.openHeight)
        // Scrolled to the end, as playing the last patterns leaves them, the patterns follow the bar: up as
        // it opens, so the one just played stays in sight rather than vanishing beneath it, and back down as
        // it closes. The scroll view keeps its offset when the room shrinks, which left the patterns past
        // their end, over a gap, until touched. Once the scroll view has the new room, so it scrolls to the
        // new end rather than the old one.
        .onScrollGeometryChange(for: CGFloat.self) { _ in nowPlaying.openHeight } action: { old, new in
            guard new != old, isEndVisible else { return }
            withAnimation(.spring(duration: 0.42, bounce: 0)) { scrollPosition.scrollTo(edge: .bottom) }
        }
        .scrollDismissesKeyboard(.immediately)
        .accessibilityIdentifier("patternList")
        // Scrolling puts the keyboard away. The field stays, since it costs the patterns no room, and
        // shows what the results are for; with nothing typed, search simply closes.
        .onScrollPhaseChange { _, phase in
            guard phase == .interacting, isSearchFieldOpen, search.isEmpty else { return }
            withAnimation(.snappy) { isSearchFieldOpen = false }
        }
        // The patterns melt into the bar instead of meeting it at a line. The system's soft edge
        // effect stays on beneath it, adding a gentle blur as they fade.
        .mask { BottomFade(nowPlaying: nowPlaying).ignoresSafeArea() }
        .modifier(RecedeBehindNowPlaying(nowPlaying: nowPlaying, navigationBarBottom: navigationBarBottom))
        // A new filter, or a search, starts at the top, not partway down, as a new mailbox does in Mail:
        // at once, since the patterns are all new. Scrolling to the edge rather than to a view keeps the
        // navigation bar settled.
        .onChange(of: filter) { scrollPosition.scrollTo(edge: .top) }
        .onChange(of: query) { scrollPosition.scrollTo(edge: .top) }
        .background(Color(.systemGroupedBackground))
    }
}

/// The sections themselves. Equatable, so the scroll view's other updates, such as the bar opening, leave
/// them alone: they only update when the patterns shown change, or one of them starts playing.
private struct PatternSections: View, Equatable {
    enum EmptyState: Equatable {
        case noFavorites
        case noResults(String)
    }

    let sections: [PatternSection]
    let layout: PatternLayout
    let emptyState: EmptyState
    /// How many patterns a filter shows, for the footer that leads back to all of them. `nil` for none.
    let footerCount: Int?
    let showAll: () -> Void

    @Environment(HapticDemoModel.self) private var model

    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.sections == rhs.sections && lhs.layout == rhs.layout
            && lhs.emptyState == rhs.emptyState && lhs.footerCount == rhs.footerCount
    }

    var body: some View {
        if sections.isEmpty {
            emptyView
                .padding(.top, 40)
        } else {
            VStack(spacing: 24) {
                patterns
                if let footerCount {
                    ShowAllFooter(shown: footerCount, showAll: showAll)
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
    private var emptyView: some View {
        switch emptyState {
        case .noResults(let query):
            ContentUnavailableView.search(text: query)
        case .noFavorites:
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

/// Fades the patterns out as the now-playing bar grows toward the navigation bar. Once there's no room
/// left between them, the only patterns left in sight would be a strip under the status bar and the
/// navigation bar's buttons, cut off below by the fade into the bar: they fade out instead, as the content
/// behind a full-height sheet recedes. The background stays.
///
/// A modifier, so following the bar every frame updates only it, not the patterns.
private struct RecedeBehindNowPlaying: ViewModifier {
    let nowPlaying: NowPlayingLayout
    let navigationBarBottom: CGFloat?

    private var visibility: Double {
        guard let navigationBarBottom else { return 1 }
        let room = nowPlaying.top - navigationBarBottom
        return min(max((room - 80) / 120, 0), 1)
    }

    func body(content: Content) -> some View {
        let visibility = visibility
        content
            .opacity(visibility)
            // The bar reports where it will settle as soon as it starts moving, so the fade eases there
            // alongside it rather than jumping ahead.
            .animation(.easeInOut(duration: 0.3), value: visibility)
            .allowsHitTesting(visibility > 0.5)
            // The edge effect under the navigation bar draws the patterns again itself, which the fade
            // doesn't reach: hidden while they're faded, or a strip of them stays under the status bar.
            .topEdgeEffectHidden(visibility < 1)
    }
}

/// Opaque down to above the now-playing bar, then fading to clear across its top edge. Used as a mask,
/// it fades the patterns out as they reach the bar, so nothing shows through behind its text.
///
/// The fade eases in and out rather than running straight, like light falling off: a straight fade
/// starts and stops abruptly, which shows as lines while scrolling.
private struct BottomFade: View {
    let nowPlaying: NowPlayingLayout

    /// How far above and below the bar's top edge the fade runs.
    private static let above: CGFloat = 56
    private static let below: CGFloat = 20
    /// Enough stops that the eased curve shows no steps.
    private static let steps = 12
    /// Smoothstep at each stop: slow at both ends, so the fade has no visible start or end. The same
    /// every frame, so worked out once.
    private static let curve: [(progress: Double, opacity: Double)] = (0...steps).map { step in
        let progress = Double(step) / Double(steps)
        return (progress, 1 - progress * progress * (3 - 2 * progress))
    }

    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .global)
            let height = max(frame.height, 1)
            let top = nowPlaying.top - frame.minY
            let start = min(max((top - Self.above) / height, 0), 1)
            let end = min(max((top + Self.below) / height, start), 1)
            LinearGradient(
                stops: [.init(color: .black, location: 0)] + Self.curve.map { point in
                    Gradient.Stop(color: .black.opacity(point.opacity), location: start + (end - start) * point.progress)
                },
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
            isSearchFieldOpen: .constant(false),
            nowPlaying: NowPlayingLayout()
        )
    }
    .environment(HapticDemoModel(engine: MockHapticEngine()))
}
