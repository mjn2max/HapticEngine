//
// SimilarPatterns.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// The category's patterns, to feel side by side, pinned along the bottom of the full size. A tap plays
/// one, and the bar shows it. The one showing stays in the row, marked, so the row never reflows as
/// they're tried one after another.
struct SimilarPatterns: View {
    let pattern: HapticPattern

    @Environment(HapticDemoModel.self) private var model

    var body: some View {
        let patterns = pattern.category.patterns
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle("More in \(pattern.category.title)")
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(patterns, id: \.self) { similar in
                            chip(similar, isSelected: similar == pattern)
                                .id(similar)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                // To the bar's edges, so chips scroll out under its corners rather than stopping short.
                .padding(.horizontal, -12)
                .contentMargins(.horizontal, 12, for: .scrollContent)
                // Only as far as needed to bring the one showing into view, so a tap never moves the row.
                .onAppear { proxy.scrollTo(pattern) }
                .onChange(of: pattern) { withAnimation(.snappy) { proxy.scrollTo(pattern) } }
            }
        }
        .padding(.trailing, 6)
        .padding(.bottom, 4)
        // The details scroll out beneath it, fading rather than cut off along its top.
        .background(alignment: .top) {
            VStack(spacing: 0) {
                LinearGradient(colors: [.barSurface.opacity(0), .barSurface], startPoint: .top, endPoint: .bottom)
                    .frame(height: 24)
                Color.barSurface
            }
            .padding(.top, -24)
            .padding(.horizontal, -12)
            .padding(.bottom, -NowPlayingBar.verticalPadding)
        }
    }

    /// Filled in its color when it's the one showing. Otherwise the same size, so nothing shifts.
    private func chip(_ similar: HapticPattern, isSelected: Bool) -> some View {
        Button {
            model.play(similar)
        } label: {
            Label(similar.title, systemImage: similar.systemImage)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(isSelected ? .white : similar.tint)
                .padding(.horizontal, 12)
                .frame(minHeight: 36)
                .background(isSelected ? similar.tint : similar.tint.opacity(0.12), in: .capsule)
                .animation(.snappy, value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityHint(isSelected ? "Plays it again" : "Plays it")
        .accessibilityIdentifier("similar.\(similar.rawValue)")
    }
}
