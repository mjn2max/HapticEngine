//
// PatternIcon.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// A pattern's symbol on a light rounded square in its color, a shade deeper while playing, with a star
/// when it's a favorite. Shared by every layout so a pattern looks the same wherever it appears.
struct PatternIcon: View {
    let pattern: HapticPattern
    let isPlaying: Bool
    var isFavorite = false
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: pattern.systemImage)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(pattern.tint)
            .frame(width: size, height: size)
            .background(pattern.tint.opacity(isPlaying ? 0.25 : 0.15), in: .rect(cornerRadius: size * 0.27))
            .overlay(alignment: .topTrailing) {
                if isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: size * 0.24, weight: .bold))
                        .foregroundStyle(.yellow)
                        // A ring in the card color keeps the star clear of the icon behind it.
                        .padding(2)
                        .background(Color(.secondarySystemGroupedBackground), in: .circle)
                        .offset(x: size * 0.14, y: -size * 0.14)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.snappy, value: isFavorite)
            // Lands just after its pattern as the home screen first appears, star and all.
            .launchRevealAccent()
    }
}

extension View {
    /// The actions every pattern offers wherever it appears: a context menu on touch and hold, and the
    /// same actions for VoiceOver.
    func patternActions(_ pattern: HapticPattern, isFavorite: Bool) -> some View {
        modifier(PatternActions(pattern: pattern, isFavorite: isFavorite))
    }
}

/// Takes plain values, not the model, so a tile or row whose pattern didn't change skips updating.
private struct PatternActions: ViewModifier {
    let pattern: HapticPattern
    let isFavorite: Bool

    @Environment(HapticDemoModel.self) private var model

    func body(content: Content) -> some View {
        let favoriteTitle = isFavorite ? "Remove from Favorites" : "Add to Favorites"
        content
            .contextMenu {
                Button("Play", systemImage: "play") { model.play(pattern) }
                Button(favoriteTitle, systemImage: isFavorite ? "star.slash" : "star", action: toggleFavorite)
            }
            .accessibilityAction(named: favoriteTitle, toggleFavorite)
            .accessibilityIdentifier("pattern.\(pattern.rawValue)")
    }

    private func toggleFavorite() {
        withAnimation(.snappy) { model.toggleFavorite(pattern) }
    }
}
