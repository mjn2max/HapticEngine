//
// NowPlayingLayout.swift
// HapticEngineDemo
//

import SwiftUI

/// Where the now-playing bar is, for the views laid out around it. The bar writes it; the patterns read it.
///
/// An object of its own rather than state passed down, because the bar's top changes on every frame it's
/// dragged or animated. Observation updates only the views that read a property, so each frame redraws
/// the patterns' fade, not the screen: passed down as a value, it updated the whole screen every frame,
/// working out every section of patterns again each time.
@MainActor
@Observable
final class NowPlayingLayout {
    /// The top of the bar, in global coordinates, where the patterns fade out. Changes every frame it moves.
    var top: CGFloat = .infinity
    /// The bar's height collapsed, padding included: the room the patterns leave it. Changes only with
    /// the text size.
    var collapsedHeight: CGFloat = NowPlayingBar.collapsedHeight
    /// How much taller than collapsed the bar has settled, which the patterns can scroll past. Changes
    /// only once a resize settles, never with the finger.
    var openHeight: CGFloat = 0
}
