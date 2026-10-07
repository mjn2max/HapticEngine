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
    /// The top of the scroll view, in global coordinates: the bottom of the navigation bar.
    @State private var scrollTop: CGFloat?
    /// Whether the patterns have been scrolled by hand. Until then, they're kept at their top.
    @State private var hasScrolled = false
    /// The widest the list grows, so a row's name and length stay within one glance.
    private static let readableWidth: CGFloat = 700

    var body: some View {
        let search = PatternSearch(query)
        // Worked out once per update, here, rather than in each place that needs them.
        let sections = PatternCatalog.sections(filter: filter, search: search, favorites: model.favorites, recents: model.recentPatterns)
        // Results replace the browsing sections once something is typed; until then, the filter's patterns
        // stay in view.
        let showsFooter = search.isEmpty && filter != .all && !sections.isEmpty

        ScrollView {
            PatternSections(
                sections: sections,
                layout: layout,
                emptyState: !search.isEmpty ? .noResults(query) : filter == .recent ? .noRecent : .noFavorites,
                footerCount: showsFooter ? sections.reduce(0) { $0 + $1.patterns.count } : nil,
                showAll: { withAnimation(.snappy) { filter = .all } }
            )
            .equatable()
            // A list row is read across, name to length: on an iPad's whole width they sat far apart.
            // The grid fills the width with more tiles instead.
            .frame(maxWidth: layout == .list ? Self.readableWidth : .infinity)
            .frame(maxWidth: .infinity)
            .padding([.horizontal, .bottom])
            // Just clear of the fade below the navigation bar, so at rest nothing's faded.
            .padding(.top, EdgeFade.topPadding)
        }
        .scrollPosition($scrollPosition)
        // Only scroll room, never layout: the patterns stay where they are as the bar opens over them.
        .contentMargins(.bottom, nowPlaying.openHeight)
        // Scrolled to the end, as playing the last patterns leaves them, the patterns follow the bar up as it
        // opens, so the one just played stays in sight rather than vanishing beneath it. And whenever the room
        // shrinks, patterns left past their new end settle back onto it: the scroll view keeps its offset
        // when the room shrinks, which left them scrolled up over a gap until touched.
        //
        // Both read from the scroll view's own geometry, so where the patterns are and how much room they
        // have always come from the same moment. Room taken from the bar arrives a pass early; the scroll
        // view's inset arrives a pass after its visible height. Either judged the patterns' place against
        // room they didn't have yet. Asking whether a marker at the end was visible failed at the full
        // size: that leaves the end of a short list at the navigation bar's edge, where it counted as out of
        // sight on some systems, so a collapse left the list stranded.
        .onScrollGeometryChange(for: BottomRoom.self) { BottomRoom($0) } action: { old, new in
            guard new.height != old.height else { return }
            let follows = new.height < old.height ? old.isAtEnd : new.isPastEnd
            guard follows else { return }
            withAnimation(.spring(duration: 0.42, bounce: 0)) { scrollPosition.scrollTo(edge: .bottom) }
        }
        // On iPad the window grows open at launch, and the scroll view's offset doesn't keep pace as its size
        // and the navigation bar's room arrive: it could settle partway down, with the first section under
        // the bar. Until the patterns are scrolled by hand, they stay at their top.
        .onScrollGeometryChange(for: TopRoom.self) { TopRoom($0) } action: { _, new in
            guard !hasScrolled, !new.isAtTop else { return }
            scrollPosition.scrollTo(edge: .top)
        }
        .scrollDismissesKeyboard(.immediately)
        .accessibilityIdentifier("patternList")
        // Scrolling puts the keyboard away. The field stays, since it costs the patterns no room, and
        // shows what the results are for; with nothing typed, search simply closes.
        .onScrollPhaseChange { _, phase in
            guard phase == .interacting else { return }
            hasScrolled = true
            guard isSearchFieldOpen, search.isEmpty else { return }
            withAnimation(.snappy) { isSearchFieldOpen = false }
        }
        .onGeometryChange(for: CGFloat.self) { $0.frame(in: .global).minY } action: { scrollTop = $0 }
        // The patterns show through the collapsed glass bar, and melt into the open one instead of meeting
        // it at a line. The system's soft edge effect stays on beneath it, adding a gentle blur. At the top
        // they melt away just below the navigation bar, rather than scrolling on behind its title and
        // buttons.
        .mask { EdgeFade(nowPlaying: nowPlaying, controlsBottom: navigationBarBottom, top: scrollTop).ignoresSafeArea() }
        // The edge effect under the navigation bar draws the patterns again itself, which neither the fade
        // nor the mask reach: a hard-edged strip of them showed below the bar's buttons. The mask fades them
        // there instead.
        .topEdgeEffectHidden(true)
        .modifier(RecedeBehindNowPlaying(nowPlaying: nowPlaying, navigationBarBottom: navigationBarBottom))
        // A new filter, or a search, starts at the top, not partway down, as a new mailbox does in Mail:
        // at once, since the patterns are all new. Scrolling to the edge rather than to a view keeps the
        // navigation bar settled.
        .onChange(of: filter) { scrollPosition.scrollTo(edge: .top) }
        .onChange(of: query) { scrollPosition.scrollTo(edge: .top) }
        .background(Color(.systemGroupedBackground))
    }
}

/// Whether the patterns are scrolled to their top, and the geometry that can move them off it.
private struct TopRoom: Equatable {
    let inset: CGFloat
    let container: CGSize
    let isAtTop: Bool

    init(_ geometry: ScrollGeometry) {
        inset = geometry.contentInsets.top
        container = geometry.containerSize
        // At rest at the top, the offset is minus the top inset.
        isAtTop = geometry.contentOffset.y + geometry.contentInsets.top <= 1
    }
}

/// Where the patterns are scrolled, relative to their end, and how much of the scroll view they can show:
/// less as the now-playing bar opens over them, more as it closes.
private struct BottomRoom: Equatable {
    /// The visible height: the scroll view's, less its insets.
    let height: CGFloat
    /// At the end, or close enough that following the bar keeps the end in place.
    let isAtEnd: Bool
    /// Past the end, over room that's no longer there.
    let isPastEnd: Bool

    init(_ geometry: ScrollGeometry) {
        height = geometry.containerSize.height
        // The furthest the content can scroll. `containerSize` already leaves out the insets, and at rest
        // at the top the offset is minus the top inset. A short list's end is its top.
        let top = -geometry.contentInsets.top
        let end = top + max(geometry.contentSize.height - geometry.containerSize.height, 0)
        isAtEnd = geometry.contentOffset.y >= end - 8
        isPastEnd = geometry.contentOffset.y > end + 1
    }
}

/// Where each section's patterns start in the launch wave, in rows from the top: a title takes half a row,
/// and a grid's patterns take a row for each line of tiles.
struct WaveRows: Equatable {
    static let titleRows: Double = 0.5

    /// The row of each section's first pattern.
    let first: [Double]
    /// Just past the last pattern.
    let end: Double

    init(sections: [PatternSection], columnCount: Int) {
        var first: [Double] = []
        var row: Double = 0
        for section in sections {
            if section.title != nil { row += Self.titleRows }
            first.append(row)
            let count = section.patterns.count
            row += Double((count + columnCount - 1) / columnCount)
        }
        self.first = first
        end = row
    }
}

/// The sections themselves. Equatable, so the scroll view's other updates, such as the bar opening, leave
/// them alone: they only update when the patterns shown change, or one of them starts playing.
private struct PatternSections: View, Equatable {
    enum EmptyState: Equatable {
        case noFavorites
        case noRecent
        case noResults(String)
    }

    let sections: [PatternSection]
    let layout: PatternLayout
    let emptyState: EmptyState
    /// How many patterns a filter shows, for the footer that leads back to all of them. `nil` for none.
    let footerCount: Int?
    let showAll: () -> Void

    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    /// How many tiles the grid fits across, for where each one comes in the launch wave.
    @State private var columnCount = 1

    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.sections == rhs.sections && lhs.layout == rhs.layout
            && lhs.emptyState == rhs.emptyState && lhs.footerCount == rhs.footerCount
    }

    var body: some View {
        if sections.isEmpty {
            emptyView
                .padding(.top, 40)
                .launchReveal(row: 0)
        } else {
            // Where each section starts in the launch wave, so it runs on from one section to the next, and
            // where the patterns end.
            let rows = WaveRows(sections: sections, columnCount: layout == .grid ? columnCount : 1)
            VStack(spacing: 24) {
                patterns(firstRows: rows.first)
                if let footerCount {
                    ShowAllFooter(shown: footerCount, showAll: showAll)
                        .launchReveal(row: rows.end)
                }
            }
            .onGeometryChange(for: Int.self) { [dynamicTypeSize] in
                PatternGrid.columnCount(width: $0.size.width, typeSize: dynamicTypeSize)
            } action: {
                columnCount = $0
            }
        }
    }

    private func patterns(firstRows: [Double]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(Array(zip(sections, firstRows)), id: \.0.id) { section, firstRow in
                VStack(alignment: .leading, spacing: 8) {
                    if let title = section.title {
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)
                            .accessibilityAddTraits(.isHeader)
                            .launchReveal(row: firstRow - WaveRows.titleRows)
                    }
                    switch layout {
                    case .grid: PatternGrid(patterns: section.patterns, firstRow: firstRow, columnCount: columnCount)
                    case .list: PatternList(patterns: section.patterns, firstRow: firstRow)
                    }
                }
            }
        }
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
        case .noRecent:
            ContentUnavailableView {
                Label("Nothing Played Yet", systemImage: "clock.arrow.circlepath")
            } description: {
                Text("Patterns you play show up here, newest first, to feel them again.")
            }
        case .noFavorites:
            // Favorites and Recent are the only filters that can be empty: every category has patterns.
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
    }
}

/// Clear down to just above the bottom of the navigation bar's buttons, fading in from there to just below
/// the bar; opaque down to above the now-playing bar, then fading to clear across its top edge. Used as a mask, it fades the
/// patterns out before they reach the navigation bar's title and buttons, so they never show behind them,
/// and as they reach the open now-playing bar, so nothing shows through behind its details.
///
/// The top fade starts up among the buttons rather than at the bar's edge, below the title, so it can be long
/// and soft while the patterns still start close below the bar. It eases in slowly, so the patterns are all
/// but invisible where they pass behind the buttons' glass, with no line where the fade begins.
/// Collapsed, the bar is glass, which the patterns should show through, but faintly: at full strength
/// their text competed with the bar's. So the fade stops at `glassFloor` beneath the collapsed bar, and
/// runs on to clear as the bar opens and turns solid.
///
/// The fade eases in and out rather than running straight, like light falling off: a straight fade
/// starts and stops abruptly, which shows as lines while scrolling.
private struct EdgeFade: View {
    let nowPlaying: NowPlayingLayout
    /// The bottom of the navigation bar's buttons, in global coordinates, where the patterns are fully
    /// faded. `nil` until known: then the fade starts at the bar's edge.
    let controlsBottom: CGFloat?
    /// The bottom of the navigation bar, in global coordinates. `nil` until it's known: no fade at the top.
    let top: CGFloat?

    /// How far below the navigation bar the patterns become opaque, and so the room above them at rest.
    static let topPadding: CGFloat = 8
    /// How far above the bottom of the buttons the patterns are clear: below the title's second line.
    private static let controlsOverlap: CGFloat = 4
    /// The shortest the top fade runs, should the buttons sit close to the bar's edge.
    private static let minimumTopFade: CGFloat = 18
    /// The top fade's curve: the bottom fade's, squared, so it lingers near clear before rising.
    private static let topCurve = curve.map { (progress: $0.progress, opacity: (1 - $0.opacity) * (1 - $0.opacity)) }

    /// How far above and below the bar's top edge the fade runs.
    private static let above: CGFloat = 56
    private static let below: CGFloat = 20
    /// How much of the patterns shows through the collapsed glass bar: enough to color it, too little to read.
    private static let glassFloor = 0.25
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
            let fadeIn = fadeIn(frame: frame, height: height)
            let barTop = nowPlaying.top - frame.minY
            let floor = Self.glassFloor * (1 - nowPlaying.openness)
            let fadeInEnd = fadeIn.last?.location ?? 0
            let start = min(max((barTop - Self.above) / height, fadeInEnd), 1)
            let end = min(max((barTop + Self.below) / height, start), 1)
            LinearGradient(
                stops: fadeIn + Self.curve.map { point in
                    Gradient.Stop(color: .black.opacity(floor + (1 - floor) * point.opacity), location: start + (end - start) * point.progress)
                },
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    /// Fading in below the navigation bar, the same curve the other way up.
    private func fadeIn(frame: CGRect, height: CGFloat) -> [Gradient.Stop] {
        guard let top else { return [.init(color: .black, location: 0)] }
        let opaque = top + Self.topPadding
        let clear = min((controlsBottom ?? top) - Self.controlsOverlap, opaque - Self.minimumTopFade)
        let start = min(max((clear - frame.minY) / height, 0), 1)
        let end = min(max((opaque - frame.minY) / height, start), 1)
        return Self.topCurve.map { point in
            Gradient.Stop(color: .black.opacity(point.opacity), location: start + (end - start) * point.progress)
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
