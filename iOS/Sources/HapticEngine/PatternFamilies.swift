//
// PatternFamilies.swift
// HapticEngine
//

import CoreHaptics
import Foundation

/// A family of generated patterns: ten variants, such as materials, meters or machines, each at several
/// levels, such as strengths, tempos or speeds.
///
/// The 1,900 patterns after the first hundred are these: the first ten families with nine levels each, then
/// twenty more with five, fewer and wider steps that are easier to tell apart. How each one feels is decided
/// here and in `MotifFamilies.swift`; its case, name and description are written by
/// `iOS/Scripts/GeneratePatterns.swift`, which also writes `HapticPattern.variant`. Changing a family's feel
/// needs no regenerating.
enum PatternFamily: Int, CaseIterable, Sendable {
    /// A hit on a material, from feather-light to crushing.
    case impacts
    /// Two to eleven taps, from a lazy pace to a rapid one.
    case tapCounts
    /// Attention signals, from calm to critical.
    case signals
    /// One bar of a meter, from 60 to 180 beats per minute.
    case meters
    /// A finger drawn across a surface, from a crawl to a rush.
    case surfaces
    /// Waveforms over a second and a half, from one cycle to five.
    case waves
    /// Changes in strength or sharpness, from 0.2 to 1.8 seconds long.
    case dynamics
    /// Weather and water, from faint to extreme.
    case weather
    /// Machines running, from idle to the redline.
    case machines
    /// Game actions, from tiny to epic.
    case arcade

    // Twenty more, each ten motifs at five levels: see `MotifFamilies.swift`.

    case animals, emotions, sports, instruments, vehicles, controls, body, kitchen, tools, space
    case ocean, city, puzzle, grooves, notifications, clocks, elements, magic, morse, electronics

    static let variantCount = 10

    /// How many levels each variant comes in: nine in the first ten families, five in the rest.
    var levelCount: Int { rawValue < PatternFamily.animals.rawValue ? 9 : 5 }
}

/// Where a generated pattern sits in its family.
struct PatternVariant: Hashable, Sendable {
    let family: PatternFamily
    /// Which of the family's ten, such as a material or a meter.
    let variant: Int
    /// Which of the family's steps, the lowest first, such as a strength or a tempo.
    let level: Int

    init(_ family: PatternFamily, _ variant: Int, _ level: Int) {
        self.family = family
        self.variant = variant
        self.level = level
    }
}

extension HapticPatterns {
    /// A generated pattern's events, in time order.
    static func events(for variant: PatternVariant) -> [CHHapticEvent] {
        // From 0 at the lowest level to 1 at the highest.
        let level = Float(variant.level) / Float(variant.family.levelCount - 1)
        let events = switch variant.family {
        case .impacts: impact(material: variant.variant, weight: level)
        case .tapCounts: tapCount(variant.variant + 2, pace: variant.level)
        case .signals: signal(variant.variant, urgency: variant.level)
        case .meters: meter(variant.variant, tempo: variant.level)
        case .surfaces: surface(variant.variant, speed: level)
        case .waves: wave(variant.variant, rate: variant.level)
        case .dynamics: dynamic(variant.variant, length: variant.level)
        case .weather: weather(variant.variant, strength: variant.level)
        case .machines: machine(variant.variant, speed: variant.level)
        case .arcade: arcade(variant.variant, power: level)
        default: motifEvents(for: variant)
        }
        // The families mix taps and holds; Core Haptics wants them in time order.
        return events.sorted { $0.relativeTime < $1.relativeTime }
    }

    // MARK: Impacts

    /// Wood, metal, glass, stone, rubber, plastic, paper, cloth, water, ceramic: the hit, then what the
    /// material does with it. Heavier hits are stronger and their tails longer.
    private static func impact(material: Int, weight: Float) -> [CHHapticEvent] {
        // From 0.3: below that a hit is hard to feel at all.
        let strength = 0.3 + 0.7 * weight
        let scale = 0.6 + 0.8 * Double(weight)
        return switch material {
        // A hollow knock and its echo.
        case 0: [tap(strength, 0.45), tap(strength * 0.35, 0.45, at: 0.04 * scale)]
        // Ringing on.
        case 1: [tap(strength, 0.95), hold(strength * 0.3, 0.9, at: 0.005, for: 0.25 * scale)]
        // A tinkle after.
        case 2: [tap(strength, 1), tap(strength * 0.3, 1, at: 0.05 * scale), tap(strength * 0.2, 1, at: 0.09 * scale)]
        // Dull and solid.
        case 3: [tap(strength, 0.3), hold(strength * 0.5, 0.1, at: 0.005, for: 0.03 * scale)]
        // Bouncing back three times.
        case 4: [tap(strength, 0.1)] + zip([0.08, 0.14, 0.18], [Float(0.5), 0.3, 0.15]).map { time, share in
            tap(strength * share, 0.1, at: time * scale)
        }
        // A click.
        case 5: [tap(strength, 0.7), tap(strength * 0.25, 0.7, at: 0.03 * scale)]
        // A rustle.
        case 6: [tap(strength, 0.55)]
            + segments(3, each: 0.02 * scale, from: 0.01, intensities: [strength * 0.3, strength * 0.2, strength * 0.1], sharpnesses: [0.6])
        // Muffled.
        case 7: [tap(strength, 0.05), hold(strength * 0.4, 0, at: 0.005, for: 0.06 * scale)]
        // A splash.
        case 8: [tap(strength, 0.2)] + ramp(from: strength * 0.6, to: strength * 0.1, sharpness: 0.2, at: 0.01, duration: 0.2 * scale, steps: 4)
        // A clink.
        default: [tap(strength, 0.85), tap(strength * 0.5, 0.85, at: 0.025 * scale)]
        }
    }

    // MARK: Tap counts

    /// `count` taps, the last a little stronger, from 300 ms apart down to 60.
    private static func tapCount(_ count: Int, pace: Int) -> [CHHapticEvent] {
        let interval = 0.3 - 0.03 * Double(pace)
        return times(count, every: interval).enumerated().map { index, time in
            tap(index == count - 1 ? 1 : 0.75, 0.6, at: time)
        }
    }

    // MARK: Signals

    /// Ping, chime, bell, beep, buzz, ding, pip, tone, siren, horn: one to five times, stronger and closer
    /// together as they grow more urgent.
    private static func signal(_ kind: Int, urgency: Int) -> [CHHapticEvent] {
        let strength = 0.45 + 0.55 * Float(urgency) / 8
        let unit: (TimeInterval) -> [CHHapticEvent]
        let length: TimeInterval
        switch kind {
        case 0: unit = { [tap(strength, 1, at: $0)] }; length = 0
        case 1: unit = { [tap(strength, 0.8, at: $0), hold(strength * 0.4, 0.7, at: $0 + 0.01, for: 0.15)] }; length = 0.16
        case 2:
            unit = { [tap(strength, 0.6, at: $0)] + ramp(from: strength * 0.6, to: strength * 0.15, sharpness: 0.5, at: $0 + 0.01, duration: 0.3, steps: 3) }
            length = 0.31
        case 3: unit = { [hold(strength, 0.7, at: $0, for: 0.12)] }; length = 0.12
        case 4: unit = { [hold(strength, 0.2, at: $0, for: 0.2)] }; length = 0.2
        case 5: unit = { [tap(strength * 0.7, 0.8, at: $0), tap(strength, 1, at: $0 + 0.08)] }; length = 0.08
        case 6: unit = { [tap(strength, 0.9, at: $0), tap(strength, 0.9, at: $0 + 0.05)] }; length = 0.05
        case 7: unit = { [hold(strength * 0.8, 0.5, at: $0, for: 0.3)] }; length = 0.3
        case 8: unit = { segments(4, each: 0.06, from: $0, intensities: [strength], sharpnesses: [0.3, 0.8]) }; length = 0.24
        default: unit = { [hold(strength, 0.3, at: $0, for: 0.12), hold(strength, 0.3, at: $0 + 0.18, for: 0.12)] }; length = 0.3
        }
        let repeats = 1 + urgency / 2
        // Closer together as urgency grows, but never overlapping.
        let gap = max(length + 0.08, 0.5 - 0.04 * Double(urgency))
        return (0..<repeats).flatMap { unit(Double($0) * gap) }
    }

    // MARK: Meters

    /// One bar of march, waltz, four-four, five-four, jig, seven-eight, swing, shuffle, clave or bossa nova,
    /// at 60 to 180 beats per minute, the downbeat strongest.
    private static func meter(_ kind: Int, tempo: Int) -> [CHHapticEvent] {
        let beat = 60 / Double(60 + 15 * tempo)
        let swung: [Double] = [0, 2.0 / 3, 1, 5.0 / 3, 2, 8.0 / 3, 3, 11.0 / 3]
        let (positions, accents, sharpness): ([Double], [Float], Float) = switch kind {
        case 0: ([0, 1], [1, 0.5], 0.6)
        case 1: ([0, 1, 2], [1, 0.5, 0.5], 0.6)
        case 2: ([0, 1, 2, 3], [1, 0.5, 0.75, 0.5], 0.6)
        case 3: ([0, 1, 2, 3, 4], [1, 0.5, 0.5, 0.75, 0.5], 0.6)
        case 4: ([0, 0.5, 1, 1.5, 2, 2.5], [1, 0.4, 0.4, 0.8, 0.4, 0.4], 0.6)
        case 5: ((0..<7).map { Double($0) * 0.5 }, [1, 0.4, 0.8, 0.4, 0.8, 0.4, 0.4], 0.6)
        case 6: (swung, [1, 0.35, 0.6, 0.35, 0.8, 0.35, 0.6, 0.35], 0.6)
        case 7: (swung, [1, 0.55, 0.6, 0.55, 0.8, 0.55, 0.6, 0.55], 0.3)
        case 8: ([0, 3, 6, 10, 12].map { $0 / 4 }, [0.9, 0.9, 0.9, 0.9, 0.9], 0.9)
        default: ([0, 3, 6, 10, 13].map { $0 / 4 }, [0.9, 0.6, 0.7, 0.6, 0.7], 0.5)
        }
        return zip(positions, accents).map { position, accent in
            // Accents are a little sharper, so the downbeat stands out by feel as well as strength.
            tap(accent, accent >= 0.8 ? min(sharpness + 0.2, 1) : sharpness, at: position * beat)
        }
    }

    // MARK: Surfaces

    /// Sand, gravel, silk, velvet, corduroy, brick, tile, ice, bark, carpet: the surface's hum, with its
    /// grain coming faster as the finger speeds up. 0.8 seconds long.
    private static func surface(_ kind: Int, speed: Float) -> [CHHapticEvent] {
        let (base, baseSharpness, spacing, grain, grainSharpness): (Float, Float, TimeInterval, Float, Float) = switch kind {
        case 0: (0.3, 0.6, 0.03, 0.3, 0.7)
        case 1: (0.4, 0.3, 0.07, 0.7, 0.4)
        case 2: (0.15, 0.9, 0.2, 0.15, 0.9)
        case 3: (0.25, 0.1, 0.15, 0.2, 0.1)
        case 4: (0.2, 0.4, 0.05, 0.6, 0.5)
        case 5: (0.35, 0.25, 0.12, 0.8, 0.3)
        case 6: (0.2, 0.5, 0.1, 0.9, 0.8)
        case 7: (0.1, 1, 0.25, 0.4, 1)
        case 8: (0.45, 0.2, 0.06, 0.6, 0.2)
        default: (0.3, 0.05, 0.04, 0.25, 0.1)
        }
        let length: TimeInterval = 0.8
        let every = spacing / (0.5 + 1.5 * Double(speed))
        let grains = (0..<Int(length / every)).map { index in
            // From 0.3, so even silk's grain is felt; the hum beneath may be fainter.
            tap(0.3 + 0.7 * grain * (0.8 + 0.2 * speed), grainSharpness, at: Double(index) * every)
        }
        return [hold(base * (0.8 + 0.4 * speed), baseSharpness, for: length)] + grains
    }

    // MARK: Waves

    /// Swell, rise, fall, square, triangle, flutter, throb, breath, ripple, wobble: thirty 50 ms steps
    /// tracing the shape one to five times over a second and a half.
    private static func wave(_ shape: Int, rate: Int) -> [CHHapticEvent] {
        let cycles = 1 + 0.5 * Double(rate)
        let steps = 30
        let each: TimeInterval = 0.05
        return (0..<steps).map { step in
            let position = (Double(step) + 0.5) / Double(steps)
            let phase = (position * cycles).truncatingRemainder(dividingBy: 1)
            let smooth = Float(pow(sin(phase * .pi), 2))
            let (value, sharpness): (Float, Float) = switch shape {
            case 0: (smooth, 0.4)
            case 1: (Float(phase), 0.5)
            case 2: (Float(1 - phase), 0.5)
            case 3: (phase < 0.5 ? 1 : 0, 0.6)
            case 4: (Float(1 - abs(2 * phase - 1)), 0.5)
            case 5: (smooth, step.isMultiple(of: 2) ? 0.3 : 0.9)
            case 6: (pow(smooth, 4), 0.2)
            case 7: (0.6 * smooth, 0.1)
            case 8: (smooth * Float(1 - position), 0.7)
            // The strength holds; the sharpness wavers.
            default: (0.53, smooth)
            }
            return hold(0.15 + 0.85 * value, sharpness, at: Double(step) * each, for: each)
        }
    }

    // MARK: Dynamics

    /// Crescendo, decrescendo, surge, ebb, climb, plunge, bloom, wilt, spike, plateau: ten steps over 0.2
    /// to 1.8 seconds.
    private static func dynamic(_ shape: Int, length level: Int) -> [CHHapticEvent] {
        let steps = 10
        let each = 0.02 * Double(level + 1)
        return (0..<steps).map { step in
            let x = (Float(step) + 0.5) / Float(steps)
            let time = Double(step) * each
            let curve: Float
            switch shape {
            case 0: curve = x
            case 1: curve = 1 - x
            case 2: curve = x < 0.3 ? x / 0.3 : 1 - (x - 0.3) / 0.7 * 0.8
            case 3: curve = x < 0.7 ? 1 - x / 0.7 * 0.8 : 0.2 + (x - 0.7) / 0.3 * 0.3
            // Taps, not holds: a staircase you feel each step of. The last lands at the end, so the pattern
            // lasts its full length, as the holds do.
            case 4: return tap(0.1 + 0.9 * x, 0.6, at: Double(step) * each * 10 / 9)
            case 5: return tap(0.1 + 0.9 * (1 - x), 0.6, at: Double(step) * each * 10 / 9)
            // The strength holds; the sharpness changes.
            case 6: return hold(0.7, x, at: time, for: each)
            case 7: return hold(0.9 - 0.6 * x, 1 - x, at: time, for: each)
            case 8: curve = x < 0.1 ? 1 : 0.15
            default: curve = x < 0.25 ? x / 0.25 : x > 0.75 ? (1 - x) / 0.25 : 1
            }
            return hold(0.1 + 0.9 * curve, shape == 8 ? 0.8 : 0.5, at: time, for: each)
        }
    }

    // MARK: Weather

    /// The closest two drops fall: taps closer than about 10 ms are felt as one.
    static let minimumGap: TimeInterval = 0.015

    /// Drizzle, rain, hail, wind, thunder, surf, stream, tremor, fire, sleet: 1.2 seconds, stronger and
    /// busier as it builds. Drops fall at the same scattered times on every play.
    private static func weather(_ kind: Int, strength level: Int) -> [CHHapticEvent] {
        let strength = Float(level) / 8
        let length: TimeInterval = 1.2
        var scatter = Scatter(seed: UInt64(kind * 100 + level + 1))
        /// `count` drops, each with a share of its full strength. Each falls somewhere in its own slot of
        /// the pattern, so none land closer than `minimumGap`: taps that close are felt as one. The first
        /// starts the pattern at full strength, so every one is felt from the start.
        func drops(_ count: Int) -> [(time: TimeInterval, share: Float)] {
            let slot = length / Double(count)
            return (0..<count).map { index in
                guard index > 0 else { return (0, 1) }
                let time = Double(index) * slot + scatter.next() * max(slot - minimumGap, 0)
                return (time, Float(scatter.next()))
            }
        }
        switch kind {
        case 0:
            return drops(4 + 2 * level).map { tap((0.3 + 0.25 * strength) * (0.7 + 0.3 * $0.share), 0.7, at: $0.time) }
        case 1:
            return drops(8 + 4 * level).map { tap((0.3 + 0.5 * strength) * (0.6 + 0.4 * $0.share), 0.5, at: $0.time) }
        case 2:
            return drops(5 + 3 * level).map { tap((0.6 + 0.4 * strength) * (0.8 + 0.2 * $0.share), 1, at: $0.time) }
        case 3:
            let gusts = (0..<12).map { index in 0.2 + (index == 0 ? 1 : Float(scatter.next())) * (0.1 + 0.6 * strength) }
            return segments(12, each: 0.1, intensities: gusts, sharpnesses: [0.2])
        case 4:
            let rumble = 0.3 + 0.3 * Double(strength)
            return [tap(0.5 + 0.5 * strength, 1), hold(0.4 + 0.6 * strength, 0.05, at: 0.03, for: rumble)]
                + ramp(from: 0.3 + 0.5 * strength, to: 0.1, sharpness: 0.05, at: 0.03 + rumble, duration: 0.5, steps: 5)
        case 5:
            let peak = 0.3 + 0.7 * strength
            return [0, 0.6].flatMap { start in
                ramp(from: 0.1, to: peak, sharpness: 0.3, at: start, duration: 0.3, steps: 3)
                    + ramp(from: peak, to: 0.1, sharpness: 0.3, at: start + 0.3, duration: 0.3, steps: 3)
            }
        case 6:
            return [hold(0.15 + 0.3 * strength, 0.5, for: length)]
                + drops(6 + 2 * level).map { tap(0.2 + 0.2 * $0.share, 0.6, at: $0.time) }
        case 7:
            let shakes = (0..<24).map { $0.isMultiple(of: 2) ? Float(0.2) : (0.4 + 0.6 * strength) * (0.8 + 0.2 * Float(scatter.next())) }
            return segments(24, each: 0.05, intensities: shakes, sharpnesses: [0.1])
        case 8:
            return [hold(0.15 + 0.2 * strength, 0.1, for: length)]
                + drops(6 + 3 * level).map { tap(0.3 + (0.2 + 0.5 * strength) * $0.share, 0.9, at: $0.time) }
        default:
            return [hold(0.1 + 0.2 * strength, 0.8, for: length)]
                + drops(6 + 4 * level).map { tap((0.3 + 0.4 * strength) * (0.7 + 0.3 * $0.share), 0.4, at: $0.time) }
        }
    }

    // MARK: Machines

    /// Motor, engine, fan, drill, pump, saw, gearbox, ratchet, clockwork, sewing machine: a second of it
    /// running, its cycle from 200 ms at idle down to 56 ms at the redline.
    private static func machine(_ kind: Int, speed level: Int) -> [CHHapticEvent] {
        let speed = Float(level) / 8
        let length: TimeInterval = 1
        let period = 0.2 - 0.018 * Double(level)
        let cycles = times(Int(length / period), every: period)
        switch kind {
        case 0:
            return segments(cycles.count * 2, each: period / 2, intensities: [0.4 + 0.4 * speed, 0.25 + 0.3 * speed], sharpnesses: [0.3])
        case 1:
            return [hold(0.2 + 0.3 * speed, 0.1, for: length)] + taps(at: cycles, intensities: [0.5 + 0.4 * speed], sharpness: 0.2)
        case 2:
            return segments(cycles.count, each: period, intensities: [0.5 + 0.3 * speed, 0.2], sharpnesses: [0.5])
        case 3:
            return [hold(0.6 + 0.4 * speed, 0.9, for: length)] + taps(at: cycles, intensities: [0.3], sharpness: 1)
        case 4:
            return cycles.flatMap { [hold(0.5 + 0.4 * speed, 0.3, at: $0, for: period * 0.6), tap(0.7, 0.5, at: $0 + period * 0.6)] }
        case 5:
            return cycles.map { hold(0.7 + 0.3 * speed, 0.7, at: $0, for: period * 0.5) }
        case 6:
            return times(cycles.count * 2, every: period / 2).enumerated().map { index, time in
                index.isMultiple(of: 2) ? tap(0.7, 0.6, at: time) : tap(0.4, 0.9, at: time)
            }
        case 7:
            return cycles.enumerated().map { index, time in tap(index.isMultiple(of: 4) ? 1 : 0.6 + 0.3 * speed, 1, at: time) }
        case 8:
            return times(Int(length / (period * 1.5)), every: period * 1.5).enumerated().map { index, time in
                tap(0.5 + 0.3 * speed, index.isMultiple(of: 2) ? 0.9 : 0.6, at: time)
            }
        default:
            return cycles.flatMap { [tap(0.6 + 0.3 * speed, 0.8, at: $0), tap(0.4, 0.6, at: $0 + period / 3)] }
        }
    }

    // MARK: Arcade

    /// Jump, landing, hit, dash, shot, charge, pickup, level up, damage, shield: stronger and longer with
    /// more power.
    private static func arcade(_ kind: Int, power: Float) -> [CHHapticEvent] {
        let extra = Double(power)
        switch kind {
        case 0: return ramp(from: 0.2, to: 0.4 + 0.6 * power, sharpness: 0.6, duration: 0.08 + 0.12 * extra, steps: 3)
        case 1: return [tap(0.4 + 0.6 * power, 0.2), hold(0.3 + 0.4 * power, 0.1, at: 0.02, for: 0.05 + 0.15 * extra)]
        case 2: return [tap(0.5 + 0.5 * power, 0.6), tap(0.2 + 0.3 * power, 0.4, at: 0.05)]
        case 3: return segments(4, each: 0.03 + 0.03 * extra, intensities: [0.3 + 0.6 * power, 0.2 + 0.5 * power], sharpnesses: [0.8])
        case 4: return [tap(0.6 + 0.4 * power, 1), hold(0.3 + 0.3 * power, 0.7, at: 0.01, for: 0.03 + 0.07 * extra)]
        case 5: return ramp(from: 0.1, to: 0.4 + 0.6 * power, sharpness: 0.7, duration: 0.3 + 0.5 * extra, steps: 6)
        case 6:
            let count = 2 + Int((power * 8).rounded()) / 3
            return taps(at: times(count, every: 0.06), intensities: levels(from: 0.4, to: 0.5 + 0.5 * power, count: count), sharpness: 0.9)
        case 7:
            let count = 3 + Int((power * 8).rounded()) / 2
            return taps(at: times(count, every: 0.08), intensities: levels(from: 0.4, to: 0.6 + 0.4 * power, count: count), sharpness: 0.8)
                + [hold(0.6 + 0.4 * power, 0.7, at: Double(count) * 0.08, for: 0.1 + 0.2 * extra)]
        case 8:
            return [tap(0.7 + 0.3 * power, 0.4)]
                + segments(3, each: 0.04, from: 0.03, intensities: [0.6 + 0.4 * power, 0.3], sharpnesses: [0.3])
        default:
            let shield = 0.2 + 0.3 * extra
            return [tap(0.5 + 0.5 * power, 0.9), hold(0.3 + 0.3 * power, 0.6, at: 0.01, for: shield), tap(0.5 + 0.5 * power, 0.9, at: 0.01 + shield)]
        }
    }
}

/// Repeatable scattered numbers from 0 up to 1, so a generated pattern plays the same every time.
private struct Scatter {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> Double {
        // A 64-bit linear congruential generator, with Knuth's MMIX constants.
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return Double(state >> 11) / Double(1 << 53)
    }
}
