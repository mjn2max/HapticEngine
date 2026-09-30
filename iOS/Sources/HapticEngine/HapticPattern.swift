//
// HapticPattern.swift
// HapticEngine
//
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

import Foundation

/// A built-in haptic pattern. Pass one to ``HapticEngineProtocol/play(_:)``.
///
/// ```swift
/// haptics.play(.success)
/// ```
///
/// The first ten patterns are also in the Android library. The rest are iOS only for now.
public enum HapticPattern: String, CaseIterable, Sendable {
    // MARK: Shared with Android

    /// One sharp tap followed by nine taps of rising strength over about one second.
    case simple

    /// Four 1.5 second segments: medium, hard, soft, hard.
    case complex

    /// One light, crisp tap. Similar to, but not the same as, `UISelectionFeedbackGenerator`.
    case tick

    /// A soft tap followed by a strong sharp tap, to confirm something worked.
    /// Similar to, but not the same as, `UINotificationFeedbackGenerator`'s `.success`.
    case success

    /// A strong tap followed by a weaker one, to draw attention.
    /// Similar to, but not the same as, `UINotificationFeedbackGenerator`'s `.warning`.
    case warning

    /// Three strong, sharp taps in quick succession, to signal a failure.
    /// Similar to, but not the same as, `UINotificationFeedbackGenerator`'s `.error`.
    case error

    /// Two "lub-dub" heartbeats over about one second.
    case heartbeat

    /// Three firm, dull taps, like knocking on a door.
    case knock

    /// A strong, low rumble for 0.8 seconds.
    case rumble

    /// Five short bursts over about one second.
    case pulse

    // MARK: Feedback

    /// A faint, crisp tick, like a picker wheel moving one row.
    case selection

    /// A light, medium-sharp tap.
    case lightImpact

    /// A moderate, medium-sharp tap.
    case mediumImpact

    /// A heavy, dull tap.
    case heavyImpact

    /// A soft, rounded tap.
    case softImpact

    /// A firm, very crisp tap.
    case rigidImpact

    /// A soft tap then a crisp one, like a switch turning on.
    case toggleOn

    /// A crisp tap then a soft one, like a switch turning off.
    case toggleOff

    /// A press and a lighter release, like a physical button.
    case buttonPress

    /// Pressure building for 0.4 seconds, then a firm click.
    case longPress

    /// A tap and a lighter follow-up, as an item lifts to be dragged.
    case dragStart

    /// A dull tap and a small settle, as a dragged item is dropped.
    case drop

    /// A light touch, then a sharp click into place.
    case snap

    /// A brief vibration that swells, following a swipe.
    case swipe

    /// Rising taps ending in a crisp click, for pull to refresh.
    case refresh

    /// A tap, then a short crumple, for deleting something.
    case delete

    /// A tap and a softer one, stepping back.
    case undo

    /// Two even taps in quick succession.
    case doubleTap

    // MARK: Alerts

    /// Two even taps, for a general notification.
    case notification

    /// Three quick taps that rise and fall, for a new message.
    case message

    /// Four rapid crisp taps, for a mention.
    case mention

    /// Two gentle buzzes, for a reminder.
    case reminder

    /// Three bursts of four rapid taps, like an alarm clock.
    case alarm

    /// Two pairs of rings, like a phone ringing.
    case ring

    /// A bright "ding" and a lower "dong".
    case doorbell

    /// A vibration that alternates between high and low, like a siren.
    case siren

    /// Three steady taps, then a strong final one.
    case countdown

    /// Two sets of three taps, for a finished timer.
    case timerDone

    /// Three taps that fade, for low battery.
    case lowBattery

    /// "SOS" in Morse code: three short, three long, three short.
    case sos

    // MARK: Rhythm

    /// Sixteen rapid taps that build in strength.
    case drumroll

    /// Three "da-da-dum" beats, like a galloping horse.
    case gallop

    /// Four steady steps, strong and weak in turn.
    case march

    /// Two bars of three beats, the first of each accented.
    case waltz

    /// A crisp "tick" and a duller "tock", twice.
    case clockTick

    /// Four evenly spaced crisp beats, the first accented.
    case metronome

    /// Four quick heartbeats.
    case racingHeart

    /// Two slow, soft heartbeats.
    case restingHeart

    /// Four dull steps, alternating feet.
    case footsteps

    /// Three sharp claps.
    case clap

    /// A ball bouncing: taps that come faster and fade.
    case bounce

    /// A tap that repeats and fades, like an echo.
    case echo

    /// An off-beat rhythm of five taps.
    case syncopation

    // MARK: Texture

    /// A crisp, steady buzz for half a second.
    case buzz

    /// A soft, low hum for one second.
    case hum

    /// A gentle fluttering vibration, like a cat purring.
    case purr

    /// Twenty tiny taps in a fast run, like a zipper.
    case zipper

    /// A rough, fine-grained texture.
    case sandpaper

    /// A coarse, uneven texture.
    case gravel

    /// Small taps at uneven intervals, like rising bubbles.
    case bubbles

    /// Tiny, bright taps that shimmer.
    case sparkle

    /// A vibration that grows from faint to full strength.
    case crescendo

    /// A vibration that fades from full strength to faint.
    case fadeOut

    /// A vibration that swings between strong and weak.
    case wobble

    /// Four heavy, dull pulses.
    case throb

    // MARK: Nature

    /// A single light, crisp drop.
    case raindrop

    /// Light taps falling at random, like rain.
    case rain

    /// A sharp crack, then a rolling rumble that fades.
    case thunder

    /// A deep, uneven shaking that dies away.
    case earthquake

    /// A vibration that swells and recedes, like a wave.
    case oceanWave

    /// A short rush of wind that builds and falls.
    case gust

    /// A slow swell and release, to pace a calm breath.
    case breathe

    /// Three quick chirps.
    case crickets

    /// Eight rapid, firm pecks.
    case woodpecker

    /// Crackles over a faint glow, like a campfire.
    case campfire

    /// A hard, rapid clatter, like hail.
    case hail

    /// Taps that come faster and stronger, then a heavy rumble.
    case avalanche

    // MARK: Mechanical

    /// Uneven key strikes, then the carriage bell.
    case typewriter

    /// Eight quick, crisp clicks.
    case ratchet

    /// Five light detents, then a firm stop, like a dial.
    case dial

    /// A bouncy vibration that settles, like a spring.
    case spring

    /// The engine cranks, catches, then idles.
    case engineStart

    /// An engine revving up and back down.
    case engineRev

    /// A quick two-part click, like a camera shutter.
    case shutter

    /// A click, then a solid clunk.
    case lock

    /// A clunk, then a light click.
    case unlock

    /// Interlocking clicks, like turning gears.
    case gears

    /// A drill spinning up, then running.
    case drill

    // MARK: Game

    /// Two bright taps, like collecting a coin.
    case coin

    /// Taps that rise in strength and sharpness.
    case powerUp

    /// Four rising taps and a bright hold.
    case levelUp

    /// A short upward push.
    case jump

    /// A heavy thud and a brief settle.
    case landing

    /// A solid hit with a small rebound.
    case hit

    /// A sharp strike, a heavy blow, then a shudder.
    case criticalHit

    /// A blast, then a rumble that dies away.
    case explosion

    /// A short zap that loses its edge.
    case laser

    /// A shimmering hold between two bright taps.
    case shield

    /// Four falling taps and a low fade.
    case gameOver

    /// Three quick taps and a triumphant hold.
    case victory

    /// How long the pattern plays, in seconds: from its first event to the end of its last. A single tap,
    /// like ``tick``, is `0`.
    ///
    /// The engine doesn't report when a pattern ends, so use this to time UI to it.
    public var duration: TimeInterval {
        HapticPatterns.durations[self, default: 0]
    }
}
