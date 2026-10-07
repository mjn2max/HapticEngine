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

    // MARK: Animals: animal sounds and movements, from tiny to huge

    /// A cat's purr, tiny.
    case tinyPurr

    /// A cat's purr, small.
    case smallPurr

    /// A cat's purr, medium.
    case mediumPurr

    /// A cat's purr, large.
    case largePurr

    /// A cat's purr, huge.
    case hugePurr

    /// A dog's bark, tiny.
    case tinyBark

    /// A dog's bark, small.
    case smallBark

    /// A dog's bark, medium.
    case mediumBark

    /// A dog's bark, large.
    case largeBark

    /// A dog's bark, huge.
    case hugeBark

    /// Hooves on the ground, tiny.
    case tinyHoofbeats

    /// Hooves on the ground, small.
    case smallHoofbeats

    /// Hooves on the ground, medium.
    case mediumHoofbeats

    /// Hooves on the ground, large.
    case largeHoofbeats

    /// Hooves on the ground, huge.
    case hugeHoofbeats

    /// A rabbit's hops, tiny.
    case tinyHop

    /// A rabbit's hops, small.
    case smallHop

    /// A rabbit's hops, medium.
    case mediumHop

    /// A rabbit's hops, large.
    case largeHop

    /// A rabbit's hops, huge.
    case hugeHop

    /// A bird pecking, tiny.
    case tinyPeck

    /// A bird pecking, small.
    case smallPeck

    /// A bird pecking, medium.
    case mediumPeck

    /// A bird pecking, large.
    case largePeck

    /// A bird pecking, huge.
    case hugePeck

    /// Wings beating, tiny.
    case tinyWingbeat

    /// Wings beating, small.
    case smallWingbeat

    /// Wings beating, medium.
    case mediumWingbeat

    /// Wings beating, large.
    case largeWingbeat

    /// Wings beating, huge.
    case hugeWingbeat

    /// Soft paws padding, tiny.
    case tinyPaws

    /// Soft paws padding, small.
    case smallPaws

    /// Soft paws padding, medium.
    case mediumPaws

    /// Soft paws padding, large.
    case largePaws

    /// Soft paws padding, huge.
    case hugePaws

    /// A snake slithering, tiny.
    case tinySlither

    /// A snake slithering, small.
    case smallSlither

    /// A snake slithering, medium.
    case mediumSlither

    /// A snake slithering, large.
    case largeSlither

    /// A snake slithering, huge.
    case hugeSlither

    /// A bee buzzing, tiny.
    case tinyBee

    /// A bee buzzing, small.
    case smallBee

    /// A bee buzzing, medium.
    case mediumBee

    /// A bee buzzing, large.
    case largeBee

    /// A bee buzzing, huge.
    case hugeBee

    /// A whale's song, tiny.
    case tinyWhale

    /// A whale's song, small.
    case smallWhale

    /// A whale's song, medium.
    case mediumWhale

    /// A whale's song, large.
    case largeWhale

    /// A whale's song, huge.
    case hugeWhale

    // MARK: Emotions: feelings, from tiny to huge

    /// Rising bright taps, tiny.
    case tinyJoy

    /// Rising bright taps, small.
    case smallJoy

    /// Rising bright taps, medium.
    case mediumJoy

    /// Rising bright taps, large.
    case largeJoy

    /// Rising bright taps, huge.
    case hugeJoy

    /// A slow, soft swell, tiny.
    case tinyCalm

    /// A slow, soft swell, small.
    case smallCalm

    /// A slow, soft swell, medium.
    case mediumCalm

    /// A slow, soft swell, large.
    case largeCalm

    /// A slow, soft swell, huge.
    case hugeCalm

    /// A sudden sharp tap, tiny.
    case tinySurprise

    /// A sudden sharp tap, small.
    case smallSurprise

    /// A sudden sharp tap, medium.
    case mediumSurprise

    /// A sudden sharp tap, large.
    case largeSurprise

    /// A sudden sharp tap, huge.
    case hugeSurprise

    /// Hard, pounding pulses, tiny.
    case tinyAnger

    /// Hard, pounding pulses, small.
    case smallAnger

    /// Hard, pounding pulses, medium.
    case mediumAnger

    /// Hard, pounding pulses, large.
    case largeAnger

    /// Hard, pounding pulses, huge.
    case hugeAnger

    /// A slowly fading weight, tiny.
    case tinySadness

    /// A slowly fading weight, small.
    case smallSadness

    /// A slowly fading weight, medium.
    case mediumSadness

    /// A slowly fading weight, large.
    case largeSadness

    /// A slowly fading weight, huge.
    case hugeSadness

    /// A quick trembling, tiny.
    case tinyFear

    /// A quick trembling, small.
    case smallFear

    /// A quick trembling, medium.
    case mediumFear

    /// A quick trembling, large.
    case largeFear

    /// A quick trembling, huge.
    case hugeFear

    /// A warm heartbeat, tiny.
    case tinyLove

    /// A warm heartbeat, small.
    case smallLove

    /// A warm heartbeat, medium.
    case mediumLove

    /// A warm heartbeat, large.
    case largeLove

    /// A warm heartbeat, huge.
    case hugeLove

    /// Bubbling, bouncing taps, tiny.
    case tinyLaughter

    /// Bubbling, bouncing taps, small.
    case smallLaughter

    /// Bubbling, bouncing taps, medium.
    case mediumLaughter

    /// Bubbling, bouncing taps, large.
    case largeLaughter

    /// Bubbling, bouncing taps, huge.
    case hugeLaughter

    /// A breath in and out, tiny.
    case tinySigh

    /// A breath in and out, small.
    case smallSigh

    /// A breath in and out, medium.
    case mediumSigh

    /// A breath in and out, large.
    case largeSigh

    /// A breath in and out, huge.
    case hugeSigh

    /// Taps quickening with excitement, tiny.
    case tinyExcitement

    /// Taps quickening with excitement, small.
    case smallExcitement

    /// Taps quickening with excitement, medium.
    case mediumExcitement

    /// Taps quickening with excitement, large.
    case largeExcitement

    /// Taps quickening with excitement, huge.
    case hugeExcitement

    // MARK: Sports: moments of play, from faint to intense

    /// A boot striking a ball, faint.
    case faintKick

    /// A boot striking a ball, soft.
    case softKick

    /// A boot striking a ball, firm.
    case firmKick

    /// A boot striking a ball, strong.
    case strongKick

    /// A boot striking a ball, intense.
    case intenseKick

    /// A ball bouncing down, faint.
    case faintDribble

    /// A ball bouncing down, soft.
    case softDribble

    /// A ball bouncing down, firm.
    case firmDribble

    /// A ball bouncing down, strong.
    case strongDribble

    /// A ball bouncing down, intense.
    case intenseDribble

    /// A toss and a crisp serve, faint.
    case faintServe

    /// A toss and a crisp serve, soft.
    case softServe

    /// A toss and a crisp serve, firm.
    case firmServe

    /// A toss and a crisp serve, strong.
    case strongServe

    /// A toss and a crisp serve, intense.
    case intenseServe

    /// A clean swish, faint.
    case faintSwish

    /// A clean swish, soft.
    case softSwish

    /// A clean swish, firm.
    case firmSwish

    /// A clean swish, strong.
    case strongSwish

    /// A clean swish, intense.
    case intenseSwish

    /// The crack of a bat, faint.
    case faintBat

    /// The crack of a bat, soft.
    case softBat

    /// The crack of a bat, firm.
    case firmBat

    /// The crack of a bat, strong.
    case strongBat

    /// The crack of a bat, intense.
    case intenseBat

    /// A referee's whistle, faint.
    case faintWhistle

    /// A referee's whistle, soft.
    case softWhistle

    /// A referee's whistle, firm.
    case firmWhistle

    /// A referee's whistle, strong.
    case strongWhistle

    /// A referee's whistle, intense.
    case intenseWhistle

    /// A goal and a cheer, faint.
    case faintGoal

    /// A goal and a cheer, soft.
    case softGoal

    /// A goal and a cheer, firm.
    case firmGoal

    /// A goal and a cheer, strong.
    case strongGoal

    /// A goal and a cheer, intense.
    case intenseGoal

    /// A rally of volleys, faint.
    case faintVolley

    /// A rally of volleys, soft.
    case softVolley

    /// A rally of volleys, firm.
    case firmVolley

    /// A rally of volleys, strong.
    case strongVolley

    /// A rally of volleys, intense.
    case intenseVolley

    /// Two quick punches, faint.
    case faintPunch

    /// Two quick punches, soft.
    case softPunch

    /// Two quick punches, firm.
    case firmPunch

    /// Two quick punches, strong.
    case strongPunch

    /// Two quick punches, intense.
    case intensePunch

    /// A sprint to the line, faint.
    case faintFinishLine

    /// A sprint to the line, soft.
    case softFinishLine

    /// A sprint to the line, firm.
    case firmFinishLine

    /// A sprint to the line, strong.
    case strongFinishLine

    /// A sprint to the line, intense.
    case intenseFinishLine

    // MARK: Instruments: notes and hits, from faint to intense

    /// A crisp snare hit, faint.
    case faintSnare

    /// A crisp snare hit, soft.
    case softSnare

    /// A crisp snare hit, firm.
    case firmSnare

    /// A crisp snare hit, strong.
    case strongSnare

    /// A crisp snare hit, intense.
    case intenseSnare

    /// A deep kick drum, faint.
    case faintKickDrum

    /// A deep kick drum, soft.
    case softKickDrum

    /// A deep kick drum, firm.
    case firmKickDrum

    /// A deep kick drum, strong.
    case strongKickDrum

    /// A deep kick drum, intense.
    case intenseKickDrum

    /// A shimmering cymbal, faint.
    case faintCymbal

    /// A shimmering cymbal, soft.
    case softCymbal

    /// A shimmering cymbal, firm.
    case firmCymbal

    /// A shimmering cymbal, strong.
    case strongCymbal

    /// A shimmering cymbal, intense.
    case intenseCymbal

    /// A plucked bass note, faint.
    case faintBass

    /// A plucked bass note, soft.
    case softBass

    /// A plucked bass note, firm.
    case firmBass

    /// A plucked bass note, strong.
    case strongBass

    /// A plucked bass note, intense.
    case intenseBass

    /// A strummed chord, faint.
    case faintStrum

    /// A strummed chord, soft.
    case softStrum

    /// A strummed chord, firm.
    case firmStrum

    /// A strummed chord, strong.
    case strongStrum

    /// A strummed chord, intense.
    case intenseStrum

    /// A rolled piano chord, faint.
    case faintChord

    /// A rolled piano chord, soft.
    case softChord

    /// A rolled piano chord, firm.
    case firmChord

    /// A rolled piano chord, strong.
    case strongChord

    /// A rolled piano chord, intense.
    case intenseChord

    /// A rising harp glissando, faint.
    case faintHarp

    /// A rising harp glissando, soft.
    case softHarp

    /// A rising harp glissando, firm.
    case firmHarp

    /// A rising harp glissando, strong.
    case strongHarp

    /// A rising harp glissando, intense.
    case intenseHarp

    /// Rising xylophone notes, faint.
    case faintXylophone

    /// Rising xylophone notes, soft.
    case softXylophone

    /// Rising xylophone notes, firm.
    case firmXylophone

    /// Rising xylophone notes, strong.
    case strongXylophone

    /// Rising xylophone notes, intense.
    case intenseXylophone

    /// A ringing gong, faint.
    case faintGong

    /// A ringing gong, soft.
    case softGong

    /// A ringing gong, firm.
    case firmGong

    /// A ringing gong, strong.
    case strongGong

    /// A ringing gong, intense.
    case intenseGong

    /// A triangle's ring, faint.
    case faintTriangle

    /// A triangle's ring, soft.
    case softTriangle

    /// A triangle's ring, firm.
    case firmTriangle

    /// A triangle's ring, strong.
    case strongTriangle

    /// A triangle's ring, intense.
    case intenseTriangle

    // MARK: Vehicles: on the move, from slow to rapid

    /// Wheels clacking over rails, slow.
    case slowTrain

    /// Wheels clacking over rails, easy.
    case easyTrain

    /// Wheels clacking over rails, steady.
    case steadyTrain

    /// Wheels clacking over rails, quick.
    case quickTrain

    /// Wheels clacking over rails, rapid.
    case rapidTrain

    /// A motorbike revving, slow.
    case slowMotorbike

    /// A motorbike revving, easy.
    case easyMotorbike

    /// A motorbike revving, steady.
    case steadyMotorbike

    /// A motorbike revving, quick.
    case quickMotorbike

    /// A motorbike revving, rapid.
    case rapidMotorbike

    /// Helicopter blades thumping, slow.
    case slowHelicopter

    /// Helicopter blades thumping, easy.
    case easyHelicopter

    /// Helicopter blades thumping, steady.
    case steadyHelicopter

    /// Helicopter blades thumping, quick.
    case quickHelicopter

    /// Helicopter blades thumping, rapid.
    case rapidHelicopter

    /// A boat on the swell, slow.
    case slowBoat

    /// A boat on the swell, easy.
    case easyBoat

    /// A boat on the swell, steady.
    case steadyBoat

    /// A boat on the swell, quick.
    case quickBoat

    /// A boat on the swell, rapid.
    case rapidBoat

    /// A bicycle bell, slow.
    case slowBicycleBell

    /// A bicycle bell, easy.
    case easyBicycleBell

    /// A bicycle bell, steady.
    case steadyBicycleBell

    /// A bicycle bell, quick.
    case quickBicycleBell

    /// A bicycle bell, rapid.
    case rapidBicycleBell

    /// A skateboard over joints, slow.
    case slowSkateboard

    /// A skateboard over joints, easy.
    case easySkateboard

    /// A skateboard over joints, steady.
    case steadySkateboard

    /// A skateboard over joints, quick.
    case quickSkateboard

    /// A skateboard over joints, rapid.
    case rapidSkateboard

    /// A subway stop, slow.
    case slowSubway

    /// A subway stop, easy.
    case easySubway

    /// A subway stop, steady.
    case steadySubway

    /// A subway stop, quick.
    case quickSubway

    /// A subway stop, rapid.
    case rapidSubway

    /// A rocket climbing, slow.
    case slowRocket

    /// A rocket climbing, easy.
    case easyRocket

    /// A rocket climbing, steady.
    case steadyRocket

    /// A rocket climbing, quick.
    case quickRocket

    /// A rocket climbing, rapid.
    case rapidRocket

    /// A cable car's bell and roll, slow.
    case slowCableCar

    /// A cable car's bell and roll, easy.
    case easyCableCar

    /// A cable car's bell and roll, steady.
    case steadyCableCar

    /// A cable car's bell and roll, quick.
    case quickCableCar

    /// A cable car's bell and roll, rapid.
    case rapidCableCar

    /// A jet passing over, slow.
    case slowJet

    /// A jet passing over, easy.
    case easyJet

    /// A jet passing over, steady.
    case steadyJet

    /// A jet passing over, quick.
    case quickJet

    /// A jet passing over, rapid.
    case rapidJet

    // MARK: Controls: interface feedback, from faint to intense

    /// A switch flipped on, faint.
    case faintSwitch

    /// A switch flipped on, soft.
    case softSwitch

    /// A switch flipped on, firm.
    case firmSwitch

    /// A switch flipped on, strong.
    case strongSwitch

    /// A switch flipped on, intense.
    case intenseSwitch

    /// A slider's detents, faint.
    case faintSlider

    /// A slider's detents, soft.
    case softSlider

    /// A slider's detents, firm.
    case firmSlider

    /// A slider's detents, strong.
    case strongSlider

    /// A slider's detents, intense.
    case intenseSlider

    /// A stepper's click, faint.
    case faintStepper

    /// A stepper's click, soft.
    case softStepper

    /// A stepper's click, firm.
    case firmStepper

    /// A stepper's click, strong.
    case strongStepper

    /// A stepper's click, intense.
    case intenseStepper

    /// Pulling, then a snap, faint.
    case faintPullToRefresh

    /// Pulling, then a snap, soft.
    case softPullToRefresh

    /// Pulling, then a snap, firm.
    case firmPullToRefresh

    /// Pulling, then a snap, strong.
    case strongPullToRefresh

    /// Pulling, then a snap, intense.
    case intensePullToRefresh

    /// A page turning, faint.
    case faintPageTurn

    /// A page turning, soft.
    case softPageTurn

    /// A page turning, firm.
    case firmPageTurn

    /// A page turning, strong.
    case strongPageTurn

    /// A page turning, intense.
    case intensePageTurn

    /// A key pressed, faint.
    case faintKeyPress

    /// A key pressed, soft.
    case softKeyPress

    /// A key pressed, firm.
    case firmKeyPress

    /// A key pressed, strong.
    case strongKeyPress

    /// A key pressed, intense.
    case intenseKeyPress

    /// A scroll settling, faint.
    case faintScrollStop

    /// A scroll settling, soft.
    case softScrollStop

    /// A scroll settling, firm.
    case firmScrollStop

    /// A scroll settling, strong.
    case strongScrollStop

    /// A scroll settling, intense.
    case intenseScrollStop

    /// A button popping, faint.
    case faintPop

    /// A button popping, soft.
    case softPop

    /// A button popping, firm.
    case firmPop

    /// A button popping, strong.
    case strongPop

    /// A button popping, intense.
    case intensePop

    /// Springing back, faint.
    case faintSnapBack

    /// Springing back, soft.
    case softSnapBack

    /// Springing back, firm.
    case firmSnapBack

    /// Springing back, strong.
    case strongSnapBack

    /// Springing back, intense.
    case intenseSnapBack

    /// An item grabbed, faint.
    case faintGrab

    /// An item grabbed, soft.
    case softGrab

    /// An item grabbed, firm.
    case firmGrab

    /// An item grabbed, strong.
    case strongGrab

    /// An item grabbed, intense.
    case intenseGrab

    // MARK: Body: the body's rhythms, from faint to intense

    /// Two slow breaths, faint.
    case faintBreath

    /// Two slow breaths, soft.
    case softBreath

    /// Two slow breaths, firm.
    case firmBreath

    /// Two slow breaths, strong.
    case strongBreath

    /// Two slow breaths, intense.
    case intenseBreath

    /// Two footsteps, faint.
    case faintFootstep

    /// Two footsteps, soft.
    case softFootstep

    /// Two footsteps, firm.
    case firmFootstep

    /// Two footsteps, strong.
    case strongFootstep

    /// Two footsteps, intense.
    case intenseFootstep

    /// A finger snap, faint.
    case faintFingerSnap

    /// A finger snap, soft.
    case softFingerSnap

    /// A finger snap, firm.
    case firmFingerSnap

    /// A finger snap, strong.
    case strongFingerSnap

    /// A finger snap, intense.
    case intenseFingerSnap

    /// Cracking knuckles, faint.
    case faintKnuckles

    /// Cracking knuckles, soft.
    case softKnuckles

    /// Cracking knuckles, firm.
    case firmKnuckles

    /// Cracking knuckles, strong.
    case strongKnuckles

    /// Cracking knuckles, intense.
    case intenseKnuckles

    /// A shiver, faint.
    case faintShiver

    /// A shiver, soft.
    case softShiver

    /// A shiver, firm.
    case firmShiver

    /// A shiver, strong.
    case strongShiver

    /// A shiver, intense.
    case intenseShiver

    /// A long yawn, faint.
    case faintYawn

    /// A long yawn, soft.
    case softYawn

    /// A long yawn, firm.
    case firmYawn

    /// A long yawn, strong.
    case strongYawn

    /// A long yawn, intense.
    case intenseYawn

    /// Two hiccups, faint.
    case faintHiccup

    /// Two hiccups, soft.
    case softHiccup

    /// Two hiccups, firm.
    case firmHiccup

    /// Two hiccups, strong.
    case strongHiccup

    /// Two hiccups, intense.
    case intenseHiccup

    /// A building sneeze, faint.
    case faintSneeze

    /// A building sneeze, soft.
    case softSneeze

    /// A building sneeze, firm.
    case firmSneeze

    /// A building sneeze, strong.
    case strongSneeze

    /// A building sneeze, intense.
    case intenseSneeze

    /// A warm hug, faint.
    case faintHug

    /// A warm hug, soft.
    case softHug

    /// A warm hug, firm.
    case firmHug

    /// A warm hug, strong.
    case strongHug

    /// A warm hug, intense.
    case intenseHug

    /// A fluttering heart, faint.
    case faintFlutter

    /// A fluttering heart, soft.
    case softFlutter

    /// A fluttering heart, firm.
    case firmFlutter

    /// A fluttering heart, strong.
    case strongFlutter

    /// A fluttering heart, intense.
    case intenseFlutter

    // MARK: Kitchen: cooking sounds, from slow to rapid

    /// A knife chopping, slow.
    case slowChop

    /// A knife chopping, easy.
    case easyChop

    /// A knife chopping, steady.
    case steadyChop

    /// A knife chopping, quick.
    case quickChop

    /// A knife chopping, rapid.
    case rapidChop

    /// Oil sizzling, slow.
    case slowSizzle

    /// Oil sizzling, easy.
    case easySizzle

    /// Oil sizzling, steady.
    case steadySizzle

    /// Oil sizzling, quick.
    case quickSizzle

    /// Oil sizzling, rapid.
    case rapidSizzle

    /// Water bubbling, slow.
    case slowBoil

    /// Water bubbling, easy.
    case easyBoil

    /// Water bubbling, steady.
    case steadyBoil

    /// Water bubbling, quick.
    case quickBoil

    /// Water bubbling, rapid.
    case rapidBoil

    /// A whisk beating, slow.
    case slowWhisk

    /// A whisk beating, easy.
    case easyWhisk

    /// A whisk beating, steady.
    case steadyWhisk

    /// A whisk beating, quick.
    case quickWhisk

    /// A whisk beating, rapid.
    case rapidWhisk

    /// Liquid pouring, slow.
    case slowPour

    /// Liquid pouring, easy.
    case easyPour

    /// Liquid pouring, steady.
    case steadyPour

    /// Liquid pouring, quick.
    case quickPour

    /// Liquid pouring, rapid.
    case rapidPour

    /// A kettle coming to the boil, slow.
    case slowKettle

    /// A kettle coming to the boil, easy.
    case easyKettle

    /// A kettle coming to the boil, steady.
    case steadyKettle

    /// A kettle coming to the boil, quick.
    case quickKettle

    /// A kettle coming to the boil, rapid.
    case rapidKettle

    /// Bread popping up, slow.
    case slowToaster

    /// Bread popping up, easy.
    case easyToaster

    /// Bread popping up, steady.
    case steadyToaster

    /// Bread popping up, quick.
    case quickToaster

    /// Bread popping up, rapid.
    case rapidToaster

    /// A microwave finishing, slow.
    case slowMicrowave

    /// A microwave finishing, easy.
    case easyMicrowave

    /// A microwave finishing, steady.
    case steadyMicrowave

    /// A microwave finishing, quick.
    case quickMicrowave

    /// A microwave finishing, rapid.
    case rapidMicrowave

    /// A blender whirring, slow.
    case slowBlender

    /// A blender whirring, easy.
    case easyBlender

    /// A blender whirring, steady.
    case steadyBlender

    /// A blender whirring, quick.
    case quickBlender

    /// A blender whirring, rapid.
    case rapidBlender

    /// A kitchen timer, slow.
    case slowTimerDing

    /// A kitchen timer, easy.
    case easyTimerDing

    /// A kitchen timer, steady.
    case steadyTimerDing

    /// A kitchen timer, quick.
    case quickTimerDing

    /// A kitchen timer, rapid.
    case rapidTimerDing

    // MARK: Tools: work in progress, from faint to intense

    /// Three hammer blows, faint.
    case faintHammer

    /// Three hammer blows, soft.
    case softHammer

    /// Three hammer blows, firm.
    case firmHammer

    /// Three hammer blows, strong.
    case strongHammer

    /// Three hammer blows, intense.
    case intenseHammer

    /// A saw cutting, faint.
    case faintHandSaw

    /// A saw cutting, soft.
    case softHandSaw

    /// A saw cutting, firm.
    case firmHandSaw

    /// A saw cutting, strong.
    case strongHandSaw

    /// A saw cutting, intense.
    case intenseHandSaw

    /// A screwdriver turning, faint.
    case faintScrewdriver

    /// A screwdriver turning, soft.
    case softScrewdriver

    /// A screwdriver turning, firm.
    case firmScrewdriver

    /// A screwdriver turning, strong.
    case strongScrewdriver

    /// A screwdriver turning, intense.
    case intenseScrewdriver

    /// A wrench tightening, faint.
    case faintWrench

    /// A wrench tightening, soft.
    case softWrench

    /// A wrench tightening, firm.
    case firmWrench

    /// A wrench tightening, strong.
    case strongWrench

    /// A wrench tightening, intense.
    case intenseWrench

    /// A drill spinning up, faint.
    case faintPowerDrill

    /// A drill spinning up, soft.
    case softPowerDrill

    /// A drill spinning up, firm.
    case firmPowerDrill

    /// A drill spinning up, strong.
    case strongPowerDrill

    /// A drill spinning up, intense.
    case intensePowerDrill

    /// A sander buzzing, faint.
    case faintSander

    /// A sander buzzing, soft.
    case softSander

    /// A sander buzzing, firm.
    case firmSander

    /// A sander buzzing, strong.
    case strongSander

    /// A sander buzzing, intense.
    case intenseSander

    /// A stapler pressed, faint.
    case faintStapler

    /// A stapler pressed, soft.
    case softStapler

    /// A stapler pressed, firm.
    case firmStapler

    /// A stapler pressed, strong.
    case strongStapler

    /// A stapler pressed, intense.
    case intenseStapler

    /// A nail gun firing, faint.
    case faintNailGun

    /// A nail gun firing, soft.
    case softNailGun

    /// A nail gun firing, firm.
    case firmNailGun

    /// A nail gun firing, strong.
    case strongNailGun

    /// A nail gun firing, intense.
    case intenseNailGun

    /// A tape measure reeling, faint.
    case faintTapeMeasure

    /// A tape measure reeling, soft.
    case softTapeMeasure

    /// A tape measure reeling, firm.
    case firmTapeMeasure

    /// A tape measure reeling, strong.
    case strongTapeMeasure

    /// A tape measure reeling, intense.
    case intenseTapeMeasure

    /// A chisel tapped, faint.
    case faintChisel

    /// A chisel tapped, soft.
    case softChisel

    /// A chisel tapped, firm.
    case firmChisel

    /// A chisel tapped, strong.
    case strongChisel

    /// A chisel tapped, intense.
    case intenseChisel

    // MARK: Space: out in orbit, from tiny to huge

    /// A launch rumbling up, tiny.
    case tinyLaunch

    /// A launch rumbling up, small.
    case smallLaunch

    /// A launch rumbling up, medium.
    case mediumLaunch

    /// A launch rumbling up, large.
    case largeLaunch

    /// A launch rumbling up, huge.
    case hugeLaunch

    /// Circling in orbit, tiny.
    case tinyOrbit

    /// Circling in orbit, small.
    case smallOrbit

    /// Circling in orbit, medium.
    case mediumOrbit

    /// Circling in orbit, large.
    case largeOrbit

    /// Circling in orbit, huge.
    case hugeOrbit

    /// A blinking beacon, tiny.
    case tinyBeacon

    /// A blinking beacon, small.
    case smallBeacon

    /// A blinking beacon, medium.
    case mediumBeacon

    /// A blinking beacon, large.
    case largeBeacon

    /// A blinking beacon, huge.
    case hugeBeacon

    /// Jumping to warp, tiny.
    case tinyWarp

    /// Jumping to warp, small.
    case smallWarp

    /// Jumping to warp, medium.
    case mediumWarp

    /// Jumping to warp, large.
    case largeWarp

    /// Jumping to warp, huge.
    case hugeWarp

    /// Docking, step by step, tiny.
    case tinyDocking

    /// Docking, step by step, small.
    case smallDocking

    /// Docking, step by step, medium.
    case mediumDocking

    /// Docking, step by step, large.
    case largeDocking

    /// Docking, step by step, huge.
    case hugeDocking

    /// A meteor striking, tiny.
    case tinyMeteor

    /// A meteor striking, small.
    case smallMeteor

    /// A meteor striking, medium.
    case mediumMeteor

    /// A meteor striking, large.
    case largeMeteor

    /// A meteor striking, huge.
    case hugeMeteor

    /// Thrusters firing, tiny.
    case tinyThruster

    /// Thrusters firing, small.
    case smallThruster

    /// Thrusters firing, medium.
    case mediumThruster

    /// Thrusters firing, large.
    case largeThruster

    /// Thrusters firing, huge.
    case hugeThruster

    /// A fading signal, tiny.
    case tinySignal

    /// A fading signal, small.
    case smallSignal

    /// A fading signal, medium.
    case mediumSignal

    /// A fading signal, large.
    case largeSignal

    /// A fading signal, huge.
    case hugeSignal

    /// A comet's tail, tiny.
    case tinyComet

    /// A comet's tail, small.
    case smallComet

    /// A comet's tail, medium.
    case mediumComet

    /// A comet's tail, large.
    case largeComet

    /// A comet's tail, huge.
    case hugeComet

    /// Pulled into a black hole, tiny.
    case tinyBlackHole

    /// Pulled into a black hole, small.
    case smallBlackHole

    /// Pulled into a black hole, medium.
    case mediumBlackHole

    /// Pulled into a black hole, large.
    case largeBlackHole

    /// Pulled into a black hole, huge.
    case hugeBlackHole

    // MARK: Ocean: by and under the sea, from tiny to huge

    /// The tide rolling in, tiny.
    case tinyTide

    /// The tide rolling in, small.
    case smallTide

    /// The tide rolling in, medium.
    case mediumTide

    /// The tide rolling in, large.
    case largeTide

    /// The tide rolling in, huge.
    case hugeTide

    /// A sonar ping and echo, tiny.
    case tinySonar

    /// A sonar ping and echo, small.
    case smallSonar

    /// A sonar ping and echo, medium.
    case mediumSonar

    /// A sonar ping and echo, large.
    case largeSonar

    /// A sonar ping and echo, huge.
    case hugeSonar

    /// Bubbles rising, tiny.
    case tinyBubbles

    /// Bubbles rising, small.
    case smallBubbles

    /// Bubbles rising, medium.
    case mediumBubbles

    /// Bubbles rising, large.
    case largeBubbles

    /// Bubbles rising, huge.
    case hugeBubbles

    /// A splash and drips, tiny.
    case tinySplash

    /// A splash and drips, small.
    case smallSplash

    /// A splash and drips, medium.
    case mediumSplash

    /// A splash and drips, large.
    case largeSplash

    /// A splash and drips, huge.
    case hugeSplash

    /// A steady current, tiny.
    case tinyCurrent

    /// A steady current, small.
    case smallCurrent

    /// A steady current, medium.
    case mediumCurrent

    /// A steady current, large.
    case largeCurrent

    /// A steady current, huge.
    case hugeCurrent

    /// A buoy's bell, tiny.
    case tinyBuoyBell

    /// A buoy's bell, small.
    case smallBuoyBell

    /// A buoy's bell, medium.
    case mediumBuoyBell

    /// A buoy's bell, large.
    case largeBuoyBell

    /// A buoy's bell, huge.
    case hugeBuoyBell

    /// A pulling undertow, tiny.
    case tinyUndertow

    /// A pulling undertow, small.
    case smallUndertow

    /// A pulling undertow, medium.
    case mediumUndertow

    /// A pulling undertow, large.
    case largeUndertow

    /// A pulling undertow, huge.
    case hugeUndertow

    /// Sea spray, tiny.
    case tinySeaSpray

    /// Sea spray, small.
    case smallSeaSpray

    /// Sea spray, medium.
    case mediumSeaSpray

    /// Sea spray, large.
    case largeSeaSpray

    /// Sea spray, huge.
    case hugeSeaSpray

    /// Dolphin clicks, tiny.
    case tinyDolphin

    /// Dolphin clicks, small.
    case smallDolphin

    /// Dolphin clicks, medium.
    case mediumDolphin

    /// Dolphin clicks, large.
    case largeDolphin

    /// Dolphin clicks, huge.
    case hugeDolphin

    /// A ship's horn, tiny.
    case tinyShipHorn

    /// A ship's horn, small.
    case smallShipHorn

    /// A ship's horn, medium.
    case mediumShipHorn

    /// A ship's horn, large.
    case largeShipHorn

    /// A ship's horn, huge.
    case hugeShipHorn

    // MARK: City: street sounds, from faint to intense

    /// Traffic rumbling, faint.
    case faintTraffic

    /// Traffic rumbling, soft.
    case softTraffic

    /// Traffic rumbling, firm.
    case firmTraffic

    /// Traffic rumbling, strong.
    case strongTraffic

    /// Traffic rumbling, intense.
    case intenseTraffic

    /// A crosswalk ticking, faint.
    case faintCrosswalk

    /// A crosswalk ticking, soft.
    case softCrosswalk

    /// A crosswalk ticking, firm.
    case firmCrosswalk

    /// A crosswalk ticking, strong.
    case strongCrosswalk

    /// A crosswalk ticking, intense.
    case intenseCrosswalk

    /// An elevator arriving, faint.
    case faintElevator

    /// An elevator arriving, soft.
    case softElevator

    /// An elevator arriving, firm.
    case firmElevator

    /// An elevator arriving, strong.
    case strongElevator

    /// An elevator arriving, intense.
    case intenseElevator

    /// A turnstile turning, faint.
    case faintTurnstile

    /// A turnstile turning, soft.
    case softTurnstile

    /// A turnstile turning, firm.
    case firmTurnstile

    /// A turnstile turning, strong.
    case strongTurnstile

    /// A turnstile turning, intense.
    case intenseTurnstile

    /// A jackhammer, faint.
    case faintJackhammer

    /// A jackhammer, soft.
    case softJackhammer

    /// A jackhammer, firm.
    case firmJackhammer

    /// A jackhammer, strong.
    case strongJackhammer

    /// A jackhammer, intense.
    case intenseJackhammer

    /// A car horn, faint.
    case faintCarHorn

    /// A car horn, soft.
    case softCarHorn

    /// A car horn, firm.
    case firmCarHorn

    /// A car horn, strong.
    case strongCarHorn

    /// A car horn, intense.
    case intenseCarHorn

    /// Doors closing, faint.
    case faintTrainDoors

    /// Doors closing, soft.
    case softTrainDoors

    /// Doors closing, firm.
    case firmTrainDoors

    /// Doors closing, strong.
    case strongTrainDoors

    /// Doors closing, intense.
    case intenseTrainDoors

    /// A bus pulling in, faint.
    case faintBusStop

    /// A bus pulling in, soft.
    case softBusStop

    /// A bus pulling in, firm.
    case firmBusStop

    /// A bus pulling in, strong.
    case strongBusStop

    /// A bus pulling in, intense.
    case intenseBusStop

    /// Parking sensors, faint.
    case faintParking

    /// Parking sensors, soft.
    case softParking

    /// Parking sensors, firm.
    case firmParking

    /// Parking sensors, strong.
    case strongParking

    /// Parking sensors, intense.
    case intenseParking

    /// Bells ringing, faint.
    case faintChurchBells

    /// Bells ringing, soft.
    case softChurchBells

    /// Bells ringing, firm.
    case firmChurchBells

    /// Bells ringing, strong.
    case strongChurchBells

    /// Bells ringing, intense.
    case intenseChurchBells

    // MARK: Puzzle: puzzle game moments, from tiny to huge

    /// A match made, tiny.
    case tinyMatch

    /// A match made, small.
    case smallMatch

    /// A match made, medium.
    case mediumMatch

    /// A match made, large.
    case largeMatch

    /// A match made, huge.
    case hugeMatch

    /// A rising combo, tiny.
    case tinyCombo

    /// A rising combo, small.
    case smallCombo

    /// A rising combo, medium.
    case mediumCombo

    /// A rising combo, large.
    case largeCombo

    /// A rising combo, huge.
    case hugeCombo

    /// A line cleared, tiny.
    case tinyLineClear

    /// A line cleared, small.
    case smallLineClear

    /// A line cleared, medium.
    case mediumLineClear

    /// A line cleared, large.
    case largeLineClear

    /// A line cleared, huge.
    case hugeLineClear

    /// A block landing, tiny.
    case tinyBlockDrop

    /// A block landing, small.
    case smallBlockDrop

    /// A block landing, medium.
    case mediumBlockDrop

    /// A block landing, large.
    case largeBlockDrop

    /// A block landing, huge.
    case hugeBlockDrop

    /// A piece rotated, tiny.
    case tinyRotate

    /// A piece rotated, small.
    case smallRotate

    /// A piece rotated, medium.
    case mediumRotate

    /// A piece rotated, large.
    case largeRotate

    /// A piece rotated, huge.
    case hugeRotate

    /// Two pieces swapped, tiny.
    case tinySwap

    /// Two pieces swapped, small.
    case smallSwap

    /// Two pieces swapped, medium.
    case mediumSwap

    /// Two pieces swapped, large.
    case largeSwap

    /// Two pieces swapped, huge.
    case hugeSwap

    /// A bonus earned, tiny.
    case tinyBonus

    /// A bonus earned, small.
    case smallBonus

    /// A bonus earned, medium.
    case mediumBonus

    /// A bonus earned, large.
    case largeBonus

    /// A bonus earned, huge.
    case hugeBonus

    /// A missed move, tiny.
    case tinyMiss

    /// A missed move, small.
    case smallMiss

    /// A missed move, medium.
    case mediumMiss

    /// A missed move, large.
    case largeMiss

    /// A missed move, huge.
    case hugeMiss

    /// A hint appearing, tiny.
    case tinyHint

    /// A hint appearing, small.
    case smallHint

    /// A hint appearing, medium.
    case mediumHint

    /// A hint appearing, large.
    case largeHint

    /// A hint appearing, huge.
    case hugeHint

    /// A level cleared, tiny.
    case tinyLevelClear

    /// A level cleared, small.
    case smallLevelClear

    /// A level cleared, medium.
    case mediumLevelClear

    /// A level cleared, large.
    case largeLevelClear

    /// A level cleared, huge.
    case hugeLevelClear

    // MARK: Grooves: one bar of a beat, from slow to rapid

    /// A rock beat, slow.
    case slowRock

    /// A rock beat, easy.
    case easyRock

    /// A rock beat, steady.
    case steadyRock

    /// A rock beat, quick.
    case quickRock

    /// A rock beat, rapid.
    case rapidRock

    /// A funk groove, slow.
    case slowFunk

    /// A funk groove, easy.
    case easyFunk

    /// A funk groove, steady.
    case steadyFunk

    /// A funk groove, quick.
    case quickFunk

    /// A funk groove, rapid.
    case rapidFunk

    /// A reggae one-drop, slow.
    case slowReggae

    /// A reggae one-drop, easy.
    case easyReggae

    /// A reggae one-drop, steady.
    case steadyReggae

    /// A reggae one-drop, quick.
    case quickReggae

    /// A reggae one-drop, rapid.
    case rapidReggae

    /// A disco beat, slow.
    case slowDisco

    /// A disco beat, easy.
    case easyDisco

    /// A disco beat, steady.
    case steadyDisco

    /// A disco beat, quick.
    case quickDisco

    /// A disco beat, rapid.
    case rapidDisco

    /// A hip hop beat, slow.
    case slowHipHop

    /// A hip hop beat, easy.
    case easyHipHop

    /// A hip hop beat, steady.
    case steadyHipHop

    /// A hip hop beat, quick.
    case quickHipHop

    /// A hip hop beat, rapid.
    case rapidHipHop

    /// A samba rhythm, slow.
    case slowSamba

    /// A samba rhythm, easy.
    case easySamba

    /// A samba rhythm, steady.
    case steadySamba

    /// A samba rhythm, quick.
    case quickSamba

    /// A samba rhythm, rapid.
    case rapidSamba

    /// A tango rhythm, slow.
    case slowTango

    /// A tango rhythm, easy.
    case easyTango

    /// A tango rhythm, steady.
    case steadyTango

    /// A tango rhythm, quick.
    case quickTango

    /// A tango rhythm, rapid.
    case rapidTango

    /// A polka beat, slow.
    case slowPolka

    /// A polka beat, easy.
    case easyPolka

    /// A polka beat, steady.
    case steadyPolka

    /// A polka beat, quick.
    case quickPolka

    /// A polka beat, rapid.
    case rapidPolka

    /// A techno pulse, slow.
    case slowTechno

    /// A techno pulse, easy.
    case easyTechno

    /// A techno pulse, steady.
    case steadyTechno

    /// A techno pulse, quick.
    case quickTechno

    /// A techno pulse, rapid.
    case rapidTechno

    /// An afrobeat groove, slow.
    case slowAfrobeat

    /// An afrobeat groove, easy.
    case easyAfrobeat

    /// An afrobeat groove, steady.
    case steadyAfrobeat

    /// An afrobeat groove, quick.
    case quickAfrobeat

    /// An afrobeat groove, rapid.
    case rapidAfrobeat

    // MARK: Notifications: alerts, from once to five times

    /// New mail, once.
    case singleMail

    /// New mail, twice.
    case doubleMail

    /// New mail, three times.
    case tripleMail

    /// New mail, four times.
    case quadrupleMail

    /// New mail, five times.
    case quintupleMail

    /// A calendar alert, once.
    case singleCalendar

    /// A calendar alert, twice.
    case doubleCalendar

    /// A calendar alert, three times.
    case tripleCalendar

    /// A calendar alert, four times.
    case quadrupleCalendar

    /// A calendar alert, five times.
    case quintupleCalendar

    /// A payment sent, once.
    case singlePayment

    /// A payment sent, twice.
    case doublePayment

    /// A payment sent, three times.
    case triplePayment

    /// A payment sent, four times.
    case quadruplePayment

    /// A payment sent, five times.
    case quintuplePayment

    /// A download done, once.
    case singleDownload

    /// A download done, twice.
    case doubleDownload

    /// A download done, three times.
    case tripleDownload

    /// A download done, four times.
    case quadrupleDownload

    /// A download done, five times.
    case quintupleDownload

    /// An upload done, once.
    case singleUpload

    /// An upload done, twice.
    case doubleUpload

    /// An upload done, three times.
    case tripleUpload

    /// An upload done, four times.
    case quadrupleUpload

    /// An upload done, five times.
    case quintupleUpload

    /// A battery warning, once.
    case singleBattery

    /// A battery warning, twice.
    case doubleBattery

    /// A battery warning, three times.
    case tripleBattery

    /// A battery warning, four times.
    case quadrupleBattery

    /// A battery warning, five times.
    case quintupleBattery

    /// A new note, once.
    case singleNote

    /// A new note, twice.
    case doubleNote

    /// A new note, three times.
    case tripleNote

    /// A new note, four times.
    case quadrupleNote

    /// A new note, five times.
    case quintupleNote

    /// A sync finished, once.
    case singleSync

    /// A sync finished, twice.
    case doubleSync

    /// A sync finished, three times.
    case tripleSync

    /// A sync finished, four times.
    case quadrupleSync

    /// A sync finished, five times.
    case quintupleSync

    /// A friend request, once.
    case singleFriend

    /// A friend request, twice.
    case doubleFriend

    /// A friend request, three times.
    case tripleFriend

    /// A friend request, four times.
    case quadrupleFriend

    /// A friend request, five times.
    case quintupleFriend

    /// Breaking news, once.
    case singleNews

    /// Breaking news, twice.
    case doubleNews

    /// Breaking news, three times.
    case tripleNews

    /// Breaking news, four times.
    case quadrupleNews

    /// Breaking news, five times.
    case quintupleNews

    // MARK: Clocks: timekeeping, from slow to rapid

    /// A clock's tick-tock, slow.
    case slowTickTock

    /// A clock's tick-tock, easy.
    case easyTickTock

    /// A clock's tick-tock, steady.
    case steadyTickTock

    /// A clock's tick-tock, quick.
    case quickTickTock

    /// A clock's tick-tock, rapid.
    case rapidTickTock

    /// An hour chiming, slow.
    case slowHourChime

    /// An hour chiming, easy.
    case easyHourChime

    /// An hour chiming, steady.
    case steadyHourChime

    /// An hour chiming, quick.
    case quickHourChime

    /// An hour chiming, rapid.
    case rapidHourChime

    /// A cuckoo clock, slow.
    case slowCuckoo

    /// A cuckoo clock, easy.
    case easyCuckoo

    /// A cuckoo clock, steady.
    case steadyCuckoo

    /// A cuckoo clock, quick.
    case quickCuckoo

    /// A cuckoo clock, rapid.
    case rapidCuckoo

    /// A stopwatch started, slow.
    case slowStopwatch

    /// A stopwatch started, easy.
    case easyStopwatch

    /// A stopwatch started, steady.
    case steadyStopwatch

    /// A stopwatch started, quick.
    case quickStopwatch

    /// A stopwatch started, rapid.
    case rapidStopwatch

    /// Sand running through, slow.
    case slowHourglass

    /// Sand running through, easy.
    case easyHourglass

    /// Sand running through, steady.
    case steadyHourglass

    /// Sand running through, quick.
    case quickHourglass

    /// Sand running through, rapid.
    case rapidHourglass

    /// A swinging pendulum, slow.
    case slowPendulum

    /// A swinging pendulum, easy.
    case easyPendulum

    /// A swinging pendulum, steady.
    case steadyPendulum

    /// A swinging pendulum, quick.
    case quickPendulum

    /// A swinging pendulum, rapid.
    case rapidPendulum

    /// An alarm clock ringing, slow.
    case slowAlarmClock

    /// An alarm clock ringing, easy.
    case easyAlarmClock

    /// An alarm clock ringing, steady.
    case steadyAlarmClock

    /// An alarm clock ringing, quick.
    case quickAlarmClock

    /// An alarm clock ringing, rapid.
    case rapidAlarmClock

    /// An egg timer ticking, slow.
    case slowEggTimer

    /// An egg timer ticking, easy.
    case easyEggTimer

    /// An egg timer ticking, steady.
    case steadyEggTimer

    /// An egg timer ticking, quick.
    case quickEggTimer

    /// An egg timer ticking, rapid.
    case rapidEggTimer

    /// A grandfather clock striking, slow.
    case slowGrandfatherClock

    /// A grandfather clock striking, easy.
    case easyGrandfatherClock

    /// A grandfather clock striking, steady.
    case steadyGrandfatherClock

    /// A grandfather clock striking, quick.
    case quickGrandfatherClock

    /// A grandfather clock striking, rapid.
    case rapidGrandfatherClock

    /// A digital beep, slow.
    case slowDigital

    /// A digital beep, easy.
    case easyDigital

    /// A digital beep, steady.
    case steadyDigital

    /// A digital beep, quick.
    case quickDigital

    /// A digital beep, rapid.
    case rapidDigital

    // MARK: Elements: the elements, from tiny to huge

    /// Earth's heavy weight, tiny.
    case tinyEarth

    /// Earth's heavy weight, small.
    case smallEarth

    /// Earth's heavy weight, medium.
    case mediumEarth

    /// Earth's heavy weight, large.
    case largeEarth

    /// Earth's heavy weight, huge.
    case hugeEarth

    /// Air moving, tiny.
    case tinyAir

    /// Air moving, small.
    case smallAir

    /// Air moving, medium.
    case mediumAir

    /// Air moving, large.
    case largeAir

    /// Air moving, huge.
    case hugeAir

    /// Water flowing, tiny.
    case tinyWater

    /// Water flowing, small.
    case smallWater

    /// Water flowing, medium.
    case mediumWater

    /// Water flowing, large.
    case largeWater

    /// Water flowing, huge.
    case hugeWater

    /// A lightning strike, tiny.
    case tinyLightning

    /// A lightning strike, small.
    case smallLightning

    /// A lightning strike, medium.
    case mediumLightning

    /// A lightning strike, large.
    case largeLightning

    /// A lightning strike, huge.
    case hugeLightning

    /// Ice cracking, tiny.
    case tinyIce

    /// Ice cracking, small.
    case smallIce

    /// Ice cracking, medium.
    case mediumIce

    /// Ice cracking, large.
    case largeIce

    /// Ice cracking, huge.
    case hugeIce

    /// Lava churning, tiny.
    case tinyLava

    /// Lava churning, small.
    case smallLava

    /// Lava churning, medium.
    case mediumLava

    /// Lava churning, large.
    case largeLava

    /// Lava churning, huge.
    case hugeLava

    /// Steam hissing, tiny.
    case tinySteam

    /// Steam hissing, small.
    case smallSteam

    /// Steam hissing, medium.
    case mediumSteam

    /// Steam hissing, large.
    case largeSteam

    /// Steam hissing, huge.
    case hugeSteam

    /// Sand shifting, tiny.
    case tinySand

    /// Sand shifting, small.
    case smallSand

    /// Sand shifting, medium.
    case mediumSand

    /// Sand shifting, large.
    case largeSand

    /// Sand shifting, huge.
    case hugeSand

    /// Crystal chiming, tiny.
    case tinyCrystal

    /// Crystal chiming, small.
    case smallCrystal

    /// Crystal chiming, medium.
    case mediumCrystal

    /// Crystal chiming, large.
    case largeCrystal

    /// Crystal chiming, huge.
    case hugeCrystal

    /// A storm raging, tiny.
    case tinyStorm

    /// A storm raging, small.
    case smallStorm

    /// A storm raging, medium.
    case mediumStorm

    /// A storm raging, large.
    case largeStorm

    /// A storm raging, huge.
    case hugeStorm

    // MARK: Magic: spells and charms, from tiny to huge

    /// A spell cast, tiny.
    case tinySpell

    /// A spell cast, small.
    case smallSpell

    /// A spell cast, medium.
    case mediumSpell

    /// A spell cast, large.
    case largeSpell

    /// A spell cast, huge.
    case hugeSpell

    /// A portal opening, tiny.
    case tinyPortal

    /// A portal opening, small.
    case smallPortal

    /// A portal opening, medium.
    case mediumPortal

    /// A portal opening, large.
    case largePortal

    /// A portal opening, huge.
    case hugePortal

    /// A wand flick, tiny.
    case tinyWand

    /// A wand flick, small.
    case smallWand

    /// A wand flick, medium.
    case mediumWand

    /// A wand flick, large.
    case largeWand

    /// A wand flick, huge.
    case hugeWand

    /// A charm, tiny.
    case tinyCharm

    /// A charm, small.
    case smallCharm

    /// A charm, medium.
    case mediumCharm

    /// A charm, large.
    case largeCharm

    /// A charm, huge.
    case hugeCharm

    /// A curse falling, tiny.
    case tinyCurse

    /// A curse falling, small.
    case smallCurse

    /// A curse falling, medium.
    case mediumCurse

    /// A curse falling, large.
    case largeCurse

    /// A curse falling, huge.
    case hugeCurse

    /// A healing glow, tiny.
    case tinyHeal

    /// A healing glow, small.
    case smallHeal

    /// A healing glow, medium.
    case mediumHeal

    /// A healing glow, large.
    case largeHeal

    /// A healing glow, huge.
    case hugeHeal

    /// Vanishing and reappearing, tiny.
    case tinyTeleport

    /// Vanishing and reappearing, small.
    case smallTeleport

    /// Vanishing and reappearing, medium.
    case mediumTeleport

    /// Vanishing and reappearing, large.
    case largeTeleport

    /// Vanishing and reappearing, huge.
    case hugeTeleport

    /// Something summoned, tiny.
    case tinySummon

    /// Something summoned, small.
    case smallSummon

    /// Something summoned, medium.
    case mediumSummon

    /// Something summoned, large.
    case largeSummon

    /// Something summoned, huge.
    case hugeSummon

    /// A hex, tiny.
    case tinyHex

    /// A hex, small.
    case smallHex

    /// A hex, medium.
    case mediumHex

    /// A hex, large.
    case largeHex

    /// A hex, huge.
    case hugeHex

    /// A spell fizzling, tiny.
    case tinyFizzle

    /// A spell fizzling, small.
    case smallFizzle

    /// A spell fizzling, medium.
    case mediumFizzle

    /// A spell fizzling, large.
    case largeFizzle

    /// A spell fizzling, huge.
    case hugeFizzle

    // MARK: Morse: short words in Morse code, from 12 to 26 words a minute

    /// OK in Morse code at 12 words a minute.
    case okInMorseSlow

    /// OK in Morse code at 15 words a minute.
    case okInMorseEasy

    /// OK in Morse code at 18 words a minute.
    case okInMorseSteady

    /// OK in Morse code at 22 words a minute.
    case okInMorseQuick

    /// OK in Morse code at 26 words a minute.
    case okInMorseRapid

    /// YES in Morse code at 12 words a minute.
    case yesInMorseSlow

    /// YES in Morse code at 15 words a minute.
    case yesInMorseEasy

    /// YES in Morse code at 18 words a minute.
    case yesInMorseSteady

    /// YES in Morse code at 22 words a minute.
    case yesInMorseQuick

    /// YES in Morse code at 26 words a minute.
    case yesInMorseRapid

    /// NO in Morse code at 12 words a minute.
    case noInMorseSlow

    /// NO in Morse code at 15 words a minute.
    case noInMorseEasy

    /// NO in Morse code at 18 words a minute.
    case noInMorseSteady

    /// NO in Morse code at 22 words a minute.
    case noInMorseQuick

    /// NO in Morse code at 26 words a minute.
    case noInMorseRapid

    /// HI in Morse code at 12 words a minute.
    case hiInMorseSlow

    /// HI in Morse code at 15 words a minute.
    case hiInMorseEasy

    /// HI in Morse code at 18 words a minute.
    case hiInMorseSteady

    /// HI in Morse code at 22 words a minute.
    case hiInMorseQuick

    /// HI in Morse code at 26 words a minute.
    case hiInMorseRapid

    /// GO in Morse code at 12 words a minute.
    case goInMorseSlow

    /// GO in Morse code at 15 words a minute.
    case goInMorseEasy

    /// GO in Morse code at 18 words a minute.
    case goInMorseSteady

    /// GO in Morse code at 22 words a minute.
    case goInMorseQuick

    /// GO in Morse code at 26 words a minute.
    case goInMorseRapid

    /// ON in Morse code at 12 words a minute.
    case onInMorseSlow

    /// ON in Morse code at 15 words a minute.
    case onInMorseEasy

    /// ON in Morse code at 18 words a minute.
    case onInMorseSteady

    /// ON in Morse code at 22 words a minute.
    case onInMorseQuick

    /// ON in Morse code at 26 words a minute.
    case onInMorseRapid

    /// OFF in Morse code at 12 words a minute.
    case offInMorseSlow

    /// OFF in Morse code at 15 words a minute.
    case offInMorseEasy

    /// OFF in Morse code at 18 words a minute.
    case offInMorseSteady

    /// OFF in Morse code at 22 words a minute.
    case offInMorseQuick

    /// OFF in Morse code at 26 words a minute.
    case offInMorseRapid

    /// UP in Morse code at 12 words a minute.
    case upInMorseSlow

    /// UP in Morse code at 15 words a minute.
    case upInMorseEasy

    /// UP in Morse code at 18 words a minute.
    case upInMorseSteady

    /// UP in Morse code at 22 words a minute.
    case upInMorseQuick

    /// UP in Morse code at 26 words a minute.
    case upInMorseRapid

    /// WIN in Morse code at 12 words a minute.
    case winInMorseSlow

    /// WIN in Morse code at 15 words a minute.
    case winInMorseEasy

    /// WIN in Morse code at 18 words a minute.
    case winInMorseSteady

    /// WIN in Morse code at 22 words a minute.
    case winInMorseQuick

    /// WIN in Morse code at 26 words a minute.
    case winInMorseRapid

    /// END in Morse code at 12 words a minute.
    case endInMorseSlow

    /// END in Morse code at 15 words a minute.
    case endInMorseEasy

    /// END in Morse code at 18 words a minute.
    case endInMorseSteady

    /// END in Morse code at 22 words a minute.
    case endInMorseQuick

    /// END in Morse code at 26 words a minute.
    case endInMorseRapid

    // MARK: Electronics: devices at work, from faint to intense

    /// Powering on, faint.
    case faintPowerOn

    /// Powering on, soft.
    case softPowerOn

    /// Powering on, firm.
    case firmPowerOn

    /// Powering on, strong.
    case strongPowerOn

    /// Powering on, intense.
    case intensePowerOn

    /// Powering off, faint.
    case faintPowerOff

    /// Powering off, soft.
    case softPowerOff

    /// Powering off, firm.
    case firmPowerOff

    /// Powering off, strong.
    case strongPowerOff

    /// Powering off, intense.
    case intensePowerOff

    /// Charging up, faint.
    case faintCharging

    /// Charging up, soft.
    case softCharging

    /// Charging up, firm.
    case firmCharging

    /// Charging up, strong.
    case strongCharging

    /// Charging up, intense.
    case intenseCharging

    /// A phone vibrating, faint.
    case faintVibrate

    /// A phone vibrating, soft.
    case softVibrate

    /// A phone vibrating, firm.
    case firmVibrate

    /// A phone vibrating, strong.
    case strongVibrate

    /// A phone vibrating, intense.
    case intenseVibrate

    /// A scanner beam, faint.
    case faintScanner

    /// A scanner beam, soft.
    case softScanner

    /// A scanner beam, firm.
    case firmScanner

    /// A scanner beam, strong.
    case strongScanner

    /// A scanner beam, intense.
    case intenseScanner

    /// A printer running, faint.
    case faintPrinter

    /// A printer running, soft.
    case softPrinter

    /// A printer running, firm.
    case firmPrinter

    /// A printer running, strong.
    case strongPrinter

    /// A printer running, intense.
    case intensePrinter

    /// A modem connecting, faint.
    case faintModem

    /// A modem connecting, soft.
    case softModem

    /// A modem connecting, firm.
    case firmModem

    /// A modem connecting, strong.
    case strongModem

    /// A modem connecting, intense.
    case intenseModem

    /// A glitch, faint.
    case faintGlitch

    /// A glitch, soft.
    case softGlitch

    /// A glitch, firm.
    case firmGlitch

    /// A glitch, strong.
    case strongGlitch

    /// A glitch, intense.
    case intenseGlitch

    /// A mouse click, faint.
    case faintClick

    /// A mouse click, soft.
    case softClick

    /// A mouse click, firm.
    case firmClick

    /// A mouse click, strong.
    case strongClick

    /// A mouse click, intense.
    case intenseClick

    /// Static noise, faint.
    case faintStatic

    /// Static noise, soft.
    case softStatic

    /// Static noise, firm.
    case firmStatic

    /// Static noise, strong.
    case strongStatic

    /// Static noise, intense.
    case intenseStatic
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
