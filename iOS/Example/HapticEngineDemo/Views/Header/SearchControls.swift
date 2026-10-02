//
// SearchField.swift
// HapticEngineDemo
//

import SwiftUI

/// The trailing controls of the navigation bar: the filter and search, and while searching, the field
/// and Cancel.
///
/// One view holds them all, so opening search is a single animation the app runs, not several items the
/// navigation bar adds and removes one after another. On iOS 26 they share a glass container, so Cancel
/// splits off the end of the capsule as it stretches into the field.
struct SearchControls: View {
    @Binding var text: String
    @Binding var isOpen: Bool
    @Binding var filter: PatternFilter
    /// The whole width while open: the field, the gap and Cancel.
    let openWidth: CGFloat

    @Environment(HapticDemoModel.self) private var model
    @FocusState private var isFocused: Bool
    @Namespace private var glass

    static let height: CGFloat = 44
    private static let size = height
    /// Each closed button's share of the capsule: the spacing of the leading buttons, so both ends match.
    private static let cellWidth: CGFloat = 52
    /// Filter and search, side by side.
    static let closedWidth = cellWidth * 2
    private static let gap: CGFloat = 8
    private static let animation = Animation.smooth(duration: 0.32)

    var body: some View {
        GlassGroup(spacing: Self.gap) {
            HStack(spacing: Self.gap) {
                capsule
                if isOpen {
                    Button(action: close) {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .frame(width: Self.size, height: Self.size)
                            .contentShape(.circle)
                    }
                    .buttonStyle(.plain)
                    .glass(in: Circle(), id: "cancel", namespace: glass)
                    .accessibilityLabel("Cancel")
                }
            }
        }
        // Playing a result puts the keyboard away, so the now-playing bar can show it.
        .onChange(of: model.nowPlaying?.id) { _, playing in
            if playing != nil { isFocused = false }
        }
    }

    /// One capsule throughout: filter and search side by side, like the leading buttons, which stretches
    /// leftward into the field as the filter fades out.
    private var capsule: some View {
        HStack(spacing: 0) {
            if !isOpen {
                FilterMenu(selection: $filter, size: CGSize(width: Self.cellWidth, height: Self.size))
                    .transition(.opacity)
            }
            Button {
                if isOpen { isFocused = true } else { open() }
            } label: {
                // Sized like the bar's other icons while a button, and like a search field's once open.
                Image(systemName: "magnifyingglass")
                    .imageScale(isOpen ? .medium : .large)
                    .foregroundStyle(isOpen ? AnyShapeStyle(.secondary) : AnyShapeStyle(.primary))
                    .frame(width: isOpen ? 28 : Self.cellWidth, height: Self.size)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Search")
            .accessibilityIdentifier(isOpen ? "" : "searchButton")
            .accessibilityHidden(isOpen)
            if isOpen {
                TextField("Search", text: $text)
                    .focused($isFocused)
                    .accessibilityIdentifier("searchField")
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    // Takes the keyboard as it widens. Focus asked for before the field is in a window is
                    // dropped, so keep asking briefly.
                    .task {
                        for _ in 0..<20 where !isFocused {
                            isFocused = true
                            try? await Task.sleep(for: .milliseconds(30))
                        }
                    }
                    .transition(.opacity)
                if !text.isEmpty {
                    Button {
                        text = ""
                        isFocused = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .frame(width: 32, height: Self.size)
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear Search")
                    .transition(.opacity)
                }
            }
        }
        .padding(.horizontal, isOpen ? 8 : 0)
        .frame(width: isOpen ? openWidth - Self.gap - Self.size : Self.closedWidth, height: Self.size, alignment: .leading)
        .glass(in: Capsule(), id: "capsule", namespace: glass)
    }

    private func open() {
        withAnimation(Self.animation) { isOpen = true }
    }

    private func close() {
        isFocused = false
        withAnimation(Self.animation) {
            text = ""
            isOpen = false
        }
    }
}
