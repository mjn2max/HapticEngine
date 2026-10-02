//
// FilterMenu.swift
// HapticEngineDemo
//

import SwiftUI

/// Chooses what the browser shows, from the toolbar beside search. Shows the selected filter's icon, in
/// its color, so the header says what's showing; the navigation subtitle names it.
///
/// A menu rather than a row of chips, so the patterns start right below the title.
struct FilterMenu: View {
    @Binding var selection: PatternFilter
    /// The area that opens the menu: the whole cell around the icon, not just the icon.
    var size = CGSize(width: 44, height: 44)

    var body: some View {
        Menu {
            // All on its own at the top, then Favorites, then the categories: the way back is always first.
            // One picker per group, since a menu draws its separators between pickers, not inside one.
            filterPicker([.all])
            filterPicker([.favorites])
            filterPicker(PatternFilter.allFilters.filter { $0 != .all && $0 != .favorites })
        } label: {
            Image(systemName: selection.systemImage)
                .imageScale(.large)
                .foregroundStyle(selection.tint.map(AnyShapeStyle.init) ?? AnyShapeStyle(.primary))
                .contentTransition(.symbolEffect(.replace))
                .frame(width: size.width, height: size.height)
                .contentShape(.rect)
        }
        // A menu takes the accent color; the icon's own color says what's showing.
        .tint(selection.tint ?? .primary)
        .sensoryFeedback(.selection, trigger: selection)
        .accessibilityLabel("Show")
        .accessibilityValue(selection.title)
        .accessibilityIdentifier("filterButton")
    }

    private func filterPicker(_ filters: [PatternFilter]) -> some View {
        Picker("Show", selection: $selection.animation(.snappy)) {
            ForEach(filters) { filter in
                Label(filter.title, systemImage: filter.systemImage)
                    .tag(filter)
            }
        }
    }
}

#Preview {
    @Previewable @State var selection = PatternFilter.favorites
    FilterMenu(selection: $selection)
}
