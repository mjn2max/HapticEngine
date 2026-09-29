//
// ContentView.swift
// HapticEngineDemo
//

import SwiftUI

struct ContentView: View {
    @Environment(HapticDemoModel.self) private var model
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            ScrollView {
                PatternGrid(nowPlaying: model.nowPlaying) { model.play($0) }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 8)
            }
            // The status and history button replace the navigation bar, pinned so what's playing stays
            // visible while scrolling to the lower patterns.
            .safeAreaInset(edge: .top) {
                HStack(spacing: 12) {
                    Button {
                        if let pattern = model.lastPlayed { model.play(pattern) }
                    } label: {
                        PlayerCard(
                            playback: model.nowPlaying,
                            lastPlayed: model.lastPlayed,
                            isHapticsSupported: model.isHapticsSupported
                        )
                    }
                    .buttonStyle(PressableStyle())
                    // Nothing to replay until a pattern has been played. Not `disabled`, which would grey
                    // out the card's icon.
                    .allowsHitTesting(model.lastPlayed != nil)
                    .accessibilityRemoveTraits(model.lastPlayed == nil ? .isButton : [])
                    .accessibilityHint(model.lastPlayed == nil ? "" : "Plays it again")
                    NavigationLink {
                        ActivityLogView()
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.tint)
                            .frame(width: 56)
                            .frame(maxHeight: .infinity)
                            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20))
                    }
                    .buttonStyle(PressableStyle())
                    .accessibilityLabel("Activity")
                }
                // Lets the button match the card's height.
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGroupedBackground))
            }
            .background(Color(.systemGroupedBackground))
            // Still names the Activity screen's back button.
            .navigationTitle("HapticEngine")
            .toolbar(.hidden, for: .navigationBar)
        }
        .onChange(of: scenePhase) { _, phase in
            model.record("Scene phase: \(String(describing: phase))")
        }
    }
}

#Preview("Supported") {
    ContentView()
        .environment(HapticDemoModel(engine: MockHapticEngine()))
}

#Preview("Unsupported") {
    ContentView()
        .environment(HapticDemoModel(engine: MockHapticEngine(isHapticsSupported: false)))
}
