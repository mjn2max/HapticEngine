//
// FilterMenu.swift
// HapticEngineDemo
//

import SwiftUI

/// Chooses what the browser shows and how, from the toolbar beside search. Shows the selected filter's
/// icon, in its color, so the header says what's showing; the navigation subtitle names it.
///
/// A menu rather than a row of chips, so the patterns start right below the title. The layout sits with
/// the filter, as view options do in Files: both are about the patterns on screen, so both change them
/// in one tap, in plain sight.
struct FilterMenu: View {
    @Binding var selection: PatternFilter
    @Binding var layout: PatternLayout
    /// The area that opens the menu: the whole cell around the icon, not just the icon.
    var size = CGSize(width: 44, height: 44)

    var body: some View {
        Menu {
            // A row of icons at the top, as in Files: switching layout is one tap once the menu is open.
            Picker("View As", selection: $layout.animation(.easeOut(duration: 0.25))) {
                ForEach(PatternLayout.allCases, id: \.self) { layout in
                    Label(layout.title, systemImage: layout.systemImage)
                }
            }
            .pickerStyle(.palette)
            // A palette stays open after a choice by default. Close it, as picking a filter does, so the
            // new layout shows at once rather than behind the menu.
            .menuActionDismissBehavior(.enabled)

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
        .sensoryFeedback(.selection, trigger: layout)
        .accessibilityShowsLargeContentViewer {
            Label(selection.title, systemImage: selection.systemImage)
        }
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
    @Previewable @State var layout = PatternLayout.grid
    FilterMenu(selection: $selection, layout: $layout)
}
