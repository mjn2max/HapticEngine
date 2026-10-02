//
// ContentView.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

struct ContentView: View {
    @Environment(HapticDemoModel.self) private var model

    @State private var filter = PatternFilter.saved
    /// Plain state rather than `@AppStorage`, so a change animates; saved on every change instead.
    @State private var layout = PatternLayout.saved
    @State private var query = ""
    /// Whether the search field is open in the navigation bar. Otherwise search is only a button.
    @State private var isSearchFieldOpen = false
    /// Where the search controls sit in the navigation bar, in global coordinates: a placeholder's frame.
    @State private var searchAnchor: CGRect?
    /// The screen's width.
    @State private var width: CGFloat = 0
    /// The height of the area the now-playing bar is laid out in: below the navigation bar, down to the
    /// bottom safe area.
    @State private var barArea: CGFloat = 0
    /// Screens pushed over the patterns. The search controls draw over the navigation bar, so they step
    /// aside while another screen shows.
    @State private var path: [Screen] = []
    /// The top of the now-playing bar, in global coordinates, where the patterns fade out.
    @State private var barTop = CGFloat.infinity
    /// The now-playing bar's height collapsed, which the patterns leave room for.
    @State private var barCollapsedHeight = NowPlayingBar.collapsedHeight
    /// The screen's bottom safe area, which the now-playing bar moves down into.
    @State private var bottomInset: CGFloat = 0
    /// The keyboard covers the now-playing bar, which would show faintly through it, so the bar fades
    /// out while it's up.
    @State private var isKeyboardVisible = false

    private var isSearching: Bool {
        isSearchFieldOpen || !query.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// Room for the open search controls: from just past the leading buttons to the trailing margin. The
    /// bar's margins are the same at both ends, so the leading buttons end at the margin plus their width.
    private var searchOpenWidth: CGFloat {
        guard let searchAnchor else { return 0 }
        let margin = width - searchAnchor.maxX
        return max(searchAnchor.maxX - margin - Self.leadingButtonsWidth - Self.gap, 180)
    }

    /// Room for the title: between the leading buttons and the closed search controls, less a gap at
    /// each end. The bar's margins are the same at both ends, as for `searchOpenWidth`.
    private var titleGap: (minX: CGFloat, width: CGFloat) {
        guard let searchAnchor else { return (0, 0) }
        let minX = width - searchAnchor.maxX + Self.leadingButtonsWidth + Self.gap
        let maxX = searchAnchor.maxX - SearchControls.closedWidth - Self.gap
        return (minX, max(maxX - minX, 0))
    }

    /// The tallest the now-playing bar may grow: up to its spacing below the navigation bar, whose controls
    /// stay in reach above it. From the room the bar is actually given, less its spacing above and below:
    /// any taller and the bar would be squeezed into it, pushing its contents up against its top edge.
    private var nowPlayingMaxHeight: CGFloat {
        guard barArea > 0 else { return .infinity }
        return barArea - NowPlayingBar.topSpacing - (NowPlayingBar.margin - bottomInset)
    }

    /// How much of the patterns shows as the now-playing bar grows toward the navigation bar. Once
    /// there's no room left between them, the only patterns left in sight would be a strip under the
    /// status bar and the navigation bar's buttons, cut off below by the fade into the bar: they fade out
    /// instead, as the content behind a full-height sheet recedes.
    private var patternsVisibility: Double {
        guard let searchAnchor else { return 1 }
        let room = barTop - searchAnchor.maxY
        return min(max((room - 80) / 120, 0), 1)
    }

    /// The menu button's glass, measured on iOS 26. The bar makes it a native bar button, which can't be
    /// measured from here.
    private static let leadingButtonsWidth: CGFloat = 45
    private static let gap: CGFloat = 8

    var body: some View {
        NavigationStack(path: $path) {
            PatternsView(
                filter: $filter,
                layout: layout,
                query: $query,
                isSearchFieldOpen: $isSearchFieldOpen,
                fadeTop: barTop,
                visibility: patternsVisibility
            )
                // Inline, so the patterns start right below the bar, and the header looks the same whether
                // scrolled or not.
                .navigationTitle("Haptic Engine")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        AppMenu(layout: $layout, isActivityEnabled: model.isHapticsSupported) {
                            path.append(.activity)
                        }
                    }
                    // Holds the title's place, so the bar shows no title of its own: the title draws over the
                    // bar, see below.
                    ToolbarItem(placement: .principal) {
                        Color.clear
                            .frame(width: 1, height: 1)
                            .accessibilityHidden(true)
                    }
                    // Holds the place of the search controls, which draw over the bar: see below.
                    ToolbarItem(placement: .topBarTrailing) {
                        Color.clear
                            .frame(width: SearchControls.closedWidth, height: SearchControls.height)
                            .accessibilityHidden(true)
                            .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: {
                                searchAnchor = $0
                            }
                    }
                    .withoutSharedBackground()
                }
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .activity: ActivityLogView()
                    }
                }
                // Room for the now-playing bar collapsed, and no more. Opened, it grows over the patterns as
                // a sheet does, rather than taking room from them: their layout never changes, so they don't
                // shift as it's resized, nor lay out again on every frame of its animation.
                .bottomBar {
                    Color.clear
                        .frame(height: max(barCollapsedHeight + NowPlayingBar.topSpacing + NowPlayingBar.margin - bottomInset, 0))
                        .allowsHitTesting(false)
                }
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { barArea = $0 }
                // Always at the bottom, within thumb reach, like the mini player in Music: play a pattern
                // above, then replay or star it here without looking for it again.
                .overlay(alignment: .bottom) {
                    NowPlayingBar(
                        bottomInset: bottomInset,
                        maxHeight: nowPlayingMaxHeight,
                        onCollapsedHeightChange: { barCollapsedHeight = $0 },
                        onTopChange: { barTop = $0 }
                    )
                    .opacity(isKeyboardVisible ? 0 : 1)
                    .animation(.easeOut(duration: 0.2), value: isKeyboardVisible)
                }
        }
        // The title, and what's showing, centered between the menu and the search controls. The bar centers
        // its title on the screen instead, which is off-center here: the search controls are the wider.
        // While searching, the field takes its place, and results ignore the filter.
        .overlay(alignment: .topLeading) {
            if let searchAnchor {
                HeaderTitle(filter: $filter)
                    .frame(width: titleGap.width, height: SearchControls.height)
                    .padding(.top, searchAnchor.minY)
                    .padding(.leading, titleGap.minX)
                    .ignoresSafeArea()
                    .opacity(path.isEmpty && !isSearching ? 1 : 0)
                    .allowsHitTesting(path.isEmpty && !isSearching)
                    .animation(.easeOut(duration: 0.2), value: path.isEmpty)
            }
        }
        // Search sits at the trailing edge, nearest the thumb, with the filter beside it. Opened, it widens
        // into a field up to the leading buttons, and the filter steps aside: results ignore it.
        //
        // Drawn over the navigation bar, at a placeholder's spot, rather than in it: the bar resizes its
        // items at once and slides them into place, which fought the animation and made opening search
        // stutter. The placeholder never changes size, so the bar never moves, and the app animates the
        // controls alone.
        .overlay(alignment: .topTrailing) {
            if let searchAnchor {
                SearchControls(text: $query, isOpen: $isSearchFieldOpen, filter: $filter, openWidth: searchOpenWidth)
                    .padding(.top, searchAnchor.minY)
                    .padding(.trailing, width - searchAnchor.maxX)
                    .ignoresSafeArea()
                    .opacity(path.isEmpty ? 1 : 0)
                    .allowsHitTesting(path.isEmpty)
                    .animation(.easeOut(duration: 0.2), value: path.isEmpty)
            }
        }
        // The keyboard covers the now-playing bar rather than pushing it up. Otherwise the bar's offset,
        // measured from this safe area, would include the keyboard: the bar would leave the screen and
        // the list would lose the room it needs to scroll.
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onGeometryChange(for: CGFloat.self) { $0.safeAreaInsets.bottom } action: { bottomInset = $0 }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .onChange(of: filter) { _, filter in filter.save() }
        .onChange(of: layout) { _, layout in layout.save() }
    }
}

/// Screens the patterns lead to.
private enum Screen: Hashable {
    case activity
}

private extension ToolbarContent {
    /// On iOS 26, no glass from the bar around the item, for an item that draws its own.
    @ToolbarContentBuilder
    func withoutSharedBackground() -> some ToolbarContent {
        if #available(iOS 26, *) {
            sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}

private extension View {
    /// On iOS 26, a bar with the system's scroll edge effect, so the patterns fade out beneath it as they
    /// do under the toolbar instead of showing through the glass. Earlier, a plain inset.
    @ViewBuilder
    func bottomBar<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if #available(iOS 26, *) {
            safeAreaBar(edge: .bottom, content: content)
        } else {
            safeAreaInset(edge: .bottom, content: content)
        }
    }
}

#Preview("Supported") {
    ContentView()
        .environment(HapticDemoModel(engine: MockHapticEngine()))
}

#Preview("Unsupported") {
    ContentView()
        .environment(HapticDemoModel(engine: MockHapticEngine(isHapticsSupported: false)))
}
