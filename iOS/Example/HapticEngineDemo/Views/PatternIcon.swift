//
// PatternIcon.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// A pattern's symbol on a rounded square in its color: light when idle, filled while playing.
/// Shared by every layout so a pattern looks the same wherever it appears.
struct PatternIcon: View {
    let pattern: HapticPattern
    let isPlaying: Bool
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: pattern.systemImage)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(isPlaying ? .white : pattern.tint)
            .frame(width: size, height: size)
            .background(
                isPlaying ? AnyShapeStyle(pattern.tint) : AnyShapeStyle(pattern.tint.opacity(0.15)),
                in: .rect(cornerRadius: size * 0.27)
            )
    }
}
