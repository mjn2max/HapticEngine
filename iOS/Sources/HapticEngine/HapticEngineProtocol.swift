//
// HapticEngineProtocol.swift
// HapticEngine
//
// Created by Huy D. on 4/8/25
// mjn2max.github.io 😜
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

/// Plays the library's haptic patterns.
///
/// Depend on this protocol rather than ``HapticEngine`` so you can substitute a
/// mock in tests and SwiftUI previews, where haptic hardware is unavailable.
/// The Android library exposes the same members on its `HapticEngine` interface.
public protocol HapticEngineProtocol {
    /// Whether the current device has haptic hardware.
    ///
    /// This is `false` in the Simulator, on most Macs, and on iPads.
    var isHapticsSupported: Bool { get }

    /// Plays one sharp tap followed by nine taps of rising strength over about one second.
    func startSimpleHaptic()

    /// Plays four 1.5 second segments: medium, hard, soft, hard.
    func startComplexHaptic()
}
