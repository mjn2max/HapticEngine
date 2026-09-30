//
// HapticPattern+Display.swift
// HapticEngineDemo
//

import HapticEngine
import SwiftUI

/// Display text and icons for the library's built-in patterns.
extension HapticPattern {
    var title: String { details.title }

    /// Written to fit two lines of the status card on the smallest supported iPhone.
    var subtitle: String { details.subtitle }

    var systemImage: String { details.symbol }

    /// `duration` for display, such as "Instant", "250 ms" or "6 s".
    var durationText: String {
        switch duration {
        case ..<0.05: "Instant"
        case ..<1: "\(Int((duration * 1000).rounded())) ms"
        default: "\(duration.formatted(.number.precision(.fractionLength(0...1)))) s"
        }
    }

    /// The original ten keep their own colors, with feedback in traffic-light colors. The rest take their
    /// category's color, so related patterns read as a group.
    var tint: Color {
        switch self {
        case .simple: .blue
        case .complex: .indigo
        case .tick: .teal
        case .success: .green
        case .warning: .orange
        case .error: .red
        case .heartbeat: .pink
        case .knock: .brown
        case .rumble: .purple
        case .pulse: .cyan
        default: category.tint
        }
    }

    /// Whether `query` matches the pattern's name, description or category, ignoring case and accents.
    func matches(_ query: String) -> Bool {
        let query = query.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return true }
        return [title, subtitle, category.title].contains { $0.localizedStandardContains(query) }
    }

    private struct Details {
        let title: String
        let subtitle: String
        let symbol: String
    }

    // One row per pattern, so each is described in one place and a new pattern can't be missed.
    private var details: Details {
        switch self {
        case .simple: Details(title: "Simple", subtitle: "Sharp tap, then a rising ramp of taps", symbol: "hand.tap")
        case .complex: Details(title: "Complex", subtitle: "Medium, hard, soft, hard over 6 seconds", symbol: "waveform.path")
        case .tick: Details(title: "Tick", subtitle: "One light, crisp tap", symbol: "hand.point.up")
        case .success: Details(title: "Success", subtitle: "Soft tap, then a strong tap", symbol: "checkmark.circle")
        case .warning: Details(title: "Warning", subtitle: "Strong tap, then a weaker tap", symbol: "exclamationmark.triangle")
        case .error: Details(title: "Error", subtitle: "Three strong taps in quick succession", symbol: "xmark.octagon")
        case .heartbeat: Details(title: "Heartbeat", subtitle: "Two lub-dub beats, like a pulse", symbol: "heart")
        case .knock: Details(title: "Knock", subtitle: "Three firm, dull taps, like a door knock", symbol: "door.left.hand.closed")
        case .rumble: Details(title: "Rumble", subtitle: "Low, strong vibration for 0.8 seconds", symbol: "water.waves")
        case .pulse: Details(title: "Pulse", subtitle: "Five short bursts over one second", symbol: "dot.radiowaves.left.and.right")

        case .selection: Details(title: "Selection", subtitle: "Faint tick, like a picker moving a row", symbol: "list.bullet.indent")
        case .lightImpact: Details(title: "Light Impact", subtitle: "A light, medium-sharp tap", symbol: "circle")
        case .mediumImpact: Details(title: "Medium Impact", subtitle: "A moderate, medium-sharp tap", symbol: "circle.lefthalf.filled")
        case .heavyImpact: Details(title: "Heavy Impact", subtitle: "A heavy, dull tap", symbol: "circle.fill")
        case .softImpact: Details(title: "Soft Impact", subtitle: "A soft, rounded tap", symbol: "cloud")
        case .rigidImpact: Details(title: "Rigid Impact", subtitle: "A firm, very crisp tap", symbol: "diamond")
        case .toggleOn: Details(title: "Toggle On", subtitle: "Soft tap, then crisp, like a switch", symbol: "lightswitch.on")
        case .toggleOff: Details(title: "Toggle Off", subtitle: "Crisp tap, then soft, like a switch", symbol: "lightswitch.off")
        case .buttonPress: Details(title: "Button Press", subtitle: "A press and a lighter release", symbol: "button.programmable")
        case .longPress: Details(title: "Long Press", subtitle: "Pressure building, then a firm click", symbol: "hand.raised")
        case .dragStart: Details(title: "Drag Start", subtitle: "A tap as an item lifts to drag", symbol: "hand.draw")
        case .drop: Details(title: "Drop", subtitle: "A dull tap as an item settles", symbol: "arrow.down.to.line")
        case .snap: Details(title: "Snap", subtitle: "A light touch, then a sharp click", symbol: "square.dashed.inset.filled")
        case .swipe: Details(title: "Swipe", subtitle: "A brief swell that follows a swipe", symbol: "arrow.forward")
        case .refresh: Details(title: "Refresh", subtitle: "Rising taps ending in a crisp click", symbol: "arrow.clockwise")
        case .delete: Details(title: "Delete", subtitle: "A tap, then a short crumple", symbol: "trash")
        case .undo: Details(title: "Undo", subtitle: "A tap and a softer one, stepping back", symbol: "arrow.uturn.backward")
        case .doubleTap: Details(title: "Double Tap", subtitle: "Two even taps in quick succession", symbol: "cursorarrow.click.2")

        case .notification: Details(title: "Notification", subtitle: "Two even taps", symbol: "bell")
        case .message: Details(title: "Message", subtitle: "Three quick taps that rise and fall", symbol: "message")
        case .mention: Details(title: "Mention", subtitle: "Four rapid, crisp taps", symbol: "at")
        case .reminder: Details(title: "Reminder", subtitle: "Two gentle buzzes", symbol: "calendar.badge.clock")
        case .alarm: Details(title: "Alarm", subtitle: "Three bursts of rapid taps", symbol: "alarm")
        case .ring: Details(title: "Ring", subtitle: "Two pairs of rings, like a phone", symbol: "phone")
        case .doorbell: Details(title: "Doorbell", subtitle: "A bright ding and a lower dong", symbol: "bell.and.waves.left.and.right")
        case .siren: Details(title: "Siren", subtitle: "Alternates between high and low", symbol: "light.beacon.max")
        case .countdown: Details(title: "Countdown", subtitle: "Three steady taps, then a strong one", symbol: "timer")
        case .timerDone: Details(title: "Timer Done", subtitle: "Two sets of three taps", symbol: "hourglass.bottomhalf.filled")
        case .lowBattery: Details(title: "Low Battery", subtitle: "Three taps that fade away", symbol: "battery.25")
        case .sos: Details(title: "SOS", subtitle: "Three short, three long, three short", symbol: "sos")

        case .drumroll: Details(title: "Drumroll", subtitle: "Sixteen rapid taps that build", symbol: "music.quarternote.3")
        case .gallop: Details(title: "Gallop", subtitle: "Three da-da-dum beats, like a horse", symbol: "hare")
        case .march: Details(title: "March", subtitle: "Four steady steps, strong and weak", symbol: "flag")
        case .waltz: Details(title: "Waltz", subtitle: "Two bars of three, first beat strong", symbol: "figure.dance")
        case .clockTick: Details(title: "Clock", subtitle: "A crisp tick and a duller tock, twice", symbol: "clock")
        case .metronome: Details(title: "Metronome", subtitle: "Four even crisp beats, first accented", symbol: "metronome")
        case .racingHeart: Details(title: "Racing Heart", subtitle: "Four quick heartbeats", symbol: "bolt.heart")
        case .restingHeart: Details(title: "Resting Heart", subtitle: "Two slow, soft heartbeats", symbol: "heart.circle")
        case .footsteps: Details(title: "Footsteps", subtitle: "Four dull steps, alternating feet", symbol: "shoeprints.fill")
        case .clap: Details(title: "Clap", subtitle: "Three sharp claps", symbol: "hands.clap")
        case .bounce: Details(title: "Bounce", subtitle: "Taps that come faster and fade", symbol: "basketball")
        case .echo: Details(title: "Echo", subtitle: "A tap that repeats and fades", symbol: "dot.radiowaves.right")
        case .syncopation: Details(title: "Syncopation", subtitle: "An off-beat rhythm of five taps", symbol: "music.note")

        case .buzz: Details(title: "Buzz", subtitle: "A crisp, steady buzz", symbol: "bolt")
        case .hum: Details(title: "Hum", subtitle: "A soft, low hum for one second", symbol: "waveform")
        case .purr: Details(title: "Purr", subtitle: "A gentle flutter, like a cat purring", symbol: "cat")
        case .zipper: Details(title: "Zipper", subtitle: "Twenty tiny taps in a fast run", symbol: "line.3.horizontal.decrease")
        case .sandpaper: Details(title: "Sandpaper", subtitle: "A rough, fine-grained texture", symbol: "square.grid.4x3.fill")
        case .gravel: Details(title: "Gravel", subtitle: "A coarse, uneven texture", symbol: "circle.grid.3x3")
        case .bubbles: Details(title: "Bubbles", subtitle: "Small taps at uneven intervals", symbol: "bubbles.and.sparkles")
        case .sparkle: Details(title: "Sparkle", subtitle: "Tiny, bright taps that shimmer", symbol: "sparkles")
        case .crescendo: Details(title: "Crescendo", subtitle: "Grows from faint to full strength", symbol: "chart.line.uptrend.xyaxis")
        case .fadeOut: Details(title: "Fade Out", subtitle: "Fades from full strength to faint", symbol: "chart.line.downtrend.xyaxis")
        case .wobble: Details(title: "Wobble", subtitle: "Swings between strong and weak", symbol: "scribble.variable")
        case .throb: Details(title: "Throb", subtitle: "Four heavy, dull pulses", symbol: "circle.circle")

        case .raindrop: Details(title: "Raindrop", subtitle: "A single light, crisp drop", symbol: "drop")
        case .rain: Details(title: "Rain", subtitle: "Light taps falling at random", symbol: "cloud.rain")
        case .thunder: Details(title: "Thunder", subtitle: "A sharp crack, then a rolling rumble", symbol: "cloud.bolt")
        case .earthquake: Details(title: "Earthquake", subtitle: "Deep, uneven shaking that dies away", symbol: "mountain.2")
        case .oceanWave: Details(title: "Ocean Wave", subtitle: "Swells and recedes, like a wave", symbol: "beach.umbrella")
        case .gust: Details(title: "Gust", subtitle: "A short rush of wind", symbol: "wind")
        case .breathe: Details(title: "Breathe", subtitle: "A slow swell and release, 4 seconds", symbol: "lungs")
        case .crickets: Details(title: "Crickets", subtitle: "Three quick chirps", symbol: "moon.stars")
        case .woodpecker: Details(title: "Woodpecker", subtitle: "Eight rapid, firm pecks", symbol: "bird")
        case .campfire: Details(title: "Campfire", subtitle: "Crackles over a faint glow", symbol: "flame")
        case .hail: Details(title: "Hail", subtitle: "A hard, rapid clatter", symbol: "cloud.hail")
        case .avalanche: Details(title: "Avalanche", subtitle: "Taps that gather, then a heavy rumble", symbol: "snowflake")

        case .typewriter: Details(title: "Typewriter", subtitle: "Key strikes, then the carriage bell", symbol: "keyboard")
        case .ratchet: Details(title: "Ratchet", subtitle: "Eight quick, crisp clicks", symbol: "wrench.adjustable")
        case .dial: Details(title: "Dial", subtitle: "Five light detents, then a firm stop", symbol: "dial.medium")
        case .spring: Details(title: "Spring", subtitle: "A bouncy vibration that settles", symbol: "scribble")
        case .engineStart: Details(title: "Engine Start", subtitle: "Cranks, catches, then idles", symbol: "engine.combustion")
        case .engineRev: Details(title: "Engine Rev", subtitle: "Revs up and back down", symbol: "speedometer")
        case .shutter: Details(title: "Shutter", subtitle: "A quick two-part click", symbol: "camera")
        case .lock: Details(title: "Lock", subtitle: "A click, then a solid clunk", symbol: "lock")
        case .unlock: Details(title: "Unlock", subtitle: "A clunk, then a light click", symbol: "lock.open")
        case .gears: Details(title: "Gears", subtitle: "Interlocking clicks, like turning gears", symbol: "gearshape.2")
        case .drill: Details(title: "Drill", subtitle: "Spins up, then runs", symbol: "screwdriver")

        case .coin: Details(title: "Coin", subtitle: "Two bright taps, like a pickup", symbol: "dollarsign.circle")
        case .powerUp: Details(title: "Power Up", subtitle: "Taps rising in strength and sharpness", symbol: "bolt.circle")
        case .levelUp: Details(title: "Level Up", subtitle: "Four rising taps and a bright hold", symbol: "arrow.up.circle")
        case .jump: Details(title: "Jump", subtitle: "A short upward push", symbol: "figure.jumprope")
        case .landing: Details(title: "Landing", subtitle: "A heavy thud and a brief settle", symbol: "airplane.arrival")
        case .hit: Details(title: "Hit", subtitle: "A solid hit with a small rebound", symbol: "target")
        case .criticalHit: Details(title: "Critical Hit", subtitle: "A sharp strike, a blow, a shudder", symbol: "scope")
        case .explosion: Details(title: "Explosion", subtitle: "A blast, then a rumble that dies away", symbol: "burst")
        case .laser: Details(title: "Laser", subtitle: "A short zap that loses its edge", symbol: "wand.and.rays")
        case .shield: Details(title: "Shield", subtitle: "A shimmering hold between two taps", symbol: "shield")
        case .gameOver: Details(title: "Game Over", subtitle: "Four falling taps and a low fade", symbol: "gamecontroller")
        case .victory: Details(title: "Victory", subtitle: "Three quick taps and a triumphant hold", symbol: "trophy")
        }
    }

    /// The section the demo lists the pattern under.
    var category: Category {
        switch self {
        case .tick, .success, .warning, .error,
             .selection, .lightImpact, .mediumImpact, .heavyImpact, .softImpact, .rigidImpact,
             .toggleOn, .toggleOff, .buttonPress, .longPress, .dragStart, .drop,
             .snap, .swipe, .refresh, .delete, .undo, .doubleTap:
            .feedback
        case .notification, .message, .mention, .reminder, .alarm, .ring,
             .doorbell, .siren, .countdown, .timerDone, .lowBattery, .sos:
            .alerts
        case .heartbeat, .knock, .pulse,
             .drumroll, .gallop, .march, .waltz, .clockTick, .metronome, .racingHeart,
             .restingHeart, .footsteps, .clap, .bounce, .echo, .syncopation:
            .rhythm
        case .simple, .complex, .rumble,
             .buzz, .hum, .purr, .zipper, .sandpaper, .gravel,
             .bubbles, .sparkle, .crescendo, .fadeOut, .wobble, .throb:
            .texture
        case .raindrop, .rain, .thunder, .earthquake, .oceanWave, .gust,
             .breathe, .crickets, .woodpecker, .campfire, .hail, .avalanche:
            .nature
        case .typewriter, .ratchet, .dial, .spring, .engineStart, .engineRev,
             .shutter, .lock, .unlock, .gears, .drill:
            .mechanical
        case .coin, .powerUp, .levelUp, .jump, .landing, .hit,
             .criticalHit, .explosion, .laser, .shield, .gameOver, .victory:
            .game
        }
    }

    /// Groups the patterns on the home screen, so the list stays easy to scan.
    enum Category: CaseIterable {
        /// Short responses to something the user did.
        case feedback
        /// Getting the user's attention.
        case alerts
        /// Repeating beats.
        case rhythm
        /// Longer vibrations that build or sustain.
        case texture
        /// Weather, water and wildlife.
        case nature
        /// Machines and devices.
        case mechanical
        /// Game events.
        case game

        var title: String {
            switch self {
            case .feedback: "Feedback"
            case .alerts: "Alerts"
            case .rhythm: "Rhythm"
            case .texture: "Texture"
            case .nature: "Nature"
            case .mechanical: "Mechanical"
            case .game: "Game"
            }
        }

        var tint: Color {
            switch self {
            case .feedback: .teal
            case .alerts: .orange
            case .rhythm: .pink
            case .texture: .purple
            case .nature: .mint
            case .mechanical: .gray
            case .game: .indigo
            }
        }

        var patterns: [HapticPattern] {
            HapticPattern.allCases.filter { $0.category == self }
        }
    }
}
