//
// HapticPatterns.swift
// HapticEngine
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

import CoreHaptics

/// The events that make up each ``HapticPattern``.
///
/// Kept separate from playback so they can be unit tested without haptic hardware.
/// Keep the ten patterns shared with Android in step with `HapticPatterns.kt` in the Android library.
enum HapticPatterns {
    // Timings in seconds. Each pattern has its own, so tuning one can't change another.
    static let simpleTapInterval: TimeInterval = 0.1
    static let complexSegmentDuration: TimeInterval = 1.5
    static let successGap: TimeInterval = 0.15
    static let warningGap: TimeInterval = 0.25
    static let errorTapInterval: TimeInterval = 0.1
    static let heartbeatInterval: TimeInterval = 0.8
    static let heartbeatDubDelay: TimeInterval = 0.15
    static let knockInterval: TimeInterval = 0.25
    static let rumbleDuration: TimeInterval = 0.8
    static let pulseBurstDuration: TimeInterval = 0.1

    /// The only way in, so playback and tests always build patterns the same way.
    static func events(for pattern: HapticPattern) -> [CHHapticEvent] {
        switch pattern {
        case .simple: simple()
        case .complex: complex()
        case .tick: tick()
        case .success: success()
        case .warning: warning()
        case .error: error()
        case .heartbeat: heartbeat()
        case .knock: knock()
        case .rumble: rumble()
        case .pulse: pulse()

        // Feedback
        case .selection: [tap(0.4, 0.8)]
        case .lightImpact: [tap(0.4, 0.5)]
        case .mediumImpact: [tap(0.7, 0.5)]
        case .heavyImpact: [tap(1, 0.3)]
        case .softImpact: [tap(0.6, 0.1)]
        case .rigidImpact: [tap(0.8, 0.9)]
        case .toggleOn: [tap(0.5, 0.6), tap(0.9, 0.9, at: 0.06)]
        case .toggleOff: [tap(0.9, 0.9), tap(0.5, 0.6, at: 0.06)]
        case .buttonPress: [tap(0.7, 0.7), tap(0.3, 0.4, at: 0.08)]
        case .longPress: ramp(from: 0.2, to: 0.6, sharpness: 0.3, duration: 0.4, steps: 4) + [tap(1, 0.8, at: 0.4)]
        case .dragStart: [tap(0.6, 0.4), tap(0.3, 0.4, at: 0.05)]
        case .drop: [tap(0.9, 0.3), tap(0.4, 0.3, at: 0.09)]
        case .snap: [tap(0.3, 0.9), tap(1, 1, at: 0.03)]
        case .swipe: ramp(from: 0.2, to: 0.6, sharpness: 0.5, duration: 0.2, steps: 4)
        case .refresh: taps(at: times(3, every: 0.08), intensities: [0.3, 0.5, 0.7], sharpness: 0.6) + [tap(1, 0.9, at: 0.3)]
        case .delete: [tap(0.8, 0.6), hold(0.5, 0.2, at: 0.05, for: 0.15)]
        case .undo: [tap(0.8, 0.7), tap(0.5, 0.5, at: 0.08)]
        case .doubleTap: [tap(0.7, 0.7), tap(0.7, 0.7, at: 0.1)]

        // Alerts
        case .notification: [tap(0.8, 0.5), tap(0.8, 0.5, at: 0.18)]
        case .message: taps(at: times(3, every: 0.1), intensities: [0.6, 0.9, 0.6], sharpness: 0.7)
        case .mention: taps(at: times(4, every: 0.06), intensities: [0.7], sharpness: 0.9)
        case .reminder: [hold(0.5, 0.4, for: 0.15), hold(0.5, 0.4, at: 0.35, for: 0.15)]
        case .alarm: [0, 0.6, 1.2].flatMap { taps(at: times(4, every: 0.08, from: $0), intensities: [1], sharpness: 0.8) }
        case .ring: [0, 0.6, 1.6, 2.2].map { hold(0.9, 0.5, at: $0, for: 0.4) }
        case .doorbell:
            [tap(1, 0.9), hold(0.5, 0.6, for: 0.3), tap(0.8, 0.4, at: 0.4), hold(0.4, 0.3, at: 0.4, for: 0.4)]
        case .siren: segments(6, each: 0.25, intensities: [0.9, 0.5], sharpnesses: [0.8, 0.3])
        case .countdown:
            taps(at: times(3, every: 0.4), intensities: [0.6], sharpness: 0.7)
                + [tap(1, 1, at: 1.2), hold(1, 0.5, at: 1.2, for: 0.3)]
        case .timerDone: taps(at: times(3, every: 0.1) + times(3, every: 0.1, from: 0.5), intensities: [0.9], sharpness: 0.8)
        case .lowBattery: taps(at: times(3, every: 0.2), intensities: [0.9, 0.6, 0.3], sharpness: 0.4)
        case .sos: sos()

        // Rhythm
        case .drumroll: taps(at: times(16, every: 0.04), intensities: levels(from: 0.4, to: 1, count: 16), sharpness: 0.5)
        case .gallop: [0, 0.45, 0.9].flatMap { taps(at: times(3, every: 0.09, from: $0), intensities: [0.6, 0.7, 1], sharpness: 0.4) }
        case .march: taps(at: times(4, every: 0.5), intensities: [1, 0.6], sharpness: 0.5)
        case .waltz: taps(at: times(6, every: 0.3), intensities: [1, 0.5, 0.5], sharpness: 0.4)
        case .clockTick: [tap(0.5, 1), tap(0.5, 0.6, at: 0.5), tap(0.5, 1, at: 1), tap(0.5, 0.6, at: 1.5)]
        case .metronome: taps(at: times(4, every: 0.35), intensities: [1, 0.6, 0.6, 0.6], sharpness: 1)
        case .racingHeart: heartbeats(4, every: 0.4, dubDelay: 0.1, lub: 1, dub: 0.6, sharpness: 0.3)
        case .restingHeart: heartbeats(2, every: 1.2, dubDelay: 0.18, lub: 0.8, dub: 0.5, sharpness: 0.2)
        case .footsteps: taps(at: times(4, every: 0.45), intensities: [0.7, 0.6], sharpness: 0.2)
        case .clap: [0, 0.3, 0.6].flatMap { [tap(1, 1, at: $0), tap(0.5, 0.9, at: $0 + 0.02)] }
        case .bounce: taps(at: [0, 0.4, 0.7, 0.92, 1.08, 1.2], intensities: [1, 0.8, 0.6, 0.45, 0.3, 0.2], sharpness: 0.5)
        case .echo: taps(at: times(4, every: 0.25), intensities: [1, 0.6, 0.35, 0.2], sharpness: 0.8)
        case .syncopation: taps(at: [0, 0.3, 0.45, 0.75, 0.9], intensities: [0.9, 0.6, 0.9, 0.6, 1], sharpness: 0.6)

        // Texture
        case .buzz: [hold(0.8, 1, for: 0.5)]
        case .hum: [hold(0.4, 0.2, for: 1)]
        case .purr: segments(12, each: 0.08, intensities: [0.6, 0.3], sharpnesses: [0.1])
        case .zipper: taps(at: times(20, every: 0.02), intensities: [0.5], sharpness: 1)
        case .sandpaper: taps(at: times(25, every: 0.03), intensities: [0.3, 0.5, 0.4, 0.6], sharpness: 0.9)
        case .gravel: taps(at: times(16, every: 0.05), intensities: [0.7, 0.4, 0.9, 0.5], sharpness: 0.3)
        case .bubbles:
            taps(at: [0, 0.12, 0.2, 0.38, 0.45, 0.6, 0.72, 0.78], intensities: [0.4, 0.3, 0.5, 0.35, 0.45], sharpness: 0.7)
        case .sparkle: taps(at: times(11, every: 0.05), intensities: [0.3, 0.5, 0.2], sharpness: 1)
        case .crescendo: ramp(from: 0.1, to: 1, sharpness: 0.5, duration: 1.2, steps: 8)
        case .fadeOut: ramp(from: 1, to: 0.1, sharpness: 0.5, duration: 1.2, steps: 8)
        case .wobble: segments(8, each: 0.15, intensities: [0.9, 0.3], sharpnesses: [0.5])
        case .throb: times(4, every: 0.4).map { hold(0.7, 0.2, at: $0, for: 0.25) }

        // Nature
        case .raindrop: [tap(0.6, 0.9)]
        case .rain:
            taps(
                at: [0, 0.07, 0.19, 0.23, 0.34, 0.41, 0.52, 0.6, 0.66, 0.78, 0.85, 0.97, 1.04, 1.13, 1.2],
                intensities: [0.3, 0.5, 0.4, 0.6, 0.35],
                sharpness: 0.8
            )
        case .thunder:
            [tap(1, 1), tap(0.8, 0.8, at: 0.05)]
                + segments(3, each: 0.4, from: 0.1, intensities: [1, 0.7, 0.4], sharpnesses: [0.2, 0.1, 0.1])
        case .earthquake:
            segments(12, each: 0.1, intensities: [0.5, 0.9, 0.6, 1, 0.7, 1, 0.8, 0.9, 0.6, 0.7, 0.4, 0.3], sharpnesses: [0])
        case .oceanWave:
            ramp(from: 0.2, to: 0.8, sharpness: 0.2, duration: 1, steps: 5)
                + ramp(from: 0.8, to: 0.2, sharpness: 0.2, at: 1, duration: 1, steps: 5)
        case .gust:
            ramp(from: 0.2, to: 0.7, sharpness: 0.4, duration: 0.5, steps: 5)
                + ramp(from: 0.6, to: 0.1, sharpness: 0.4, at: 0.5, duration: 0.7, steps: 5)
        case .breathe:
            ramp(from: 0.1, to: 0.5, sharpness: 0, duration: 2, steps: 10)
                + ramp(from: 0.5, to: 0.1, sharpness: 0, at: 2, duration: 2, steps: 10)
        case .crickets: [0, 0.4, 0.8].flatMap { taps(at: times(4, every: 0.03, from: $0), intensities: [0.5], sharpness: 1) }
        case .woodpecker: taps(at: times(8, every: 0.05), intensities: [0.9], sharpness: 0.7)
        case .campfire:
            [hold(0.15, 0.1, for: 1)]
                + taps(
                    at: [0, 0.15, 0.18, 0.4, 0.55, 0.58, 0.62, 0.9],
                    intensities: [0.5, 0.9, 0.4, 0.7, 0.6, 1, 0.5, 0.8],
                    sharpness: 0.9
                )
        case .hail: taps(at: times(20, every: 0.04), intensities: [0.8, 1, 0.7, 0.9], sharpness: 1)
        case .avalanche: avalanche()

        // Mechanical
        case .typewriter:
            taps(at: [0, 0.12, 0.2, 0.35, 0.44, 0.55], intensities: [0.7, 0.6, 0.75, 0.65], sharpness: 0.9)
                + [tap(1, 1, at: 0.8), tap(0.5, 1, at: 0.83)]
        case .ratchet: taps(at: times(8, every: 0.07), intensities: [0.6], sharpness: 0.95)
        case .dial: taps(at: times(5, every: 0.12), intensities: [0.45], sharpness: 0.85) + [tap(0.9, 0.6, at: 0.6)]
        case .spring: segments(8, each: 0.08, intensities: [1, 0.3, 0.8, 0.25, 0.6, 0.2, 0.4, 0.15], sharpnesses: [0.6])
        case .engineStart:
            taps(at: times(3, every: 0.15), intensities: [0.6], sharpness: 0.3)
                + ramp(from: 0.3, to: 0.9, sharpness: 0.3, at: 0.45, duration: 0.5, steps: 5)
                + [hold(0.5, 0.2, at: 0.95, for: 0.5)]
        case .engineRev:
            ramp(from: 0.4, to: 1, sharpness: 0.6, duration: 0.8, steps: 8)
                + ramp(from: 1, to: 0.4, sharpness: 0.6, at: 0.8, duration: 0.6, steps: 6)
        case .shutter: [tap(0.8, 1), tap(0.6, 0.7, at: 0.06)]
        case .lock: [tap(0.6, 0.8), tap(1, 0.5, at: 0.1)]
        case .unlock: [tap(1, 0.5), tap(0.6, 0.8, at: 0.12)]
        case .gears: times(10, every: 0.09).enumerated().map { $0.offset.isMultiple(of: 2) ? tap(0.7, 0.6, at: $0.element) : tap(0.4, 0.9, at: $0.element) }
        case .drill: ramp(from: 0.5, to: 1, sharpness: 0.9, duration: 0.3, steps: 3) + [hold(1, 0.9, at: 0.3, for: 0.5)]

        // Game
        case .coin: [tap(0.6, 1), tap(0.9, 1, at: 0.07)]
        case .powerUp:
            zip(times(6, every: 0.06), zip(levels(from: 0.3, to: 1, count: 6), levels(from: 0.5, to: 1, count: 6)))
                .map { time, level in tap(level.0, level.1, at: time) }
        case .levelUp:
            taps(at: times(4, every: 0.1), intensities: [0.5, 0.6, 0.8, 1], sharpness: 0.8) + [hold(0.8, 0.7, at: 0.4, for: 0.3)]
        case .jump: ramp(from: 0.3, to: 0.7, sharpness: 0.6, duration: 0.12, steps: 3)
        case .landing: [tap(1, 0.2), hold(0.5, 0.1, at: 0.02, for: 0.1)]
        case .hit: [tap(1, 0.6), tap(0.4, 0.4, at: 0.05)]
        case .criticalHit: [tap(1, 1), tap(1, 0.5, at: 0.04), hold(0.8, 0.3, at: 0.08, for: 0.2)]
        case .explosion:
            [tap(1, 1), hold(1, 0.1, at: 0.02, for: 0.3)]
                + ramp(from: 0.8, to: 0.1, sharpness: 0.1, at: 0.32, duration: 0.8, steps: 8)
        case .laser: segments(5, each: 0.05, intensities: [0.8], sharpnesses: [1, 0.9, 0.8, 0.65, 0.5])
        case .shield: [tap(0.8, 0.9), hold(0.5, 0.6, for: 0.4), tap(0.8, 0.9, at: 0.4)]
        case .gameOver:
            taps(at: times(4, every: 0.25), intensities: [1, 0.8, 0.6, 0.4], sharpness: 0.3) + [hold(0.3, 0.1, at: 1, for: 0.5)]
        case .victory:
            taps(at: times(3, every: 0.12), intensities: [0.7], sharpness: 0.8)
                + [tap(1, 1, at: 0.45), hold(0.8, 0.6, at: 0.45, for: 0.5)]
        }
    }

    /// How long each pattern plays, worked out once from its events so it can't drift from them.
    static let durations: [HapticPattern: TimeInterval] = Dictionary(
        uniqueKeysWithValues: HapticPattern.allCases.map { pattern in
            let ends = events(for: pattern).map { event in
                event.relativeTime + (event.type == .hapticContinuous ? event.duration : 0)
            }
            return (pattern, ends.max() ?? 0)
        }
    )

    /// A full-strength tap, then taps every 100 ms rising from 10% to 90% strength.
    private static func simple() -> [CHHapticEvent] {
        let firstTap = transient(intensity: 1, sharpness: 1, at: 0)
        let ramp = (1...9).map { step in
            let level = Float(step) / 10
            return transient(intensity: level, sharpness: level, at: Double(step) * simpleTapInterval)
        }
        return [firstTap] + ramp
    }

    /// Medium (0.5), hard (1.0), soft (0.2), hard (1.0); 1.5 seconds each.
    private static func complex() -> [CHHapticEvent] {
        let levels: [Float] = [0.5, 1.0, 0.2, 1.0]
        return levels.enumerated().map { index, level in
            continuous(
                intensity: level,
                sharpness: level,
                at: Double(index) * complexSegmentDuration,
                duration: complexSegmentDuration
            )
        }
    }

    /// One light, crisp tap, like a picker detent.
    private static func tick() -> [CHHapticEvent] {
        [transient(intensity: 0.5, sharpness: 1, at: 0)]
    }

    /// A soft tap, then a strong sharp tap 150 ms later.
    private static func success() -> [CHHapticEvent] {
        [
            transient(intensity: 0.6, sharpness: 0.5, at: 0),
            transient(intensity: 1, sharpness: 1, at: successGap),
        ]
    }

    /// A strong tap, then a weaker tap 250 ms later.
    private static func warning() -> [CHHapticEvent] {
        [
            transient(intensity: 1, sharpness: 0.6, at: 0),
            transient(intensity: 0.6, sharpness: 0.6, at: warningGap),
        ]
    }

    /// Three strong, sharp taps 100 ms apart.
    private static func error() -> [CHHapticEvent] {
        (0..<3).map { index in
            transient(intensity: 1, sharpness: 1, at: Double(index) * errorTapInterval)
        }
    }

    /// Two "lub-dub" beats 800 ms apart: a strong dull tap, then a softer one 150 ms later.
    private static func heartbeat() -> [CHHapticEvent] {
        (0..<2).flatMap { beat in
            let start = Double(beat) * heartbeatInterval
            return [
                transient(intensity: 1, sharpness: 0.3, at: start),
                transient(intensity: 0.6, sharpness: 0.3, at: start + heartbeatDubDelay),
            ]
        }
    }

    /// Three firm, dull taps 250 ms apart, like knocking on a door.
    private static func knock() -> [CHHapticEvent] {
        (0..<3).map { index in
            transient(intensity: 0.8, sharpness: 0.2, at: Double(index) * knockInterval)
        }
    }

    /// A strong, low-sharpness vibration for 800 ms.
    private static func rumble() -> [CHHapticEvent] {
        [continuous(intensity: 0.8, sharpness: 0.1, at: 0, duration: rumbleDuration)]
    }

    /// Five 100 ms bursts with 100 ms gaps between them.
    private static func pulse() -> [CHHapticEvent] {
        (0..<5).map { index in
            // Each gap is as long as a burst.
            continuous(
                intensity: 1,
                sharpness: 0.5,
                at: Double(index) * 2 * pulseBurstDuration,
                duration: pulseBurstDuration
            )
        }
    }

    // MARK: Builders for the patterns beyond the shared ten

    /// "SOS" in Morse code. A dot is 80 ms and a dash three dots; symbols are one dot apart, letters three.
    private static func sos() -> [CHHapticEvent] {
        let dot: TimeInterval = 0.08
        var time: TimeInterval = 0
        var events: [CHHapticEvent] = []
        for (index, symbol) in [dot, dot * 3, dot].enumerated() {
            // One dot of gap is already added after the previous letter's last symbol.
            if index > 0 { time += dot * 2 }
            for _ in 0..<3 {
                events.append(hold(1, 0.6, at: time, for: symbol))
                time += symbol + dot
            }
        }
        return events
    }

    /// Twelve taps that come faster and stronger, then a heavy rumble.
    private static func avalanche() -> [CHHapticEvent] {
        var time: TimeInterval = 0
        var events: [CHHapticEvent] = []
        for (index, level) in levels(from: 0.3, to: 1, count: 12).enumerated() {
            events.append(tap(level, 0.4, at: time))
            // The gap shrinks from 200 ms to 30 ms.
            time += 0.2 - 0.17 * Double(index) / 11
        }
        return events + [hold(1, 0.1, at: time, for: 0.6)]
    }

    /// `count` "lub-dub" beats `interval` apart.
    private static func heartbeats(
        _ count: Int,
        every interval: TimeInterval,
        dubDelay: TimeInterval,
        lub: Float,
        dub: Float,
        sharpness: Float
    ) -> [CHHapticEvent] {
        times(count, every: interval).flatMap { start in
            [tap(lub, sharpness, at: start), tap(dub, sharpness, at: start + dubDelay)]
        }
    }

    /// Back-to-back holds stepping evenly from one intensity to another, since an event's intensity is fixed.
    private static func ramp(
        from start: Float,
        to end: Float,
        sharpness: Float,
        at time: TimeInterval = 0,
        duration: TimeInterval,
        steps: Int
    ) -> [CHHapticEvent] {
        segments(
            steps,
            each: duration / Double(steps),
            from: time,
            intensities: levels(from: start, to: end, count: steps),
            sharpnesses: [sharpness]
        )
    }

    /// `count` back-to-back holds of `each` seconds, cycling through `intensities` and `sharpnesses`.
    private static func segments(
        _ count: Int,
        each: TimeInterval,
        from start: TimeInterval = 0,
        intensities: [Float],
        sharpnesses: [Float]
    ) -> [CHHapticEvent] {
        (0..<count).map { index in
            hold(
                intensities[index % intensities.count],
                sharpnesses[index % sharpnesses.count],
                at: start + Double(index) * each,
                for: each
            )
        }
    }

    /// A tap at each of `times`, cycling through `intensities`.
    private static func taps(at times: [TimeInterval], intensities: [Float], sharpness: Float) -> [CHHapticEvent] {
        times.enumerated().map { index, time in
            tap(intensities[index % intensities.count], sharpness, at: time)
        }
    }

    /// `count` evenly spaced times, starting at `start`.
    private static func times(_ count: Int, every interval: TimeInterval, from start: TimeInterval = 0) -> [TimeInterval] {
        (0..<count).map { start + Double($0) * interval }
    }

    /// `count` levels stepping evenly from `start` to `end`, both included.
    private static func levels(from start: Float, to end: Float, count: Int) -> [Float] {
        (0..<count).map { start + (end - start) * Float($0) / Float(count - 1) }
    }

    private static func tap(_ intensity: Float, _ sharpness: Float, at time: TimeInterval = 0) -> CHHapticEvent {
        transient(intensity: intensity, sharpness: sharpness, at: time)
    }

    private static func hold(
        _ intensity: Float,
        _ sharpness: Float,
        at time: TimeInterval = 0,
        for duration: TimeInterval
    ) -> CHHapticEvent {
        continuous(intensity: intensity, sharpness: sharpness, at: time, duration: duration)
    }

    // MARK: Event basics

    private static func transient(intensity: Float, sharpness: Float, at time: TimeInterval) -> CHHapticEvent {
        CHHapticEvent(
            eventType: .hapticTransient,
            parameters: parameters(intensity: intensity, sharpness: sharpness),
            relativeTime: time
        )
    }

    private static func continuous(
        intensity: Float,
        sharpness: Float,
        at time: TimeInterval,
        duration: TimeInterval
    ) -> CHHapticEvent {
        CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: parameters(intensity: intensity, sharpness: sharpness),
            relativeTime: time,
            duration: duration
        )
    }

    private static func parameters(intensity: Float, sharpness: Float) -> [CHHapticEventParameter] {
        [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
        ]
    }
}
