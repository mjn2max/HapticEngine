//
// BuiltInMotifs.swift
// HapticEngine
//

import Foundation

/// The motifs of the twenty sets shown with the hand-built groups, ten each, in the order the generator
/// names them. Shaped through five levels like the other motif families: see `MotifFamilies.swift`.
extension MotifLibrary {
    // MARK: Feedback

    // Button, card tap, icon tap, chip, tab, badge, checkbox, radio, link, menu item.
    static let feedbackTaps: [[MotifStep]] = [
        [t(0, 0.9, 0.7), t(0.07, 0.35, 0.5)],
        [t(0, 0.8, 0.75), t(0.05, 0.4, 0.4)],
        [t(0, 0.85, 1), t(0.03, 0.3, 1)],
        [t(0, 0.75, 0.9), t(0.05, 0.75, 0.6)],
        [t(0, 0.6, 0.6), t(0.04, 0.95, 0.8)],
        [t(0, 0.9, 0.9), t(0.1, 0.5, 0.9), t(0.2, 0.3, 0.9)],
        [t(0, 0.6, 0.5), t(0.06, 0.9, 0.9), t(0.1, 0.4, 0.6)],
        [h(0, 0.5, 0.7, 0.03), t(0.04, 0.9, 0.8)],
        [t(0, 0.8, 0.55), h(0.015, 0.3, 0.5, 0.04)],
        [t(0, 0.85, 0.35), t(0.025, 0.55, 0.75)],
    ]

    // Flip, latch, dial click, lever, knob, rocker, push button, slide lock, thumb switch, detent.
    static let feedbackToggles: [[MotifStep]] = [
        [t(0, 1, 0.9), t(0.04, 0.5, 0.5)],
        [t(0, 0.7, 0.8), h(0.02, 0.6, 0.3, 0.06), t(0.1, 1, 0.6)],
        ticks(3, every: 0.04, [0.7, 0.85, 1], 0.9),
        holds(3, each: 0.05, [0.4, 0.6, 0.8], [0.3]) + [t(0.16, 1, 0.5)],
        ticks(6, every: 0.07, [0.7], 0.75),
        [t(0, 0.9, 0.4), t(0.15, 0.9, 0.8)],
        [h(0, 0.6, 0.3, 0.04), t(0.05, 1, 0.7), h(0.06, 0.4, 0.3, 0.04)],
        holds(4, each: 0.05, [0.5, 0.6, 0.7, 0.8], [0.6]) + [t(0.22, 1, 1)],
        [t(0, 1, 0.2), t(0.08, 0.6, 0.9)],
        [t(0, 1, 0.5), t(0.12, 0.6, 0.5)],
    ]

    // Fling, pinch, spread, drag, long hold, flick, pan, edge swipe, twist, double press.
    static let feedbackGestures: [[MotifStep]] = [
        holds(5, each: 0.04, [0.3, 0.5, 0.7, 0.9, 0.6], [0.7]),
        [t(0, 0.6, 0.6), t(0.08, 0.8, 0.7), t(0.16, 1, 0.9)],
        [t(0, 1, 0.9), t(0.08, 0.8, 0.7), t(0.16, 0.6, 0.6)],
        ticks(6, every: 0.06, [0.5], 0.4) + [t(0.4, 0.9, 0.6)],
        holds(4, each: 0.1, [0.3, 0.45, 0.6, 0.75], [0.3]) + [t(0.42, 1, 0.9)],
        [h(0, 0.6, 0.8, 0.05), t(0.06, 0.9, 1)],
        holds(6, each: 0.08, [0.5, 0.55, 0.6, 0.6, 0.55, 0.5], [0.4]),
        [t(0, 0.8, 1)] + holds(3, each: 0.05, from: 0.02, [0.6, 0.4, 0.25], [0.6]),
        ticks(4, every: 0.05, [0.6, 0.8], 0, sharpnesses: [0.5, 0.9]),
        [t(0, 0.9, 0.6), t(0.15, 0.9, 0.6), h(0.16, 0.4, 0.4, 0.05)],
    ]

    // Save, send, copy, delete, undo, add, remove, upload, like, share.
    static let feedbackResults: [[MotifStep]] = [
        [t(0, 0.6, 0.6), t(0.1, 0.9, 0.9)],
        [t(0, 0.5, 1), h(0.03, 0.7, 0.8, 0.1)],
        [t(0, 0.8, 1), t(0.04, 0.8, 1)],
        [t(0, 0.9, 0.4), h(0.02, 0.5, 0.2, 0.1)],
        [t(0, 0.9, 0.8), t(0.06, 0.5, 0.6)],
        [h(0, 0.4, 0.6, 0.06), t(0.08, 1, 0.9)],
        [t(0, 1, 0.9), t(0.05, 0.6, 0.4), t(0.1, 0.3, 0.2)],
        holds(3, each: 0.05, [0.6, 0.8, 1], [0.5, 0.7, 0.9]),
        [t(0, 0.8, 0.3), t(0.12, 0.8, 0.3)],
        [t(0, 0.7, 0.9), t(0.06, 0.85, 0.9), t(0.12, 1, 0.9)],
    ]

    // MARK: Alerts

    // Door chime, wind chime, tone pair, arpeggio, low bell, harmonic, glass chime, twin bell, soft gong, bright tone.
    static let alertsChimes: [[MotifStep]] = [
        [t(0, 1, 0.8), h(0.01, 0.4, 0.7, 0.2), t(0.35, 0.8, 0.5), h(0.36, 0.35, 0.4, 0.25)],
        ticks(5, every: 0.07, [0.5, 0.8, 0.6, 0.9, 0.7], 1),
        [h(0, 0.7, 0.6, 0.12), h(0.18, 0.9, 0.9, 0.12)],
        ticks(4, every: 0.09, [0.7, 0.8, 0.9, 1], 0, sharpnesses: [0.4, 0.6, 0.8, 1]),
        [t(0, 1, 0.1), h(0.01, 0.6, 0.05, 0.4)],
        [h(0, 0.8, 0.5, 0.3), t(0.32, 0.6, 0.9)],
        [t(0, 0.9, 1), t(0.05, 0.5, 1), t(0.15, 0.7, 1)],
        [t(0, 0.9, 0.7), h(0.01, 0.3, 0.6, 0.15), t(0.2, 0.9, 0.7), h(0.21, 0.3, 0.6, 0.15)],
        [h(0, 0.5, 0.1, 0.15), h(0.15, 0.8, 0.1, 0.3)],
        [h(0, 0.9, 1, 0.18)],
    ]

    // Ringtone, intercom, pager, walkie-talkie, buzzer, hotline, telegraph, hold music, busy signal, voicemail.
    static let alertsCalls: [[MotifStep]] = [
        holds(8, each: 0.05, [1, 0.4], [0.7]) + holds(8, each: 0.05, from: 0.7, [1, 0.4], [0.7]),
        [h(0, 0.8, 0.4, 0.15), h(0.25, 0.8, 0.4, 0.15)],
        ticks(3, every: 0.1, [1], 0.9) + ticks(3, every: 0.1, from: 0.6, [1], 0.9),
        [t(0, 1, 0.5), h(0.02, 0.3, 0.95, 0.4)],
        [h(0, 1, 0.1, 0.5)],
        ticks(4, every: 0.15, [0.9, 0.5], 0.7),
        [0, 0.08, 0.32, 0.4, 0.48].map { t($0, 1, 0.6) },
        ticks(6, every: 0.2, [0.6, 0.7, 0.8, 0.7, 0.6, 0.75], 0.5),
        [h(0, 0.85, 0.5, 0.25), h(0.5, 0.85, 0.5, 0.25), h(1.0, 0.85, 0.5, 0.25)],
        [t(0, 0.7, 0.8), h(0.3, 0.5, 0.4, 0.3), t(0.7, 0.9, 0.8)],
    ]

    // Caution, hazard, overheat, low signal, storage full, timeout, blocked, denied, error tone, critical alert.
    static let alertsWarnings: [[MotifStep]] = [
        [t(0, 1, 0.7), t(0.25, 1, 0.7)],
        holds(6, each: 0.08, [1, 0.3], [0.6]),
        holds(5, each: 0.1, [0.5, 0.6, 0.7, 0.85, 1], [0.1]),
        ticks(3, every: 0.2, [0.9, 0.6, 0.3], 0.8),
        [h(0, 0.8, 0.5, 0.15), h(0.2, 0.8, 0.5, 0.15), t(0.4, 1, 0.8)],
        [t(0, 0.9, 0.4), t(0.4, 0.6, 0.4)],
        [t(0, 1, 0.2), t(0.1, 1, 0.2), h(0.11, 0.6, 0.1, 0.08)],
        [t(0, 1, 0.9), t(0.08, 1, 0.9), t(0.16, 0.5, 0.4)],
        [h(0, 0.9, 0.3, 0.1), h(0.15, 0.9, 0.3, 0.1), h(0.3, 0.9, 0.3, 0.2)],
        ticks(10, every: 0.05, [1, 0.5], 0.95),
    ]

    // MARK: Rhythm

    // Backbeat, offbeat, half time, double time, triplet, syncopated, cross beat, breakbeat, paradiddle, flam.
    static let rhythmBeats: [[MotifStep]] = [
        groove("o...X...o...X..."),
        groove(".x.x.x.x.x.x.x.x"),
        groove("o.......X......."),
        groove("oxXxoxXxoxXxoxXx"),
        ticks(12, every: 1.0 / 6, [1, 0.5, 0.5], 0.6),
        groove("o..x..x...x.o..."),
        groove("o..o..o..o..o.o."),
        groove("o.X..oo.X.o.o.X."),
        ticks(8, every: 0.125, [0.9, 0.6, 0.9, 0.9, 0.6, 0.9, 0.6, 0.6], 0.7, sharpnesses: [0.9, 0.5, 0.9, 0.9, 0.5, 0.9, 0.5, 0.5]),
        [0, 0.5, 1, 1.5].flatMap { [t($0, 0.5, 0.7), t($0 + 0.03, 1, 0.8)] },
    ]

    // Thump, pound, patter, bump, thud, strike, rap, tap pair, drumbeat, heave.
    static let rhythmPulses: [[MotifStep]] = [
        [t(0, 1, 0.2), h(0.01, 0.5, 0.1, 0.08)],
        holds(2, each: 0.08, [1, 0.6], [0.3]),
        ticks(4, every: 0.04, [0.6, 0.7, 0.6, 0.8], 0.6),
        [h(0, 0.5, 0.4, 0.06), t(0.07, 0.9, 0.5)],
        [t(0, 1, 0), t(0.04, 0.4, 0)],
        [t(0, 1, 1), h(0.01, 0.5, 0.5, 0.06)],
        ticks(3, every: 0.06, [0.9], 0.8),
        [t(0, 0.8, 0.6), t(0.1, 0.8, 0.6)],
        [t(0, 1, 0.4), t(0.12, 0.6, 0.4)],
        holds(3, each: 0.12, [0.4, 0.8, 0.5], [0.2]),
    ]

    // Walking, running, marching feet, tiptoe, skipping, stomping, tap dance, jogging, climbing stairs, shuffling feet.
    static let rhythmFootwork: [[MotifStep]] = [
        ticks(4, every: 0.5, [0.8, 0.7], 0.3),
        ticks(8, every: 0.2, [0.9, 0.8], 0.4),
        ticks(4, every: 0.35, [1, 0.6], 0.6),
        ticks(6, every: 0.18, [0.45], 0.9),
        [0, 0.4, 0.8].flatMap { [t($0, 0.8, 0.4), t($0 + 0.12, 0.6, 0.4)] },
        [0, 0.45, 0.9].flatMap { [t($0, 1, 0), h($0 + 0.01, 0.6, 0, 0.08)] },
        ticks(10, every: 0.09, [0.9, 0.5, 0.7, 0.5], 0.95),
        ticks(6, every: 0.3, [0.8, 0.75], 0.4),
        ticks(5, every: 0.35, [0.5, 0.6, 0.7, 0.8, 0.9], 0.5),
        holds(6, each: 0.12, [0.5, 0.3], [0.4]),
    ]

    // MARK: Texture

    // Grit, pebbles, salt, gravel path, crumbs, Velcro, bubble wrap, corrugated, beads, sawdust.
    static let textureGrains: [[MotifStep]] = [
        [h(0, 0.3, 0.9, 0.6)] + ticks(15, every: 0.04, [0.6, 0.8], 0.8),
        ticks(8, every: 0.08, [0.9, 0.6, 0.8, 0.5], 0.5),
        ticks(20, every: 0.025, [0.4, 0.6, 0.5, 0.75], 0.95),
        [h(0, 0.4, 0.2, 0.8)] + ticks(10, every: 0.08, [0.9, 0.6], 0.3),
        ticks(12, every: 0.05, [0.3, 0.5, 0.75, 0.4], 0.8),
        holds(12, each: 0.04, [0.9, 0.3], [0.8]),
        ticks(6, every: 0.12, [1], 0.9),
        holds(8, each: 0.06, [0.8, 0.2], [0.4]),
        ticks(8, every: 0.06, [0.8, 0.75, 0.7, 0.65, 0.6, 0.55, 0.5, 0.45], 1),
        [h(0, 0.35, 0.5, 0.7)] + ticks(7, every: 0.1, [0.75], 0.6),
    ]

    // Drone, whirr, murmur, vibration, resonance, thrum, fizz, crackle, hiss, warble.
    static let textureHums: [[MotifStep]] = [
        [h(0, 0.75, 0.2, 1.0)],
        holds(10, each: 0.06, [0.7, 0.6], [0.6]),
        holds(6, each: 0.15, [0.4, 0.55, 0.45, 0.6, 0.5, 0.7], [0.1]),
        holds(16, each: 0.03, [0.8, 0.4], [0.5]),
        [h(0, 0.9, 0.4, 0.2), h(0.2, 0.6, 0.4, 0.3), h(0.5, 0.4, 0.4, 0.4)],
        holds(8, each: 0.08, [0.9, 0.5], [0.1]),
        ticks(14, every: 0.035, [0.4, 0.75], 1),
        ticks(9, every: 0.07, [0.8, 0.4, 0.9, 0.3], 0.9),
        [h(0, 0.7, 1, 0.6)],
        holds(10, each: 0.06, [0.7], [0.2, 0.8]),
    ]

    // Crest, undulation, glide, billow, flare, fade in, fade away, breathing, tremolo, lull.
    static let textureSwells: [[MotifStep]] = [
        holds(6, each: 0.1, [0.3, 0.5, 0.8, 1, 0.6, 0.3], [0.4]),
        holds(10, each: 0.08, [0.4, 0.7, 0.9, 0.7, 0.4], [0.3]),
        holds(8, each: 0.1, [0.6], [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8]),
        holds(4, each: 0.2, [0.5, 0.85, 0.6, 0.75], [0.1]),
        [t(0, 1, 1)] + holds(4, each: 0.08, from: 0.02, [0.8, 0.6, 0.4, 0.3], [0.8]),
        holds(6, each: 0.1, [0.15, 0.3, 0.45, 0.6, 0.75, 0.9], [0.5]),
        holds(6, each: 0.1, [0.9, 0.75, 0.6, 0.45, 0.3, 0.15], [0.5]),
        holds(8, each: 0.15, [0.3, 0.6, 0.85, 0.6], [0.5]),
        holds(20, each: 0.04, [0.75, 0.45], [0.6]),
        holds(5, each: 0.2, [0.6, 0.4, 0.3, 0.4, 0.6], [0.2]),
    ]

    // MARK: Nature

    // Frog, owl, hummingbird, squirrel, snake rattle, lion roar, elephant, mosquito, firefly, bat wings.
    static let natureCreatures: [[MotifStep]] = [
        [t(0, 0.9, 0.3), t(0.08, 0.6, 0.3), t(0.6, 0.9, 0.3), t(0.68, 0.6, 0.3)],
        [h(0, 0.6, 0.1, 0.2), h(0.3, 0.85, 0.1, 0.3)],
        holds(20, each: 0.03, [0.5, 0.75], [0.9]),
        ticks(6, every: 0.06, [0.8, 0.6], 0.9) + ticks(6, every: 0.06, from: 0.6, [0.8, 0.6], 0.9),
        holds(15, each: 0.04, [0.8, 0.3], [1]),
        holds(6, each: 0.12, [0.6, 0.8, 1, 1, 0.8, 0.5], [0.05]),
        [h(0, 1, 0, 0.4), t(0.45, 0.8, 0.2)],
        holds(10, each: 0.06, [0.75, 0.45], [1]),
        ticks(4, every: 0.25, [0.75], 1),
        holds(6, each: 0.05, [0.8, 0.3], [0.6]),
    ]

    // Drip, puddle, waterfall, brook, fountain, geyser, lake lap, icicle, hot spring, river rapids.
    static let natureWater: [[MotifStep]] = [
        ticks(3, every: 0.4, [0.85], 0.8),
        [t(0, 1, 0.5), h(0.01, 0.4, 0.3, 0.15)],
        holds(10, each: 0.08, [0.8, 0.9], [0.2]),
        ticks(10, every: 0.07, [0.4, 0.6, 0.5, 0.75], 0.6),
        holds(5, each: 0.08, [0.4, 0.6, 0.8, 1, 0.7], [0.7]),
        holds(4, each: 0.06, [0.3, 0.4, 0.5, 0.6], [0.2]) + [h(0.25, 1, 0.5, 0.3)],
        [h(0, 0.5, 0.2, 0.15), h(0.4, 0.8, 0.2, 0.15), h(0.8, 0.5, 0.2, 0.15)],
        ticks(2, every: 0.3, [0.9], 1) + [h(0.31, 0.3, 1, 0.1)],
        holds(6, each: 0.1, [0.5, 0.75], [0, 0.2]),
        holds(12, each: 0.05, [0.9, 0.5, 0.7, 0.4], [0.4]),
    ]

    // Breeze, gale, sunrise, sunset, rainbow, snowfall, fog roll, aurora, starlight, overcast.
    static let natureSky: [[MotifStep]] = [
        holds(6, each: 0.12, [0.3, 0.5, 0.75, 0.5, 0.3, 0.4], [0.5]),
        holds(10, each: 0.06, [1, 0.6, 0.9, 0.5], [0.3]),
        holds(6, each: 0.12, [0.2, 0.35, 0.5, 0.65, 0.8, 1], [0.3, 0.4, 0.5, 0.6, 0.7, 0.8]),
        holds(6, each: 0.12, [1, 0.8, 0.65, 0.5, 0.35, 0.2], [0.8, 0.7, 0.6, 0.5, 0.4, 0.3]),
        ticks(7, every: 0.08, [0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9], 0, sharpnesses: [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]),
        ticks(6, every: 0.22, [0.4, 0.35], 0.9),
        holds(4, each: 0.2, [0.4, 0.55], [0]),
        holds(8, each: 0.12, [0.4, 0.6, 0.8, 0.6], [0.9, 0.7]),
        ticks(5, every: 0.15, [0.75, 0.4, 0.6, 0.3, 0.5], 1),
        holds(3, each: 0.3, [0.55, 0.65, 0.55], [0.1]),
    ]

    // MARK: Mechanical

    // Cog, spring coil, piston, valve, gear shift, bearing, hinge, latch bolt, crank, pulley.
    static let mechanicalParts: [[MotifStep]] = [
        ticks(6, every: 0.07, [0.9, 0.7], 0.7),
        holds(6, each: 0.05, [1, 0.7, 0.85, 0.55, 0.7, 0.4], [0.6]),
        [h(0, 0.9, 0.3, 0.08), h(0.15, 0.9, 0.3, 0.08), h(0.3, 0.9, 0.3, 0.08)],
        [t(0, 0.8, 0.9), h(0.02, 0.5, 0.95, 0.25)],
        [t(0, 1, 0.5), t(0.06, 0.7, 0.7), h(0.1, 0.4, 0.3, 0.1)],
        holds(10, each: 0.05, [0.6, 0.75], [0.9]),
        [h(0, 0.5, 0.4, 0.2), t(0.22, 0.8, 0.6)],
        [t(0, 0.7, 0.9), t(0.1, 1, 0.4)],
        ticks(4, every: 0.2, [1, 0.7, 0.9, 0.6], 0.4),
        holds(4, each: 0.15, [0.5, 0.75], [0.5]),
    ]

    // Turntable, projector, cassette, vending machine, washing machine, dishwasher, lawn mower, vacuum,
    // air conditioner, coffee machine.
    static let mechanicalDevices: [[MotifStep]] = [
        holds(8, each: 0.1, [0.6, 0.5], [0.3]),
        ticks(16, every: 0.05, [0.8, 0.5], 0.7),
        [t(0, 0.9, 0.8)] + holds(6, each: 0.1, from: 0.05, [0.4, 0.45], [0.2]),
        [h(0, 0.5, 0.4, 0.3), t(0.35, 1, 0.3), t(0.5, 0.6, 0.5)],
        holds(6, each: 0.15, [0.85, 0.4], [0.15]),
        holds(8, each: 0.1, [0.5, 0.6], [0.6, 0.8]),
        holds(12, each: 0.05, [1, 0.75], [0.2]),
        [h(0, 0.8, 0.7, 0.8)],
        [t(0, 0.8, 0.5), h(0.05, 0.5, 0.3, 0.8)],
        holds(4, each: 0.08, [0.4, 0.6, 0.8, 0.6], [0.5]) + ticks(4, every: 0.1, from: 0.4, [0.7], 0.7),
    ]

    // MARK: Game

    // Sprint, slide, roll, ledge climb, wall jump, dodge, block, parry, grapple, crouch.
    static let gameMoves: [[MotifStep]] = [
        ticks(6, every: 0.08, [0.9, 0.7], 0.6),
        holds(5, each: 0.06, [0.8, 0.7, 0.6, 0.5, 0.4], [0.6]),
        [t(0, 0.9, 0.3), h(0.02, 0.6, 0.2, 0.2), t(0.25, 0.7, 0.3)],
        ticks(4, every: 0.15, [0.6, 0.7, 0.8, 0.9], 0.6),
        [t(0, 1, 0.7), t(0.1, 0.7, 0.5), t(0.2, 1, 0.8)],
        [h(0, 0.6, 0.8, 0.06), t(0.07, 0.9, 0.9)],
        [t(0, 1, 0.2), h(0.01, 0.7, 0.1, 0.05)],
        [t(0, 1, 1), t(0.05, 1, 0.5)],
        [h(0, 0.5, 0.6, 0.15), t(0.17, 1, 0.6), h(0.18, 0.5, 0.4, 0.15)],
        holds(2, each: 0.08, [0.75, 0.45], [0.05]) + [t(0.18, 0.6, 0.3)],
    ]

    // Gem, star, key, chest, heart, trophy, medal, token, crown, scroll.
    static let gameRewards: [[MotifStep]] = [
        [t(0, 0.7, 1), t(0.05, 1, 1)],
        ticks(3, every: 0.05, [0.6, 0.8, 1], 1),
        [t(0, 0.8, 0.9), t(0.08, 0.5, 0.6)],
        [t(0, 0.6, 0.3), h(0.02, 0.4, 0.2, 0.1), t(0.15, 1, 0.9)],
        [t(0, 0.9, 0.3), t(0.1, 0.6, 0.3)],
        [t(0, 0.7, 0.8), h(0.02, 0.6, 0.7, 0.2)],
        ticks(2, every: 0.06, [1, 0.7], 0.9),
        [t(0, 0.75, 0.95), t(0.08, 0.75, 0.6)],
        holds(3, each: 0.06, [0.6, 0.8, 1], [1]),
        [h(0, 0.5, 0.3, 0.15), t(0.17, 0.8, 0.7)],
    ]
}
