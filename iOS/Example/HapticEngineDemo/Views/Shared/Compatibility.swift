//
// Compatibility.swift
// HapticEngineDemo
//

import SwiftUI

// iOS 26 features, with what the demo does on iOS 18 instead. Kept together so they can go in one change
// once the deployment target reaches iOS 26.

extension View {
    /// On iOS 26, a bar with the system's scroll edge effect, so content fades out beneath it as it does
    /// under the toolbar instead of showing through the glass. Earlier, a plain inset.
    @ViewBuilder
    func bottomBar<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if #available(iOS 26, *) {
            safeAreaBar(edge: .bottom, content: content)
        } else {
            safeAreaInset(edge: .bottom, content: content)
        }
    }

    /// On iOS 26, hides the scroll edge effect under the navigation bar. Earlier, there's none.
    @ViewBuilder
    func topEdgeEffectHidden(_ isHidden: Bool) -> some View {
        if #available(iOS 26, *) {
            scrollEdgeEffectHidden(isHidden, for: .top)
        } else {
            self
        }
    }

    /// Interactive glass on iOS 26, matching the navigation bar's other buttons. Earlier, a thin
    /// material, like the bar.
    @ViewBuilder
    func glass<S: Shape>(in shape: S, id: String, namespace: Namespace.ID) -> some View {
        if #available(iOS 26, *) {
            glassEffect(.regular.interactive(), in: shape)
                .glassEffectID(id, in: namespace)
        } else {
            background(.thinMaterial, in: shape)
        }
    }
}

extension ToolbarContent {
    /// On iOS 26, no glass from the bar around the item, for an item that draws its own.
    @ToolbarContentBuilder
    func withoutSharedBackground() -> some ToolbarContent {
        if #available(iOS 26, *) {
            sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}

/// On iOS 26, a glass container, so shapes inside blend as they meet and part. Earlier, a plain group.
struct GlassGroup<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: Content

    var body: some View {
        if #available(iOS 26, *) {
            GlassEffectContainer(spacing: spacing) { content }
        } else {
            content
        }
    }
}
