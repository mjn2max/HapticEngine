//
// AppMenu.swift
// HapticEngineDemo
//

import SwiftUI

/// The menu at the leading edge of the navigation bar: how the patterns are laid out, and the screens
/// beyond them. One button, so features can join it without crowding the bar.
struct AppMenu: View {
    @Binding var layout: PatternLayout
    let isActivityEnabled: Bool
    let showActivity: () -> Void

    var body: some View {
        Menu {
            // A row of icons at the top, as in Files: switching layout is one tap once the menu is open.
            Picker("View As", selection: $layout.animation(.easeOut(duration: 0.25))) {
                ForEach(PatternLayout.allCases, id: \.self) { layout in
                    Label(layout.title, systemImage: layout.systemImage)
                }
            }
            .pickerStyle(.palette)

            Section {
                Button("Activity", systemImage: "clock.arrow.circlepath", action: showActivity)
                    // Nothing can be played without haptic hardware, so there's no activity to show.
                    .disabled(!isActivityEnabled)
            }
        } label: {
            Label("Menu", systemImage: "line.3.horizontal")
        }
        .sensoryFeedback(.selection, trigger: layout)
        .accessibilityIdentifier("appMenu")
    }
}

#Preview {
    @Previewable @State var layout = PatternLayout.grid
    AppMenu(layout: $layout, isActivityEnabled: true) {}
}
