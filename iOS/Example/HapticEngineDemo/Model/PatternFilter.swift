//
// PatternFilter.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// What the pattern browser shows: every pattern, the favorites, or one category. Remembered between
/// launches, so someone testing their favorites comes back to them.
enum PatternFilter: Hashable, Identifiable {
    case all
    case favorites
    case category(HapticPattern.Category)

    /// Every filter, in the order the filter bar shows them. New categories join automatically.
    static var allFilters: [PatternFilter] {
        [.all, .favorites] + HapticPattern.Category.allCases.map(PatternFilter.category)
    }

    var id: String { storageValue }

    var title: String {
        switch self {
        case .all: "All"
        case .favorites: "Favorites"
        case .category(let category): category.title
        }
    }

    /// Shown in the filter menu, and on its toolbar button so the button says what's showing.
    var systemImage: String {
        switch self {
        case .all: "line.3.horizontal.decrease"
        case .favorites: "star.fill"
        case .category(let category): category.systemImage
        }
    }

    /// The selected chip's color. `nil` for all, which takes the app's tint.
    var tint: Color? {
        switch self {
        case .all: nil
        case .favorites: .yellow
        case .category(let category): category.tint
        }
    }

    // MARK: Saving

    private static let storageKey = "patternFilter"

    /// The filter saved last time, or `all`. A saved category that no longer exists falls back to `all`.
    static var saved: PatternFilter {
        UserDefaults.standard.string(forKey: storageKey).flatMap(PatternFilter.init(storageValue:)) ?? .all
    }

    func save() {
        UserDefaults.standard.set(storageValue, forKey: Self.storageKey)
    }

    private var storageValue: String {
        switch self {
        case .all: "all"
        case .favorites: "favorites"
        case .category(let category): "category.\(category.rawValue)"
        }
    }

    private init?(storageValue: String) {
        switch storageValue {
        case "all": self = .all
        case "favorites": self = .favorites
        default:
            guard storageValue.hasPrefix("category."),
                  let category = HapticPattern.Category(rawValue: String(storageValue.dropFirst("category.".count)))
            else { return nil }
            self = .category(category)
        }
    }
}
