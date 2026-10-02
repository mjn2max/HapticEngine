//
// Preferences.swift
// HapticEngineDemo
//

import Foundation
import HapticEngine

/// What the demo remembers between launches, in one place: favorites, the filter and the layout.
///
/// Backed by `UserDefaults`, injected so tests get a store of their own. The keys are also launch
/// arguments: UI tests start from a known state with `-patternFilter all -patternLayout list -favorites ()`.
/// A saved value that no longer exists, such as a renamed pattern or category, falls back to the default.
struct Preferences {
    private let defaults: UserDefaults

    private enum Key {
        static let favorites = "favorites"
        static let filter = "patternFilter"
        static let layout = "patternLayout"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// In the order they were starred.
    var favorites: [HapticPattern] {
        get { (defaults.stringArray(forKey: Key.favorites) ?? []).compactMap(HapticPattern.init(rawValue:)) }
        nonmutating set { defaults.set(newValue.map(\.rawValue), forKey: Key.favorites) }
    }

    var filter: PatternFilter {
        get { defaults.string(forKey: Key.filter).flatMap(PatternFilter.init(storageValue:)) ?? .all }
        nonmutating set { defaults.set(newValue.storageValue, forKey: Key.filter) }
    }

    var layout: PatternLayout {
        get { defaults.string(forKey: Key.layout).flatMap(PatternLayout.init(rawValue:)) ?? .grid }
        nonmutating set { defaults.set(newValue.rawValue, forKey: Key.layout) }
    }
}
