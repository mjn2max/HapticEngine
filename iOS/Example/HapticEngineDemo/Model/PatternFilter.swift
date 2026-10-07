//
// PatternFilter.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// What the pattern browser shows: every pattern, the favorites, those played recently, or one category.
/// Remembered between launches, so someone testing their favorites comes back to them.
enum PatternFilter: Hashable, Identifiable {
    case all
    case favorites
    /// The patterns played lately, newest first: the activity log without its repeats.
    case recent
    case category(HapticPattern.Category)

    /// Every filter, in the order the filter menu shows them. New categories join automatically.
    static var allFilters: [PatternFilter] {
        [.all, .favorites, .recent] + HapticPattern.Category.allCases.map(PatternFilter.category)
    }

    var id: String { storageValue }

    var title: String {
        switch self {
        case .all: "All"
        case .favorites: "Favorites"
        case .recent: "Recent"
        case .category(let category): category.title
        }
    }

    /// Shown in the filter menu, and on its toolbar button so the button says what's showing.
    var systemImage: String {
        switch self {
        case .all: "line.3.horizontal.decrease"
        case .favorites: "star.fill"
        case .recent: "clock.arrow.circlepath"
        case .category(let category): category.systemImage
        }
    }

    /// The selected filter's color. `nil` for all, which takes the app's tint.
    var tint: Color? {
        switch self {
        case .all: nil
        case .favorites: .yellow
        // The activity log's color, on the menu page.
        case .recent: .blue
        case .category(let category): category.tint
        }
    }

    // MARK: Saving

    /// How `Preferences` saves it. Also a launch argument value, such as `-patternFilter category.game`.
    var storageValue: String {
        switch self {
        case .all: "all"
        case .favorites: "favorites"
        case .recent: "recent"
        case .category(let category): "category.\(category.rawValue)"
        }
    }

    /// `nil` for a value that no longer names a filter, such as a removed category.
    init?(storageValue: String) {
        switch storageValue {
        case "all": self = .all
        case "favorites": self = .favorites
        case "recent": self = .recent
        default:
            guard storageValue.hasPrefix("category."),
                  let category = HapticPattern.Category(rawValue: String(storageValue.dropFirst("category.".count)))
            else { return nil }
            self = .category(category)
        }
    }
}
