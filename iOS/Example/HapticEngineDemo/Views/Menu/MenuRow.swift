//
// MenuRow.swift
// HapticEngineDemo
//

import SwiftUI

/// A row on the menu page, as in Settings: a white symbol on a colored tile, the title and perhaps a line
/// under it, then whatever goes at the end, such as a count or where the row leads.
struct MenuRow<Accessory: View>: View {
    let title: String
    let subtitle: String?
    let systemImage: String
    let tint: Color
    @ViewBuilder let accessory: Accessory

    init(
        _ title: String,
        subtitle: String? = nil,
        systemImage: String,
        tint: Color,
        @ViewBuilder accessory: () -> Accessory = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.tint = tint
        self.accessory = accessory()
    }

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(tint.gradient, in: .rect(cornerRadius: 8, style: .continuous))
                .saturation(isEnabled ? 1 : 0)
                .accessibilityHidden(true)
            // Buttons and links tint their labels, and `.primary` would follow the tint: a row reads as a
            // row, not as a link.
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(Color(isEnabled ? .label : .secondaryLabel))
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
            Spacer(minLength: 8)
            accessory
        }
        .contentShape(.rect)
    }
}

/// What goes at the end of a `MenuRow`, saying where it leads.
enum MenuAccessory {
    /// Leads to another screen.
    static var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Color(.tertiaryLabel))
            .accessibilityHidden(true)
    }

    /// Leaves the app, for Safari or the App Store.
    static var external: some View {
        Image(systemName: "arrow.up.right")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Color(.tertiaryLabel))
            .accessibilityHidden(true)
    }
}

/// A count at the end of a row, such as how many favorites there are.
struct MenuBadge: View {
    let count: Int

    var body: some View {
        Text(count, format: .number)
            .font(.subheadline)
            .foregroundStyle(Color(.secondaryLabel))
            .monospacedDigit()
            .contentTransition(.numericText())
    }
}
