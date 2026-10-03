//
// AppMenu.swift
// HapticEngineDemo
//

import SwiftUI

/// The button at the leading edge of the navigation bar, which opens the menu page: the layout, the
/// screens beyond the patterns, and everything about the app. One button, so features can join the page
/// without crowding the bar.
///
/// The page covers the whole screen, so `ContentView` shows it, over everything it draws.
struct AppMenu: View {
    let open: () -> Void

    var body: some View {
        Button("Menu", systemImage: "line.3.horizontal", action: open)
            .accessibilityIdentifier("appMenu")
    }
}

#Preview {
    NavigationStack {
        Color.clear
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { AppMenu {} }
            }
    }
}
