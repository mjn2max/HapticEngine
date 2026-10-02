//
// TestSupport.swift
// HapticEngineDemoTests
//

import Foundation
import HapticEngine
import Synchronization
@testable import HapticEngineDemo

/// Records what it's asked to play. Plays arrive on the model's playback queue, so the record is locked.
final class SpyEngine: HapticEngineProtocol {
    let isHapticsSupported: Bool
    private let played = Mutex<[HapticPattern]>([])

    init(isHapticsSupported: Bool = true) {
        self.isHapticsSupported = isHapticsSupported
    }

    var plays: [HapticPattern] { played.withLock { $0 } }

    func play(_ pattern: HapticPattern) {
        played.withLock { $0.append(pattern) }
    }
}

/// `UserDefaults` of its own, so tests never see each other's saves, or the app's.
func makeDefaults() -> UserDefaults {
    let name = "HapticEngineDemoTests.\(UUID().uuidString)"
    let defaults = UserDefaults(suiteName: name)!
    defaults.removePersistentDomain(forName: name)
    return defaults
}
