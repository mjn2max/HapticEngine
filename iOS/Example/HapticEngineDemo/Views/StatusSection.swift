//
// StatusSection.swift
// HapticEngineDemo
//

import SwiftUI

struct StatusSection: View {
    let isHapticsSupported: Bool

    var body: some View {
        Section {
            LabeledContent("Haptic hardware") {
                Text("\(Image(systemName: statusSymbol)) \(isHapticsSupported ? "Supported" : "Unsupported")")
                    .foregroundStyle(isHapticsSupported ? .green : .red)
            }
        } header: {
            Text("Status")
        } footer: {
            if !isHapticsSupported {
                Text("Haptics only play on a physical iPhone. The Simulator and Mac report no haptic hardware.")
            }
        }
    }

    private var statusSymbol: String {
        isHapticsSupported ? "checkmark.circle.fill" : "xmark.octagon.fill"
    }
}
