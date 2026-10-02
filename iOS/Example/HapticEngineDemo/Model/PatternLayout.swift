//
// PatternLayout.swift
// HapticEngineDemo
//

/// How the patterns are laid out. Remembered between launches.
///
/// A saved value from a removed layout (such as the old "compact" or "cards") falls back to the default.
enum PatternLayout: String, CaseIterable {
    /// Icon and name, three or more to a row: for tapping quickly.
    case grid
    /// One row per pattern with description and length: for reading what each one does.
    case list

    var title: String {
        switch self {
        case .grid: "Grid"
        case .list: "List"
        }
    }

    var systemImage: String {
        switch self {
        case .grid: "square.grid.2x2"
        case .list: "list.bullet"
        }
    }
}
