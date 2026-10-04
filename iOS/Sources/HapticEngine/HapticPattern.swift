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
/// The first ten patterns are also in the Android library. The rest are iOS only for now: ninety more built
/// by hand, then 900 in ten families of ninety, such as impacts, meters and weather, each a variant at one
/// of nine levels, like ``heavyMetalHit`` or ``waltzAllegro``.
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

    // BEGIN GENERATED PATTERNS: written by iOS/Scripts/GeneratePatterns.swift. Don't edit by hand.

    // MARK: Impacts: a hit on a material, from feather-light to crushing

    /// A feather-light hit on wood, a hollow knock.
    case featherWoodHit

    /// A light hit on wood, a hollow knock.
    case lightWoodHit

    /// A soft hit on wood, a hollow knock.
    case softWoodHit

    /// A gentle hit on wood, a hollow knock.
    case gentleWoodHit

    /// A medium hit on wood, a hollow knock.
    case mediumWoodHit

    /// A firm hit on wood, a hollow knock.
    case firmWoodHit

    /// A heavy hit on wood, a hollow knock.
    case heavyWoodHit

    /// A hard hit on wood, a hollow knock.
    case hardWoodHit

    /// A crushing hit on wood, a hollow knock.
    case crushingWoodHit

    /// A feather-light hit on metal, ringing on.
    case featherMetalHit

    /// A light hit on metal, ringing on.
    case lightMetalHit

    /// A soft hit on metal, ringing on.
    case softMetalHit

    /// A gentle hit on metal, ringing on.
    case gentleMetalHit

    /// A medium hit on metal, ringing on.
    case mediumMetalHit

    /// A firm hit on metal, ringing on.
    case firmMetalHit

    /// A heavy hit on metal, ringing on.
    case heavyMetalHit

    /// A hard hit on metal, ringing on.
    case hardMetalHit

    /// A crushing hit on metal, ringing on.
    case crushingMetalHit

    /// A feather-light hit on glass, with a tinkle.
    case featherGlassHit

    /// A light hit on glass, with a tinkle.
    case lightGlassHit

    /// A soft hit on glass, with a tinkle.
    case softGlassHit

    /// A gentle hit on glass, with a tinkle.
    case gentleGlassHit

    /// A medium hit on glass, with a tinkle.
    case mediumGlassHit

    /// A firm hit on glass, with a tinkle.
    case firmGlassHit

    /// A heavy hit on glass, with a tinkle.
    case heavyGlassHit

    /// A hard hit on glass, with a tinkle.
    case hardGlassHit

    /// A crushing hit on glass, with a tinkle.
    case crushingGlassHit

    /// A feather-light hit on stone, dull and solid.
    case featherStoneHit

    /// A light hit on stone, dull and solid.
    case lightStoneHit

    /// A soft hit on stone, dull and solid.
    case softStoneHit

    /// A gentle hit on stone, dull and solid.
    case gentleStoneHit

    /// A medium hit on stone, dull and solid.
    case mediumStoneHit

    /// A firm hit on stone, dull and solid.
    case firmStoneHit

    /// A heavy hit on stone, dull and solid.
    case heavyStoneHit

    /// A hard hit on stone, dull and solid.
    case hardStoneHit

    /// A crushing hit on stone, dull and solid.
    case crushingStoneHit

    /// A feather-light hit on rubber, bouncing back.
    case featherRubberHit

    /// A light hit on rubber, bouncing back.
    case lightRubberHit

    /// A soft hit on rubber, bouncing back.
    case softRubberHit

    /// A gentle hit on rubber, bouncing back.
    case gentleRubberHit

    /// A medium hit on rubber, bouncing back.
    case mediumRubberHit

    /// A firm hit on rubber, bouncing back.
    case firmRubberHit

    /// A heavy hit on rubber, bouncing back.
    case heavyRubberHit

    /// A hard hit on rubber, bouncing back.
    case hardRubberHit

    /// A crushing hit on rubber, bouncing back.
    case crushingRubberHit

    /// A feather-light hit on plastic, with a click.
    case featherPlasticHit

    /// A light hit on plastic, with a click.
    case lightPlasticHit

    /// A soft hit on plastic, with a click.
    case softPlasticHit

    /// A gentle hit on plastic, with a click.
    case gentlePlasticHit

    /// A medium hit on plastic, with a click.
    case mediumPlasticHit

    /// A firm hit on plastic, with a click.
    case firmPlasticHit

    /// A heavy hit on plastic, with a click.
    case heavyPlasticHit

    /// A hard hit on plastic, with a click.
    case hardPlasticHit

    /// A crushing hit on plastic, with a click.
    case crushingPlasticHit

    /// A feather-light hit on paper, with a rustle.
    case featherPaperHit

    /// A light hit on paper, with a rustle.
    case lightPaperHit

    /// A soft hit on paper, with a rustle.
    case softPaperHit

    /// A gentle hit on paper, with a rustle.
    case gentlePaperHit

    /// A medium hit on paper, with a rustle.
    case mediumPaperHit

    /// A firm hit on paper, with a rustle.
    case firmPaperHit

    /// A heavy hit on paper, with a rustle.
    case heavyPaperHit

    /// A hard hit on paper, with a rustle.
    case hardPaperHit

    /// A crushing hit on paper, with a rustle.
    case crushingPaperHit

    /// A feather-light hit on cloth, muffled.
    case featherClothHit

    /// A light hit on cloth, muffled.
    case lightClothHit

    /// A soft hit on cloth, muffled.
    case softClothHit

    /// A gentle hit on cloth, muffled.
    case gentleClothHit

    /// A medium hit on cloth, muffled.
    case mediumClothHit

    /// A firm hit on cloth, muffled.
    case firmClothHit

    /// A heavy hit on cloth, muffled.
    case heavyClothHit

    /// A hard hit on cloth, muffled.
    case hardClothHit

    /// A crushing hit on cloth, muffled.
    case crushingClothHit

    /// A feather-light hit on water, with a splash.
    case featherWaterHit

    /// A light hit on water, with a splash.
    case lightWaterHit

    /// A soft hit on water, with a splash.
    case softWaterHit

    /// A gentle hit on water, with a splash.
    case gentleWaterHit

    /// A medium hit on water, with a splash.
    case mediumWaterHit

    /// A firm hit on water, with a splash.
    case firmWaterHit

    /// A heavy hit on water, with a splash.
    case heavyWaterHit

    /// A hard hit on water, with a splash.
    case hardWaterHit

    /// A crushing hit on water, with a splash.
    case crushingWaterHit

    /// A feather-light hit on ceramic, with a clink.
    case featherCeramicHit

    /// A light hit on ceramic, with a clink.
    case lightCeramicHit

    /// A soft hit on ceramic, with a clink.
    case softCeramicHit

    /// A gentle hit on ceramic, with a clink.
    case gentleCeramicHit

    /// A medium hit on ceramic, with a clink.
    case mediumCeramicHit

    /// A firm hit on ceramic, with a clink.
    case firmCeramicHit

    /// A heavy hit on ceramic, with a clink.
    case heavyCeramicHit

    /// A hard hit on ceramic, with a clink.
    case hardCeramicHit

    /// A crushing hit on ceramic, with a clink.
    case crushingCeramicHit

    // MARK: Tap counts: two to eleven taps, from a lazy pace to a rapid one

    /// Two taps at a lazy pace, the last strongest.
    case twoTapsLazy

    /// Two taps at a slow pace, the last strongest.
    case twoTapsSlow

    /// Two taps at a relaxed pace, the last strongest.
    case twoTapsRelaxed

    /// Two taps at a easy pace, the last strongest.
    case twoTapsEasy

    /// Two taps at a steady pace, the last strongest.
    case twoTapsSteady

    /// Two taps at a brisk pace, the last strongest.
    case twoTapsBrisk

    /// Two taps at a quick pace, the last strongest.
    case twoTapsQuick

    /// Two taps at a fast pace, the last strongest.
    case twoTapsFast

    /// Two taps at a rapid pace, the last strongest.
    case twoTapsRapid

    /// Three taps at a lazy pace, the last strongest.
    case threeTapsLazy

    /// Three taps at a slow pace, the last strongest.
    case threeTapsSlow

    /// Three taps at a relaxed pace, the last strongest.
    case threeTapsRelaxed

    /// Three taps at a easy pace, the last strongest.
    case threeTapsEasy

    /// Three taps at a steady pace, the last strongest.
    case threeTapsSteady

    /// Three taps at a brisk pace, the last strongest.
    case threeTapsBrisk

    /// Three taps at a quick pace, the last strongest.
    case threeTapsQuick

    /// Three taps at a fast pace, the last strongest.
    case threeTapsFast

    /// Three taps at a rapid pace, the last strongest.
    case threeTapsRapid

    /// Four taps at a lazy pace, the last strongest.
    case fourTapsLazy

    /// Four taps at a slow pace, the last strongest.
    case fourTapsSlow

    /// Four taps at a relaxed pace, the last strongest.
    case fourTapsRelaxed

    /// Four taps at a easy pace, the last strongest.
    case fourTapsEasy

    /// Four taps at a steady pace, the last strongest.
    case fourTapsSteady

    /// Four taps at a brisk pace, the last strongest.
    case fourTapsBrisk

    /// Four taps at a quick pace, the last strongest.
    case fourTapsQuick

    /// Four taps at a fast pace, the last strongest.
    case fourTapsFast

    /// Four taps at a rapid pace, the last strongest.
    case fourTapsRapid

    /// Five taps at a lazy pace, the last strongest.
    case fiveTapsLazy

    /// Five taps at a slow pace, the last strongest.
    case fiveTapsSlow

    /// Five taps at a relaxed pace, the last strongest.
    case fiveTapsRelaxed

    /// Five taps at a easy pace, the last strongest.
    case fiveTapsEasy

    /// Five taps at a steady pace, the last strongest.
    case fiveTapsSteady

    /// Five taps at a brisk pace, the last strongest.
    case fiveTapsBrisk

    /// Five taps at a quick pace, the last strongest.
    case fiveTapsQuick

    /// Five taps at a fast pace, the last strongest.
    case fiveTapsFast

    /// Five taps at a rapid pace, the last strongest.
    case fiveTapsRapid

    /// Six taps at a lazy pace, the last strongest.
    case sixTapsLazy

    /// Six taps at a slow pace, the last strongest.
    case sixTapsSlow

    /// Six taps at a relaxed pace, the last strongest.
    case sixTapsRelaxed

    /// Six taps at a easy pace, the last strongest.
    case sixTapsEasy

    /// Six taps at a steady pace, the last strongest.
    case sixTapsSteady

    /// Six taps at a brisk pace, the last strongest.
    case sixTapsBrisk

    /// Six taps at a quick pace, the last strongest.
    case sixTapsQuick

    /// Six taps at a fast pace, the last strongest.
    case sixTapsFast

    /// Six taps at a rapid pace, the last strongest.
    case sixTapsRapid

    /// Seven taps at a lazy pace, the last strongest.
    case sevenTapsLazy

    /// Seven taps at a slow pace, the last strongest.
    case sevenTapsSlow

    /// Seven taps at a relaxed pace, the last strongest.
    case sevenTapsRelaxed

    /// Seven taps at a easy pace, the last strongest.
    case sevenTapsEasy

    /// Seven taps at a steady pace, the last strongest.
    case sevenTapsSteady

    /// Seven taps at a brisk pace, the last strongest.
    case sevenTapsBrisk

    /// Seven taps at a quick pace, the last strongest.
    case sevenTapsQuick

    /// Seven taps at a fast pace, the last strongest.
    case sevenTapsFast

    /// Seven taps at a rapid pace, the last strongest.
    case sevenTapsRapid

    /// Eight taps at a lazy pace, the last strongest.
    case eightTapsLazy

    /// Eight taps at a slow pace, the last strongest.
    case eightTapsSlow

    /// Eight taps at a relaxed pace, the last strongest.
    case eightTapsRelaxed

    /// Eight taps at a easy pace, the last strongest.
    case eightTapsEasy

    /// Eight taps at a steady pace, the last strongest.
    case eightTapsSteady

    /// Eight taps at a brisk pace, the last strongest.
    case eightTapsBrisk

    /// Eight taps at a quick pace, the last strongest.
    case eightTapsQuick

    /// Eight taps at a fast pace, the last strongest.
    case eightTapsFast

    /// Eight taps at a rapid pace, the last strongest.
    case eightTapsRapid

    /// Nine taps at a lazy pace, the last strongest.
    case nineTapsLazy

    /// Nine taps at a slow pace, the last strongest.
    case nineTapsSlow

    /// Nine taps at a relaxed pace, the last strongest.
    case nineTapsRelaxed

    /// Nine taps at a easy pace, the last strongest.
    case nineTapsEasy

    /// Nine taps at a steady pace, the last strongest.
    case nineTapsSteady

    /// Nine taps at a brisk pace, the last strongest.
    case nineTapsBrisk

    /// Nine taps at a quick pace, the last strongest.
    case nineTapsQuick

    /// Nine taps at a fast pace, the last strongest.
    case nineTapsFast

    /// Nine taps at a rapid pace, the last strongest.
    case nineTapsRapid

    /// Ten taps at a lazy pace, the last strongest.
    case tenTapsLazy

    /// Ten taps at a slow pace, the last strongest.
    case tenTapsSlow

    /// Ten taps at a relaxed pace, the last strongest.
    case tenTapsRelaxed

    /// Ten taps at a easy pace, the last strongest.
    case tenTapsEasy

    /// Ten taps at a steady pace, the last strongest.
    case tenTapsSteady

    /// Ten taps at a brisk pace, the last strongest.
    case tenTapsBrisk

    /// Ten taps at a quick pace, the last strongest.
    case tenTapsQuick

    /// Ten taps at a fast pace, the last strongest.
    case tenTapsFast

    /// Ten taps at a rapid pace, the last strongest.
    case tenTapsRapid

    /// Eleven taps at a lazy pace, the last strongest.
    case elevenTapsLazy

    /// Eleven taps at a slow pace, the last strongest.
    case elevenTapsSlow

    /// Eleven taps at a relaxed pace, the last strongest.
    case elevenTapsRelaxed

    /// Eleven taps at a easy pace, the last strongest.
    case elevenTapsEasy

    /// Eleven taps at a steady pace, the last strongest.
    case elevenTapsSteady

    /// Eleven taps at a brisk pace, the last strongest.
    case elevenTapsBrisk

    /// Eleven taps at a quick pace, the last strongest.
    case elevenTapsQuick

    /// Eleven taps at a fast pace, the last strongest.
    case elevenTapsFast

    /// Eleven taps at a rapid pace, the last strongest.
    case elevenTapsRapid

    // MARK: Signals: attention signals, from calm to critical

    /// A crisp ping, once calmly.
    case calmPing

    /// A crisp ping, once softly.
    case softPing

    /// A crisp ping, twice gently.
    case gentlePing

    /// A crisp ping, twice clearly.
    case clearPing

    /// A crisp ping, three times firmly.
    case firmPing

    /// A crisp ping, three times promptly.
    case promptPing

    /// A crisp ping, four times insistently.
    case pressingPing

    /// A crisp ping, four times urgently.
    case urgentPing

    /// A crisp ping, five times with alarm.
    case criticalPing

    /// A chime that rings on, once calmly.
    case calmChime

    /// A chime that rings on, once softly.
    case softChime

    /// A chime that rings on, twice gently.
    case gentleChime

    /// A chime that rings on, twice clearly.
    case clearChime

    /// A chime that rings on, three times firmly.
    case firmChime

    /// A chime that rings on, three times promptly.
    case promptChime

    /// A chime that rings on, four times insistently.
    case pressingChime

    /// A chime that rings on, four times urgently.
    case urgentChime

    /// A chime that rings on, five times with alarm.
    case criticalChime

    /// A bell that fades, once calmly.
    case calmBell

    /// A bell that fades, once softly.
    case softBell

    /// A bell that fades, twice gently.
    case gentleBell

    /// A bell that fades, twice clearly.
    case clearBell

    /// A bell that fades, three times firmly.
    case firmBell

    /// A bell that fades, three times promptly.
    case promptBell

    /// A bell that fades, four times insistently.
    case pressingBell

    /// A bell that fades, four times urgently.
    case urgentBell

    /// A bell that fades, five times with alarm.
    case criticalBell

    /// A short beep, once calmly.
    case calmBeep

    /// A short beep, once softly.
    case softBeep

    /// A short beep, twice gently.
    case gentleBeep

    /// A short beep, twice clearly.
    case clearBeep

    /// A short beep, three times firmly.
    case firmBeep

    /// A short beep, three times promptly.
    case promptBeep

    /// A short beep, four times insistently.
    case pressingBeep

    /// A short beep, four times urgently.
    case urgentBeep

    /// A short beep, five times with alarm.
    case criticalBeep

    /// A low buzz, once calmly.
    case calmBuzz

    /// A low buzz, once softly.
    case softBuzz

    /// A low buzz, twice gently.
    case gentleBuzz

    /// A low buzz, twice clearly.
    case clearBuzz

    /// A low buzz, three times firmly.
    case firmBuzz

    /// A low buzz, three times promptly.
    case promptBuzz

    /// A low buzz, four times insistently.
    case pressingBuzz

    /// A low buzz, four times urgently.
    case urgentBuzz

    /// A low buzz, five times with alarm.
    case criticalBuzz

    /// A rising two-note ding, once calmly.
    case calmDing

    /// A rising two-note ding, once softly.
    case softDing

    /// A rising two-note ding, twice gently.
    case gentleDing

    /// A rising two-note ding, twice clearly.
    case clearDing

    /// A rising two-note ding, three times firmly.
    case firmDing

    /// A rising two-note ding, three times promptly.
    case promptDing

    /// A rising two-note ding, four times insistently.
    case pressingDing

    /// A rising two-note ding, four times urgently.
    case urgentDing

    /// A rising two-note ding, five times with alarm.
    case criticalDing

    /// A quick double pip, once calmly.
    case calmPip

    /// A quick double pip, once softly.
    case softPip

    /// A quick double pip, twice gently.
    case gentlePip

    /// A quick double pip, twice clearly.
    case clearPip

    /// A quick double pip, three times firmly.
    case firmPip

    /// A quick double pip, three times promptly.
    case promptPip

    /// A quick double pip, four times insistently.
    case pressingPip

    /// A quick double pip, four times urgently.
    case urgentPip

    /// A quick double pip, five times with alarm.
    case criticalPip

    /// A long, even tone, once calmly.
    case calmTone

    /// A long, even tone, once softly.
    case softTone

    /// A long, even tone, twice gently.
    case gentleTone

    /// A long, even tone, twice clearly.
    case clearTone

    /// A long, even tone, three times firmly.
    case firmTone

    /// A long, even tone, three times promptly.
    case promptTone

    /// A long, even tone, four times insistently.
    case pressingTone

    /// A long, even tone, four times urgently.
    case urgentTone

    /// A long, even tone, five times with alarm.
    case criticalTone

    /// A wavering siren, once calmly.
    case calmSiren

    /// A wavering siren, once softly.
    case softSiren

    /// A wavering siren, twice gently.
    case gentleSiren

    /// A wavering siren, twice clearly.
    case clearSiren

    /// A wavering siren, three times firmly.
    case firmSiren

    /// A wavering siren, three times promptly.
    case promptSiren

    /// A wavering siren, four times insistently.
    case pressingSiren

    /// A wavering siren, four times urgently.
    case urgentSiren

    /// A wavering siren, five times with alarm.
    case criticalSiren

    /// A two-blast horn, once calmly.
    case calmHorn

    /// A two-blast horn, once softly.
    case softHorn

    /// A two-blast horn, twice gently.
    case gentleHorn

    /// A two-blast horn, twice clearly.
    case clearHorn

    /// A two-blast horn, three times firmly.
    case firmHorn

    /// A two-blast horn, three times promptly.
    case promptHorn

    /// A two-blast horn, four times insistently.
    case pressingHorn

    /// A two-blast horn, four times urgently.
    case urgentHorn

    /// A two-blast horn, five times with alarm.
    case criticalHorn

    // MARK: Meters: one bar of a meter, from 60 to 180 beats per minute

    /// One bar of march at 60 BPM.
    case marchLargo

    /// One bar of march at 75 BPM.
    case marchLarghetto

    /// One bar of march at 90 BPM.
    case marchAdagio

    /// One bar of march at 105 BPM.
    case marchAndante

    /// One bar of march at 120 BPM.
    case marchModerato

    /// One bar of march at 135 BPM.
    case marchAllegretto

    /// One bar of march at 150 BPM.
    case marchAllegro

    /// One bar of march at 165 BPM.
    case marchVivace

    /// One bar of march at 180 BPM.
    case marchPresto

    /// One bar of waltz at 60 BPM.
    case waltzLargo

    /// One bar of waltz at 75 BPM.
    case waltzLarghetto

    /// One bar of waltz at 90 BPM.
    case waltzAdagio

    /// One bar of waltz at 105 BPM.
    case waltzAndante

    /// One bar of waltz at 120 BPM.
    case waltzModerato

    /// One bar of waltz at 135 BPM.
    case waltzAllegretto

    /// One bar of waltz at 150 BPM.
    case waltzAllegro

    /// One bar of waltz at 165 BPM.
    case waltzVivace

    /// One bar of waltz at 180 BPM.
    case waltzPresto

    /// One bar of four-four at 60 BPM.
    case fourFourLargo

    /// One bar of four-four at 75 BPM.
    case fourFourLarghetto

    /// One bar of four-four at 90 BPM.
    case fourFourAdagio

    /// One bar of four-four at 105 BPM.
    case fourFourAndante

    /// One bar of four-four at 120 BPM.
    case fourFourModerato

    /// One bar of four-four at 135 BPM.
    case fourFourAllegretto

    /// One bar of four-four at 150 BPM.
    case fourFourAllegro

    /// One bar of four-four at 165 BPM.
    case fourFourVivace

    /// One bar of four-four at 180 BPM.
    case fourFourPresto

    /// One bar of five-four at 60 BPM.
    case fiveFourLargo

    /// One bar of five-four at 75 BPM.
    case fiveFourLarghetto

    /// One bar of five-four at 90 BPM.
    case fiveFourAdagio

    /// One bar of five-four at 105 BPM.
    case fiveFourAndante

    /// One bar of five-four at 120 BPM.
    case fiveFourModerato

    /// One bar of five-four at 135 BPM.
    case fiveFourAllegretto

    /// One bar of five-four at 150 BPM.
    case fiveFourAllegro

    /// One bar of five-four at 165 BPM.
    case fiveFourVivace

    /// One bar of five-four at 180 BPM.
    case fiveFourPresto

    /// One bar of jig at 60 BPM.
    case jigLargo

    /// One bar of jig at 75 BPM.
    case jigLarghetto

    /// One bar of jig at 90 BPM.
    case jigAdagio

    /// One bar of jig at 105 BPM.
    case jigAndante

    /// One bar of jig at 120 BPM.
    case jigModerato

    /// One bar of jig at 135 BPM.
    case jigAllegretto

    /// One bar of jig at 150 BPM.
    case jigAllegro

    /// One bar of jig at 165 BPM.
    case jigVivace

    /// One bar of jig at 180 BPM.
    case jigPresto

    /// One bar of seven-eight at 60 BPM.
    case sevenEightLargo

    /// One bar of seven-eight at 75 BPM.
    case sevenEightLarghetto

    /// One bar of seven-eight at 90 BPM.
    case sevenEightAdagio

    /// One bar of seven-eight at 105 BPM.
    case sevenEightAndante

    /// One bar of seven-eight at 120 BPM.
    case sevenEightModerato

    /// One bar of seven-eight at 135 BPM.
    case sevenEightAllegretto

    /// One bar of seven-eight at 150 BPM.
    case sevenEightAllegro

    /// One bar of seven-eight at 165 BPM.
    case sevenEightVivace

    /// One bar of seven-eight at 180 BPM.
    case sevenEightPresto

    /// One bar of swing at 60 BPM.
    case swingLargo

    /// One bar of swing at 75 BPM.
    case swingLarghetto

    /// One bar of swing at 90 BPM.
    case swingAdagio

    /// One bar of swing at 105 BPM.
    case swingAndante

    /// One bar of swing at 120 BPM.
    case swingModerato

    /// One bar of swing at 135 BPM.
    case swingAllegretto

    /// One bar of swing at 150 BPM.
    case swingAllegro

    /// One bar of swing at 165 BPM.
    case swingVivace

    /// One bar of swing at 180 BPM.
    case swingPresto

    /// One bar of shuffle at 60 BPM.
    case shuffleLargo

    /// One bar of shuffle at 75 BPM.
    case shuffleLarghetto

    /// One bar of shuffle at 90 BPM.
    case shuffleAdagio

    /// One bar of shuffle at 105 BPM.
    case shuffleAndante

    /// One bar of shuffle at 120 BPM.
    case shuffleModerato

    /// One bar of shuffle at 135 BPM.
    case shuffleAllegretto

    /// One bar of shuffle at 150 BPM.
    case shuffleAllegro

    /// One bar of shuffle at 165 BPM.
    case shuffleVivace

    /// One bar of shuffle at 180 BPM.
    case shufflePresto

    /// One bar of son clave at 60 BPM.
    case claveLargo

    /// One bar of son clave at 75 BPM.
    case claveLarghetto

    /// One bar of son clave at 90 BPM.
    case claveAdagio

    /// One bar of son clave at 105 BPM.
    case claveAndante

    /// One bar of son clave at 120 BPM.
    case claveModerato

    /// One bar of son clave at 135 BPM.
    case claveAllegretto

    /// One bar of son clave at 150 BPM.
    case claveAllegro

    /// One bar of son clave at 165 BPM.
    case claveVivace

    /// One bar of son clave at 180 BPM.
    case clavePresto

    /// One bar of bossa nova at 60 BPM.
    case bossaNovaLargo

    /// One bar of bossa nova at 75 BPM.
    case bossaNovaLarghetto

    /// One bar of bossa nova at 90 BPM.
    case bossaNovaAdagio

    /// One bar of bossa nova at 105 BPM.
    case bossaNovaAndante

    /// One bar of bossa nova at 120 BPM.
    case bossaNovaModerato

    /// One bar of bossa nova at 135 BPM.
    case bossaNovaAllegretto

    /// One bar of bossa nova at 150 BPM.
    case bossaNovaAllegro

    /// One bar of bossa nova at 165 BPM.
    case bossaNovaVivace

    /// One bar of bossa nova at 180 BPM.
    case bossaNovaPresto

    // MARK: Surfaces: a finger drawn across a surface, from a crawl to a rush

    /// A finger across sand, barely moving.
    case crawlOverSand

    /// A finger across sand, creeping.
    case creepOverSand

    /// A finger across sand, drifting.
    case driftOverSand

    /// A finger across sand, at a stroll.
    case strollOverSand

    /// A finger across sand, at a walk.
    case walkOverSand

    /// A finger across sand, jogging.
    case jogOverSand

    /// A finger across sand, running.
    case runOverSand

    /// A finger across sand, sprinting.
    case sprintOverSand

    /// A finger across sand, in a rush.
    case rushOverSand

    /// A finger across gravel, barely moving.
    case crawlOverGravel

    /// A finger across gravel, creeping.
    case creepOverGravel

    /// A finger across gravel, drifting.
    case driftOverGravel

    /// A finger across gravel, at a stroll.
    case strollOverGravel

    /// A finger across gravel, at a walk.
    case walkOverGravel

    /// A finger across gravel, jogging.
    case jogOverGravel

    /// A finger across gravel, running.
    case runOverGravel

    /// A finger across gravel, sprinting.
    case sprintOverGravel

    /// A finger across gravel, in a rush.
    case rushOverGravel

    /// A finger across silk, barely moving.
    case crawlOverSilk

    /// A finger across silk, creeping.
    case creepOverSilk

    /// A finger across silk, drifting.
    case driftOverSilk

    /// A finger across silk, at a stroll.
    case strollOverSilk

    /// A finger across silk, at a walk.
    case walkOverSilk

    /// A finger across silk, jogging.
    case jogOverSilk

    /// A finger across silk, running.
    case runOverSilk

    /// A finger across silk, sprinting.
    case sprintOverSilk

    /// A finger across silk, in a rush.
    case rushOverSilk

    /// A finger across velvet, barely moving.
    case crawlOverVelvet

    /// A finger across velvet, creeping.
    case creepOverVelvet

    /// A finger across velvet, drifting.
    case driftOverVelvet

    /// A finger across velvet, at a stroll.
    case strollOverVelvet

    /// A finger across velvet, at a walk.
    case walkOverVelvet

    /// A finger across velvet, jogging.
    case jogOverVelvet

    /// A finger across velvet, running.
    case runOverVelvet

    /// A finger across velvet, sprinting.
    case sprintOverVelvet

    /// A finger across velvet, in a rush.
    case rushOverVelvet

    /// A finger across corduroy, barely moving.
    case crawlOverCorduroy

    /// A finger across corduroy, creeping.
    case creepOverCorduroy

    /// A finger across corduroy, drifting.
    case driftOverCorduroy

    /// A finger across corduroy, at a stroll.
    case strollOverCorduroy

    /// A finger across corduroy, at a walk.
    case walkOverCorduroy

    /// A finger across corduroy, jogging.
    case jogOverCorduroy

    /// A finger across corduroy, running.
    case runOverCorduroy

    /// A finger across corduroy, sprinting.
    case sprintOverCorduroy

    /// A finger across corduroy, in a rush.
    case rushOverCorduroy

    /// A finger across brick, barely moving.
    case crawlOverBrick

    /// A finger across brick, creeping.
    case creepOverBrick

    /// A finger across brick, drifting.
    case driftOverBrick

    /// A finger across brick, at a stroll.
    case strollOverBrick

    /// A finger across brick, at a walk.
    case walkOverBrick

    /// A finger across brick, jogging.
    case jogOverBrick

    /// A finger across brick, running.
    case runOverBrick

    /// A finger across brick, sprinting.
    case sprintOverBrick

    /// A finger across brick, in a rush.
    case rushOverBrick

    /// A finger across tile, barely moving.
    case crawlOverTile

    /// A finger across tile, creeping.
    case creepOverTile

    /// A finger across tile, drifting.
    case driftOverTile

    /// A finger across tile, at a stroll.
    case strollOverTile

    /// A finger across tile, at a walk.
    case walkOverTile

    /// A finger across tile, jogging.
    case jogOverTile

    /// A finger across tile, running.
    case runOverTile

    /// A finger across tile, sprinting.
    case sprintOverTile

    /// A finger across tile, in a rush.
    case rushOverTile

    /// A finger across ice, barely moving.
    case crawlOverIce

    /// A finger across ice, creeping.
    case creepOverIce

    /// A finger across ice, drifting.
    case driftOverIce

    /// A finger across ice, at a stroll.
    case strollOverIce

    /// A finger across ice, at a walk.
    case walkOverIce

    /// A finger across ice, jogging.
    case jogOverIce

    /// A finger across ice, running.
    case runOverIce

    /// A finger across ice, sprinting.
    case sprintOverIce

    /// A finger across ice, in a rush.
    case rushOverIce

    /// A finger across bark, barely moving.
    case crawlOverBark

    /// A finger across bark, creeping.
    case creepOverBark

    /// A finger across bark, drifting.
    case driftOverBark

    /// A finger across bark, at a stroll.
    case strollOverBark

    /// A finger across bark, at a walk.
    case walkOverBark

    /// A finger across bark, jogging.
    case jogOverBark

    /// A finger across bark, running.
    case runOverBark

    /// A finger across bark, sprinting.
    case sprintOverBark

    /// A finger across bark, in a rush.
    case rushOverBark

    /// A finger across carpet, barely moving.
    case crawlOverCarpet

    /// A finger across carpet, creeping.
    case creepOverCarpet

    /// A finger across carpet, drifting.
    case driftOverCarpet

    /// A finger across carpet, at a stroll.
    case strollOverCarpet

    /// A finger across carpet, at a walk.
    case walkOverCarpet

    /// A finger across carpet, jogging.
    case jogOverCarpet

    /// A finger across carpet, running.
    case runOverCarpet

    /// A finger across carpet, sprinting.
    case sprintOverCarpet

    /// A finger across carpet, in a rush.
    case rushOverCarpet

    // MARK: Waves: waveforms over a second and a half, from one cycle to five

    /// Swelling and easing smoothly, once.
    case glacialSwell

    /// Swelling and easing smoothly, one and a half times.
    case languidSwell

    /// Swelling and easing smoothly, twice.
    case slowSwell

    /// Swelling and easing smoothly, two and a half times.
    case easySwell

    /// Swelling and easing smoothly, three times.
    case moderateSwell

    /// Swelling and easing smoothly, three and a half times.
    case livelySwell

    /// Swelling and easing smoothly, four times.
    case fastSwell

    /// Swelling and easing smoothly, four and a half times.
    case rapidSwell

    /// Swelling and easing smoothly, five times.
    case franticSwell

    /// Rising, then dropping back, once.
    case glacialRise

    /// Rising, then dropping back, one and a half times.
    case languidRise

    /// Rising, then dropping back, twice.
    case slowRise

    /// Rising, then dropping back, two and a half times.
    case easyRise

    /// Rising, then dropping back, three times.
    case moderateRise

    /// Rising, then dropping back, three and a half times.
    case livelyRise

    /// Rising, then dropping back, four times.
    case fastRise

    /// Rising, then dropping back, four and a half times.
    case rapidRise

    /// Rising, then dropping back, five times.
    case franticRise

    /// Falling, then jumping back, once.
    case glacialFall

    /// Falling, then jumping back, one and a half times.
    case languidFall

    /// Falling, then jumping back, twice.
    case slowFall

    /// Falling, then jumping back, two and a half times.
    case easyFall

    /// Falling, then jumping back, three times.
    case moderateFall

    /// Falling, then jumping back, three and a half times.
    case livelyFall

    /// Falling, then jumping back, four times.
    case fastFall

    /// Falling, then jumping back, four and a half times.
    case rapidFall

    /// Falling, then jumping back, five times.
    case franticFall

    /// Switching hard on and off, once.
    case glacialSquare

    /// Switching hard on and off, one and a half times.
    case languidSquare

    /// Switching hard on and off, twice.
    case slowSquare

    /// Switching hard on and off, two and a half times.
    case easySquare

    /// Switching hard on and off, three times.
    case moderateSquare

    /// Switching hard on and off, three and a half times.
    case livelySquare

    /// Switching hard on and off, four times.
    case fastSquare

    /// Switching hard on and off, four and a half times.
    case rapidSquare

    /// Switching hard on and off, five times.
    case franticSquare

    /// Rising and falling evenly, once.
    case glacialTriangle

    /// Rising and falling evenly, one and a half times.
    case languidTriangle

    /// Rising and falling evenly, twice.
    case slowTriangle

    /// Rising and falling evenly, two and a half times.
    case easyTriangle

    /// Rising and falling evenly, three times.
    case moderateTriangle

    /// Rising and falling evenly, three and a half times.
    case livelyTriangle

    /// Rising and falling evenly, four times.
    case fastTriangle

    /// Rising and falling evenly, four and a half times.
    case rapidTriangle

    /// Rising and falling evenly, five times.
    case franticTriangle

    /// Flickering crisp and soft, once.
    case glacialFlutter

    /// Flickering crisp and soft, one and a half times.
    case languidFlutter

    /// Flickering crisp and soft, twice.
    case slowFlutter

    /// Flickering crisp and soft, two and a half times.
    case easyFlutter

    /// Flickering crisp and soft, three times.
    case moderateFlutter

    /// Flickering crisp and soft, three and a half times.
    case livelyFlutter

    /// Flickering crisp and soft, four times.
    case fastFlutter

    /// Flickering crisp and soft, four and a half times.
    case rapidFlutter

    /// Flickering crisp and soft, five times.
    case franticFlutter

    /// Peaking in sharp throbs, once.
    case glacialThrob

    /// Peaking in sharp throbs, one and a half times.
    case languidThrob

    /// Peaking in sharp throbs, twice.
    case slowThrob

    /// Peaking in sharp throbs, two and a half times.
    case easyThrob

    /// Peaking in sharp throbs, three times.
    case moderateThrob

    /// Peaking in sharp throbs, three and a half times.
    case livelyThrob

    /// Peaking in sharp throbs, four times.
    case fastThrob

    /// Peaking in sharp throbs, four and a half times.
    case rapidThrob

    /// Peaking in sharp throbs, five times.
    case franticThrob

    /// Breathing softly in and out, once.
    case glacialBreath

    /// Breathing softly in and out, one and a half times.
    case languidBreath

    /// Breathing softly in and out, twice.
    case slowBreath

    /// Breathing softly in and out, two and a half times.
    case easyBreath

    /// Breathing softly in and out, three times.
    case moderateBreath

    /// Breathing softly in and out, three and a half times.
    case livelyBreath

    /// Breathing softly in and out, four times.
    case fastBreath

    /// Breathing softly in and out, four and a half times.
    case rapidBreath

    /// Breathing softly in and out, five times.
    case franticBreath

    /// Rippling as it fades, once.
    case glacialRipple

    /// Rippling as it fades, one and a half times.
    case languidRipple

    /// Rippling as it fades, twice.
    case slowRipple

    /// Rippling as it fades, two and a half times.
    case easyRipple

    /// Rippling as it fades, three times.
    case moderateRipple

    /// Rippling as it fades, three and a half times.
    case livelyRipple

    /// Rippling as it fades, four times.
    case fastRipple

    /// Rippling as it fades, four and a half times.
    case rapidRipple

    /// Rippling as it fades, five times.
    case franticRipple

    /// Wavering in sharpness, once.
    case glacialWobble

    /// Wavering in sharpness, one and a half times.
    case languidWobble

    /// Wavering in sharpness, twice.
    case slowWobble

    /// Wavering in sharpness, two and a half times.
    case easyWobble

    /// Wavering in sharpness, three times.
    case moderateWobble

    /// Wavering in sharpness, three and a half times.
    case livelyWobble

    /// Wavering in sharpness, four times.
    case fastWobble

    /// Wavering in sharpness, four and a half times.
    case rapidWobble

    /// Wavering in sharpness, five times.
    case franticWobble

    // MARK: Dynamics: changes in strength or sharpness, from 0.2 to 1.8 seconds long

    /// Growing steadily stronger over 0.2 s.
    case flashCrescendo

    /// Growing steadily stronger over 0.4 s.
    case quickCrescendo

    /// Growing steadily stronger over 0.6 s.
    case shortCrescendo

    /// Growing steadily stronger over 0.8 s.
    case measuredCrescendo

    /// Growing steadily stronger over 1.0 s.
    case mediumCrescendo

    /// Growing steadily stronger over 1.2 s.
    case longCrescendo

    /// Growing steadily stronger over 1.4 s.
    case extendedCrescendo

    /// Growing steadily stronger over 1.6 s.
    case slowCrescendo

    /// Growing steadily stronger over 1.8 s.
    case sustainedCrescendo

    /// Fading steadily weaker over 0.2 s.
    case flashDecrescendo

    /// Fading steadily weaker over 0.4 s.
    case quickDecrescendo

    /// Fading steadily weaker over 0.6 s.
    case shortDecrescendo

    /// Fading steadily weaker over 0.8 s.
    case measuredDecrescendo

    /// Fading steadily weaker over 1.0 s.
    case mediumDecrescendo

    /// Fading steadily weaker over 1.2 s.
    case longDecrescendo

    /// Fading steadily weaker over 1.4 s.
    case extendedDecrescendo

    /// Fading steadily weaker over 1.6 s.
    case slowDecrescendo

    /// Fading steadily weaker over 1.8 s.
    case sustainedDecrescendo

    /// A quick rise and a slow fall over 0.2 s.
    case flashSurge

    /// A quick rise and a slow fall over 0.4 s.
    case quickSurge

    /// A quick rise and a slow fall over 0.6 s.
    case shortSurge

    /// A quick rise and a slow fall over 0.8 s.
    case measuredSurge

    /// A quick rise and a slow fall over 1.0 s.
    case mediumSurge

    /// A quick rise and a slow fall over 1.2 s.
    case longSurge

    /// A quick rise and a slow fall over 1.4 s.
    case extendedSurge

    /// A quick rise and a slow fall over 1.6 s.
    case slowSurge

    /// A quick rise and a slow fall over 1.8 s.
    case sustainedSurge

    /// A slow fall and a small return over 0.2 s.
    case flashEbb

    /// A slow fall and a small return over 0.4 s.
    case quickEbb

    /// A slow fall and a small return over 0.6 s.
    case shortEbb

    /// A slow fall and a small return over 0.8 s.
    case measuredEbb

    /// A slow fall and a small return over 1.0 s.
    case mediumEbb

    /// A slow fall and a small return over 1.2 s.
    case longEbb

    /// A slow fall and a small return over 1.4 s.
    case extendedEbb

    /// A slow fall and a small return over 1.6 s.
    case slowEbb

    /// A slow fall and a small return over 1.8 s.
    case sustainedEbb

    /// Taps climbing in strength over 0.2 s.
    case flashClimb

    /// Taps climbing in strength over 0.4 s.
    case quickClimb

    /// Taps climbing in strength over 0.6 s.
    case shortClimb

    /// Taps climbing in strength over 0.8 s.
    case measuredClimb

    /// Taps climbing in strength over 1.0 s.
    case mediumClimb

    /// Taps climbing in strength over 1.2 s.
    case longClimb

    /// Taps climbing in strength over 1.4 s.
    case extendedClimb

    /// Taps climbing in strength over 1.6 s.
    case slowClimb

    /// Taps climbing in strength over 1.8 s.
    case sustainedClimb

    /// Taps dropping in strength over 0.2 s.
    case flashPlunge

    /// Taps dropping in strength over 0.4 s.
    case quickPlunge

    /// Taps dropping in strength over 0.6 s.
    case shortPlunge

    /// Taps dropping in strength over 0.8 s.
    case measuredPlunge

    /// Taps dropping in strength over 1.0 s.
    case mediumPlunge

    /// Taps dropping in strength over 1.2 s.
    case longPlunge

    /// Taps dropping in strength over 1.4 s.
    case extendedPlunge

    /// Taps dropping in strength over 1.6 s.
    case slowPlunge

    /// Taps dropping in strength over 1.8 s.
    case sustainedPlunge

    /// Steady, growing sharper over 0.2 s.
    case flashBloom

    /// Steady, growing sharper over 0.4 s.
    case quickBloom

    /// Steady, growing sharper over 0.6 s.
    case shortBloom

    /// Steady, growing sharper over 0.8 s.
    case measuredBloom

    /// Steady, growing sharper over 1.0 s.
    case mediumBloom

    /// Steady, growing sharper over 1.2 s.
    case longBloom

    /// Steady, growing sharper over 1.4 s.
    case extendedBloom

    /// Steady, growing sharper over 1.6 s.
    case slowBloom

    /// Steady, growing sharper over 1.8 s.
    case sustainedBloom

    /// Softening and dulling over 0.2 s.
    case flashWilt

    /// Softening and dulling over 0.4 s.
    case quickWilt

    /// Softening and dulling over 0.6 s.
    case shortWilt

    /// Softening and dulling over 0.8 s.
    case measuredWilt

    /// Softening and dulling over 1.0 s.
    case mediumWilt

    /// Softening and dulling over 1.2 s.
    case longWilt

    /// Softening and dulling over 1.4 s.
    case extendedWilt

    /// Softening and dulling over 1.6 s.
    case slowWilt

    /// Softening and dulling over 1.8 s.
    case sustainedWilt

    /// A sharp peak, then a low hum over 0.2 s.
    case flashSpike

    /// A sharp peak, then a low hum over 0.4 s.
    case quickSpike

    /// A sharp peak, then a low hum over 0.6 s.
    case shortSpike

    /// A sharp peak, then a low hum over 0.8 s.
    case measuredSpike

    /// A sharp peak, then a low hum over 1.0 s.
    case mediumSpike

    /// A sharp peak, then a low hum over 1.2 s.
    case longSpike

    /// A sharp peak, then a low hum over 1.4 s.
    case extendedSpike

    /// A sharp peak, then a low hum over 1.6 s.
    case slowSpike

    /// A sharp peak, then a low hum over 1.8 s.
    case sustainedSpike

    /// Rising, holding, then falling over 0.2 s.
    case flashPlateau

    /// Rising, holding, then falling over 0.4 s.
    case quickPlateau

    /// Rising, holding, then falling over 0.6 s.
    case shortPlateau

    /// Rising, holding, then falling over 0.8 s.
    case measuredPlateau

    /// Rising, holding, then falling over 1.0 s.
    case mediumPlateau

    /// Rising, holding, then falling over 1.2 s.
    case longPlateau

    /// Rising, holding, then falling over 1.4 s.
    case extendedPlateau

    /// Rising, holding, then falling over 1.6 s.
    case slowPlateau

    /// Rising, holding, then falling over 1.8 s.
    case sustainedPlateau

    // MARK: Weather: weather and water, from faint to extreme

    /// Fine, scattered drops, faint.
    case faintDrizzle

    /// Fine, scattered drops, light.
    case lightDrizzle

    /// Fine, scattered drops, gentle.
    case gentleDrizzle

    /// Fine, scattered drops, moderate.
    case moderateDrizzle

    /// Fine, scattered drops, steady.
    case steadyDrizzle

    /// Fine, scattered drops, strong.
    case strongDrizzle

    /// Fine, scattered drops, heavy.
    case heavyDrizzle

    /// Fine, scattered drops, intense.
    case intenseDrizzle

    /// Fine, scattered drops, extreme.
    case extremeDrizzle

    /// Drops falling at random, faint.
    case faintRain

    /// Drops falling at random, light.
    case lightRain

    /// Drops falling at random, gentle.
    case gentleRain

    /// Drops falling at random, moderate.
    case moderateRain

    /// Drops falling at random, steady.
    case steadyRain

    /// Drops falling at random, strong.
    case strongRain

    /// Drops falling at random, heavy.
    case heavyRain

    /// Drops falling at random, intense.
    case intenseRain

    /// Drops falling at random, extreme.
    case extremeRain

    /// Hard, sharp pellets, faint.
    case faintHail

    /// Hard, sharp pellets, light.
    case lightHail

    /// Hard, sharp pellets, gentle.
    case gentleHail

    /// Hard, sharp pellets, moderate.
    case moderateHail

    /// Hard, sharp pellets, steady.
    case steadyHail

    /// Hard, sharp pellets, strong.
    case strongHail

    /// Hard, sharp pellets, heavy.
    case heavyHail

    /// Hard, sharp pellets, intense.
    case intenseHail

    /// Hard, sharp pellets, extreme.
    case extremeHail

    /// Gusts rising and falling, faint.
    case faintWind

    /// Gusts rising and falling, light.
    case lightWind

    /// Gusts rising and falling, gentle.
    case gentleWind

    /// Gusts rising and falling, moderate.
    case moderateWind

    /// Gusts rising and falling, steady.
    case steadyWind

    /// Gusts rising and falling, strong.
    case strongWind

    /// Gusts rising and falling, heavy.
    case heavyWind

    /// Gusts rising and falling, intense.
    case intenseWind

    /// Gusts rising and falling, extreme.
    case extremeWind

    /// A crack, then a rolling rumble, faint.
    case faintThunder

    /// A crack, then a rolling rumble, light.
    case lightThunder

    /// A crack, then a rolling rumble, gentle.
    case gentleThunder

    /// A crack, then a rolling rumble, moderate.
    case moderateThunder

    /// A crack, then a rolling rumble, steady.
    case steadyThunder

    /// A crack, then a rolling rumble, strong.
    case strongThunder

    /// A crack, then a rolling rumble, heavy.
    case heavyThunder

    /// A crack, then a rolling rumble, intense.
    case intenseThunder

    /// A crack, then a rolling rumble, extreme.
    case extremeThunder

    /// Waves rolling in, faint.
    case faintSurf

    /// Waves rolling in, light.
    case lightSurf

    /// Waves rolling in, gentle.
    case gentleSurf

    /// Waves rolling in, moderate.
    case moderateSurf

    /// Waves rolling in, steady.
    case steadySurf

    /// Waves rolling in, strong.
    case strongSurf

    /// Waves rolling in, heavy.
    case heavySurf

    /// Waves rolling in, intense.
    case intenseSurf

    /// Waves rolling in, extreme.
    case extremeSurf

    /// Water running over stones, faint.
    case faintStream

    /// Water running over stones, light.
    case lightStream

    /// Water running over stones, gentle.
    case gentleStream

    /// Water running over stones, moderate.
    case moderateStream

    /// Water running over stones, steady.
    case steadyStream

    /// Water running over stones, strong.
    case strongStream

    /// Water running over stones, heavy.
    case heavyStream

    /// Water running over stones, intense.
    case intenseStream

    /// Water running over stones, extreme.
    case extremeStream

    /// The ground shaking, faint.
    case faintTremor

    /// The ground shaking, light.
    case lightTremor

    /// The ground shaking, gentle.
    case gentleTremor

    /// The ground shaking, moderate.
    case moderateTremor

    /// The ground shaking, steady.
    case steadyTremor

    /// The ground shaking, strong.
    case strongTremor

    /// The ground shaking, heavy.
    case heavyTremor

    /// The ground shaking, intense.
    case intenseTremor

    /// The ground shaking, extreme.
    case extremeTremor

    /// A crackling fire, faint.
    case faintFire

    /// A crackling fire, light.
    case lightFire

    /// A crackling fire, gentle.
    case gentleFire

    /// A crackling fire, moderate.
    case moderateFire

    /// A crackling fire, steady.
    case steadyFire

    /// A crackling fire, strong.
    case strongFire

    /// A crackling fire, heavy.
    case heavyFire

    /// A crackling fire, intense.
    case intenseFire

    /// A crackling fire, extreme.
    case extremeFire

    /// Icy drops in a cold hiss, faint.
    case faintSleet

    /// Icy drops in a cold hiss, light.
    case lightSleet

    /// Icy drops in a cold hiss, gentle.
    case gentleSleet

    /// Icy drops in a cold hiss, moderate.
    case moderateSleet

    /// Icy drops in a cold hiss, steady.
    case steadySleet

    /// Icy drops in a cold hiss, strong.
    case strongSleet

    /// Icy drops in a cold hiss, heavy.
    case heavySleet

    /// Icy drops in a cold hiss, intense.
    case intenseSleet

    /// Icy drops in a cold hiss, extreme.
    case extremeSleet

    // MARK: Machines: machines running, from idle to the redline

    /// A humming motor, at idle.
    case idleMotor

    /// A humming motor, turning slowly.
    case lowMotor

    /// A humming motor, at an easy pace.
    case easyMotor

    /// A humming motor, cruising.
    case cruisingMotor

    /// A humming motor, running steadily.
    case steadyMotor

    /// A humming motor, working hard.
    case busyMotor

    /// A humming motor, at high speed.
    case highMotor

    /// A humming motor, racing.
    case racingMotor

    /// A humming motor, at the redline.
    case redlineMotor

    /// An engine's firing strokes, at idle.
    case idleEngine

    /// An engine's firing strokes, turning slowly.
    case lowEngine

    /// An engine's firing strokes, at an easy pace.
    case easyEngine

    /// An engine's firing strokes, cruising.
    case cruisingEngine

    /// An engine's firing strokes, running steadily.
    case steadyEngine

    /// An engine's firing strokes, working hard.
    case busyEngine

    /// An engine's firing strokes, at high speed.
    case highEngine

    /// An engine's firing strokes, racing.
    case racingEngine

    /// An engine's firing strokes, at the redline.
    case redlineEngine

    /// Fan blades sweeping past, at idle.
    case idleFan

    /// Fan blades sweeping past, turning slowly.
    case lowFan

    /// Fan blades sweeping past, at an easy pace.
    case easyFan

    /// Fan blades sweeping past, cruising.
    case cruisingFan

    /// Fan blades sweeping past, running steadily.
    case steadyFan

    /// Fan blades sweeping past, working hard.
    case busyFan

    /// Fan blades sweeping past, at high speed.
    case highFan

    /// Fan blades sweeping past, racing.
    case racingFan

    /// Fan blades sweeping past, at the redline.
    case redlineFan

    /// A drill bit spinning, at idle.
    case idleDrill

    /// A drill bit spinning, turning slowly.
    case lowDrill

    /// A drill bit spinning, at an easy pace.
    case easyDrill

    /// A drill bit spinning, cruising.
    case cruisingDrill

    /// A drill bit spinning, running steadily.
    case steadyDrill

    /// A drill bit spinning, working hard.
    case busyDrill

    /// A drill bit spinning, at high speed.
    case highDrill

    /// A drill bit spinning, racing.
    case racingDrill

    /// A drill bit spinning, at the redline.
    case redlineDrill

    /// A pump pushing and releasing, at idle.
    case idlePump

    /// A pump pushing and releasing, turning slowly.
    case lowPump

    /// A pump pushing and releasing, at an easy pace.
    case easyPump

    /// A pump pushing and releasing, cruising.
    case cruisingPump

    /// A pump pushing and releasing, running steadily.
    case steadyPump

    /// A pump pushing and releasing, working hard.
    case busyPump

    /// A pump pushing and releasing, at high speed.
    case highPump

    /// A pump pushing and releasing, racing.
    case racingPump

    /// A pump pushing and releasing, at the redline.
    case redlinePump

    /// A saw rasping back and forth, at idle.
    case idleSaw

    /// A saw rasping back and forth, turning slowly.
    case lowSaw

    /// A saw rasping back and forth, at an easy pace.
    case easySaw

    /// A saw rasping back and forth, cruising.
    case cruisingSaw

    /// A saw rasping back and forth, running steadily.
    case steadySaw

    /// A saw rasping back and forth, working hard.
    case busySaw

    /// A saw rasping back and forth, at high speed.
    case highSaw

    /// A saw rasping back and forth, racing.
    case racingSaw

    /// A saw rasping back and forth, at the redline.
    case redlineSaw

    /// Gears meshing, at idle.
    case idleGearbox

    /// Gears meshing, turning slowly.
    case lowGearbox

    /// Gears meshing, at an easy pace.
    case easyGearbox

    /// Gears meshing, cruising.
    case cruisingGearbox

    /// Gears meshing, running steadily.
    case steadyGearbox

    /// Gears meshing, working hard.
    case busyGearbox

    /// Gears meshing, at high speed.
    case highGearbox

    /// Gears meshing, racing.
    case racingGearbox

    /// Gears meshing, at the redline.
    case redlineGearbox

    /// A ratchet clicking, at idle.
    case idleRatchet

    /// A ratchet clicking, turning slowly.
    case lowRatchet

    /// A ratchet clicking, at an easy pace.
    case easyRatchet

    /// A ratchet clicking, cruising.
    case cruisingRatchet

    /// A ratchet clicking, running steadily.
    case steadyRatchet

    /// A ratchet clicking, working hard.
    case busyRatchet

    /// A ratchet clicking, at high speed.
    case highRatchet

    /// A ratchet clicking, racing.
    case racingRatchet

    /// A ratchet clicking, at the redline.
    case redlineRatchet

    /// Clockwork ticking, at idle.
    case idleClockwork

    /// Clockwork ticking, turning slowly.
    case lowClockwork

    /// Clockwork ticking, at an easy pace.
    case easyClockwork

    /// Clockwork ticking, cruising.
    case cruisingClockwork

    /// Clockwork ticking, running steadily.
    case steadyClockwork

    /// Clockwork ticking, working hard.
    case busyClockwork

    /// Clockwork ticking, at high speed.
    case highClockwork

    /// Clockwork ticking, racing.
    case racingClockwork

    /// Clockwork ticking, at the redline.
    case redlineClockwork

    /// A needle stitching, at idle.
    case idleSewingMachine

    /// A needle stitching, turning slowly.
    case lowSewingMachine

    /// A needle stitching, at an easy pace.
    case easySewingMachine

    /// A needle stitching, cruising.
    case cruisingSewingMachine

    /// A needle stitching, running steadily.
    case steadySewingMachine

    /// A needle stitching, working hard.
    case busySewingMachine

    /// A needle stitching, at high speed.
    case highSewingMachine

    /// A needle stitching, racing.
    case racingSewingMachine

    /// A needle stitching, at the redline.
    case redlineSewingMachine

    // MARK: Arcade: game actions, from tiny to epic

    /// A push upward, tiny.
    case tinyJump

    /// A push upward, small.
    case smallJump

    /// A push upward, light.
    case lightJump

    /// A push upward, medium.
    case mediumJump

    /// A push upward, big.
    case bigJump

    /// A push upward, heavy.
    case heavyJump

    /// A push upward, huge.
    case hugeJump

    /// A push upward, giant.
    case giantJump

    /// A push upward, epic.
    case epicJump

    /// A thud and a settle, tiny.
    case tinyLanding

    /// A thud and a settle, small.
    case smallLanding

    /// A thud and a settle, light.
    case lightLanding

    /// A thud and a settle, medium.
    case mediumLanding

    /// A thud and a settle, big.
    case bigLanding

    /// A thud and a settle, heavy.
    case heavyLanding

    /// A thud and a settle, huge.
    case hugeLanding

    /// A thud and a settle, giant.
    case giantLanding

    /// A thud and a settle, epic.
    case epicLanding

    /// A strike and a rebound, tiny.
    case tinyHit

    /// A strike and a rebound, small.
    case smallHit

    /// A strike and a rebound, light.
    case lightHit

    /// A strike and a rebound, medium.
    case mediumHit

    /// A strike and a rebound, big.
    case bigHit

    /// A strike and a rebound, heavy.
    case heavyHit

    /// A strike and a rebound, huge.
    case hugeHit

    /// A strike and a rebound, giant.
    case giantHit

    /// A strike and a rebound, epic.
    case epicHit

    /// A quick burst forward, tiny.
    case tinyDash

    /// A quick burst forward, small.
    case smallDash

    /// A quick burst forward, light.
    case lightDash

    /// A quick burst forward, medium.
    case mediumDash

    /// A quick burst forward, big.
    case bigDash

    /// A quick burst forward, heavy.
    case heavyDash

    /// A quick burst forward, huge.
    case hugeDash

    /// A quick burst forward, giant.
    case giantDash

    /// A quick burst forward, epic.
    case epicDash

    /// A crisp shot and its kick, tiny.
    case tinyShot

    /// A crisp shot and its kick, small.
    case smallShot

    /// A crisp shot and its kick, light.
    case lightShot

    /// A crisp shot and its kick, medium.
    case mediumShot

    /// A crisp shot and its kick, big.
    case bigShot

    /// A crisp shot and its kick, heavy.
    case heavyShot

    /// A crisp shot and its kick, huge.
    case hugeShot

    /// A crisp shot and its kick, giant.
    case giantShot

    /// A crisp shot and its kick, epic.
    case epicShot

    /// Power building up, tiny.
    case tinyCharge

    /// Power building up, small.
    case smallCharge

    /// Power building up, light.
    case lightCharge

    /// Power building up, medium.
    case mediumCharge

    /// Power building up, big.
    case bigCharge

    /// Power building up, heavy.
    case heavyCharge

    /// Power building up, huge.
    case hugeCharge

    /// Power building up, giant.
    case giantCharge

    /// Power building up, epic.
    case epicCharge

    /// Bright rising taps, tiny.
    case tinyPickup

    /// Bright rising taps, small.
    case smallPickup

    /// Bright rising taps, light.
    case lightPickup

    /// Bright rising taps, medium.
    case mediumPickup

    /// Bright rising taps, big.
    case bigPickup

    /// Bright rising taps, heavy.
    case heavyPickup

    /// Bright rising taps, huge.
    case hugePickup

    /// Bright rising taps, giant.
    case giantPickup

    /// Bright rising taps, epic.
    case epicPickup

    /// Rising taps and a bright hold, tiny.
    case tinyLevelUp

    /// Rising taps and a bright hold, small.
    case smallLevelUp

    /// Rising taps and a bright hold, light.
    case lightLevelUp

    /// Rising taps and a bright hold, medium.
    case mediumLevelUp

    /// Rising taps and a bright hold, big.
    case bigLevelUp

    /// Rising taps and a bright hold, heavy.
    case heavyLevelUp

    /// Rising taps and a bright hold, huge.
    case hugeLevelUp

    /// Rising taps and a bright hold, giant.
    case giantLevelUp

    /// Rising taps and a bright hold, epic.
    case epicLevelUp

    /// A blow and a shake, tiny.
    case tinyDamage

    /// A blow and a shake, small.
    case smallDamage

    /// A blow and a shake, light.
    case lightDamage

    /// A blow and a shake, medium.
    case mediumDamage

    /// A blow and a shake, big.
    case bigDamage

    /// A blow and a shake, heavy.
    case heavyDamage

    /// A blow and a shake, huge.
    case hugeDamage

    /// A blow and a shake, giant.
    case giantDamage

    /// A blow and a shake, epic.
    case epicDamage

    /// A shimmering barrier, tiny.
    case tinyShield

    /// A shimmering barrier, small.
    case smallShield

    /// A shimmering barrier, light.
    case lightShield

    /// A shimmering barrier, medium.
    case mediumShield

    /// A shimmering barrier, big.
    case bigShield

    /// A shimmering barrier, heavy.
    case heavyShield

    /// A shimmering barrier, huge.
    case hugeShield

    /// A shimmering barrier, giant.
    case giantShield

    /// A shimmering barrier, epic.
    case epicShield
    // END GENERATED PATTERNS

    /// How long the pattern plays, in seconds: from its first event to the end of its last. A single tap,
    /// like ``tick``, is `0`.
    ///
    /// The engine doesn't report when a pattern ends, so use this to time UI to it.
    public var duration: TimeInterval {
        HapticPatterns.info(for: self).duration
    }

    /// The taps and holds that make up the pattern, in time order: for showing or inspecting it, such as
    /// drawing its timeline.
    public var events: [HapticPatternEvent] {
        HapticPatterns.info(for: self).events
    }
}
