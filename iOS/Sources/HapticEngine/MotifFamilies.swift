//
// MotifFamilies.swift
// HapticEngine
//

import CoreHaptics
import Foundation

/// The twenty families after the first ten: each variant a short motif of taps and holds, and each family
/// one way of taking it through five levels, such as stronger, bigger, faster or more often.
///
/// Five levels, not nine: the first families' nine were too close to tell apart on some phones. Every
/// pattern here is held to feeling different from every other, not only to differing at all: see
/// `familyPatternsFeelDistinct` in the tests.
extension HapticPatterns {
    static func motifEvents(for variant: PatternVariant) -> [CHHapticEvent] {
        let level = Double(variant.level) / Double(variant.family.levelCount - 1)
        if variant.family == .morse {
            return morse(MotifLibrary.morseWords[variant.variant], wordsPerMinute: [12, 15, 18, 22, 26][variant.level])
        }
        let (shaping, motifs) = MotifLibrary.family(variant.family)
        // Every pattern starts at once, even a motif written with a lead-in, such as a groove's first rest.
        let motif = motifs[variant.variant]
        let start = motif.map(\.time).min() ?? 0
        return shaped(motif.map { $0.delayed(by: -start) }, by: shaping, at: level).map { step in
            step.duration > 0
                ? hold(step.intensity, step.sharpness, at: step.time, for: step.duration)
                : tap(step.intensity, step.sharpness, at: step.time)
        }
    }

    /// How a family takes its motifs from its lowest level, at 0, to its highest, at 1.
    enum Shaping {
        /// Stronger.
        case strength
        /// Stronger and longer, as a bigger thing would be.
        case size
        /// Faster: from 1.5 times the motif's length down to 0.7.
        case tempo
        /// Played one to five times.
        case repeats
    }

    private static func shaped(_ motif: [MotifStep], by shaping: Shaping, at level: Double) -> [MotifStep] {
        let x = Float(level)
        switch shaping {
        case .strength:
            // From 0.42, so a motif peaking at 0.75 still reaches the 0.3 that can be felt.
            return motif.map { $0.scaled(intensity: 0.42 + 0.58 * x) }
        case .size:
            return motif.map { $0.scaled(intensity: 0.45 + 0.55 * x, time: 0.7 + 0.6 * level) }
        case .tempo:
            return motif.map { $0.scaled(time: 1.5 - 0.8 * level) }
        case .repeats:
            let end = motif.map { $0.time + $0.duration }.max() ?? 0
            let count = Int((level * 4).rounded()) + 1
            return (0..<count).flatMap { index in
                motif.map { $0.scaled(intensity: 0.7 + 0.3 * x).delayed(by: Double(index) * (end + 0.15)) }
            }
        }
    }

    /// A word in Morse code: a dot one unit long, a dash three, a unit between them, three between letters.
    private static func morse(_ word: String, wordsPerMinute: Double) -> [CHHapticEvent] {
        let unit = 1.2 / wordsPerMinute
        var time: TimeInterval = 0
        var events: [CHHapticEvent] = []
        for (index, letter) in word.enumerated() {
            if index > 0 { time += unit * 2 }
            for symbol in MotifLibrary.morseCode[letter, default: ""] {
                let length = symbol == "-" ? unit * 3 : unit
                events.append(hold(1, 0.6, at: time, for: length))
                time += length + unit
            }
        }
        return events
    }
}

/// One event of a motif, before its level shapes it. A duration of 0 is a tap.
struct MotifStep: Sendable {
    var time: TimeInterval
    var intensity: Float
    var sharpness: Float
    var duration: TimeInterval

    func scaled(intensity factor: Float = 1, time stretch: Double = 1) -> MotifStep {
        MotifStep(time: time * stretch, intensity: intensity * factor, sharpness: sharpness, duration: duration * stretch)
    }

    func delayed(by delay: TimeInterval) -> MotifStep {
        MotifStep(time: time + delay, intensity: intensity, sharpness: sharpness, duration: duration)
    }
}

/// The motifs of the twenty families, ten each, in the order the generator names them.
enum MotifLibrary {
    private static func t(_ time: Double, _ intensity: Float, _ sharpness: Float) -> MotifStep {
        MotifStep(time: time, intensity: intensity, sharpness: sharpness, duration: 0)
    }

    private static func h(_ time: Double, _ intensity: Float, _ sharpness: Float, _ duration: Double) -> MotifStep {
        MotifStep(time: time, intensity: intensity, sharpness: sharpness, duration: duration)
    }

    /// `count` taps `every` seconds apart, cycling through `intensities`, and through `sharpnesses` if given.
    private static func ticks(_ count: Int, every: Double, from start: Double = 0, _ intensities: [Float], _ sharpness: Float, sharpnesses: [Float] = []) -> [MotifStep] {
        (0..<count).map { index in
            t(start + Double(index) * every, intensities[index % intensities.count],
              sharpnesses.isEmpty ? sharpness : sharpnesses[index % sharpnesses.count])
        }
    }

    /// `count` back-to-back holds of `each` seconds, cycling through `intensities` and `sharpnesses`.
    private static func holds(_ count: Int, each: Double, from start: Double = 0, _ intensities: [Float], _ sharpnesses: [Float]) -> [MotifStep] {
        (0..<count).map { index in
            h(start + Double(index) * each, intensities[index % intensities.count], sharpnesses[index % sharpnesses.count], each)
        }
    }

    /// One bar of sixteen steps at 120 beats per minute: X an accent, x a crisp hit, o a low one, h an open
    /// hi-hat held briefly, . a rest.
    private static func groove(_ steps: String) -> [MotifStep] {
        steps.enumerated().compactMap { index, step in
            let time = Double(index) * 0.125
            return switch step {
            case "X": t(time, 1, 0.85)
            case "x": t(time, 0.65, 0.6)
            case "o": t(time, 0.85, 0.1)
            case "h": h(time, 0.55, 0.9, 0.06)
            default: nil
            }
        }
    }

    static func family(_ family: PatternFamily) -> (HapticPatterns.Shaping, [[MotifStep]]) {
        switch family {
        case .animals: (.size, animals)
        case .emotions: (.size, emotions)
        case .sports: (.strength, sports)
        case .instruments: (.strength, instruments)
        case .vehicles: (.tempo, vehicles)
        case .controls: (.strength, controls)
        case .body: (.strength, body)
        case .kitchen: (.tempo, kitchen)
        case .tools: (.strength, tools)
        case .space: (.size, space)
        case .ocean: (.size, ocean)
        case .city: (.strength, city)
        case .puzzle: (.size, puzzle)
        case .grooves: (.tempo, grooves)
        case .notifications: (.repeats, notifications)
        case .clocks: (.tempo, clocks)
        case .elements: (.size, elements)
        case .magic: (.size, magic)
        case .electronics: (.strength, electronics)
        default: preconditionFailure("\(family) has no motifs")
        }
    }

    // MARK: The motifs

    // Purr, bark, hoofbeats, hop, peck, wingbeat, paws, slither, bee, whale.
    static let animals: [[MotifStep]] = [
        holds(8, each: 0.06, [0.7, 0.4], [0.15]),
        [t(0, 1, 0.6), h(0.01, 0.8, 0.35, 0.08), t(0.25, 0.9, 0.6), h(0.26, 0.7, 0.35, 0.08)],
        ticks(4, every: 0.09, [0.9, 0.6, 0.8, 0.5], 0.35),
        [t(0, 0.6, 0.5), t(0.3, 1, 0.75), t(0.6, 0.6, 0.5), t(0.9, 1, 0.75)],
        ticks(6, every: 0.05, [0.8], 1),
        (0..<4).map { h(Double($0) * 0.2, 0.9, 0.4, 0.1) },
        ticks(5, every: 0.12, [0.75, 0.5], 0.15),
        holds(10, each: 0.06, [0.3, 0.45, 0.6, 0.75, 0.6, 0.45, 0.3, 0.45, 0.6, 0.75], [0.1]),
        holds(12, each: 0.05, [0.5, 0.75], [0.8, 0.95]),
        [h(0, 0.4, 0, 0.4), h(0.4, 0.85, 0, 0.6), h(1.0, 0.45, 0, 0.4)],
    ]

    // Joy, calm, surprise, anger, sadness, fear, love, laughter, sigh, excitement.
    static let emotions: [[MotifStep]] = [
        [t(0, 0.7, 0.8), t(0.1, 0.85, 0.9), t(0.2, 1, 1), h(0.22, 0.6, 0.8, 0.2)],
        holds(4, each: 0.25, [0.35, 0.55, 0.75, 0.55], [0.1]),
        [t(0, 1, 1), h(0.02, 0.5, 0.6, 0.15)],
        holds(8, each: 0.05, [1, 0.55], [0.2]),
        holds(6, each: 0.15, [0.75, 0.65, 0.55, 0.45, 0.38, 0.3], [0]),
        holds(16, each: 0.04, [0.5, 0.8], [0.5]),
        [h(0, 0.6, 0.2, 0.3), t(0.35, 0.9, 0.3), h(0.4, 0.6, 0.2, 0.3)],
        ticks(7, every: 0.11, [0.9, 0.6], 0.7),
        // A breath in, a pause, then a long breath out.
        holds(3, each: 0.2, [0.35, 0.55, 0.75], [0.3]) + holds(4, each: 0.25, from: 0.8, [0.6, 0.45, 0.35, 0.3], [0]),
        [0, 0.2, 0.35, 0.47, 0.56, 0.63, 0.69, 0.74].map { t($0, 0.85, 0.9) },
    ]

    // Kick, dribble, serve, swish, bat, whistle, goal, volley, punch, finish line.
    static let sports: [[MotifStep]] = [
        [t(0, 1, 0.4), h(0.01, 0.6, 0.2, 0.06)],
        ticks(6, every: 0.18, [1, 0.85, 0.7, 0.55, 0.45, 0.35], 0.4),
        [t(0, 0.5, 0.6), t(0.4, 1, 0.9)],
        holds(5, each: 0.04, [0.3, 0.6, 0.9, 0.6, 0.3], [0.9]),
        [t(0, 1, 1), t(0.03, 0.6, 0.8), h(0.05, 0.4, 0.6, 0.05)],
        [h(0, 0.9, 1, 0.25), h(0.3, 0.9, 1, 0.5)],
        ticks(4, every: 0.1, [0.6, 0.7, 0.8, 0.9], 0.8) + [h(0.4, 1, 0.7, 0.6)],
        [t(0, 0.8, 0.7), t(0.16, 1, 0.8), t(0.32, 0.8, 0.7)],
        [t(0, 1, 0.5), h(0.015, 0.9, 0.3, 0.04), t(0.2, 1, 0.5), h(0.215, 0.9, 0.3, 0.04)],
        [h(0, 0.6, 0.5, 0.2), h(0.25, 0.8, 0.6, 0.2), h(0.5, 1, 0.7, 0.35)],
    ]

    // Snare, kick drum, cymbal, bass, strum, chord, harp, xylophone, gong, triangle.
    static let instruments: [[MotifStep]] = [
        [t(0, 1, 0.95), h(0.01, 0.4, 0.9, 0.08)],
        [t(0, 1, 0), h(0.01, 0.7, 0, 0.12)],
        [t(0, 0.9, 1)] + holds(5, each: 0.1, from: 0.01, [0.6, 0.5, 0.4, 0.3, 0.2], [1]),
        [t(0, 0.9, 0.2), h(0.01, 0.7, 0.1, 0.3)],
        ticks(6, every: 0.025, [0.5, 0.6, 0.7, 0.8, 0.9, 1], 0.7),
        [t(0, 1, 0.6), t(0.02, 0.8, 0.5), t(0.04, 0.6, 0.4)],
        ticks(8, every: 0.06, [0.4, 0.5, 0.6, 0.7, 0.8, 0.85, 0.9, 1], 0.9),
        ticks(5, every: 0.15, [0.9], 0, sharpnesses: [0.6, 0.7, 0.8, 0.9, 1]),
        [t(0, 1, 0.2), h(0.01, 0.8, 0.1, 0.4), h(0.41, 0.6, 0.1, 0.4), h(0.81, 0.4, 0.1, 0.4)],
        [t(0, 0.85, 1), h(0.01, 0.35, 1, 0.5), t(0.6, 0.85, 1)],
    ]

    // Train, motorbike, helicopter, boat, bicycle bell, skateboard, subway, rocket, tram, jet.
    static let vehicles: [[MotifStep]] = [
        [t(0, 0.9, 0.6), t(0.12, 0.9, 0.6), t(0.6, 0.9, 0.6), t(0.72, 0.9, 0.6)],
        holds(12, each: 0.05, [0.9, 0.5], [0.4]),
        holds(6, each: 0.1, [1, 0.3], [0.3]),
        holds(3, each: 0.3, [0.4, 0.8, 0.4], [0.1]),
        [t(0, 0.9, 1), h(0.01, 0.4, 1, 0.12), t(0.2, 0.9, 1), h(0.21, 0.4, 1, 0.12)],
        [t(0, 1, 0.6), h(0.01, 0.4, 0.5, 0.6), t(0.2, 0.8, 0.5), t(0.4, 0.8, 0.5)],
        [h(0, 0.5, 0.2, 0.4), t(0.45, 0.9, 0.5), t(0.55, 0.9, 0.5), h(0.6, 0.5, 0.2, 0.4)],
        holds(8, each: 0.1, [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1], [0.2]),
        [t(0, 0.8, 0.9), t(0.3, 0.8, 0.9), h(0.5, 0.5, 0.4, 0.5)],
        holds(10, each: 0.08, [0.6, 0.75, 0.9, 1, 1, 1, 0.9, 0.75, 0.6, 0.45], [0.8]),
    ]

    // Switch, slider, stepper, pull to refresh, page turn, key press, scroll stop, pop, snap back, grab.
    static let controls: [[MotifStep]] = [
        [t(0, 0.5, 0.6), t(0.05, 1, 1)],
        ticks(8, every: 0.04, [0.8], 0.9),
        [t(0, 0.9, 0.8), t(0.08, 0.4, 0.5)],
        holds(4, each: 0.08, [0.3, 0.5, 0.7, 0.85], [0.4]) + [t(0.35, 1, 1)],
        holds(3, each: 0.05, [0.4, 0.8, 0.4], [0.6]) + [t(0.16, 0.6, 0.8)],
        [t(0, 0.85, 0.95), t(0.06, 0.4, 0.7)],
        [t(0, 0.9, 0.3), t(0.05, 0.5, 0.3), t(0.1, 0.25, 0.3)],
        [h(0, 0.4, 0.5, 0.05), t(0.06, 1, 1)],
        [t(0, 1, 0.8), h(0.02, 0.5, 0.5, 0.1), t(0.14, 0.6, 0.8)],
        ticks(3, every: 0.025, [0.8, 0.6, 0.8], 0.6),
    ]

    // Breath, footstep, finger snap, knuckles, shiver, yawn, hiccup, sneeze, hug, flutter.
    static let body: [[MotifStep]] = [
        holds(8, each: 0.15, [0.3, 0.6, 0.8, 0.4], [0]),
        [t(0, 0.9, 0.3), t(0.5, 0.9, 0.3)],
        [t(0, 1, 1), h(0.01, 0.3, 0.9, 0.03)],
        ticks(4, every: 0.035, [0.8, 0.6, 0.9, 0.7], 0.9),
        holds(20, each: 0.03, [0.5, 0.85], [0.7]),
        holds(5, each: 0.2, [0.4, 0.6, 0.8, 0.6, 0.3], [0.3]),
        [t(0, 1, 0.7), t(0.7, 1, 0.7)],
        holds(4, each: 0.1, [0.3, 0.5, 0.7, 0.85], [0.2]) + [t(0.42, 1, 0.8), h(0.43, 0.6, 0.5, 0.1)],
        [h(0, 0.5, 0.1, 0.6), h(0.6, 0.85, 0.1, 0.3)],
        ticks(6, every: 0.07, [0.8, 0.5], 0.3),
    ]

    // Chop, sizzle, boil, whisk, pour, kettle, toaster, microwave, blender, timer ding.
    static let kitchen: [[MotifStep]] = [
        ticks(5, every: 0.25, [0.9], 0.7),
        holds(10, each: 0.05, [0.4, 0.55], [0.95]),
        zip([0, 0.15, 0.22, 0.4, 0.47, 0.6, 0.75, 0.8], [Float(0.5), 0.8, 0.6, 0.9, 0.5, 0.7, 0.8, 0.6]).map { t($0, $1, 0.4) },
        holds(8, each: 0.07, [0.75, 0.45], [0.6]),
        holds(6, each: 0.12, [0.5, 0.6, 0.7, 0.75, 0.7, 0.6], [0.3]),
        holds(6, each: 0.12, [0.3, 0.4, 0.55, 0.7, 0.85, 1], [1]),
        [h(0, 0.3, 0.3, 0.3), t(0.35, 1, 0.9)],
        [h(0, 0.4, 0.2, 0.8), t(0.85, 0.9, 1), t(0.95, 0.9, 1), t(1.05, 0.9, 1)],
        holds(12, each: 0.05, [1, 0.7], [0.5]),
        [t(0, 1, 1), h(0.01, 0.5, 1, 0.3)],
    ]

    // Hammer, hand saw, screwdriver, wrench, power drill, sander, stapler, nail gun, tape measure, chisel.
    static let tools: [[MotifStep]] = [
        [t(0, 1, 0.5), t(0.3, 1, 0.5), t(0.6, 1, 0.5)],
        holds(6, each: 0.1, [0.85, 0.5], [0.75]),
        ticks(8, every: 0.08, [0.8, 0.5], 0.8),
        [t(0, 0.9, 0.6), h(0.02, 0.5, 0.4, 0.15), t(0.3, 0.9, 0.6), h(0.32, 0.5, 0.4, 0.15)],
        holds(6, each: 0.08, [0.6, 0.7, 0.8, 0.9, 1, 1], [0.9]),
        holds(10, each: 0.06, [0.8, 0.65], [0.35]),
        [t(0, 0.8, 1), t(0.03, 1, 0.6)],
        [t(0, 1, 0.8), h(0.01, 0.5, 0.4, 0.05), t(0.4, 1, 0.8), h(0.41, 0.5, 0.4, 0.05)],
        ticks(10, every: 0.03, [0.6, 0.8], 0.9),
        [t(0, 0.9, 0.9), t(0.15, 0.9, 0.9), t(0.3, 0.9, 0.9), h(0.32, 0.4, 0.8, 0.1)],
    ]

    // Launch, orbit, beacon, warp, docking, meteor, thruster, signal, comet, black hole.
    static let space: [[MotifStep]] = [
        holds(6, each: 0.15, [0.4, 0.55, 0.7, 0.85, 1, 1], [0.1]),
        holds(8, each: 0.12, [0.4, 0.7, 0.85, 0.7], [0.5]),
        [t(0, 0.9, 1), t(0.6, 0.9, 1)],
        holds(6, each: 0.06, [0.3, 0.5, 0.7, 0.85, 1, 0.6], [0.3, 0.4, 0.5, 0.6, 0.8, 1]),
        [t(0, 0.6, 0.6), t(0.3, 0.7, 0.6), t(0.5, 0.85, 0.7), t(0.6, 1, 0.8)],
        [h(0, 0.4, 0.6, 0.3), t(0.3, 1, 0.4), h(0.31, 0.7, 0.1, 0.2)],
        holds(4, each: 0.1, [0.9, 0.6], [0.2]),
        [t(0, 0.8, 1), t(0.15, 0.5, 1), t(0.3, 0.3, 1)],
        holds(5, each: 0.12, [1, 0.8, 0.6, 0.45, 0.3], [0.9]),
        holds(6, each: 0.15, [0.3, 0.4, 0.55, 0.7, 0.85, 1], [0.9, 0.7, 0.5, 0.3, 0.1, 0]),
    ]

    // Tide, sonar, bubbles, splash, current, buoy bell, undertow, sea spray, dolphin, ship horn.
    static let ocean: [[MotifStep]] = [
        holds(6, each: 0.2, [0.3, 0.5, 0.75, 0.75, 0.5, 0.3], [0.2]),
        [t(0, 0.9, 0.8), h(0.01, 0.3, 0.7, 0.3), t(0.8, 0.5, 0.8)],
        ticks(6, every: 0.09, [0.5, 0.8, 0.6, 0.9, 0.5, 0.7], 0.7),
        [t(0, 1, 0.6), h(0.01, 0.6, 0.4, 0.1)] + ticks(3, every: 0.06, from: 0.15, [0.5], 0.8),
        holds(8, each: 0.1, [0.55, 0.75], [0.3, 0.4]),
        [t(0, 0.9, 0.9), h(0.01, 0.3, 0.8, 0.25), t(0.9, 0.9, 0.9)],
        holds(5, each: 0.15, [0.85, 0.7, 0.55, 0.45, 0.35], [0]),
        ticks(10, every: 0.04, [0.3, 0.6, 0.9, 0.5, 0.4, 0.8, 0.3, 0.6, 0.5, 0.4], 1),
        [t(0, 0.8, 0.9), t(0.08, 0.9, 1), t(0.16, 0.8, 0.9)],
        [h(0, 0.9, 0.1, 0.6), h(0.8, 0.9, 0.1, 0.3)],
    ]

    // Traffic, crosswalk, elevator, turnstile, jackhammer, car horn, train doors, bus stop, parking, bells.
    static let city: [[MotifStep]] = [
        holds(6, each: 0.15, [0.6, 0.8], [0.3]),
        ticks(6, every: 0.2, [0.85], 0.9),
        [t(0, 0.9, 1), h(0.3, 0.4, 0.2, 0.6)],
        [t(0, 0.9, 0.5), t(0.08, 0.6, 0.7), t(0.16, 0.9, 0.5)],
        ticks(15, every: 0.04, [1, 0.7], 0.4),
        [h(0, 1, 0.5, 0.15), h(0.25, 1, 0.5, 0.35)],
        [h(0, 0.6, 0.6, 0.3), t(0.35, 1, 0.3)],
        [t(0, 0.8, 0.4), h(0.02, 0.5, 0.2, 0.4), t(0.5, 0.6, 0.4)],
        ticks(4, every: 0.25, [0.6, 0.7, 0.8, 1], 0.8),
        [t(0, 0.9, 0.6), t(0.4, 0.8, 0.6), t(0.8, 0.9, 0.6), t(1.2, 0.8, 0.6)],
    ]

    // Match, combo, line clear, block drop, rotate, swap, bonus, miss, hint, level clear.
    static let puzzle: [[MotifStep]] = [
        [t(0, 0.8, 0.9), t(0.06, 1, 1)],
        ticks(4, every: 0.07, [0.6, 0.7, 0.85, 1], 0.9),
        holds(4, each: 0.06, [0.5, 0.7, 0.85, 1], [1]) + [t(0.26, 1, 0.8)],
        [t(0, 1, 0.3), t(0.06, 0.4, 0.3)],
        [t(0, 0.75, 0.7), t(0.04, 0.75, 0.9)],
        [t(0, 0.8, 0.6), t(0.12, 0.8, 0.6)],
        [t(0, 0.7, 1), t(0.08, 0.8, 1), t(0.16, 0.9, 1), h(0.18, 0.6, 0.9, 0.25)],
        [t(0, 0.9, 0.2), h(0.02, 0.5, 0.1, 0.2)],
        [h(0, 0.4, 0.5, 0.15), h(0.3, 0.75, 0.6, 0.15)],
        ticks(5, every: 0.1, [0.6, 0.7, 0.8, 0.9, 1], 0.9) + [h(0.5, 0.9, 0.7, 0.4)],
    ]

    // Rock, funk, reggae, disco, hip hop, samba, tango, polka, techno, afrobeat.
    static let grooves: [[MotifStep]] = [
        groove("o...X...o.o.X..."),
        groove("o..xX.o.x.oxX..x"),
        groove("........o...X..."),
        groove("o.h.o.h.o.h.o.h."),
        groove("o.....o.X..o.X.."),
        groove("o.xxo.xxo.xxo.xx"),
        groove("X..x..x.X..x..x."),
        groove("o.X.o.X.o.X.o.X."),
        groove("ohxhohxhohxhohxh"),
        groove("o..x.xo..x..o.x."),
    ]

    // Mail, calendar, payment, download, upload, battery, note, sync, friend, news.
    static let notifications: [[MotifStep]] = [
        [t(0, 0.7, 0.8), t(0.12, 0.9, 0.9)],
        [h(0, 0.6, 0.6, 0.12), t(0.16, 0.9, 0.8)],
        // Cha-ching: two rising taps and a short ring.
        [t(0, 0.6, 1), t(0.04, 0.8, 1), h(0.08, 0.5, 0.9, 0.12)],
        holds(3, each: 0.06, [0.5, 0.75, 1], [0.5]),
        holds(3, each: 0.06, [1, 0.75, 0.5], [0.5]),
        [h(0, 0.85, 0.2, 0.2)],
        [t(0, 0.9, 0.6), t(0.05, 0.5, 0.9)],
        [t(0, 0.6, 0.7), t(0.1, 0.6, 0.7), t(0.2, 0.9, 0.9)],
        [t(0, 0.9, 0.5), h(0.02, 0.4, 0.4, 0.1)],
        [h(0, 0.5, 0.8, 0.08), h(0.12, 0.9, 0.8, 0.08)],
    ]

    // Tick-tock, hour chime, cuckoo, stopwatch, hourglass, pendulum, alarm clock, egg timer, grandfather clock, digital.
    static let clocks: [[MotifStep]] = [
        // A crisp tick, then a dull, held tock.
        [t(0, 0.8, 1), h(0.5, 0.6, 0.2, 0.08), t(1, 0.8, 1), h(1.5, 0.6, 0.2, 0.08)],
        [t(0, 1, 0.7), h(0.01, 0.5, 0.6, 0.3), t(0.5, 1, 0.7), h(0.51, 0.5, 0.6, 0.3)],
        [t(0, 0.9, 0.9), t(0.25, 0.7, 0.6), t(0.6, 0.9, 0.9), t(0.85, 0.7, 0.6)],
        [t(0, 1, 1), t(0.05, 0.6, 1)],
        ticks(12, every: 0.08, [0.35, 0.5, 0.65, 0.8], 0.7),
        holds(4, each: 0.25, [0.75, 0.35], [0.3]),
        ticks(8, every: 0.06, [1, 0.6], 0.9),
        ticks(10, every: 0.1, [0.6, 0.8], 0.6),
        [t(0, 1, 0.2), h(0.01, 0.7, 0.1, 0.5), t(0.6, 1, 0.2), h(0.61, 0.7, 0.1, 0.5)],
        [h(0, 0.9, 0.9, 0.05), h(0.1, 0.9, 0.9, 0.05), h(0.4, 0.9, 0.9, 0.05), h(0.5, 0.9, 0.9, 0.05)],
    ]

    // Earth, air, water, lightning, ice, lava, steam, sand, crystal, storm.
    static let elements: [[MotifStep]] = [
        holds(4, each: 0.15, [1, 0.7, 0.85, 0.6], [0]),
        holds(8, each: 0.1, [0.3, 0.5, 0.75, 0.5], [0.6]),
        ticks(6, every: 0.1, [0.5, 0.7, 0.9, 0.7, 0.5, 0.4], 0.4),
        [t(0, 1, 1), t(0.04, 0.8, 1), h(0.08, 0.6, 0.2, 0.3)],
        ticks(4, every: 0.05, [0.9, 0.7, 0.5, 0.3], 1),
        holds(6, each: 0.15, [0.6, 0.8], [0, 0.1]),
        holds(6, each: 0.08, [0.3, 0.5, 0.7, 0.9, 0.7, 0.5], [1]),
        ticks(14, every: 0.04, [0.3, 0.5, 0.4, 0.6, 0.75], 0.5),
        [t(0, 0.9, 1), t(0.1, 0.6, 1), t(0.25, 0.8, 1), t(0.45, 0.5, 1)],
        holds(8, each: 0.08, [0.9, 0.4, 0.8, 0.5, 1, 0.3, 0.7, 0.6], [0.3]),
    ]

    // Spell, portal, wand, charm, curse, heal, teleport, summon, hex, fizzle.
    static let magic: [[MotifStep]] = [
        ticks(5, every: 0.06, [0.5, 0.6, 0.7, 0.8, 1], 1) + [h(0.3, 0.5, 0.9, 0.2)],
        holds(6, each: 0.1, [0.3, 0.6, 0.9, 0.9, 0.6, 0.3], [0.8, 0.6, 0.4, 0.4, 0.6, 0.8]),
        [h(0, 0.4, 0.9, 0.15), t(0.17, 1, 1)],
        [t(0, 0.8, 0.9), t(0.15, 0.8, 0.9), t(0.3, 1, 1)],
        holds(4, each: 0.12, [0.9, 0.75, 0.6, 0.45], [0]),
        holds(5, each: 0.12, [0.3, 0.45, 0.6, 0.75, 0.85], [0.5]),
        [t(0, 1, 1), h(0.3, 0.5, 0.5, 0.1), t(0.42, 1, 1)],
        holds(6, each: 0.1, [0.4, 0.5, 0.6, 0.7, 0.85, 1], [0.2, 0.3, 0.4, 0.5, 0.6, 0.7]) + [t(0.62, 1, 0.9)],
        ticks(3, every: 0.2, [0.9], 0.3),
        [t(0, 0.8, 0.8)] + ticks(5, every: 0.04, from: 0.05, [0.5, 0.4, 0.3, 0.2, 0.1], 0.8),
    ]

    // Power on, power off, charging, vibrate, scanner, printer, modem, glitch, click, static.
    static let electronics: [[MotifStep]] = [
        holds(4, each: 0.06, [0.4, 0.6, 0.8, 1], [0.6]) + [t(0.25, 1, 1)],
        [t(0, 1, 1)] + holds(4, each: 0.06, from: 0.02, [1, 0.8, 0.6, 0.4], [0.6]),
        [h(0, 0.4, 0.3, 0.2), t(0.22, 0.9, 0.8), t(0.32, 0.9, 0.8)],
        [h(0, 1, 0.4, 0.25), h(0.4, 1, 0.4, 0.25)],
        holds(10, each: 0.05, [0.6, 0.9], [0.95]),
        ticks(10, every: 0.07, [0.8, 0.5], 0.5),
        holds(8, each: 0.06, [0.6, 0.85, 0.5, 0.9], [0.9, 0.3, 0.7, 0.5]),
        [t(0, 1, 1), t(0.03, 0.4, 0.2), t(0.09, 0.9, 0.8), t(0.11, 0.3, 0.1), t(0.2, 1, 0.9)],
        [t(0, 0.9, 0.95), t(0.02, 0.3, 0.5)],
        holds(16, each: 0.03, [0.4, 0.75, 0.5, 0.9], [1, 0.6]),
    ]

    // MARK: Morse

    /// Short words, so even the slowest stays under six seconds.
    static let morseWords = ["OK", "YES", "NO", "HI", "GO", "ON", "OFF", "UP", "WIN", "END"]

    static let morseCode: [Character: String] = [
        "D": "-..", "E": ".", "F": "..-.", "G": "--.", "H": "....", "I": "..", "K": "-.-", "N": "-.",
        "O": "---", "P": ".--.", "S": "...", "U": "..-", "W": ".--", "Y": "-.--",
    ]
}
