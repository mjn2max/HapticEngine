//
// HeaderTitle.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// The navigation bar's title, with what's showing beneath it. With a filter on, that line is a token in
/// the filter's color that clears it in one tap, as Photos and Mail show their filters: the filter and the
/// way out of it, side by side.
struct HeaderTitle: View {
    @Binding var filter: PatternFilter

    @Environment(HapticDemoModel.self) private var model

    private var count: Int {
        PatternCatalog.count(of: filter, favorites: model.favorites, recents: model.recentPatterns)
    }

    var body: some View {
        VStack(spacing: 1) {
            Text("Haptic Engine")
                .font(.headline)
                .lineLimit(1)
                .accessibilityAddTraits(.isHeader)
            if filter == .all {
                Text("All · \(count)")
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            } else {
                token
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
        .animation(.snappy, value: filter)
        .sensoryFeedback(.selection, trigger: filter)
        // It shares the bar's 44 points with the buttons, so it stops growing where the system's own
        // inline titles do; past that, the title would run into the status bar and the count into the list.
        .dynamicTypeSize(...HeaderTitle.largestTypeSize)
    }

    /// The largest text the header's title and controls draw at.
    static let largestTypeSize = DynamicTypeSize.xxLarge

    private var token: some View {
        let tint = filter.tint ?? .accentColor
        return Button {
            filter = .all
        } label: {
            HStack(spacing: 4) {
                Image(systemName: filter.systemImage)
                    .imageScale(.small)
                Text("\(filter.title) · \(count)")
                    .lineLimit(1)
                Image(systemName: "xmark")
                    .imageScale(.small)
                    .fontWeight(.bold)
                    .foregroundStyle(tint.opacity(0.7))
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(tint.opacity(0.15), in: .capsule)
            // Taller than it looks, so it's easy to hit in the bar.
            .padding(.vertical, 4)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .padding(.vertical, -4)
        .accessibilityShowsLargeContentViewer {
            Label("\(filter.title) · \(count)", systemImage: filter.systemImage)
        }
        .accessibilityLabel("Showing \(filter.title)")
        .accessibilityHint("Clears the filter to show all patterns")
        .accessibilityIdentifier("clearFilter")
    }
}
