//
// FilterMenu.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// The toolbar button beside search that opens the filter panel: what the browser shows. Shows
/// the selected filter's icon, in its color, so the header says what's showing; the navigation subtitle
/// names it.
///
/// A button in the toolbar rather than a row of chips, so the patterns start right below the title. The
/// panel it opens is a popover by the button on iPad, and a sheet on iPhone: see `FilterPanel`.
struct FilterMenu: View {
    @Binding var selection: PatternFilter
    /// The area that opens the panel: the whole cell around the icon, not just the icon.
    var size = CGSize(width: 44, height: 44)

    @State private var isPresented = false

    var body: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: selection.systemImage)
                .imageScale(.large)
                .foregroundStyle(selection.tint.map(AnyShapeStyle.init) ?? AnyShapeStyle(.primary))
                .contentTransition(.symbolEffect(.replace))
                .frame(width: size.width, height: size.height)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isPresented) {
            FilterPanel(selection: $selection)
                .frame(minWidth: 360, idealWidth: 400, minHeight: 560, idealHeight: 640)
                // A sheet on iPhone, tall enough to show every choice at once.
                .presentationCompactAdaptation(.sheet)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sensoryFeedback(.selection, trigger: selection)
        .accessibilityShowsLargeContentViewer {
            Label(selection.title, systemImage: selection.systemImage)
        }
        .accessibilityLabel("Filter")
        .accessibilityValue(selection.title)
        .accessibilityHint("Chooses which patterns show")
        .accessibilityIdentifier("filterButton")
    }
}

#Preview {
    @Previewable @State var selection = PatternFilter.favorites
    FilterMenu(selection: $selection)
        .environment(HapticDemoModel(engine: MockHapticEngine()))
}
