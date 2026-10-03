//
// MenuView.swift
// HapticEngineDemo
//

import SwiftUI

/// The page behind the menu button, laid out like Settings: what the app is and whether haptics play here,
/// then Activity, then what a developer trying the library reaches for next: adding it to their app, its
/// code, reporting a bug, its license. Favorites and the layout aren't here but in the filter menu, beside
/// the patterns they change: see `FilterMenu`.
///
/// Covers the whole screen, sliding in from the leading edge where its button is, and back out the same
/// way: by its close button, which sits where the menu button was, or by swiping it back.
struct MenuView: View {
    /// What to show once the page has closed.
    enum Action {
        case showActivity
    }

    /// Closes the page, then shows what was chosen, if anything.
    let onClose: (Action?) -> Void

    @Environment(HapticDemoModel.self) private var model
    /// Bumped by tapping the icon, to feel a tap: this is an app about haptics, after all.
    @State private var iconTaps = 0
    /// How far the page has been swiped back toward the leading edge, while it's being swiped.
    @State private var dragOffset: CGFloat = 0
    /// Whether the current drag is a swipe back, rather than a scroll. Decided as it starts.
    @State private var isSwipingBack: Bool?
    /// Whether the header has scrolled up under the navigation bar, which then names the app in its place.
    @State private var isHeaderHidden = false
    /// Bumped by copying the package URL: the row says so for a moment.
    @State private var packageCopies = 0
    @State private var isShowingCopied = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            List {
                Section {
                    header
                } footer: {
                    if !model.isHapticsSupported {
                        Text("This device has no Taptic Engine, so patterns can't be felt here. Try the demo on an iPhone.")
                    }
                }

                Section {
                    Button {
                        onClose(.showActivity)
                    } label: {
                        MenuRow("Activity", systemImage: "clock.arrow.circlepath", tint: .blue) {
                            if !model.log.isEmpty { MenuBadge(count: model.log.count) }
                            MenuAccessory.chevron
                        }
                    }
                    // Nothing can be played without haptic hardware, so there's no activity to show.
                    .disabled(!model.isHapticsSupported)
                    .accessibilityIdentifier("menu.activity")

                    Button(action: copyPackageURL) {
                        MenuRow(
                            "Use in Your App",
                            subtitle: isShowingCopied ? "Copied. Paste it in Add Package Dependencies." : "Copy the Swift Package URL",
                            systemImage: "shippingbox.fill",
                            tint: .orange
                        ) {
                            Image(systemName: isShowingCopied ? "checkmark" : "doc.on.doc")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(isShowingCopied ? Color.green : Color(.tertiaryLabel))
                                .contentTransition(.symbolEffect(.replace))
                                .accessibilityHidden(true)
                        }
                    }
                    .sensoryFeedback(.success, trigger: packageCopies)
                    .accessibilityIdentifier("menu.package")

                    Link(destination: AppInfo.sourceCode) {
                        MenuRow("Source Code", systemImage: "chevron.left.forwardslash.chevron.right", tint: .gray) {
                            MenuAccessory.external
                        }
                    }
                    Link(destination: AppInfo.newIssue(isHapticsSupported: model.isHapticsSupported)) {
                        MenuRow("Report an Issue", systemImage: "ladybug.fill", tint: .indigo) {
                            MenuAccessory.external
                        }
                    }
                    NavigationLink {
                        LicensesView()
                    } label: {
                        MenuRow("License", systemImage: "doc.text.fill", tint: .purple)
                    }
                }

                footer
            }
            .contentMargins(.top, 8, for: .scrollContent)
            // No title while the header shows the app's name; once it's scrolled away, the bar takes it.
            .onScrollGeometryChange(for: Bool.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top > 70
            } action: { _, isHidden in
                withAnimation(.easeOut(duration: 0.2)) { isHeaderHidden = isHidden }
            }
            .navigationTitle(isHeaderHidden ? "Haptic Engine" : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Where the menu button was, so the same spot opens and closes the page. A back arrow, as
                // the page slid in from that edge and goes back the way it came.
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back", systemImage: "chevron.backward") { onClose(nil) }
                        .accessibilityIdentifier("menu.done")
                }
            }
        }
        // Opaque edge to edge: the patterns mustn't show through anywhere, nor under the bars.
        .background(Color(.systemGroupedBackground))
        // A soft edge on the patterns beneath, once swiped far enough to see them.
        .shadow(color: .black.opacity(dragOffset < 0 ? 0.15 : 0), radius: 12)
        .offset(x: dragOffset)
        .simultaneousGesture(swipeBack)
    }

    /// Follows a finger swiping the page back to the left, and closes it if let go far enough or fast
    /// enough. Vertical drags are left to the list.
    private var swipeBack: some Gesture {
        DragGesture(minimumDistance: 16)
            .onChanged { drag in
                let translation = drag.translation
                if isSwipingBack == nil {
                    isSwipingBack = translation.width < 0 && abs(translation.width) > abs(translation.height)
                }
                guard isSwipingBack == true else { return }
                dragOffset = min(translation.width, 0)
            }
            .onEnded { drag in
                defer { isSwipingBack = nil }
                guard isSwipingBack == true else { return }
                if drag.translation.width < -120 || drag.predictedEndTranslation.width < -240 {
                    onClose(nil)
                } else {
                    withAnimation(.snappy) { dragOffset = 0 }
                }
            }
    }

    // MARK: Header and footer

    /// The app's icon and version, and whether this device can play haptics: the first thing to check
    /// when nothing is felt. In a row, like the account at the top of Settings; stacked at the largest text
    /// sizes, where a row leaves the text too little room.
    private var header: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
            : AnyLayout(HStackLayout(spacing: 16))
        return layout {
            Image("AppIconImage")
                .resizable()
                .frame(width: 64, height: 64)
                .clipShape(.rect(cornerRadius: 14.5, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 14.5, style: .continuous)
                        .strokeBorder(.primary.opacity(0.08), lineWidth: 0.5)
                }
                // Pressed in and sprung back, in time with the tap felt.
                .keyframeAnimator(initialValue: 1.0, trigger: iconTaps) { icon, scale in
                    icon.scaleEffect(scale)
                } keyframes: { _ in
                    CubicKeyframe(0.88, duration: 0.08)
                    SpringKeyframe(1, duration: 0.4, spring: .bouncy)
                }
                .onTapGesture { iconTaps += 1 }
                .sensoryFeedback(.impact(weight: .medium), trigger: iconTaps)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Haptic Engine")
                    .font(.title3.bold())
                Text(AppInfo.version)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                HapticsStatus(isSupported: model.isHapticsSupported)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
        // For bug reports: the exact build, without retyping it.
        .contextMenu {
            Button("Copy Version", systemImage: "doc.on.doc") {
                UIPasteboard.general.string = AppInfo.version
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var footer: some View {
        Text("Made with care by Huy D. · MIT License")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
    }

    private func copyPackageURL() {
        UIPasteboard.general.string = AppInfo.packageURL.absoluteString
        packageCopies += 1
        withAnimation(.snappy) { isShowingCopied = true }
        let copy = packageCopies
        Task {
            try? await Task.sleep(for: .seconds(2.5))
            // Only the latest copy puts the row back.
            guard copy == packageCopies else { return }
            withAnimation(.snappy) { isShowingCopied = false }
        }
    }
}

/// A pill saying whether haptics play here, green when they do.
private struct HapticsStatus: View {
    let isSupported: Bool

    var body: some View {
        Label(
            isSupported ? "Haptics Ready" : "No Haptics on This Device",
            systemImage: isSupported ? "iphone.radiowaves.left.and.right" : "iphone.slash"
        )
        .font(.caption.weight(.semibold))
        .foregroundStyle(isSupported ? .green : .orange)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background((isSupported ? Color.green : .orange).opacity(0.14), in: .capsule)
    }
}

#Preview("Supported") {
    MenuView { _ in }
        .environment(HapticDemoModel(engine: MockHapticEngine()))
}

#Preview("Unsupported") {
    MenuView { _ in }
        .environment(HapticDemoModel(engine: MockHapticEngine(isHapticsSupported: false)))
}
