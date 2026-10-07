//
// FilterPanel.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Which patterns the home screen shows: every place to go as a tile with its count, all in sight at once.
/// How they're laid out is on the menu page, apart from this.
///
/// Seventeen categories didn't fit a menu on an iPhone: the families fell below its fold, or behind a
/// submenu, and a menu row has no room to say how many patterns are behind it. Tiles do both, and give
/// each choice a target as big as a thumb. Picking one applies it and closes the panel, as a menu does.
struct FilterPanel: View {
    @Binding var selection: PatternFilter

    @Environment(HapticDemoModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.adaptive(minimum: 104), spacing: 8)]
    /// The icon's slot: one height for every symbol, so a tall one such as the star doesn't make its tile
    /// taller than its neighbor. Grows with the text.
    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 22

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // The way back to everything, your own and what you played, first, under their own
                    // heading, as the groups below have theirs.
                    VStack(alignment: .leading, spacing: 8) {
                        header("Show")
                        HStack(spacing: 8) {
                            tile(.all)
                            tile(.favorites)
                            tile(.recent)
                        }
                        // All as tall as the tallest.
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    group("Built In", HapticPattern.Category.handWritten)
                    group("Families", HapticPattern.Category.families)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("filter.done")
                }
            }
        }
    }

    private func header(_ title: LocalizedStringKey) -> some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .padding(.leading, 4)
            .accessibilityAddTraits(.isHeader)
    }

    private func group(_ title: LocalizedStringKey, _ categories: [HapticPattern.Category]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            header(title)
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(categories, id: \.self) { tile(.category($0)) }
            }
        }
    }

    /// A place to go: its icon in its color, its name and how many patterns it holds. What's showing is
    /// marked with a wash and a border in its color and a checkmark, with the text kept as it is: white text
    /// on a solid fill was unreadable on the light colors, yellow above all.
    private func tile(_ filter: PatternFilter) -> some View {
        let isSelected = filter == selection
        let tint = filter.tint ?? .accentColor
        let count = PatternCatalog.count(of: filter, favorites: model.favorites, recents: model.recentPatterns)
        return Button {
            withAnimation(.snappy) { selection = filter }
            dismiss()
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: symbol(for: filter))
                        .font(.body.weight(.semibold))
                        .foregroundStyle(tint)
                        .frame(width: iconSize, height: iconSize, alignment: .leading)
                    Spacer(minLength: 4)
                    countLabel(filter, count: count)
                }
                HStack(spacing: 4) {
                    Text(filter.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer(minLength: 0)
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.subheadline)
                            .foregroundStyle(tint)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background {
                // The wash over the card, so it reads as the card's color, not behind it.
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .overlay(RoundedRectangle(cornerRadius: 12).fill(tint.opacity(isSelected ? 0.15 : 0)))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(tint, lineWidth: isSelected ? 2 : 0)
            }
            .contentShape(.rect(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(filter.title)
        .accessibilityValue(isEmptyToStart(filter, count: count)
            ? Text("None yet")
            : Text("^[\(count) pattern](inflect: true)"))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("filter.\(filter.storageValue)")
    }

    /// All's own icon: the toolbar button's lines mean "filter" there, but on a tile they read as a
    /// filter, not as every pattern.
    private func symbol(for filter: PatternFilter) -> String {
        filter == .all ? "square.grid.2x2" : filter.systemImage
    }

    /// Favorites and Recent start empty, and fill as patterns are starred and played.
    private func isEmptyToStart(_ filter: PatternFilter, count: Int) -> Bool {
        (filter == .favorites || filter == .recent) && count == 0
    }

    /// How many patterns, or for none yet, says so: a bare 0 led to an empty screen unexplained.
    @ViewBuilder
    private func countLabel(_ filter: PatternFilter, count: Int) -> some View {
        Group {
            if isEmptyToStart(filter, count: count) {
                Text("None yet")
            } else {
                Text(count, format: .number)
                    .monospacedDigit()
            }
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(.secondary)
    }
}

#Preview {
    @Previewable @State var selection = PatternFilter.category(.weather)
    Color.clear
        .sheet(isPresented: .constant(true)) {
            FilterPanel(selection: $selection)
                .presentationDetents([.medium, .large])
        }
        .environment(HapticDemoModel(engine: MockHapticEngine()))
}
