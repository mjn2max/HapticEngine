//
// PresetsSection.swift
// HapticEngineDemo
//

import SwiftUI

struct PresetsSection: View {
    let onPlay: (HapticPreset) -> Void

    var body: some View {
        Section("Presets") {
            ForEach(HapticPreset.allCases) { preset in
                Button {
                    onPlay(preset)
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text(preset.title)
                            Text(preset.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: preset.systemImage)
                    }
                }
            }
        }
    }
}
