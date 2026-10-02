//
// PatternStyles.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Highlights a row while pressed, like a system list row, rather than shrinking it as tiles do.
struct RowPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(.systemFill) : .clear)
    }
}

/// Highlights a card while pressed, like the rows in the list layout and on the Activity screen, so a
/// pattern responds the same way in every layout. Draws the card's background too, so the highlight
/// sits behind its content.
struct CardPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(.systemFill) : .clear)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: GroupedCard.cornerRadius))
    }
}

/// The rounded surface rows sit on, over the grouped background, as in a system inset list.
enum GroupedCard {
    static let cornerRadius: CGFloat = 20
    /// Where a divider between rows starts: past the 40 point icon, in line with the text.
    static let dividerInset: CGFloat = 64
}

extension View {
    /// Draws the view on a `GroupedCard`, clipping rows to its corners.
    func groupedCard() -> some View {
        background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: GroupedCard.cornerRadius))
            .clipShape(.rect(cornerRadius: GroupedCard.cornerRadius))
    }
}

/// An animated waveform at the end of a row, while its pattern plays.
struct PlayingIndicator: View {
    let tint: Color

    var body: some View {
        Image(systemName: "waveform")
            .foregroundStyle(tint)
            .symbolEffect(.variableColor.iterative, isActive: true)
            .transition(.scale.combined(with: .opacity))
    }
}
