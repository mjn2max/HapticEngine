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

    var body: some View {
        Menu {
            Picker("Show", selection: $selection.animation(.snappy)) {
                ForEach(PatternFilter.allFilters) { filter in
                    Label(filter.title, systemImage: filter.systemImage)
                        .tag(filter)
                }
            }
        } label: {
            Image(systemName: selection.systemImage)
                .foregroundStyle(selection.tint.map(AnyShapeStyle.init) ?? AnyShapeStyle(.primary))
                .contentTransition(.symbolEffect(.replace))
        }
        .sensoryFeedback(.selection, trigger: selection)
        .accessibilityLabel("Show")
        .accessibilityValue(selection.title)
        .accessibilityIdentifier("filterButton")
    }
}

#Preview {
    @Previewable @State var selection = PatternFilter.favorites
    FilterMenu(selection: $selection)
}
