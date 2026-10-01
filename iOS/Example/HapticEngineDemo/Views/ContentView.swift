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
    /// Whether the search field is open. Otherwise search is only a button, so the patterns start right
    /// below the title. Scrolling closes the field but keeps the query and its results.
    @State private var isSearchFieldOpen = false
    /// The top of the now-playing bar, in global coordinates, where the patterns fade out.
    @State private var barTop = CGFloat.infinity
    /// The screen's bottom safe area, which the now-playing bar moves down into.
    @State private var bottomInset: CGFloat = 0
    /// The keyboard covers the now-playing bar, which would show faintly through it, so the bar fades
    /// out while it's up.
    @State private var isKeyboardVisible = false

    private var isSearching: Bool {
        isSearchFieldOpen || !query.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// Names what's showing under the title, as Mail names its mailbox. Nothing while searching: results
    /// ignore the filter.
    private var subtitle: String? {
        guard !isSearching else { return nil }
        switch filter {
        case .all: return "\(HapticPattern.allCases.count) Patterns"
        case .favorites: return "Favorites · \(model.favorites.count)"
        case .category(let category): return "\(category.title) · \(category.patterns.count)"
        }
    }

    var body: some View {
        NavigationStack {
            PatternsView(
                filter: $filter,
                layout: layout,
                query: $query,
                isSearchFieldOpen: $isSearchFieldOpen,
                fadeTop: barTop
            )
                .navigationTitle("Patterns")
                .navigationSubtitleIfAvailable(subtitle)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        LayoutMenu(selection: $layout)
                        NavigationLink {
                            ActivityLogView()
                        } label: {
                            Label("Activity", systemImage: "clock.arrow.circlepath")
                        }
                        // Nothing can be played without haptic hardware, so there's no activity to show.
                        .disabled(!model.isHapticsSupported)
                    }
                    // Search sits at the trailing edge, nearest the thumb, with the filter beside it. The
                    // filter steps aside during a search, whose results ignore it.
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        if !isSearching {
                            FilterMenu(selection: $filter)
                        }
                        if !isSearchFieldOpen {
                            SearchButton(query: query) {
                                withAnimation(.snappy) { isSearchFieldOpen = true }
                            }
                        }
                    }
                }
                // Always at the bottom, within thumb reach, like the mini player in Music: play a pattern
                // above, then replay or star it here without looking for it again.
                .bottomBar {
                    NowPlayingBar(bottomInset: bottomInset) { barTop = $0 }
                        .opacity(isKeyboardVisible ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: isKeyboardVisible)
                }
        }
        // The keyboard covers the now-playing bar rather than pushing it up. Otherwise the bar's offset,
        // measured from this safe area, would include the keyboard: the bar would leave the screen and
        // the list would lose the room it needs to scroll.
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onGeometryChange(for: CGFloat.self) { $0.safeAreaInsets.bottom } action: { bottomInset = $0 }
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

/// Opens the search field. Tinted while a search is active but its field is closed, so it's clear the
/// patterns shown are results; tapping it reopens the field with the query.
private struct SearchButton: View {
    let query: String
    let action: () -> Void

    private var isActive: Bool { !query.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        Button(action: action) {
            Image(systemName: "magnifyingglass")
        }
        .prominent(isActive)
        .accessibilityLabel("Search")
        .accessibilityValue(isActive ? query : "")
        .accessibilityIdentifier("searchButton")
    }
}

private extension View {
    @ViewBuilder
    func prominent(_ isProminent: Bool) -> some View {
        if !isProminent {
            self
        } else if #available(iOS 26, *) {
            buttonStyle(.glassProminent)
        } else {
            buttonStyle(.borderedProminent)
        }
    }

    /// On iOS 26, a subtitle under the navigation title. Earlier, nothing: the filter button's icon
    /// still says what's showing. `nil` hides the subtitle without swapping the view, so the content
    /// below keeps its state.
    @ViewBuilder
    func navigationSubtitleIfAvailable(_ subtitle: String?) -> some View {
        if #available(iOS 26, *) {
            navigationSubtitle(subtitle ?? "")
        } else {
            self
        }
    }

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
