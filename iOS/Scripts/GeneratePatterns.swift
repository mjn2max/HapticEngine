#!/usr/bin/env swift
//
// GeneratePatterns.swift
//
// Writes the 900 family patterns: their cases in `HapticPattern`, `HapticPattern.variant` in the library,
// and their names, descriptions, symbols and categories in the demo. How each one feels is in
// `Sources/HapticEngine/PatternFamilies.swift`; this only names them.
//
// Run from the repository root after changing a name here:
//
//     swift iOS/Scripts/GeneratePatterns.swift
//
// Descriptions that give a count, a tempo or a length must stay in step with the formulas in
// `PatternFamilies.swift`; each is noted where it's used.

import Foundation

struct Variant {
    let title: String
    let symbol: String
    /// Used in descriptions.
    let phrase: String
}

struct Level {
    let title: String
    /// Used in descriptions.
    let phrase: String
}

struct Family {
    /// The case of `PatternFamily`, and of the demo's `HapticPattern.Category`.
    let id: String
    let heading: String
    let variants: [Variant]
    let levels: [Level]
    let title: (Variant, Level) -> String
    let subtitle: (Variant, Level, Int) -> String
}

func variants(_ items: [(String, String, String)]) -> [Variant] {
    items.map { Variant(title: $0.0, symbol: $0.1, phrase: $0.2) }
}

func levels(_ items: [(String, String)]) -> [Level] {
    items.map { Level(title: $0.0, phrase: $0.1) }
}

let numbers = ["Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven"]
let timesSaid = ["once", "twice", "three times", "four times", "five times"]
let cyclesSaid = ["once", "one and a half times", "twice", "two and a half times", "three times",
                  "three and a half times", "four times", "four and a half times", "five times"]

let families: [Family] = [
    Family(
        id: "impacts",
        heading: "Impacts: a hit on a material, from feather-light to crushing",
        variants: variants([
            ("Wood", "tree", "a hollow knock"), ("Metal", "wrench.and.screwdriver", "ringing on"),
            ("Glass", "wineglass", "with a tinkle"), ("Stone", "mountain.2", "dull and solid"),
            ("Rubber", "circle.circle", "bouncing back"), ("Plastic", "cube", "with a click"),
            ("Paper", "doc", "with a rustle"), ("Cloth", "tshirt", "muffled"),
            ("Water", "drop", "with a splash"), ("Ceramic", "cup.and.saucer", "with a clink"),
        ]),
        levels: levels([
            ("Feather", "feather-light"), ("Light", "light"), ("Soft", "soft"), ("Gentle", "gentle"),
            ("Medium", "medium"), ("Firm", "firm"), ("Heavy", "heavy"), ("Hard", "hard"), ("Crushing", "crushing"),
        ]),
        title: { "\($1.title) \($0.title) Hit" },
        subtitle: { variant, level, _ in "A \(level.phrase) hit on \(variant.title.lowercased()), \(variant.phrase)" }
    ),
    Family(
        id: "tapCounts",
        heading: "Tap counts: two to eleven taps, from a lazy pace to a rapid one",
        variants: numbers.enumerated().map { index, number in
            Variant(title: number, symbol: "\(index + 2).circle", phrase: number)
        },
        levels: levels([
            ("Lazy", "lazy"), ("Slow", "slow"), ("Relaxed", "relaxed"), ("Easy", "easy"), ("Steady", "steady"),
            ("Brisk", "brisk"), ("Quick", "quick"), ("Fast", "fast"), ("Rapid", "rapid"),
        ]),
        title: { "\($0.title) Taps, \($1.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase) taps at a \(level.phrase) pace, the last strongest" }
    ),
    Family(
        id: "signals",
        heading: "Signals: attention signals, from calm to critical",
        variants: variants([
            ("Ping", "dot.radiowaves.right", "A crisp ping"), ("Chime", "bell.and.waves.left.and.right", "A chime that rings on"),
            ("Bell", "bell", "A bell that fades"), ("Beep", "speaker.wave.1", "A short beep"),
            ("Buzz", "bolt", "A low buzz"), ("Ding", "bell.badge", "A rising two-note ding"),
            ("Pip", "smallcircle.filled.circle", "A quick double pip"), ("Tone", "waveform", "A long, even tone"),
            ("Siren", "light.beacon.max", "A wavering siren"), ("Horn", "megaphone", "A two-blast horn"),
        ]),
        levels: levels([
            ("Calm", "calmly"), ("Soft", "softly"), ("Gentle", "gently"), ("Clear", "clearly"), ("Firm", "firmly"),
            ("Prompt", "promptly"), ("Pressing", "insistently"), ("Urgent", "urgently"), ("Critical", "with alarm"),
        ]),
        title: { "\($1.title) \($0.title)" },
        // Repeats 1 + level / 2 times, as `PatternFamilies.signal` does.
        subtitle: { variant, level, index in "\(variant.phrase), \(timesSaid[index / 2]) \(level.phrase)" }
    ),
    Family(
        id: "meters",
        heading: "Meters: one bar of a meter, from 60 to 180 beats per minute",
        variants: variants([
            ("March", "figure.walk", "march"), ("Waltz", "figure.dance", "waltz"),
            ("Four-Four", "metronome", "four-four"), ("Five-Four", "5.square", "five-four"),
            ("Jig", "music.note", "jig"), ("Seven-Eight", "7.square", "seven-eight"),
            ("Swing", "music.quarternote.3", "swing"), ("Shuffle", "shuffle", "shuffle"),
            ("Clave", "music.note.list", "son clave"), ("Bossa Nova", "guitars", "bossa nova"),
        ]),
        levels: levels([
            ("Largo", ""), ("Larghetto", ""), ("Adagio", ""), ("Andante", ""), ("Moderato", ""),
            ("Allegretto", ""), ("Allegro", ""), ("Vivace", ""), ("Presto", ""),
        ]),
        title: { "\($0.title), \($1.title)" },
        // 60 + 15 × level beats per minute, as `PatternFamilies.meter` does.
        subtitle: { variant, _, index in "One bar of \(variant.phrase) at \(60 + 15 * index) BPM" }
    ),
    Family(
        id: "surfaces",
        heading: "Surfaces: a finger drawn across a surface, from a crawl to a rush",
        variants: variants([
            ("Sand", "beach.umbrella", ""), ("Gravel", "circle.grid.3x3", ""), ("Silk", "wind", ""),
            ("Velvet", "rectangle.fill", ""), ("Corduroy", "line.3.horizontal", ""),
            ("Brick", "rectangle.split.3x3", ""), ("Tile", "square.grid.3x3", ""), ("Ice", "snowflake", ""),
            ("Bark", "tree", ""), ("Carpet", "rectangle.grid.1x2", ""),
        ]),
        levels: levels([
            ("Crawl", "barely moving"), ("Creep", "creeping"), ("Drift", "drifting"), ("Stroll", "at a stroll"),
            ("Walk", "at a walk"), ("Jog", "jogging"), ("Run", "running"), ("Sprint", "sprinting"), ("Rush", "in a rush"),
        ]),
        title: { "\($1.title) over \($0.title)" },
        subtitle: { variant, level, _ in "A finger across \(variant.title.lowercased()), \(level.phrase)" }
    ),
    Family(
        id: "waves",
        heading: "Waves: waveforms over a second and a half, from one cycle to five",
        variants: variants([
            ("Swell", "water.waves", "Swelling and easing smoothly"), ("Rise", "chart.line.uptrend.xyaxis", "Rising, then dropping back"),
            ("Fall", "chart.line.downtrend.xyaxis", "Falling, then jumping back"), ("Square", "square.on.square", "Switching hard on and off"),
            ("Triangle", "triangle", "Rising and falling evenly"), ("Flutter", "wind", "Flickering crisp and soft"),
            ("Throb", "waveform.path.ecg", "Peaking in sharp throbs"), ("Breath", "lungs", "Breathing softly in and out"),
            ("Ripple", "circle.dotted", "Rippling as it fades"), ("Wobble", "tornado", "Wavering in sharpness"),
        ]),
        levels: levels([
            ("Glacial", ""), ("Languid", ""), ("Slow", ""), ("Easy", ""), ("Moderate", ""),
            ("Lively", ""), ("Fast", ""), ("Rapid", ""), ("Frantic", ""),
        ]),
        title: { "\($1.title) \($0.title)" },
        // 1 + 0.5 × level cycles, as `PatternFamilies.wave` does.
        subtitle: { variant, _, index in "\(variant.phrase), \(cyclesSaid[index])" }
    ),
    Family(
        id: "dynamics",
        heading: "Dynamics: changes in strength or sharpness, from 0.2 to 1.8 seconds long",
        variants: variants([
            ("Crescendo", "arrow.up.right", "Growing steadily stronger"), ("Decrescendo", "arrow.down.right", "Fading steadily weaker"),
            ("Surge", "bolt.horizontal", "A quick rise and a slow fall"), ("Ebb", "arrow.uturn.down", "A slow fall and a small return"),
            ("Climb", "stairs", "Taps climbing in strength"), ("Plunge", "arrow.down.to.line", "Taps dropping in strength"),
            ("Bloom", "sparkle", "Steady, growing sharper"), ("Wilt", "leaf", "Softening and dulling"),
            ("Spike", "chart.bar", "A sharp peak, then a low hum"), ("Plateau", "chart.line.flattrend.xyaxis", "Rising, holding, then falling"),
        ]),
        levels: levels([
            ("Flash", ""), ("Quick", ""), ("Short", ""), ("Measured", ""), ("Medium", ""),
            ("Long", ""), ("Extended", ""), ("Slow", ""), ("Sustained", ""),
        ]),
        title: { "\($1.title) \($0.title)" },
        // 0.2 × (level + 1) seconds, as `PatternFamilies.dynamic` does.
        subtitle: { variant, _, index in
            "\(variant.phrase) over \(String(format: "%.1f", 0.2 * Double(index + 1))) s"
        }
    ),
    Family(
        id: "weather",
        heading: "Weather: weather and water, from faint to extreme",
        variants: variants([
            ("Drizzle", "cloud.drizzle", "Fine, scattered drops"), ("Rain", "cloud.rain", "Drops falling at random"),
            ("Hail", "cloud.hail", "Hard, sharp pellets"), ("Wind", "wind", "Gusts rising and falling"),
            ("Thunder", "cloud.bolt", "A crack, then a rolling rumble"), ("Surf", "water.waves", "Waves rolling in"),
            ("Stream", "drop", "Water running over stones"), ("Tremor", "waveform.path", "The ground shaking"),
            ("Fire", "flame", "A crackling fire"), ("Sleet", "cloud.sleet", "Icy drops in a cold hiss"),
        ]),
        levels: levels([
            ("Faint", "faint"), ("Light", "light"), ("Gentle", "gentle"), ("Moderate", "moderate"), ("Steady", "steady"),
            ("Strong", "strong"), ("Heavy", "heavy"), ("Intense", "intense"), ("Extreme", "extreme"),
        ]),
        title: { "\($1.title) \($0.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase), \(level.phrase)" }
    ),
    Family(
        id: "machines",
        heading: "Machines: machines running, from idle to the redline",
        variants: variants([
            ("Motor", "powerplug", "A humming motor"), ("Engine", "engine.combustion", "An engine's firing strokes"),
            ("Fan", "fan", "Fan blades sweeping past"), ("Drill", "wrench.adjustable", "A drill bit spinning"),
            ("Pump", "arrow.up.arrow.down", "A pump pushing and releasing"), ("Saw", "scissors", "A saw rasping back and forth"),
            ("Gearbox", "gearshape.2", "Gears meshing"), ("Ratchet", "wrench", "A ratchet clicking"),
            ("Clockwork", "clock", "Clockwork ticking"), ("Sewing Machine", "lines.measurement.horizontal", "A needle stitching"),
        ]),
        levels: levels([
            ("Idle", "at idle"), ("Low", "turning slowly"), ("Easy", "at an easy pace"), ("Cruising", "cruising"),
            ("Steady", "running steadily"), ("Busy", "working hard"), ("High", "at high speed"), ("Racing", "racing"),
            ("Redline", "at the redline"),
        ]),
        title: { "\($1.title) \($0.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase), \(level.phrase)" }
    ),
    Family(
        id: "arcade",
        heading: "Arcade: game actions, from tiny to epic",
        variants: variants([
            ("Jump", "arrow.up", "A push upward"), ("Landing", "arrow.down.to.line", "A thud and a settle"),
            ("Hit", "burst", "A strike and a rebound"), ("Dash", "hare", "A quick burst forward"),
            ("Shot", "scope", "A crisp shot and its kick"), ("Charge", "bolt.fill", "Power building up"),
            ("Pickup", "star", "Bright rising taps"), ("Level Up", "arrow.up.circle", "Rising taps and a bright hold"),
            ("Damage", "heart.slash", "A blow and a shake"), ("Shield", "shield", "A shimmering barrier"),
        ]),
        levels: levels([
            ("Tiny", "tiny"), ("Small", "small"), ("Light", "light"), ("Medium", "medium"), ("Big", "big"),
            ("Heavy", "heavy"), ("Huge", "huge"), ("Giant", "giant"), ("Epic", "epic"),
        ]),
        title: { "\($1.title) \($0.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase), \(level.phrase)" }
    ),
]

// MARK: Building

struct Pattern {
    let name: String
    let title: String
    let subtitle: String
    let symbol: String
    let family: Family
    let variant: Int
    let level: Int
}

/// "Four-Four, Largo" gives "fourFourLargo".
func caseName(_ title: String) -> String {
    let words = title.split { !$0.isLetter && !$0.isNumber }.map(String.init)
    return words.enumerated().map { index, word in
        index == 0 ? word.lowercased() : word.prefix(1).uppercased() + word.dropFirst().lowercased()
    }.joined()
}

let patterns: [Pattern] = families.flatMap { family in
    family.variants.enumerated().flatMap { variantIndex, variant in
        family.levels.enumerated().map { levelIndex, level in
            let title = family.title(variant, level)
            return Pattern(
                name: caseName(title),
                title: title,
                subtitle: family.subtitle(variant, level, levelIndex),
                symbol: variant.symbol,
                family: family,
                variant: variantIndex,
                level: levelIndex
            )
        }
    }
}

// MARK: Files

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
func path(_ relative: String) -> URL { root.appendingPathComponent(relative) }
let enumFile = path("iOS/Sources/HapticEngine/HapticPattern.swift")
let variantFile = path("iOS/Sources/HapticEngine/HapticPattern+Variant.swift")
let demoFile = path("iOS/Example/HapticEngineDemo/Model/HapticPattern+Families.swift")
let displayFile = path("iOS/Example/HapticEngineDemo/Model/HapticPattern+Display.swift")

let begin = "    // BEGIN GENERATED PATTERNS: written by iOS/Scripts/GeneratePatterns.swift. Don't edit by hand.\n"
let end = "    // END GENERATED PATTERNS\n"

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("error: \(message)\n".utf8))
    exit(1)
}

guard var enumSource = try? String(contentsOf: enumFile, encoding: .utf8) else {
    fail("Run from the repository root: \(enumFile.path) not found")
}

// The hand-written cases and titles, which the generated ones mustn't repeat.
if let start = enumSource.range(of: "\n" + begin), let stop = enumSource.range(of: end) {
    // With the blank line written before it, so running again changes nothing.
    enumSource.removeSubrange(start.lowerBound..<stop.upperBound)
}
let handNames = Set(enumSource.split(separator: "\n").compactMap { line -> String? in
    guard line.hasPrefix("    case ") else { return nil }
    return String(line.dropFirst("    case ".count))
})
let displaySource = (try? String(contentsOf: displayFile, encoding: .utf8)) ?? ""
let handTitles = Set(displaySource.components(separatedBy: "Details(title: \"").dropFirst().compactMap { rest in
    rest.split(separator: "\"", maxSplits: 1).first.map(String.init)
})
guard handNames.count == 100, handTitles.count == 100 else {
    fail("Expected 100 hand-written patterns, found \(handNames.count) cases and \(handTitles.count) titles")
}

for (label, values, existing) in [("case name", patterns.map(\.name), handNames), ("title", patterns.map(\.title), handTitles)] {
    let repeated = Dictionary(grouping: values, by: { $0 }).filter { $0.value.count > 1 }.keys
    guard repeated.isEmpty else { fail("Repeated \(label)s: \(repeated.sorted())") }
    let clashes = Set(values).intersection(existing)
    guard clashes.isEmpty else { fail("\(label)s already used by hand-written patterns: \(clashes.sorted())") }
}
guard patterns.count == 900 else { fail("Expected 900 patterns, made \(patterns.count)") }

// The cases, after the hand-written ones.
var cases = begin
for family in families {
    cases += "\n    // MARK: \(family.heading)\n"
    for pattern in patterns where pattern.family.id == family.id {
        cases += "\n    /// \(pattern.subtitle).\n    case \(pattern.name)\n"
    }
}
cases += end
guard let anchor = enumSource.range(of: "\n    /// How long the pattern plays") else {
    fail("Couldn't find where the cases end in \(enumFile.lastPathComponent)")
}
enumSource.insert(contentsOf: "\n" + cases, at: anchor.lowerBound)

var variantSource = """
//
// HapticPattern+Variant.swift
// HapticEngine
//
// Written by iOS/Scripts/GeneratePatterns.swift. Don't edit by hand.
//

extension HapticPattern {
    /// Where a family pattern sits in its family. `nil` for the hundred built by hand.
    var variant: PatternVariant? {
        switch self {

"""
for pattern in patterns {
    variantSource += "        case .\(pattern.name): PatternVariant(.\(pattern.family.id), \(pattern.variant), \(pattern.level))\n"
}
variantSource += """
        default: nil
        }
    }
}

"""

var demoSource = """
//
// HapticPattern+Families.swift
// HapticEngineDemo
//
// Written by iOS/Scripts/GeneratePatterns.swift. Don't edit by hand.
//

import HapticEngine

extension HapticPattern {
    /// A family pattern's name, description, symbol and category. `nil` for the hundred described by hand.
    var familyDetails: FamilyDetails? {
        switch self {

"""
for pattern in patterns {
    demoSource += "        case .\(pattern.name): FamilyDetails(\"\(pattern.title)\", \"\(pattern.subtitle)\", \"\(pattern.symbol)\", .\(pattern.family.id))\n"
}
demoSource += """
        default: nil
        }
    }
}

"""

do {
    try enumSource.write(to: enumFile, atomically: true, encoding: .utf8)
    try variantSource.write(to: variantFile, atomically: true, encoding: .utf8)
    try demoSource.write(to: demoFile, atomically: true, encoding: .utf8)
} catch {
    fail("Couldn't write: \(error)")
}
print("Wrote \(patterns.count) patterns in \(families.count) families.")
