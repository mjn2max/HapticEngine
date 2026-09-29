//
// PresetsSection.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

struct PresetsSection: View {
    let onPlay: (HapticPattern) -> Void

    var body: some View {
        Section("Presets") {
            ForEach(HapticPattern.allCases, id: \.self) { pattern in
                Button {
                    onPlay(pattern)
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text(pattern.title)
                            Text(pattern.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: pattern.systemImage)
                    }
                }
            }
        }
    }
}
