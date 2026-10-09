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
/// Every pattern is also in the Android library, in the same order. The first ten came first, then ninety
/// more built by hand, then 2,900 generated in families, each a variant at one of several levels: 900 in ten families
/// of ninety, like ``heavyMetalHit`` or ``waltzAllegro``, then 2,000 in forty sets of fifty, like
/// ``hugeBark``, ``firmButton`` or ``tripleGem``, then 1,000 drawn at random from a fixed seed, like
/// ``emberNebula``.
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

    // MARK: Feedback taps: buttons and other targets, from faint to intense

    /// A button pressed, faint.
    case faintButton

    /// A button pressed, soft.
    case softButton

    /// A button pressed, firm.
    case firmButton

    /// A button pressed, strong.
    case strongButton

    /// A button pressed, intense.
    case intenseButton

    /// A card tapped, faint.
    case faintCardTap

    /// A card tapped, soft.
    case softCardTap

    /// A card tapped, firm.
    case firmCardTap

    /// A card tapped, strong.
    case strongCardTap

    /// A card tapped, intense.
    case intenseCardTap

    /// An icon tapped, faint.
    case faintIconTap

    /// An icon tapped, soft.
    case softIconTap

    /// An icon tapped, firm.
    case firmIconTap

    /// An icon tapped, strong.
    case strongIconTap

    /// An icon tapped, intense.
    case intenseIconTap

    /// A chip selected, faint.
    case faintChip

    /// A chip selected, soft.
    case softChip

    /// A chip selected, firm.
    case firmChip

    /// A chip selected, strong.
    case strongChip

    /// A chip selected, intense.
    case intenseChip

    /// A tab chosen, faint.
    case faintTab

    /// A tab chosen, soft.
    case softTab

    /// A tab chosen, firm.
    case firmTab

    /// A tab chosen, strong.
    case strongTab

    /// A tab chosen, intense.
    case intenseTab

    /// A badge cleared, faint.
    case faintBadge

    /// A badge cleared, soft.
    case softBadge

    /// A badge cleared, firm.
    case firmBadge

    /// A badge cleared, strong.
    case strongBadge

    /// A badge cleared, intense.
    case intenseBadge

    /// A box checked, faint.
    case faintCheckbox

    /// A box checked, soft.
    case softCheckbox

    /// A box checked, firm.
    case firmCheckbox

    /// A box checked, strong.
    case strongCheckbox

    /// A box checked, intense.
    case intenseCheckbox

    /// A radio button chosen, faint.
    case faintRadio

    /// A radio button chosen, soft.
    case softRadio

    /// A radio button chosen, firm.
    case firmRadio

    /// A radio button chosen, strong.
    case strongRadio

    /// A radio button chosen, intense.
    case intenseRadio

    /// A link followed, faint.
    case faintLink

    /// A link followed, soft.
    case softLink

    /// A link followed, firm.
    case firmLink

    /// A link followed, strong.
    case strongLink

    /// A link followed, intense.
    case intenseLink

    /// A menu item chosen, faint.
    case faintMenuItem

    /// A menu item chosen, soft.
    case softMenuItem

    /// A menu item chosen, firm.
    case firmMenuItem

    /// A menu item chosen, strong.
    case strongMenuItem

    /// A menu item chosen, intense.
    case intenseMenuItem

    // MARK: Feedback toggles: switches and catches, from tiny to huge

    /// Flipped over, tiny.
    case tinyFlip

    /// Flipped over, small.
    case smallFlip

    /// Flipped over, medium.
    case mediumFlip

    /// Flipped over, large.
    case largeFlip

    /// Flipped over, huge.
    case hugeFlip

    /// A latch catching, tiny.
    case tinyLatch

    /// A latch catching, small.
    case smallLatch

    /// A latch catching, medium.
    case mediumLatch

    /// A latch catching, large.
    case largeLatch

    /// A latch catching, huge.
    case hugeLatch

    /// A dial clicking round, tiny.
    case tinyDialClick

    /// A dial clicking round, small.
    case smallDialClick

    /// A dial clicking round, medium.
    case mediumDialClick

    /// A dial clicking round, large.
    case largeDialClick

    /// A dial clicking round, huge.
    case hugeDialClick

    /// A lever pulled, tiny.
    case tinyLever

    /// A lever pulled, small.
    case smallLever

    /// A lever pulled, medium.
    case mediumLever

    /// A lever pulled, large.
    case largeLever

    /// A lever pulled, huge.
    case hugeLever

    /// A knob turned, tiny.
    case tinyKnob

    /// A knob turned, small.
    case smallKnob

    /// A knob turned, medium.
    case mediumKnob

    /// A knob turned, large.
    case largeKnob

    /// A knob turned, huge.
    case hugeKnob

    /// A rocker switch, tiny.
    case tinyRocker

    /// A rocker switch, small.
    case smallRocker

    /// A rocker switch, medium.
    case mediumRocker

    /// A rocker switch, large.
    case largeRocker

    /// A rocker switch, huge.
    case hugeRocker

    /// A push button, tiny.
    case tinyPushButton

    /// A push button, small.
    case smallPushButton

    /// A push button, medium.
    case mediumPushButton

    /// A push button, large.
    case largePushButton

    /// A push button, huge.
    case hugePushButton

    /// A lock slid open, tiny.
    case tinySlideLock

    /// A lock slid open, small.
    case smallSlideLock

    /// A lock slid open, medium.
    case mediumSlideLock

    /// A lock slid open, large.
    case largeSlideLock

    /// A lock slid open, huge.
    case hugeSlideLock

    /// A thumb switch, tiny.
    case tinyThumbSwitch

    /// A thumb switch, small.
    case smallThumbSwitch

    /// A thumb switch, medium.
    case mediumThumbSwitch

    /// A thumb switch, large.
    case largeThumbSwitch

    /// A thumb switch, huge.
    case hugeThumbSwitch

    /// A detent, tiny.
    case tinyDetent

    /// A detent, small.
    case smallDetent

    /// A detent, medium.
    case mediumDetent

    /// A detent, large.
    case largeDetent

    /// A detent, huge.
    case hugeDetent

    // MARK: Feedback gestures: touches and swipes, from slow to rapid

    /// A fling, slow.
    case slowFling

    /// A fling, easy.
    case easyFling

    /// A fling, steady.
    case steadyFling

    /// A fling, quick.
    case quickFling

    /// A fling, rapid.
    case rapidFling

    /// A pinch closing, slow.
    case slowPinch

    /// A pinch closing, easy.
    case easyPinch

    /// A pinch closing, steady.
    case steadyPinch

    /// A pinch closing, quick.
    case quickPinch

    /// A pinch closing, rapid.
    case rapidPinch

    /// A pinch opening, slow.
    case slowSpread

    /// A pinch opening, easy.
    case easySpread

    /// A pinch opening, steady.
    case steadySpread

    /// A pinch opening, quick.
    case quickSpread

    /// A pinch opening, rapid.
    case rapidSpread

    /// Dragged, then dropped, slow.
    case slowDrag

    /// Dragged, then dropped, easy.
    case easyDrag

    /// Dragged, then dropped, steady.
    case steadyDrag

    /// Dragged, then dropped, quick.
    case quickDrag

    /// Dragged, then dropped, rapid.
    case rapidDrag

    /// Held, then released, slow.
    case slowLongHold

    /// Held, then released, easy.
    case easyLongHold

    /// Held, then released, steady.
    case steadyLongHold

    /// Held, then released, quick.
    case quickLongHold

    /// Held, then released, rapid.
    case rapidLongHold

    /// A flick, slow.
    case slowFlick

    /// A flick, easy.
    case easyFlick

    /// A flick, steady.
    case steadyFlick

    /// A flick, quick.
    case quickFlick

    /// A flick, rapid.
    case rapidFlick

    /// Panning around, slow.
    case slowPan

    /// Panning around, easy.
    case easyPan

    /// Panning around, steady.
    case steadyPan

    /// Panning around, quick.
    case quickPan

    /// Panning around, rapid.
    case rapidPan

    /// A swipe from the edge, slow.
    case slowEdgeSwipe

    /// A swipe from the edge, easy.
    case easyEdgeSwipe

    /// A swipe from the edge, steady.
    case steadyEdgeSwipe

    /// A swipe from the edge, quick.
    case quickEdgeSwipe

    /// A swipe from the edge, rapid.
    case rapidEdgeSwipe

    /// A twist, slow.
    case slowTwist

    /// A twist, easy.
    case easyTwist

    /// A twist, steady.
    case steadyTwist

    /// A twist, quick.
    case quickTwist

    /// A twist, rapid.
    case rapidTwist

    /// Pressed twice, slow.
    case slowDoublePress

    /// Pressed twice, easy.
    case easyDoublePress

    /// Pressed twice, steady.
    case steadyDoublePress

    /// Pressed twice, quick.
    case quickDoublePress

    /// Pressed twice, rapid.
    case rapidDoublePress

    // MARK: Feedback results: actions done, from once to five times

    /// Saved, once.
    case singleSave

    /// Saved, twice.
    case doubleSave

    /// Saved, three times.
    case tripleSave

    /// Saved, four times.
    case quadrupleSave

    /// Saved, five times.
    case quintupleSave

    /// Sent, once.
    case singleSend

    /// Sent, twice.
    case doubleSend

    /// Sent, three times.
    case tripleSend

    /// Sent, four times.
    case quadrupleSend

    /// Sent, five times.
    case quintupleSend

    /// Copied, once.
    case singleCopy

    /// Copied, twice.
    case doubleCopy

    /// Copied, three times.
    case tripleCopy

    /// Copied, four times.
    case quadrupleCopy

    /// Copied, five times.
    case quintupleCopy

    /// Removed, once.
    case singleRemoveItem

    /// Removed, twice.
    case doubleRemoveItem

    /// Removed, three times.
    case tripleRemoveItem

    /// Removed, four times.
    case quadrupleRemoveItem

    /// Removed, five times.
    case quintupleRemoveItem

    /// Reverted, once.
    case singleRevert

    /// Reverted, twice.
    case doubleRevert

    /// Reverted, three times.
    case tripleRevert

    /// Reverted, four times.
    case quadrupleRevert

    /// Reverted, five times.
    case quintupleRevert

    /// Added, once.
    case singleAdd

    /// Added, twice.
    case doubleAdd

    /// Added, three times.
    case tripleAdd

    /// Added, four times.
    case quadrupleAdd

    /// Added, five times.
    case quintupleAdd

    /// Discarded, once.
    case singleDiscard

    /// Discarded, twice.
    case doubleDiscard

    /// Discarded, three times.
    case tripleDiscard

    /// Discarded, four times.
    case quadrupleDiscard

    /// Discarded, five times.
    case quintupleDiscard

    /// Uploaded, once.
    case singleUploadDone

    /// Uploaded, twice.
    case doubleUploadDone

    /// Uploaded, three times.
    case tripleUploadDone

    /// Uploaded, four times.
    case quadrupleUploadDone

    /// Uploaded, five times.
    case quintupleUploadDone

    /// Liked, once.
    case singleLike

    /// Liked, twice.
    case doubleLike

    /// Liked, three times.
    case tripleLike

    /// Liked, four times.
    case quadrupleLike

    /// Liked, five times.
    case quintupleLike

    /// Shared, once.
    case singleShare

    /// Shared, twice.
    case doubleShare

    /// Shared, three times.
    case tripleShare

    /// Shared, four times.
    case quadrupleShare

    /// Shared, five times.
    case quintupleShare

    // MARK: Alert chimes: bells and tones, from once to five times

    /// A two-tone door chime, once.
    case singleDoorChime

    /// A two-tone door chime, twice.
    case doubleDoorChime

    /// A two-tone door chime, three times.
    case tripleDoorChime

    /// A two-tone door chime, four times.
    case quadrupleDoorChime

    /// A two-tone door chime, five times.
    case quintupleDoorChime

    /// Wind chimes, once.
    case singleWindChime

    /// Wind chimes, twice.
    case doubleWindChime

    /// Wind chimes, three times.
    case tripleWindChime

    /// Wind chimes, four times.
    case quadrupleWindChime

    /// Wind chimes, five times.
    case quintupleWindChime

    /// A pair of tones, once.
    case singleTonePair

    /// A pair of tones, twice.
    case doubleTonePair

    /// A pair of tones, three times.
    case tripleTonePair

    /// A pair of tones, four times.
    case quadrupleTonePair

    /// A pair of tones, five times.
    case quintupleTonePair

    /// A rising arpeggio, once.
    case singleArpeggio

    /// A rising arpeggio, twice.
    case doubleArpeggio

    /// A rising arpeggio, three times.
    case tripleArpeggio

    /// A rising arpeggio, four times.
    case quadrupleArpeggio

    /// A rising arpeggio, five times.
    case quintupleArpeggio

    /// A low bell, once.
    case singleLowBell

    /// A low bell, twice.
    case doubleLowBell

    /// A low bell, three times.
    case tripleLowBell

    /// A low bell, four times.
    case quadrupleLowBell

    /// A low bell, five times.
    case quintupleLowBell

    /// A held harmonic, once.
    case singleHarmonic

    /// A held harmonic, twice.
    case doubleHarmonic

    /// A held harmonic, three times.
    case tripleHarmonic

    /// A held harmonic, four times.
    case quadrupleHarmonic

    /// A held harmonic, five times.
    case quintupleHarmonic

    /// A glass chime, once.
    case singleGlassChime

    /// A glass chime, twice.
    case doubleGlassChime

    /// A glass chime, three times.
    case tripleGlassChime

    /// A glass chime, four times.
    case quadrupleGlassChime

    /// A glass chime, five times.
    case quintupleGlassChime

    /// Twin bells, once.
    case singleTwinBell

    /// Twin bells, twice.
    case doubleTwinBell

    /// Twin bells, three times.
    case tripleTwinBell

    /// Twin bells, four times.
    case quadrupleTwinBell

    /// Twin bells, five times.
    case quintupleTwinBell

    /// A soft gong, once.
    case singleSoftGong

    /// A soft gong, twice.
    case doubleSoftGong

    /// A soft gong, three times.
    case tripleSoftGong

    /// A soft gong, four times.
    case quadrupleSoftGong

    /// A soft gong, five times.
    case quintupleSoftGong

    /// A bright tone, once.
    case singleBrightTone

    /// A bright tone, twice.
    case doubleBrightTone

    /// A bright tone, three times.
    case tripleBrightTone

    /// A bright tone, four times.
    case quadrupleBrightTone

    /// A bright tone, five times.
    case quintupleBrightTone

    // MARK: Alert calls: rings and calls, from slow to rapid

    /// A phone ringing, slow.
    case slowRingtone

    /// A phone ringing, easy.
    case easyRingtone

    /// A phone ringing, steady.
    case steadyRingtone

    /// A phone ringing, quick.
    case quickRingtone

    /// A phone ringing, rapid.
    case rapidRingtone

    /// An intercom buzz, slow.
    case slowIntercom

    /// An intercom buzz, easy.
    case easyIntercom

    /// An intercom buzz, steady.
    case steadyIntercom

    /// An intercom buzz, quick.
    case quickIntercom

    /// An intercom buzz, rapid.
    case rapidIntercom

    /// A pager going off, slow.
    case slowPager

    /// A pager going off, easy.
    case easyPager

    /// A pager going off, steady.
    case steadyPager

    /// A pager going off, quick.
    case quickPager

    /// A pager going off, rapid.
    case rapidPager

    /// A walkie-talkie click, slow.
    case slowWalkieTalkie

    /// A walkie-talkie click, easy.
    case easyWalkieTalkie

    /// A walkie-talkie click, steady.
    case steadyWalkieTalkie

    /// A walkie-talkie click, quick.
    case quickWalkieTalkie

    /// A walkie-talkie click, rapid.
    case rapidWalkieTalkie

    /// A long buzzer, slow.
    case slowBuzzer

    /// A long buzzer, easy.
    case easyBuzzer

    /// A long buzzer, steady.
    case steadyBuzzer

    /// A long buzzer, quick.
    case quickBuzzer

    /// A long buzzer, rapid.
    case rapidBuzzer

    /// A hotline ringing, slow.
    case slowHotline

    /// A hotline ringing, easy.
    case easyHotline

    /// A hotline ringing, steady.
    case steadyHotline

    /// A hotline ringing, quick.
    case quickHotline

    /// A hotline ringing, rapid.
    case rapidHotline

    /// A telegraph key, slow.
    case slowTelegraph

    /// A telegraph key, easy.
    case easyTelegraph

    /// A telegraph key, steady.
    case steadyTelegraph

    /// A telegraph key, quick.
    case quickTelegraph

    /// A telegraph key, rapid.
    case rapidTelegraph

    /// On hold, slow.
    case slowHoldMusic

    /// On hold, easy.
    case easyHoldMusic

    /// On hold, steady.
    case steadyHoldMusic

    /// On hold, quick.
    case quickHoldMusic

    /// On hold, rapid.
    case rapidHoldMusic

    /// A busy signal, slow.
    case slowBusySignal

    /// A busy signal, easy.
    case easyBusySignal

    /// A busy signal, steady.
    case steadyBusySignal

    /// A busy signal, quick.
    case quickBusySignal

    /// A busy signal, rapid.
    case rapidBusySignal

    /// A voicemail waiting, slow.
    case slowVoicemail

    /// A voicemail waiting, easy.
    case easyVoicemail

    /// A voicemail waiting, steady.
    case steadyVoicemail

    /// A voicemail waiting, quick.
    case quickVoicemail

    /// A voicemail waiting, rapid.
    case rapidVoicemail

    // MARK: Alert warnings: something's wrong, from faint to intense

    /// Caution, faint.
    case faintCaution

    /// Caution, soft.
    case softCaution

    /// Caution, firm.
    case firmCaution

    /// Caution, strong.
    case strongCaution

    /// Caution, intense.
    case intenseCaution

    /// A hazard flashing, faint.
    case faintHazard

    /// A hazard flashing, soft.
    case softHazard

    /// A hazard flashing, firm.
    case firmHazard

    /// A hazard flashing, strong.
    case strongHazard

    /// A hazard flashing, intense.
    case intenseHazard

    /// Heat building, faint.
    case faintOverheat

    /// Heat building, soft.
    case softOverheat

    /// Heat building, firm.
    case firmOverheat

    /// Heat building, strong.
    case strongOverheat

    /// Heat building, intense.
    case intenseOverheat

    /// A signal fading, faint.
    case faintLowSignal

    /// A signal fading, soft.
    case softLowSignal

    /// A signal fading, firm.
    case firmLowSignal

    /// A signal fading, strong.
    case strongLowSignal

    /// A signal fading, intense.
    case intenseLowSignal

    /// Storage full, faint.
    case faintStorageFull

    /// Storage full, soft.
    case softStorageFull

    /// Storage full, firm.
    case firmStorageFull

    /// Storage full, strong.
    case strongStorageFull

    /// Storage full, intense.
    case intenseStorageFull

    /// Timed out, faint.
    case faintTimeout

    /// Timed out, soft.
    case softTimeout

    /// Timed out, firm.
    case firmTimeout

    /// Timed out, strong.
    case strongTimeout

    /// Timed out, intense.
    case intenseTimeout

    /// Blocked, faint.
    case faintBlocked

    /// Blocked, soft.
    case softBlocked

    /// Blocked, firm.
    case firmBlocked

    /// Blocked, strong.
    case strongBlocked

    /// Blocked, intense.
    case intenseBlocked

    /// Denied, faint.
    case faintDenied

    /// Denied, soft.
    case softDenied

    /// Denied, firm.
    case firmDenied

    /// Denied, strong.
    case strongDenied

    /// Denied, intense.
    case intenseDenied

    /// An error tone, faint.
    case faintErrorTone

    /// An error tone, soft.
    case softErrorTone

    /// An error tone, firm.
    case firmErrorTone

    /// An error tone, strong.
    case strongErrorTone

    /// An error tone, intense.
    case intenseErrorTone

    /// A critical alert, faint.
    case faintCriticalAlert

    /// A critical alert, soft.
    case softCriticalAlert

    /// A critical alert, firm.
    case firmCriticalAlert

    /// A critical alert, strong.
    case strongCriticalAlert

    /// A critical alert, intense.
    case intenseCriticalAlert

    // MARK: Rhythm beats: drum patterns, from slow to rapid

    /// A backbeat, slow.
    case slowBackbeat

    /// A backbeat, easy.
    case easyBackbeat

    /// A backbeat, steady.
    case steadyBackbeat

    /// A backbeat, quick.
    case quickBackbeat

    /// A backbeat, rapid.
    case rapidBackbeat

    /// Offbeat hits, slow.
    case slowOffbeat

    /// Offbeat hits, easy.
    case easyOffbeat

    /// Offbeat hits, steady.
    case steadyOffbeat

    /// Offbeat hits, quick.
    case quickOffbeat

    /// Offbeat hits, rapid.
    case rapidOffbeat

    /// A half-time feel, slow.
    case slowHalfTime

    /// A half-time feel, easy.
    case easyHalfTime

    /// A half-time feel, steady.
    case steadyHalfTime

    /// A half-time feel, quick.
    case quickHalfTime

    /// A half-time feel, rapid.
    case rapidHalfTime

    /// A double-time feel, slow.
    case slowDoubleTime

    /// A double-time feel, easy.
    case easyDoubleTime

    /// A double-time feel, steady.
    case steadyDoubleTime

    /// A double-time feel, quick.
    case quickDoubleTime

    /// A double-time feel, rapid.
    case rapidDoubleTime

    /// Triplets, slow.
    case slowTriplet

    /// Triplets, easy.
    case easyTriplet

    /// Triplets, steady.
    case steadyTriplet

    /// Triplets, quick.
    case quickTriplet

    /// Triplets, rapid.
    case rapidTriplet

    /// A syncopated beat, slow.
    case slowSyncopated

    /// A syncopated beat, easy.
    case easySyncopated

    /// A syncopated beat, steady.
    case steadySyncopated

    /// A syncopated beat, quick.
    case quickSyncopated

    /// A syncopated beat, rapid.
    case rapidSyncopated

    /// A cross rhythm, slow.
    case slowCrossBeat

    /// A cross rhythm, easy.
    case easyCrossBeat

    /// A cross rhythm, steady.
    case steadyCrossBeat

    /// A cross rhythm, quick.
    case quickCrossBeat

    /// A cross rhythm, rapid.
    case rapidCrossBeat

    /// A breakbeat, slow.
    case slowBreakbeat

    /// A breakbeat, easy.
    case easyBreakbeat

    /// A breakbeat, steady.
    case steadyBreakbeat

    /// A breakbeat, quick.
    case quickBreakbeat

    /// A breakbeat, rapid.
    case rapidBreakbeat

    /// A paradiddle, slow.
    case slowParadiddle

    /// A paradiddle, easy.
    case easyParadiddle

    /// A paradiddle, steady.
    case steadyParadiddle

    /// A paradiddle, quick.
    case quickParadiddle

    /// A paradiddle, rapid.
    case rapidParadiddle

    /// Flams, slow.
    case slowFlam

    /// Flams, easy.
    case easyFlam

    /// Flams, steady.
    case steadyFlam

    /// Flams, quick.
    case quickFlam

    /// Flams, rapid.
    case rapidFlam

    // MARK: Rhythm pulses: single beats, from once to five times

    /// A thump, once.
    case singleThump

    /// A thump, twice.
    case doubleThump

    /// A thump, three times.
    case tripleThump

    /// A thump, four times.
    case quadrupleThump

    /// A thump, five times.
    case quintupleThump

    /// A pound, once.
    case singlePound

    /// A pound, twice.
    case doublePound

    /// A pound, three times.
    case triplePound

    /// A pound, four times.
    case quadruplePound

    /// A pound, five times.
    case quintuplePound

    /// A patter, once.
    case singlePatter

    /// A patter, twice.
    case doublePatter

    /// A patter, three times.
    case triplePatter

    /// A patter, four times.
    case quadruplePatter

    /// A patter, five times.
    case quintuplePatter

    /// A bump, once.
    case singleBump

    /// A bump, twice.
    case doubleBump

    /// A bump, three times.
    case tripleBump

    /// A bump, four times.
    case quadrupleBump

    /// A bump, five times.
    case quintupleBump

    /// A thud, once.
    case singleThud

    /// A thud, twice.
    case doubleThud

    /// A thud, three times.
    case tripleThud

    /// A thud, four times.
    case quadrupleThud

    /// A thud, five times.
    case quintupleThud

    /// A strike, once.
    case singleStrike

    /// A strike, twice.
    case doubleStrike

    /// A strike, three times.
    case tripleStrike

    /// A strike, four times.
    case quadrupleStrike

    /// A strike, five times.
    case quintupleStrike

    /// A rap on a door, once.
    case singleRap

    /// A rap on a door, twice.
    case doubleRap

    /// A rap on a door, three times.
    case tripleRap

    /// A rap on a door, four times.
    case quadrupleRap

    /// A rap on a door, five times.
    case quintupleRap

    /// A pair of taps, once.
    case singleTapPair

    /// A pair of taps, twice.
    case doubleTapPair

    /// A pair of taps, three times.
    case tripleTapPair

    /// A pair of taps, four times.
    case quadrupleTapPair

    /// A pair of taps, five times.
    case quintupleTapPair

    /// A drumbeat, once.
    case singleDrumbeat

    /// A drumbeat, twice.
    case doubleDrumbeat

    /// A drumbeat, three times.
    case tripleDrumbeat

    /// A drumbeat, four times.
    case quadrupleDrumbeat

    /// A drumbeat, five times.
    case quintupleDrumbeat

    /// A heave, once.
    case singleHeave

    /// A heave, twice.
    case doubleHeave

    /// A heave, three times.
    case tripleHeave

    /// A heave, four times.
    case quadrupleHeave

    /// A heave, five times.
    case quintupleHeave

    // MARK: Rhythm footwork: steps, from slow to rapid

    /// Walking, slow.
    case slowWalking

    /// Walking, easy.
    case easyWalking

    /// Walking, steady.
    case steadyWalking

    /// Walking, quick.
    case quickWalking

    /// Walking, rapid.
    case rapidWalking

    /// Running, slow.
    case slowRunning

    /// Running, easy.
    case easyRunning

    /// Running, steady.
    case steadyRunning

    /// Running, quick.
    case quickRunning

    /// Running, rapid.
    case rapidRunning

    /// Marching, slow.
    case slowMarchingFeet

    /// Marching, easy.
    case easyMarchingFeet

    /// Marching, steady.
    case steadyMarchingFeet

    /// Marching, quick.
    case quickMarchingFeet

    /// Marching, rapid.
    case rapidMarchingFeet

    /// Tiptoeing, slow.
    case slowTiptoe

    /// Tiptoeing, easy.
    case easyTiptoe

    /// Tiptoeing, steady.
    case steadyTiptoe

    /// Tiptoeing, quick.
    case quickTiptoe

    /// Tiptoeing, rapid.
    case rapidTiptoe

    /// Skipping, slow.
    case slowSkipping

    /// Skipping, easy.
    case easySkipping

    /// Skipping, steady.
    case steadySkipping

    /// Skipping, quick.
    case quickSkipping

    /// Skipping, rapid.
    case rapidSkipping

    /// Stomping, slow.
    case slowStomping

    /// Stomping, easy.
    case easyStomping

    /// Stomping, steady.
    case steadyStomping

    /// Stomping, quick.
    case quickStomping

    /// Stomping, rapid.
    case rapidStomping

    /// Tap dancing, slow.
    case slowTapDance

    /// Tap dancing, easy.
    case easyTapDance

    /// Tap dancing, steady.
    case steadyTapDance

    /// Tap dancing, quick.
    case quickTapDance

    /// Tap dancing, rapid.
    case rapidTapDance

    /// Jogging, slow.
    case slowJogging

    /// Jogging, easy.
    case easyJogging

    /// Jogging, steady.
    case steadyJogging

    /// Jogging, quick.
    case quickJogging

    /// Jogging, rapid.
    case rapidJogging

    /// Climbing stairs, slow.
    case slowClimbingStairs

    /// Climbing stairs, easy.
    case easyClimbingStairs

    /// Climbing stairs, steady.
    case steadyClimbingStairs

    /// Climbing stairs, quick.
    case quickClimbingStairs

    /// Climbing stairs, rapid.
    case rapidClimbingStairs

    /// Shuffling along, slow.
    case slowShufflingFeet

    /// Shuffling along, easy.
    case easyShufflingFeet

    /// Shuffling along, steady.
    case steadyShufflingFeet

    /// Shuffling along, quick.
    case quickShufflingFeet

    /// Shuffling along, rapid.
    case rapidShufflingFeet

    // MARK: Texture grains: grainy surfaces, from faint to intense

    /// Fine grit, faint.
    case faintGrit

    /// Fine grit, soft.
    case softGrit

    /// Fine grit, firm.
    case firmGrit

    /// Fine grit, strong.
    case strongGrit

    /// Fine grit, intense.
    case intenseGrit

    /// Pebbles, faint.
    case faintPebbles

    /// Pebbles, soft.
    case softPebbles

    /// Pebbles, firm.
    case firmPebbles

    /// Pebbles, strong.
    case strongPebbles

    /// Pebbles, intense.
    case intensePebbles

    /// Grains of salt, faint.
    case faintSalt

    /// Grains of salt, soft.
    case softSalt

    /// Grains of salt, firm.
    case firmSalt

    /// Grains of salt, strong.
    case strongSalt

    /// Grains of salt, intense.
    case intenseSalt

    /// A gravel path, faint.
    case faintGravelPath

    /// A gravel path, soft.
    case softGravelPath

    /// A gravel path, firm.
    case firmGravelPath

    /// A gravel path, strong.
    case strongGravelPath

    /// A gravel path, intense.
    case intenseGravelPath

    /// Crumbs, faint.
    case faintCrumbs

    /// Crumbs, soft.
    case softCrumbs

    /// Crumbs, firm.
    case firmCrumbs

    /// Crumbs, strong.
    case strongCrumbs

    /// Crumbs, intense.
    case intenseCrumbs

    /// Velcro pulled apart, faint.
    case faintVelcro

    /// Velcro pulled apart, soft.
    case softVelcro

    /// Velcro pulled apart, firm.
    case firmVelcro

    /// Velcro pulled apart, strong.
    case strongVelcro

    /// Velcro pulled apart, intense.
    case intenseVelcro

    /// Bubble wrap popping, faint.
    case faintBubbleWrap

    /// Bubble wrap popping, soft.
    case softBubbleWrap

    /// Bubble wrap popping, firm.
    case firmBubbleWrap

    /// Bubble wrap popping, strong.
    case strongBubbleWrap

    /// Bubble wrap popping, intense.
    case intenseBubbleWrap

    /// Corrugated card, faint.
    case faintCorrugated

    /// Corrugated card, soft.
    case softCorrugated

    /// Corrugated card, firm.
    case firmCorrugated

    /// Corrugated card, strong.
    case strongCorrugated

    /// Corrugated card, intense.
    case intenseCorrugated

    /// Beads rolling, faint.
    case faintBeads

    /// Beads rolling, soft.
    case softBeads

    /// Beads rolling, firm.
    case firmBeads

    /// Beads rolling, strong.
    case strongBeads

    /// Beads rolling, intense.
    case intenseBeads

    /// Sawdust, faint.
    case faintSawdust

    /// Sawdust, soft.
    case softSawdust

    /// Sawdust, firm.
    case firmSawdust

    /// Sawdust, strong.
    case strongSawdust

    /// Sawdust, intense.
    case intenseSawdust

    // MARK: Texture hums: steady sounds, from tiny to huge

    /// A low drone, tiny.
    case tinyDrone

    /// A low drone, small.
    case smallDrone

    /// A low drone, medium.
    case mediumDrone

    /// A low drone, large.
    case largeDrone

    /// A low drone, huge.
    case hugeDrone

    /// A whirr, tiny.
    case tinyWhirr

    /// A whirr, small.
    case smallWhirr

    /// A whirr, medium.
    case mediumWhirr

    /// A whirr, large.
    case largeWhirr

    /// A whirr, huge.
    case hugeWhirr

    /// A murmur, tiny.
    case tinyMurmur

    /// A murmur, small.
    case smallMurmur

    /// A murmur, medium.
    case mediumMurmur

    /// A murmur, large.
    case largeMurmur

    /// A murmur, huge.
    case hugeMurmur

    /// A vibration, tiny.
    case tinyVibration

    /// A vibration, small.
    case smallVibration

    /// A vibration, medium.
    case mediumVibration

    /// A vibration, large.
    case largeVibration

    /// A vibration, huge.
    case hugeVibration

    /// A fading resonance, tiny.
    case tinyResonance

    /// A fading resonance, small.
    case smallResonance

    /// A fading resonance, medium.
    case mediumResonance

    /// A fading resonance, large.
    case largeResonance

    /// A fading resonance, huge.
    case hugeResonance

    /// A thrum, tiny.
    case tinyThrum

    /// A thrum, small.
    case smallThrum

    /// A thrum, medium.
    case mediumThrum

    /// A thrum, large.
    case largeThrum

    /// A thrum, huge.
    case hugeThrum

    /// A fizz, tiny.
    case tinyFizz

    /// A fizz, small.
    case smallFizz

    /// A fizz, medium.
    case mediumFizz

    /// A fizz, large.
    case largeFizz

    /// A fizz, huge.
    case hugeFizz

    /// A crackle, tiny.
    case tinyCrackle

    /// A crackle, small.
    case smallCrackle

    /// A crackle, medium.
    case mediumCrackle

    /// A crackle, large.
    case largeCrackle

    /// A crackle, huge.
    case hugeCrackle

    /// A hiss, tiny.
    case tinyHiss

    /// A hiss, small.
    case smallHiss

    /// A hiss, medium.
    case mediumHiss

    /// A hiss, large.
    case largeHiss

    /// A hiss, huge.
    case hugeHiss

    /// A warble, tiny.
    case tinyWarble

    /// A warble, small.
    case smallWarble

    /// A warble, medium.
    case mediumWarble

    /// A warble, large.
    case largeWarble

    /// A warble, huge.
    case hugeWarble

    // MARK: Texture swells: rising and falling, from slow to rapid

    /// A crest, slow.
    case slowCrest

    /// A crest, easy.
    case easyCrest

    /// A crest, steady.
    case steadyCrest

    /// A crest, quick.
    case quickCrest

    /// A crest, rapid.
    case rapidCrest

    /// An undulation, slow.
    case slowUndulation

    /// An undulation, easy.
    case easyUndulation

    /// An undulation, steady.
    case steadyUndulation

    /// An undulation, quick.
    case quickUndulation

    /// An undulation, rapid.
    case rapidUndulation

    /// A glide sharpening, slow.
    case slowGlide

    /// A glide sharpening, easy.
    case easyGlide

    /// A glide sharpening, steady.
    case steadyGlide

    /// A glide sharpening, quick.
    case quickGlide

    /// A glide sharpening, rapid.
    case rapidGlide

    /// A billow, slow.
    case slowBillow

    /// A billow, easy.
    case easyBillow

    /// A billow, steady.
    case steadyBillow

    /// A billow, quick.
    case quickBillow

    /// A billow, rapid.
    case rapidBillow

    /// A flare, slow.
    case slowFlare

    /// A flare, easy.
    case easyFlare

    /// A flare, steady.
    case steadyFlare

    /// A flare, quick.
    case quickFlare

    /// A flare, rapid.
    case rapidFlare

    /// Fading in, slow.
    case slowFadeIn

    /// Fading in, easy.
    case easyFadeIn

    /// Fading in, steady.
    case steadyFadeIn

    /// Fading in, quick.
    case quickFadeIn

    /// Fading in, rapid.
    case rapidFadeIn

    /// Fading away, slow.
    case slowFadeAway

    /// Fading away, easy.
    case easyFadeAway

    /// Fading away, steady.
    case steadyFadeAway

    /// Fading away, quick.
    case quickFadeAway

    /// Fading away, rapid.
    case rapidFadeAway

    /// Breathing, slow.
    case slowBreathing

    /// Breathing, easy.
    case easyBreathing

    /// Breathing, steady.
    case steadyBreathing

    /// Breathing, quick.
    case quickBreathing

    /// Breathing, rapid.
    case rapidBreathing

    /// A tremolo, slow.
    case slowTremolo

    /// A tremolo, easy.
    case easyTremolo

    /// A tremolo, steady.
    case steadyTremolo

    /// A tremolo, quick.
    case quickTremolo

    /// A tremolo, rapid.
    case rapidTremolo

    /// A lull, slow.
    case slowLull

    /// A lull, easy.
    case easyLull

    /// A lull, steady.
    case steadyLull

    /// A lull, quick.
    case quickLull

    /// A lull, rapid.
    case rapidLull

    // MARK: Nature creatures: wildlife, from tiny to huge

    /// A frog croaking, tiny.
    case tinyFrog

    /// A frog croaking, small.
    case smallFrog

    /// A frog croaking, medium.
    case mediumFrog

    /// A frog croaking, large.
    case largeFrog

    /// A frog croaking, huge.
    case hugeFrog

    /// An owl hooting, tiny.
    case tinyOwl

    /// An owl hooting, small.
    case smallOwl

    /// An owl hooting, medium.
    case mediumOwl

    /// An owl hooting, large.
    case largeOwl

    /// An owl hooting, huge.
    case hugeOwl

    /// A hummingbird hovering, tiny.
    case tinyHummingbird

    /// A hummingbird hovering, small.
    case smallHummingbird

    /// A hummingbird hovering, medium.
    case mediumHummingbird

    /// A hummingbird hovering, large.
    case largeHummingbird

    /// A hummingbird hovering, huge.
    case hugeHummingbird

    /// A squirrel chattering, tiny.
    case tinySquirrel

    /// A squirrel chattering, small.
    case smallSquirrel

    /// A squirrel chattering, medium.
    case mediumSquirrel

    /// A squirrel chattering, large.
    case largeSquirrel

    /// A squirrel chattering, huge.
    case hugeSquirrel

    /// A rattlesnake, tiny.
    case tinySnakeRattle

    /// A rattlesnake, small.
    case smallSnakeRattle

    /// A rattlesnake, medium.
    case mediumSnakeRattle

    /// A rattlesnake, large.
    case largeSnakeRattle

    /// A rattlesnake, huge.
    case hugeSnakeRattle

    /// A lion's roar, tiny.
    case tinyLionRoar

    /// A lion's roar, small.
    case smallLionRoar

    /// A lion's roar, medium.
    case mediumLionRoar

    /// A lion's roar, large.
    case largeLionRoar

    /// A lion's roar, huge.
    case hugeLionRoar

    /// An elephant's stomp, tiny.
    case tinyElephant

    /// An elephant's stomp, small.
    case smallElephant

    /// An elephant's stomp, medium.
    case mediumElephant

    /// An elephant's stomp, large.
    case largeElephant

    /// An elephant's stomp, huge.
    case hugeElephant

    /// A mosquito, tiny.
    case tinyMosquito

    /// A mosquito, small.
    case smallMosquito

    /// A mosquito, medium.
    case mediumMosquito

    /// A mosquito, large.
    case largeMosquito

    /// A mosquito, huge.
    case hugeMosquito

    /// Fireflies, tiny.
    case tinyFirefly

    /// Fireflies, small.
    case smallFirefly

    /// Fireflies, medium.
    case mediumFirefly

    /// Fireflies, large.
    case largeFirefly

    /// Fireflies, huge.
    case hugeFirefly

    /// Bat wings, tiny.
    case tinyBatWings

    /// Bat wings, small.
    case smallBatWings

    /// Bat wings, medium.
    case mediumBatWings

    /// Bat wings, large.
    case largeBatWings

    /// Bat wings, huge.
    case hugeBatWings

    // MARK: Nature water: water in motion, from faint to intense

    /// A slow drip, faint.
    case faintDrip

    /// A slow drip, soft.
    case softDrip

    /// A slow drip, firm.
    case firmDrip

    /// A slow drip, strong.
    case strongDrip

    /// A slow drip, intense.
    case intenseDrip

    /// A puddle splash, faint.
    case faintPuddle

    /// A puddle splash, soft.
    case softPuddle

    /// A puddle splash, firm.
    case firmPuddle

    /// A puddle splash, strong.
    case strongPuddle

    /// A puddle splash, intense.
    case intensePuddle

    /// A waterfall, faint.
    case faintWaterfall

    /// A waterfall, soft.
    case softWaterfall

    /// A waterfall, firm.
    case firmWaterfall

    /// A waterfall, strong.
    case strongWaterfall

    /// A waterfall, intense.
    case intenseWaterfall

    /// A babbling brook, faint.
    case faintBrook

    /// A babbling brook, soft.
    case softBrook

    /// A babbling brook, firm.
    case firmBrook

    /// A babbling brook, strong.
    case strongBrook

    /// A babbling brook, intense.
    case intenseBrook

    /// A fountain, faint.
    case faintFountain

    /// A fountain, soft.
    case softFountain

    /// A fountain, firm.
    case firmFountain

    /// A fountain, strong.
    case strongFountain

    /// A fountain, intense.
    case intenseFountain

    /// A geyser erupting, faint.
    case faintGeyser

    /// A geyser erupting, soft.
    case softGeyser

    /// A geyser erupting, firm.
    case firmGeyser

    /// A geyser erupting, strong.
    case strongGeyser

    /// A geyser erupting, intense.
    case intenseGeyser

    /// Water lapping a shore, faint.
    case faintLakeLap

    /// Water lapping a shore, soft.
    case softLakeLap

    /// Water lapping a shore, firm.
    case firmLakeLap

    /// Water lapping a shore, strong.
    case strongLakeLap

    /// Water lapping a shore, intense.
    case intenseLakeLap

    /// Icicles dripping, faint.
    case faintIcicle

    /// Icicles dripping, soft.
    case softIcicle

    /// Icicles dripping, firm.
    case firmIcicle

    /// Icicles dripping, strong.
    case strongIcicle

    /// Icicles dripping, intense.
    case intenseIcicle

    /// A hot spring, faint.
    case faintHotSpring

    /// A hot spring, soft.
    case softHotSpring

    /// A hot spring, firm.
    case firmHotSpring

    /// A hot spring, strong.
    case strongHotSpring

    /// A hot spring, intense.
    case intenseHotSpring

    /// River rapids, faint.
    case faintRiverRapids

    /// River rapids, soft.
    case softRiverRapids

    /// River rapids, firm.
    case firmRiverRapids

    /// River rapids, strong.
    case strongRiverRapids

    /// River rapids, intense.
    case intenseRiverRapids

    // MARK: Nature sky: weather overhead, from slow to rapid

    /// A breeze, slow.
    case slowBreeze

    /// A breeze, easy.
    case easyBreeze

    /// A breeze, steady.
    case steadyBreeze

    /// A breeze, quick.
    case quickBreeze

    /// A breeze, rapid.
    case rapidBreeze

    /// A gale, slow.
    case slowGale

    /// A gale, easy.
    case easyGale

    /// A gale, steady.
    case steadyGale

    /// A gale, quick.
    case quickGale

    /// A gale, rapid.
    case rapidGale

    /// A sunrise, slow.
    case slowSunrise

    /// A sunrise, easy.
    case easySunrise

    /// A sunrise, steady.
    case steadySunrise

    /// A sunrise, quick.
    case quickSunrise

    /// A sunrise, rapid.
    case rapidSunrise

    /// A sunset, slow.
    case slowSunset

    /// A sunset, easy.
    case easySunset

    /// A sunset, steady.
    case steadySunset

    /// A sunset, quick.
    case quickSunset

    /// A sunset, rapid.
    case rapidSunset

    /// A rainbow, slow.
    case slowRainbow

    /// A rainbow, easy.
    case easyRainbow

    /// A rainbow, steady.
    case steadyRainbow

    /// A rainbow, quick.
    case quickRainbow

    /// A rainbow, rapid.
    case rapidRainbow

    /// Falling snow, slow.
    case slowSnowfall

    /// Falling snow, easy.
    case easySnowfall

    /// Falling snow, steady.
    case steadySnowfall

    /// Falling snow, quick.
    case quickSnowfall

    /// Falling snow, rapid.
    case rapidSnowfall

    /// Fog rolling in, slow.
    case slowFogRoll

    /// Fog rolling in, easy.
    case easyFogRoll

    /// Fog rolling in, steady.
    case steadyFogRoll

    /// Fog rolling in, quick.
    case quickFogRoll

    /// Fog rolling in, rapid.
    case rapidFogRoll

    /// An aurora, slow.
    case slowAurora

    /// An aurora, easy.
    case easyAurora

    /// An aurora, steady.
    case steadyAurora

    /// An aurora, quick.
    case quickAurora

    /// An aurora, rapid.
    case rapidAurora

    /// Starlight, slow.
    case slowStarlight

    /// Starlight, easy.
    case easyStarlight

    /// Starlight, steady.
    case steadyStarlight

    /// Starlight, quick.
    case quickStarlight

    /// Starlight, rapid.
    case rapidStarlight

    /// An overcast sky, slow.
    case slowOvercast

    /// An overcast sky, easy.
    case easyOvercast

    /// An overcast sky, steady.
    case steadyOvercast

    /// An overcast sky, quick.
    case quickOvercast

    /// An overcast sky, rapid.
    case rapidOvercast

    // MARK: Mechanical parts: moving parts, from faint to intense

    /// A cog turning, faint.
    case faintCog

    /// A cog turning, soft.
    case softCog

    /// A cog turning, firm.
    case firmCog

    /// A cog turning, strong.
    case strongCog

    /// A cog turning, intense.
    case intenseCog

    /// A spring bouncing, faint.
    case faintSpringCoil

    /// A spring bouncing, soft.
    case softSpringCoil

    /// A spring bouncing, firm.
    case firmSpringCoil

    /// A spring bouncing, strong.
    case strongSpringCoil

    /// A spring bouncing, intense.
    case intenseSpringCoil

    /// A piston pumping, faint.
    case faintPiston

    /// A piston pumping, soft.
    case softPiston

    /// A piston pumping, firm.
    case firmPiston

    /// A piston pumping, strong.
    case strongPiston

    /// A piston pumping, intense.
    case intensePiston

    /// A valve releasing, faint.
    case faintValve

    /// A valve releasing, soft.
    case softValve

    /// A valve releasing, firm.
    case firmValve

    /// A valve releasing, strong.
    case strongValve

    /// A valve releasing, intense.
    case intenseValve

    /// A gear shift, faint.
    case faintGearShift

    /// A gear shift, soft.
    case softGearShift

    /// A gear shift, firm.
    case firmGearShift

    /// A gear shift, strong.
    case strongGearShift

    /// A gear shift, intense.
    case intenseGearShift

    /// A bearing spinning, faint.
    case faintBearing

    /// A bearing spinning, soft.
    case softBearing

    /// A bearing spinning, firm.
    case firmBearing

    /// A bearing spinning, strong.
    case strongBearing

    /// A bearing spinning, intense.
    case intenseBearing

    /// A hinge swinging, faint.
    case faintHinge

    /// A hinge swinging, soft.
    case softHinge

    /// A hinge swinging, firm.
    case firmHinge

    /// A hinge swinging, strong.
    case strongHinge

    /// A hinge swinging, intense.
    case intenseHinge

    /// A bolt sliding home, faint.
    case faintLatchBolt

    /// A bolt sliding home, soft.
    case softLatchBolt

    /// A bolt sliding home, firm.
    case firmLatchBolt

    /// A bolt sliding home, strong.
    case strongLatchBolt

    /// A bolt sliding home, intense.
    case intenseLatchBolt

    /// A crank turning, faint.
    case faintCrank

    /// A crank turning, soft.
    case softCrank

    /// A crank turning, firm.
    case firmCrank

    /// A crank turning, strong.
    case strongCrank

    /// A crank turning, intense.
    case intenseCrank

    /// A pulley hauling, faint.
    case faintPulley

    /// A pulley hauling, soft.
    case softPulley

    /// A pulley hauling, firm.
    case firmPulley

    /// A pulley hauling, strong.
    case strongPulley

    /// A pulley hauling, intense.
    case intensePulley

    // MARK: Mechanical devices: machines at home, from slow to rapid

    /// A turntable spinning, slow.
    case slowTurntable

    /// A turntable spinning, easy.
    case easyTurntable

    /// A turntable spinning, steady.
    case steadyTurntable

    /// A turntable spinning, quick.
    case quickTurntable

    /// A turntable spinning, rapid.
    case rapidTurntable

    /// A projector running, slow.
    case slowProjector

    /// A projector running, easy.
    case easyProjector

    /// A projector running, steady.
    case steadyProjector

    /// A projector running, quick.
    case quickProjector

    /// A projector running, rapid.
    case rapidProjector

    /// A cassette playing, slow.
    case slowCassette

    /// A cassette playing, easy.
    case easyCassette

    /// A cassette playing, steady.
    case steadyCassette

    /// A cassette playing, quick.
    case quickCassette

    /// A cassette playing, rapid.
    case rapidCassette

    /// A vending machine, slow.
    case slowVendingMachine

    /// A vending machine, easy.
    case easyVendingMachine

    /// A vending machine, steady.
    case steadyVendingMachine

    /// A vending machine, quick.
    case quickVendingMachine

    /// A vending machine, rapid.
    case rapidVendingMachine

    /// A washing machine, slow.
    case slowWashingMachine

    /// A washing machine, easy.
    case easyWashingMachine

    /// A washing machine, steady.
    case steadyWashingMachine

    /// A washing machine, quick.
    case quickWashingMachine

    /// A washing machine, rapid.
    case rapidWashingMachine

    /// A dishwasher, slow.
    case slowDishwasher

    /// A dishwasher, easy.
    case easyDishwasher

    /// A dishwasher, steady.
    case steadyDishwasher

    /// A dishwasher, quick.
    case quickDishwasher

    /// A dishwasher, rapid.
    case rapidDishwasher

    /// A lawn mower, slow.
    case slowLawnMower

    /// A lawn mower, easy.
    case easyLawnMower

    /// A lawn mower, steady.
    case steadyLawnMower

    /// A lawn mower, quick.
    case quickLawnMower

    /// A lawn mower, rapid.
    case rapidLawnMower

    /// A vacuum cleaner, slow.
    case slowVacuum

    /// A vacuum cleaner, easy.
    case easyVacuum

    /// A vacuum cleaner, steady.
    case steadyVacuum

    /// A vacuum cleaner, quick.
    case quickVacuum

    /// A vacuum cleaner, rapid.
    case rapidVacuum

    /// An air conditioner, slow.
    case slowAirConditioner

    /// An air conditioner, easy.
    case easyAirConditioner

    /// An air conditioner, steady.
    case steadyAirConditioner

    /// An air conditioner, quick.
    case quickAirConditioner

    /// An air conditioner, rapid.
    case rapidAirConditioner

    /// A coffee machine, slow.
    case slowCoffeeMachine

    /// A coffee machine, easy.
    case easyCoffeeMachine

    /// A coffee machine, steady.
    case steadyCoffeeMachine

    /// A coffee machine, quick.
    case quickCoffeeMachine

    /// A coffee machine, rapid.
    case rapidCoffeeMachine

    // MARK: Game moves: a character's moves, from tiny to huge

    /// A sprint, tiny.
    case tinySprint

    /// A sprint, small.
    case smallSprint

    /// A sprint, medium.
    case mediumSprint

    /// A sprint, large.
    case largeSprint

    /// A sprint, huge.
    case hugeSprint

    /// A slide, tiny.
    case tinySlide

    /// A slide, small.
    case smallSlide

    /// A slide, medium.
    case mediumSlide

    /// A slide, large.
    case largeSlide

    /// A slide, huge.
    case hugeSlide

    /// A roll, tiny.
    case tinyRoll

    /// A roll, small.
    case smallRoll

    /// A roll, medium.
    case mediumRoll

    /// A roll, large.
    case largeRoll

    /// A roll, huge.
    case hugeRoll

    /// Climbing a ledge, tiny.
    case tinyLedgeClimb

    /// Climbing a ledge, small.
    case smallLedgeClimb

    /// Climbing a ledge, medium.
    case mediumLedgeClimb

    /// Climbing a ledge, large.
    case largeLedgeClimb

    /// Climbing a ledge, huge.
    case hugeLedgeClimb

    /// A wall jump, tiny.
    case tinyWallJump

    /// A wall jump, small.
    case smallWallJump

    /// A wall jump, medium.
    case mediumWallJump

    /// A wall jump, large.
    case largeWallJump

    /// A wall jump, huge.
    case hugeWallJump

    /// A dodge, tiny.
    case tinyDodge

    /// A dodge, small.
    case smallDodge

    /// A dodge, medium.
    case mediumDodge

    /// A dodge, large.
    case largeDodge

    /// A dodge, huge.
    case hugeDodge

    /// A block, tiny.
    case tinyBlock

    /// A block, small.
    case smallBlock

    /// A block, medium.
    case mediumBlock

    /// A block, large.
    case largeBlock

    /// A block, huge.
    case hugeBlock

    /// A parry, tiny.
    case tinyParry

    /// A parry, small.
    case smallParry

    /// A parry, medium.
    case mediumParry

    /// A parry, large.
    case largeParry

    /// A parry, huge.
    case hugeParry

    /// A grapple, tiny.
    case tinyGrapple

    /// A grapple, small.
    case smallGrapple

    /// A grapple, medium.
    case mediumGrapple

    /// A grapple, large.
    case largeGrapple

    /// A grapple, huge.
    case hugeGrapple

    /// A crouch, tiny.
    case tinyCrouch

    /// A crouch, small.
    case smallCrouch

    /// A crouch, medium.
    case mediumCrouch

    /// A crouch, large.
    case largeCrouch

    /// A crouch, huge.
    case hugeCrouch

    // MARK: Game rewards: things collected, from once to five times

    /// A gem collected, once.
    case singleGem

    /// A gem collected, twice.
    case doubleGem

    /// A gem collected, three times.
    case tripleGem

    /// A gem collected, four times.
    case quadrupleGem

    /// A gem collected, five times.
    case quintupleGem

    /// A star collected, once.
    case singleStar

    /// A star collected, twice.
    case doubleStar

    /// A star collected, three times.
    case tripleStar

    /// A star collected, four times.
    case quadrupleStar

    /// A star collected, five times.
    case quintupleStar

    /// A key collected, once.
    case singleKey

    /// A key collected, twice.
    case doubleKey

    /// A key collected, three times.
    case tripleKey

    /// A key collected, four times.
    case quadrupleKey

    /// A key collected, five times.
    case quintupleKey

    /// A chest opened, once.
    case singleChest

    /// A chest opened, twice.
    case doubleChest

    /// A chest opened, three times.
    case tripleChest

    /// A chest opened, four times.
    case quadrupleChest

    /// A chest opened, five times.
    case quintupleChest

    /// A heart collected, once.
    case singleHeart

    /// A heart collected, twice.
    case doubleHeart

    /// A heart collected, three times.
    case tripleHeart

    /// A heart collected, four times.
    case quadrupleHeart

    /// A heart collected, five times.
    case quintupleHeart

    /// A trophy won, once.
    case singleTrophy

    /// A trophy won, twice.
    case doubleTrophy

    /// A trophy won, three times.
    case tripleTrophy

    /// A trophy won, four times.
    case quadrupleTrophy

    /// A trophy won, five times.
    case quintupleTrophy

    /// A medal won, once.
    case singleMedal

    /// A medal won, twice.
    case doubleMedal

    /// A medal won, three times.
    case tripleMedal

    /// A medal won, four times.
    case quadrupleMedal

    /// A medal won, five times.
    case quintupleMedal

    /// A token collected, once.
    case singleToken

    /// A token collected, twice.
    case doubleToken

    /// A token collected, three times.
    case tripleToken

    /// A token collected, four times.
    case quadrupleToken

    /// A token collected, five times.
    case quintupleToken

    /// A crown won, once.
    case singleCrown

    /// A crown won, twice.
    case doubleCrown

    /// A crown won, three times.
    case tripleCrown

    /// A crown won, four times.
    case quadrupleCrown

    /// A crown won, five times.
    case quintupleCrown

    /// A scroll found, once.
    case singleScroll

    /// A scroll found, twice.
    case doubleScroll

    /// A scroll found, three times.
    case tripleScroll

    /// A scroll found, four times.
    case quadrupleScroll

    /// A scroll found, five times.
    case quintupleScroll

    // MARK: Random: a thousand drawn at random from a fixed seed, each listed with the built-in group it suits

    /// 4 taps over 217 ms.
    case emberNebula

    /// A tap and a hold over 91 ms.
    case mellowRhapsody

    /// 2 taps and 8 holds over 1.3 s.
    case hollowComet

    /// A tap and 7 holds over 831 ms.
    case mellowZephyr

    /// 7 taps and 2 holds over 897 ms.
    case hazyWhisper

    /// 2 taps and 3 holds over 763 ms.
    case mossyHarbor

    /// A tap and a hold over 94 ms.
    case rubyBlossom

    /// 8 taps and 2 holds over 1.2 s.
    case stormyHaven

    /// A tap and a hold over 88 ms.
    case emberThistle

    /// 2 taps and 5 holds over 1.2 s.
    case goldenQuartz

    /// 4 taps over 338 ms.
    case cobaltLotus

    /// 7 taps over 1.2 s.
    case saffronEmberGlow

    /// 6 taps and a hold over 1.8 s.
    case crimsonDelta

    /// 3 taps and 2 holds over 633 ms.
    case cosmicHaven

    /// 3 taps and a hold over 190 ms.
    case lunarWren

    /// 4 taps over 220 ms.
    case cobaltStarling

    /// 2 taps and 2 holds over 241 ms.
    case ivoryMeadow

    /// 3 taps and a hold over 182 ms.
    case glacialBlueCascade

    /// 4 taps over 219 ms.
    case zestySaga

    /// 8 taps over 1.2 s.
    case zestyVortex

    /// 2 taps and 2 holds over 238 ms.
    case glacialBlueVortex

    /// 3 taps and a hold over 181 ms.
    case violetKite

    /// 4 taps and 7 holds over 873 ms.
    case cobaltFjord

    /// 4 holds over 197 ms.
    case mellowLighthouse

    /// 2 taps and a hold over 545 ms.
    case pastelOasis

    /// 3 taps over 253 ms.
    case wovenReef

    /// 6 holds over 913 ms.
    case obsidianVale

    /// 9 taps over 2.2 s.
    case obsidianFable

    /// 6 taps over 356 ms.
    case prismMonsoon

    /// 5 taps and 2 holds over 826 ms.
    case solarNimbus

    /// A tap and 3 holds over 1.0 s.
    case rusticLighthouse

    /// 4 taps and 4 holds over 1.6 s.
    case mistyVortex

    /// 3 taps and a hold over 375 ms.
    case ashenStarling

    /// 6 holds over 731 ms.
    case neonWillow

    /// 2 taps and 2 holds over 1.0 s.
    case velvetJuniper

    /// 3 taps and 3 holds over 1.4 s.
    case emeraldThistle

    /// 4 taps and 2 holds over 605 ms.
    case azureOasis

    /// 4 taps and a hold over 349 ms.
    case copperWhisper

    /// 5 taps over 547 ms.
    case twilightJuniper

    /// 6 taps and 2 holds over 879 ms.
    case solarQuasar

    /// A tap and 2 holds over 368 ms.
    case prismOrchid

    /// 2 taps over 88 ms.
    case velvetWhisper

    /// 8 taps and a hold over 1.5 s.
    case cosmicJuniper

    /// A tap and 2 holds over 211 ms.
    case hazyMarble

    /// A tap and a hold over 241 ms.
    case emberJubilee

    /// 6 taps over 1.3 s.
    case obsidianFjord

    /// 5 taps and 2 holds over 863 ms.
    case opalLagoon

    /// 3 taps and 5 holds over 1.4 s.
    case jaggedNimbus

    /// 3 taps over 102 ms.
    case dappledLantern

    /// 5 taps over 835 ms.
    case ochreSparrow

    /// 4 taps over 163 ms.
    case crimsonTalisman

    /// 3 taps over 127 ms.
    case wovenDune

    /// 5 taps and a hold over 489 ms.
    case amberNebula

    /// 6 taps and 3 holds over 1.9 s.
    case cosmicThistle

    /// 3 taps and a hold over 746 ms.
    case mellowAtlas

    /// 5 taps and 4 holds over 1.1 s.
    case hollowBlossom

    /// 2 taps and 7 holds over 1.1 s.
    case cobaltOasis

    /// 4 taps over 588 ms.
    case feralHarbor

    /// 2 taps and 3 holds over 1.0 s.
    case paleUtopia

    /// 5 taps and a hold over 940 ms.
    case feralWren

    /// A tap and 3 holds over 827 ms.
    case obsidianOrchid

    /// 4 taps and 3 holds over 810 ms.
    case azureZephyr

    /// 3 taps and a hold over 152 ms.
    case indigoWren

    /// 2 holds over 122 ms.
    case jadeVale

    /// A tap and 10 holds over 1.3 s.
    case mistyVale

    /// 3 taps over 103 ms.
    case saffronKite

    /// 4 taps and 2 holds over 632 ms.
    case wovenWren

    /// 4 taps over 631 ms.
    case bronzeHarbor

    /// 6 taps and a hold over 908 ms.
    case indigoOrchid

    /// 5 taps and 4 holds over 2.0 s.
    case scarletMarble

    /// 3 taps and a hold over 654 ms.
    case silverZephyr

    /// 3 taps and 6 holds over 1.0 s.
    case gildedOasis

    /// 6 taps and 3 holds over 1.5 s.
    case twilightWhisper

    /// 5 taps and a hold over 942 ms.
    case emeraldQuartz

    /// 4 taps over 204 ms.
    case bronzeQuartz

    /// 3 taps and 3 holds over 886 ms.
    case luckyMonsoon

    /// 3 taps and 6 holds over 712 ms.
    case cobaltLighthouse

    /// A tap and 3 holds over 530 ms.
    case rubyMarble

    /// 7 taps and a hold over 746 ms.
    case paleLagoon

    /// 6 taps and 3 holds over 1.4 s.
    case dappledLotus

    /// 6 taps over 1.4 s.
    case goldenQuill

    /// 4 taps and 2 holds over 1.2 s.
    case sableMirage

    /// A tap and 2 holds over 521 ms.
    case umberHorizon

    /// 2 taps and a hold over 436 ms.
    case paleDelta

    /// 6 taps and 2 holds over 1.5 s.
    case electricMirage

    /// 6 taps over 519 ms.
    case jadePinnacle

    /// 2 taps over 86 ms.
    case jadeNimbus

    /// 5 taps and 2 holds over 1.1 s.
    case hollowTundra

    /// A tap and a hold over 331 ms.
    case emberComet

    /// 5 taps and a hold over 733 ms.
    case mistyLotus

    /// 2 taps and 7 holds over 1.1 s.
    case nobleLotus

    /// 3 taps over 107 ms.
    case rubyHorizon

    /// 4 taps and 7 holds over 1.1 s.
    case copperThistle

    /// 2 taps and 9 holds over 1.4 s.
    case rubyTalisman

    /// 2 taps over 85 ms.
    case cobaltQuartz

    /// 6 taps and 2 holds over 598 ms.
    case dappledTundra

    /// 5 taps and 2 holds over 1.2 s.
    case wovenPrairie

    /// 7 taps over 1.3 s.
    case rubyWren

    /// 4 taps and a hold over 401 ms.
    case hazyHorizon

    /// 2 taps and 3 holds over 511 ms.
    case indigoUtopia

    /// 3 taps and a hold over 184 ms.
    case ashenLotus

    /// A tap and 4 holds over 1.3 s.
    case silverPinnacle

    /// 2 taps and 7 holds over 1.1 s.
    case pastelPrairie

    /// 3 taps and a hold over 181 ms.
    case goldenPebble

    /// 2 taps and a hold over 173 ms.
    case vividOrchid

    /// 3 taps and 2 holds over 561 ms.
    case gildedHarbor

    /// 2 taps over 90 ms.
    case zestyMosaic

    /// 3 holds over 617 ms.
    case azureQuartz

    /// 2 taps and 10 holds over 1.6 s.
    case pastelVale

    /// 9 taps and a hold over 1.1 s.
    case opalGalaxy

    /// 4 taps over 212 ms.
    case vividTalisman

    /// 4 taps and 2 holds over 896 ms.
    case lunarUtopia

    /// 6 taps over 966 ms.
    case emeraldLotus

    /// 6 taps and 2 holds over 1.2 s.
    case vividSonnet

    /// 2 taps over 83 ms.
    case mistyPebble

    /// 4 holds over 738 ms.
    case amberPinnacle

    /// 12 holds over 1.7 s.
    case sableLagoon

    /// 3 taps over 124 ms.
    case frostyMonsoon

    /// 4 taps and 6 holds over 803 ms.
    case violetQuill

    /// 5 taps over 467 ms.
    case electricOasis

    /// 5 taps over 478 ms.
    case opalFjord

    /// 7 taps and 3 holds over 1.1 s.
    case feralNimbus

    /// A tap and 3 holds over 397 ms.
    case vividIris

    /// 7 taps and 3 holds over 991 ms.
    case swiftPinnacle

    /// 2 taps over 81 ms.
    case rusticLagoon

    /// 5 taps and 2 holds over 1.4 s.
    case vividReef

    /// 4 taps and 2 holds over 843 ms.
    case vividSaga

    /// 3 taps and 6 holds over 1.2 s.
    case velvetSaga

    /// 3 taps and a hold over 219 ms.
    case feralFable

    /// 4 taps over 645 ms.
    case nobleSpire

    /// 3 taps and 4 holds over 1.1 s.
    case dappledHarbor

    /// 7 taps over 1.2 s.
    case stormyOrchid

    /// 4 taps and 3 holds over 577 ms.
    case tidalFable

    /// 3 taps over 96 ms.
    case opalHorizon

    /// 4 taps and 3 holds over 1.2 s.
    case paleLantern

    /// 2 taps and 7 holds over 1.0 s.
    case duskyMarble

    /// 3 taps over 200 ms.
    case emeraldTundra

    /// 2 taps over 42 ms.
    case saffronHaven

    /// 6 taps over 1.5 s.
    case wovenMirage

    /// 8 taps and 2 holds over 1.4 s.
    case obsidianQuasar

    /// 2 taps over 93 ms.
    case wovenLighthouse

    /// 3 taps and a hold over 204 ms.
    case electricLighthouse

    /// 5 taps and a hold over 1.1 s.
    case silverAtlas

    /// A tap and 5 holds over 897 ms.
    case mellowWren

    /// 5 taps and a hold over 540 ms.
    case dappledMarble

    /// 6 taps and a hold over 957 ms.
    case umberFable

    /// A tap and 11 holds over 1.4 s.
    case stormyTalisman

    /// 2 taps and a hold over 377 ms.
    case luckyStarling

    /// A tap and a hold over 54 ms.
    case silverAnchor

    /// 4 taps and 3 holds over 939 ms.
    case bronzeRhapsody

    /// 4 taps over 415 ms.
    case wildTalisman

    /// 3 taps and a hold over 173 ms.
    case feralSparrow

    /// A tap and 9 holds over 1.3 s.
    case mistyHarbor

    /// 3 taps and 4 holds over 731 ms.
    case mellowEmberGlow

    /// 5 taps and a hold over 404 ms.
    case cobaltZenith

    /// A tap and 7 holds over 886 ms.
    case twilightMarble

    /// 6 taps and 2 holds over 1.6 s.
    case dappledYarrow

    /// 3 taps and 2 holds over 706 ms.
    case hollowQuill

    /// 3 taps and 5 holds over 706 ms.
    case ashenEmberGlow

    /// 3 taps and a hold over 442 ms.
    case luckyWillow

    /// A tap and 9 holds over 1.3 s.
    case jaggedHaven

    /// 3 taps and 2 holds over 832 ms.
    case tidalTalisman

    /// 5 taps and 5 holds over 753 ms.
    case lunarMarble

    /// 5 taps and 4 holds over 1.6 s.
    case sunlitMonsoon

    /// 4 holds over 770 ms.
    case zestyAtlas

    /// 3 taps and a hold over 287 ms.
    case neonWren

    /// 3 taps and a hold over 179 ms.
    case rubyLighthouse

    /// 7 taps and 3 holds over 588 ms.
    case solarOasis

    /// 10 taps over 882 ms.
    case feralJuniper

    /// 2 taps over 45 ms.
    case emeraldGalaxy

    /// 3 taps and 5 holds over 1.9 s.
    case solarQuill

    /// 2 taps and a hold over 570 ms.
    case saffronPebble

    /// 5 taps and a hold over 811 ms.
    case cobaltZephyr

    /// 6 taps and 6 holds over 954 ms.
    case gildedMeadow

    /// 5 taps and 7 holds over 1.0 s.
    case violetYarrow

    /// 3 taps and a hold over 495 ms.
    case velvetHarbor

    /// A tap and 2 holds over 658 ms.
    case ivoryKite

    /// 3 taps and 2 holds over 873 ms.
    case umberGalaxy

    /// 6 taps and 4 holds over 871 ms.
    case emeraldEmberGlow

    /// 2 taps and a hold over 338 ms.
    case saffronLantern

    /// 5 holds over 513 ms.
    case mellowIris

    /// 3 taps and 8 holds over 1.2 s.
    case emeraldPrairie

    /// 3 taps and a hold over 620 ms.
    case twilightSpire

    /// 5 taps over 1.0 s.
    case bronzeVortex

    /// 4 taps and 2 holds over 740 ms.
    case electricLagoon

    /// 2 taps and a hold over 164 ms.
    case nobleMarble

    /// 4 taps and 2 holds over 551 ms.
    case wildPebble

    /// A tap and 4 holds over 903 ms.
    case violetLantern

    /// 4 taps and 2 holds over 714 ms.
    case hazyLotus

    /// 6 taps and 2 holds over 1.2 s.
    case saffronZephyr

    /// 7 taps and 2 holds over 860 ms.
    case jaggedGalaxy

    /// 5 taps and 3 holds over 1.1 s.
    case crimsonIris

    /// 6 taps and 2 holds over 1.8 s.
    case ashenPebble

    /// 3 taps over 276 ms.
    case frostyTalisman

    /// 3 taps and a hold over 213 ms.
    case cosmicGlacier

    /// 6 holds over 818 ms.
    case wildIris

    /// 4 taps and a hold over 861 ms.
    case arcticThistle

    /// 4 taps and 2 holds over 804 ms.
    case ivoryTundra

    /// 5 taps over 549 ms.
    case cobaltQuasar

    /// A tap and a hold over 135 ms.
    case pastelZenith

    /// 2 taps and 8 holds over 1.1 s.
    case velvetFable

    /// 4 taps and 3 holds over 1.1 s.
    case indigoKestrel

    /// 4 taps and 3 holds over 1.1 s.
    case feralKite

    /// 2 taps over 58 ms.
    case wildSpire

    /// 2 taps over 40 ms.
    case opalJubilee

    /// 4 taps and 3 holds over 618 ms.
    case ashenWillow

    /// 2 taps and 10 holds over 1.4 s.
    case mellowCascade

    /// 2 taps and 3 holds over 607 ms.
    case lunarLagoon

    /// 3 taps over 448 ms.
    case vividQuartz

    /// 2 taps and 3 holds over 749 ms.
    case mellowWhisper

    /// 6 taps over 464 ms.
    case mossySaga

    /// 2 taps over 77 ms.
    case tealOasis

    /// 4 taps and a hold over 452 ms.
    case neonHaven

    /// A tap and 5 holds over 911 ms.
    case sableZephyr

    /// 7 taps and 2 holds over 734 ms.
    case copperNimbus

    /// 3 taps over 301 ms.
    case sunlitWren

    /// A tap and a hold over 49 ms.
    case azureSonnet

    /// 2 taps and 4 holds over 909 ms.
    case prismQuasar

    /// 9 taps over 1.4 s.
    case electricYarrow

    /// 4 taps and a hold over 487 ms.
    case mistyKite

    /// A tap and 4 holds over 450 ms.
    case mossyLighthouse

    /// 2 taps over 58 ms.
    case hollowGlacier

    /// 4 taps over 164 ms.
    case amberLantern

    /// 3 taps and 3 holds over 691 ms.
    case ivoryMonsoon

    /// 2 taps and 10 holds over 1.3 s.
    case electricNimbus

    /// 2 taps and 2 holds over 192 ms.
    case twilightEmberGlow

    /// 2 taps and 2 holds over 240 ms.
    case umberHarbor

    /// 8 taps and a hold over 1.3 s.
    case cobaltRhapsody

    /// 5 taps and a hold over 993 ms.
    case prismNimbus

    /// 2 taps and 2 holds over 676 ms.
    case wildAnchor

    /// 4 taps and a hold over 826 ms.
    case azureTundra

    /// 2 taps and a hold over 384 ms.
    case neonGlacier

    /// A tap and 7 holds over 1.0 s.
    case umberMeadow

    /// 9 taps and a hold over 984 ms.
    case opalVortex

    /// 4 taps and a hold over 566 ms.
    case scarletCanyon

    /// 5 taps and 2 holds over 1.1 s.
    case arcticTundra

    /// 2 taps and 3 holds over 876 ms.
    case jaggedFjord

    /// 4 taps and a hold over 456 ms.
    case amberWhisper

    /// 3 taps and a hold over 545 ms.
    case paleThistle

    /// 6 taps and 2 holds over 913 ms.
    case hazyTundra

    /// A tap and 5 holds over 971 ms.
    case glacialBlueQuill

    /// 3 taps and a hold over 388 ms.
    case duskyYarrow

    /// A tap and 7 holds over 922 ms.
    case duskyMeadow

    /// 5 taps and 4 holds over 810 ms.
    case coralNebula

    /// 4 taps and 5 holds over 1.8 s.
    case copperSparrow

    /// 8 taps over 856 ms.
    case glacialBlueMosaic

    /// 5 taps and 4 holds over 573 ms.
    case electricMonsoon

    /// 3 taps and a hold over 282 ms.
    case paleMirage

    /// 9 taps and a hold over 1.4 s.
    case coralDriftwood

    /// 4 taps over 352 ms.
    case indigoLighthouse

    /// 4 taps over 579 ms.
    case sableAtlas

    /// 6 taps and 2 holds over 815 ms.
    case wistfulLantern

    /// 5 taps and 2 holds over 667 ms.
    case amberOrchid

    /// 4 taps over 880 ms.
    case mistyKestrel

    /// A tap and 2 holds over 498 ms.
    case dappledWren

    /// 3 taps and a hold over 260 ms.
    case glacialBlueLantern

    /// 2 taps and 9 holds over 1.6 s.
    case solarThistle

    /// 3 taps and 3 holds over 1.2 s.
    case amberZephyr

    /// 3 taps and 9 holds over 1.3 s.
    case solarDriftwood

    /// 4 taps over 278 ms.
    case hollowQuartz

    /// 5 taps and a hold over 564 ms.
    case ivoryNebula

    /// A tap and 3 holds over 409 ms.
    case emeraldKite

    /// 2 taps and 7 holds over 1.2 s.
    case frostyLighthouse

    /// 5 taps and a hold over 994 ms.
    case jadeGalaxy

    /// 3 taps over 108 ms.
    case rusticReef

    /// 2 taps over 128 ms.
    case swiftUtopia

    /// 3 taps over 163 ms.
    case violetHaven

    /// 3 taps and a hold over 614 ms.
    case mistyQuasar

    /// 7 taps and 3 holds over 1.3 s.
    case scarletSparrow

    /// 2 taps and 3 holds over 375 ms.
    case wistfulComet

    /// A tap and 8 holds over 1.1 s.
    case scarletBlossom

    /// 7 taps and 2 holds over 2.1 s.
    case saffronComet

    /// A tap and 2 holds over 233 ms.
    case tidalPrairie

    /// 2 taps and 2 holds over 643 ms.
    case coralStarling

    /// 6 taps over 1.5 s.
    case jaggedDune

    /// 4 taps and 2 holds over 946 ms.
    case copperRhapsody

    /// 5 taps and 5 holds over 947 ms.
    case rusticHorizon

    /// 5 taps over 538 ms.
    case crimsonDriftwood

    /// 2 taps and a hold over 143 ms.
    case prismTalisman

    /// 3 taps and 5 holds over 634 ms.
    case neonReef

    /// 2 taps and a hold over 547 ms.
    case rusticUtopia

    /// 8 taps over 1.4 s.
    case nobleQuartz

    /// A tap and 2 holds over 205 ms.
    case electricFable

    /// 2 taps and 5 holds over 729 ms.
    case stormyCanyon

    /// 2 taps and a hold over 183 ms.
    case frostyLotus

    /// 3 taps and 4 holds over 1.1 s.
    case gildedQuartz

    /// 4 taps over 159 ms.
    case bronzeWren

    /// 4 taps over 882 ms.
    case gildedQuill

    /// A tap and 3 holds over 749 ms.
    case pastelGlacier

    /// 5 taps over 472 ms.
    case nobleFjord

    /// 2 taps and 2 holds over 503 ms.
    case arcticJuniper

    /// 5 taps and 2 holds over 1.2 s.
    case twilightPinnacle

    /// 2 taps and 2 holds over 249 ms.
    case sableJuniper

    /// 4 taps and 2 holds over 929 ms.
    case jadeCascade

    /// 2 taps and 2 holds over 234 ms.
    case scarletQuartz

    /// 4 taps and a hold over 428 ms.
    case arcticIris

    /// 2 taps over 65 ms.
    case mellowZenith

    /// 3 taps and 2 holds over 1.2 s.
    case mellowAnchor

    /// 3 taps and 3 holds over 603 ms.
    case feralIris

    /// A tap and a hold over 149 ms.
    case prismLighthouse

    /// 4 taps and 3 holds over 531 ms.
    case prismOasis

    /// 4 taps and 2 holds over 1.0 s.
    case tidalEmberGlow

    /// 4 taps over 294 ms.
    case goldenIris

    /// A tap and 2 holds over 326 ms.
    case ivoryDune

    /// A tap and 9 holds over 1.5 s.
    case jaggedSaga

    /// 3 taps and a hold over 621 ms.
    case wistfulFable

    /// 8 taps over 1.3 s.
    case emberVale

    /// 7 taps over 904 ms.
    case duskyLotus

    /// 5 taps and a hold over 785 ms.
    case glacialBlueGalaxy

    /// A tap and 3 holds over 898 ms.
    case sableHaven

    /// 3 taps and 2 holds over 712 ms.
    case sablePrairie

    /// 3 taps and a hold over 182 ms.
    case umberThistle

    /// A tap and 9 holds over 1.3 s.
    case wovenKestrel

    /// 5 taps and 5 holds over 774 ms.
    case tidalDelta

    /// 5 taps and 3 holds over 1.4 s.
    case sunlitHaven

    /// 3 taps and a hold over 179 ms.
    case emberFable

    /// 2 taps over 38 ms.
    case bronzeMeadow

    /// 3 taps over 110 ms.
    case nobleAnchor

    /// 2 taps and 2 holds over 694 ms.
    case sableReef

    /// 6 taps over 729 ms.
    case pastelRhapsody

    /// 2 taps and a hold over 437 ms.
    case feralVortex

    /// 3 taps over 223 ms.
    case cosmicFjord

    /// 2 taps and a hold over 403 ms.
    case twilightQuasar

    /// 3 taps over 124 ms.
    case jadeSaga

    /// 6 taps and a hold over 961 ms.
    case vividWillow

    /// 3 taps over 80 ms.
    case opalOasis

    /// 3 taps and 7 holds over 903 ms.
    case swiftNebula

    /// 9 holds over 1.1 s.
    case copperMeadow

    /// 2 taps and 4 holds over 433 ms.
    case duskyGalaxy

    /// A tap and 2 holds over 322 ms.
    case prismMosaic

    /// A tap and 3 holds over 431 ms.
    case emberSparrow

    /// 5 taps and 5 holds over 1.0 s.
    case copperJubilee

    /// 3 taps and 2 holds over 486 ms.
    case wistfulTalisman

    /// 4 taps and a hold over 243 ms.
    case rusticHarbor

    /// 2 taps and 2 holds over 392 ms.
    case azurePebble

    /// 2 holds over 319 ms.
    case obsidianSparrow

    /// A tap and 10 holds over 1.5 s.
    case tealMosaic

    /// 5 taps and 4 holds over 1.7 s.
    case mossyJuniper

    /// 8 taps and 2 holds over 1.0 s.
    case sunlitZephyr

    /// 4 taps and 4 holds over 2.0 s.
    case velvetSparrow

    /// 3 taps and a hold over 262 ms.
    case violetCascade

    /// 9 taps and a hold over 1.3 s.
    case violetWren

    /// A tap and 3 holds over 525 ms.
    case cosmicWren

    /// 2 holds over 127 ms.
    case sunlitWhisper

    /// 2 taps and a hold over 142 ms.
    case violetPebble

    /// 5 taps over 634 ms.
    case lunarOasis

    /// 3 holds over 241 ms.
    case nobleEmberGlow

    /// 6 taps and 3 holds over 1.8 s.
    case ashenVortex

    /// A tap and a hold over 157 ms.
    case electricZenith

    /// 5 taps and 2 holds over 1.0 s.
    case lunarFable

    /// 5 taps and 5 holds over 923 ms.
    case ashenJubilee

    /// 5 taps and 2 holds over 468 ms.
    case neonZenith

    /// 7 taps and 2 holds over 1.2 s.
    case rubyPebble

    /// A tap and 4 holds over 562 ms.
    case ashenHarbor

    /// 4 taps and 5 holds over 796 ms.
    case glacialBlueThistle

    /// 3 taps over 89 ms.
    case sunlitFable

    /// 2 taps and 10 holds over 1.5 s.
    case ochrePrairie

    /// 3 taps and a hold over 191 ms.
    case electricAnchor

    /// 2 taps and a hold over 362 ms.
    case goldenSparrow

    /// A tap and a hold over 141 ms.
    case saffronWhisper

    /// 2 taps and 3 holds over 1.2 s.
    case twilightNebula

    /// 5 taps and a hold over 635 ms.
    case gildedKestrel

    /// 2 taps and a hold over 129 ms.
    case mellowFable

    /// A tap and a hold over 114 ms.
    case wistfulCanyon

    /// 2 taps and 3 holds over 1.2 s.
    case sunlitLighthouse

    /// 4 taps and 3 holds over 1.2 s.
    case emberDelta

    /// A tap and 3 holds over 502 ms.
    case feralDriftwood

    /// 3 taps and 6 holds over 2.1 s.
    case vividKite

    /// 4 taps over 537 ms.
    case vividTundra

    /// A tap and 9 holds over 1.4 s.
    case azureMarble

    /// A tap and 2 holds over 163 ms.
    case jadeZenith

    /// 2 holds over 112 ms.
    case ivorySparrow

    /// 3 taps over 220 ms.
    case velvetQuasar

    /// 2 taps and 4 holds over 704 ms.
    case bronzeEmberGlow

    /// 4 taps and 3 holds over 1.2 s.
    case bronzeLantern

    /// 7 taps and 2 holds over 1.3 s.
    case gildedDriftwood

    /// 7 taps and a hold over 1.8 s.
    case jaggedStarling

    /// 3 taps over 86 ms.
    case indigoMonsoon

    /// 3 taps and a hold over 697 ms.
    case gildedJuniper

    /// 2 taps and 4 holds over 655 ms.
    case amberCanyon

    /// 3 taps and 2 holds over 710 ms.
    case hazyPrairie

    /// 4 taps over 557 ms.
    case ashenWhisper

    /// 4 taps and 2 holds over 959 ms.
    case electricHaven

    /// 7 taps over 1.4 s.
    case wovenQuill

    /// A tap and 4 holds over 861 ms.
    case luckyLantern

    /// 4 taps and a hold over 384 ms.
    case stormySonnet

    /// 2 taps and 3 holds over 848 ms.
    case lunarSpire

    /// A tap and 4 holds over 600 ms.
    case hazyQuasar

    /// 8 taps and a hold over 619 ms.
    case prismZephyr

    /// 5 taps and 2 holds over 1.1 s.
    case wistfulMosaic

    /// 8 taps over 789 ms.
    case bronzeHorizon

    /// 4 taps and a hold over 467 ms.
    case tidalWhisper

    /// 2 taps and 2 holds over 547 ms.
    case vividMarble

    /// 3 taps and 3 holds over 1.1 s.
    case neonAtlas

    /// 2 taps and 4 holds over 1.0 s.
    case tidalNimbus

    /// 5 taps over 657 ms.
    case wovenCanyon

    /// 3 taps over 130 ms.
    case pastelSaga

    /// A tap and a hold over 119 ms.
    case feralNebula

    /// 2 taps and a hold over 375 ms.
    case wildWhisper

    /// 2 taps and 10 holds over 1.3 s.
    case saffronOasis

    /// 8 taps over 1.2 s.
    case wistfulVortex

    /// 6 taps and a hold over 398 ms.
    case mossyCanyon

    /// 2 taps and a hold over 217 ms.
    case hazyEmberGlow

    /// 2 taps and 7 holds over 713 ms.
    case hazyMirage

    /// 3 taps and 4 holds over 1.1 s.
    case emberWhisper

    /// 2 taps and a hold over 410 ms.
    case prismRhapsody

    /// 7 taps over 1.1 s.
    case scarletSpire

    /// 7 taps over 475 ms.
    case sableOasis

    /// 2 taps and a hold over 458 ms.
    case ivoryGlacier

    /// 3 taps over 85 ms.
    case swiftSpire

    /// 7 taps and a hold over 845 ms.
    case silverBlossom

    /// 3 taps and 2 holds over 275 ms.
    case sableTalisman

    /// 2 taps and 10 holds over 1.6 s.
    case ivoryPrairie

    /// 6 taps and a hold over 858 ms.
    case goldenLantern

    /// 5 taps and a hold over 568 ms.
    case emberLantern

    /// 4 taps and 2 holds over 583 ms.
    case crimsonAnchor

    /// 3 taps and a hold over 879 ms.
    case wildMonsoon

    /// 2 taps and 2 holds over 770 ms.
    case stormyQuartz

    /// 4 taps and a hold over 542 ms.
    case gildedIris

    /// 2 taps and 5 holds over 993 ms.
    case frostyMosaic

    /// 4 taps and 2 holds over 1.2 s.
    case jaggedKestrel

    /// A tap and 6 holds over 743 ms.
    case rusticSpire

    /// 3 taps and a hold over 318 ms.
    case obsidianUtopia

    /// 4 taps and 5 holds over 1.9 s.
    case sunlitTundra

    /// 4 taps and a hold over 496 ms.
    case coralCanyon

    /// 11 holds over 1.5 s.
    case copperGalaxy

    /// 4 taps and 4 holds over 781 ms.
    case mistyYarrow

    /// 5 taps and a hold over 839 ms.
    case vividHaven

    /// 3 taps and 4 holds over 706 ms.
    case mossyHaven

    /// 5 taps and 4 holds over 737 ms.
    case silverUtopia

    /// 4 taps over 723 ms.
    case prismUtopia

    /// 5 taps and 3 holds over 1.4 s.
    case scarletNimbus

    /// A tap and 2 holds over 218 ms.
    case pastelComet

    /// 2 taps and 2 holds over 228 ms.
    case umberIris

    /// 2 taps over 89 ms.
    case frostyNimbus

    /// 3 taps and a hold over 599 ms.
    case pastelSparrow

    /// 3 taps over 157 ms.
    case umberHaven

    /// 3 taps over 106 ms.
    case ivoryLotus

    /// 4 taps and a hold over 631 ms.
    case cobaltWhisper

    /// 2 taps over 65 ms.
    case neonVale

    /// 3 taps and a hold over 570 ms.
    case opalTundra

    /// 7 taps and 2 holds over 634 ms.
    case solarIris

    /// 2 taps and 7 holds over 1.2 s.
    case azureUtopia

    /// 11 holds over 1.6 s.
    case duskyVale

    /// 5 taps and a hold over 955 ms.
    case jadeAtlas

    /// A tap and 3 holds over 219 ms.
    case prismPinnacle

    /// 8 taps and 2 holds over 1.2 s.
    case nobleYarrow

    /// A tap and 2 holds over 364 ms.
    case velvetYarrow

    /// 3 taps and a hold over 654 ms.
    case hazyFable

    /// 5 taps and a hold over 916 ms.
    case tidalHaven

    /// 3 taps over 288 ms.
    case mistyUtopia

    /// 2 taps and 2 holds over 270 ms.
    case rusticPinnacle

    /// 6 taps over 457 ms.
    case ochreNimbus

    /// 5 taps and 2 holds over 873 ms.
    case twilightZephyr

    /// A tap and 2 holds over 208 ms.
    case mistySaga

    /// 2 taps and 7 holds over 921 ms.
    case hollowLantern

    /// 2 taps and a hold over 113 ms.
    case sableIris

    /// 4 taps over 697 ms.
    case lunarHarbor

    /// 2 taps over 118 ms.
    case luckyDriftwood

    /// 3 taps and 2 holds over 941 ms.
    case wistfulLagoon

    /// 4 taps and a hold over 475 ms.
    case copperOrchid

    /// 2 taps over 88 ms.
    case neonLotus

    /// 2 taps over 41 ms.
    case scarletGalaxy

    /// 5 holds over 712 ms.
    case vividJubilee

    /// 2 taps over 37 ms.
    case wildLantern

    /// 5 taps and 3 holds over 676 ms.
    case opalBlossom

    /// A tap and 9 holds over 1.3 s.
    case saffronOrchid

    /// 4 taps and 3 holds over 1.3 s.
    case velvetLantern

    /// 3 taps and 3 holds over 431 ms.
    case bronzeQuill

    /// 5 taps and 3 holds over 672 ms.
    case solarSparrow

    /// 4 taps over 206 ms.
    case mellowJubilee

    /// 2 taps and 3 holds over 428 ms.
    case frostyPebble

    /// 4 taps and a hold over 632 ms.
    case zestyHarbor

    /// 8 taps over 1.3 s.
    case saffronGalaxy

    /// 2 taps and a hold over 110 ms.
    case zestyLantern

    /// A tap and 3 holds over 665 ms.
    case duskyJubilee

    /// 4 taps and 2 holds over 814 ms.
    case gildedTalisman

    /// 7 taps and 2 holds over 1.3 s.
    case rubyFjord

    /// 2 taps and 4 holds over 1.4 s.
    case sunlitRhapsody

    /// 3 taps and 4 holds over 1.4 s.
    case tidalYarrow

    /// 4 taps and 2 holds over 844 ms.
    case twilightDelta

    /// 2 taps over 54 ms.
    case sableZenith

    /// 5 taps and a hold over 508 ms.
    case jaggedQuasar

    /// A tap and 4 holds over 574 ms.
    case jadeUtopia

    /// 4 holds over 597 ms.
    case neonDriftwood

    /// 8 taps and 2 holds over 1.1 s.
    case indigoThistle

    /// 5 taps and a hold over 625 ms.
    case gildedEmberGlow

    /// 2 taps and 2 holds over 546 ms.
    case violetRhapsody

    /// 4 taps and 2 holds over 911 ms.
    case sableJubilee

    /// 5 taps and 4 holds over 1.5 s.
    case hollowSparrow

    /// 2 taps and 5 holds over 1.4 s.
    case ashenCanyon

    /// 3 taps and 2 holds over 687 ms.
    case zestyJuniper

    /// 6 taps and a hold over 1.2 s.
    case neonGalaxy

    /// 3 taps over 261 ms.
    case nobleOrchid

    /// 3 taps and 2 holds over 626 ms.
    case cosmicQuasar

    /// 2 taps and a hold over 141 ms.
    case umberTundra

    /// 3 taps and a hold over 299 ms.
    case rusticFjord

    /// 2 taps and 2 holds over 866 ms.
    case obsidianLantern

    /// A tap and a hold over 105 ms.
    case wovenFable

    /// 3 taps and 2 holds over 807 ms.
    case mossyQuasar

    /// 6 taps and 3 holds over 696 ms.
    case wovenAtlas

    /// 2 taps over 68 ms.
    case cobaltHorizon

    /// 9 taps over 1.2 s.
    case emberQuartz

    /// 3 taps and a hold over 554 ms.
    case sableDune

    /// 4 taps over 371 ms.
    case lunarHorizon

    /// 6 taps and 3 holds over 1.4 s.
    case jadeJubilee

    /// 8 taps and a hold over 1.2 s.
    case tealNimbus

    /// 9 taps over 1.4 s.
    case sunlitComet

    /// 3 taps over 276 ms.
    case silverOasis

    /// 2 taps and 4 holds over 1.1 s.
    case copperYarrow

    /// 2 taps and a hold over 303 ms.
    case obsidianLagoon

    /// 4 taps and a hold over 618 ms.
    case ochreMosaic

    /// 4 taps and a hold over 968 ms.
    case cosmicPebble

    /// A tap and 5 holds over 557 ms.
    case dappledTalisman

    /// 6 taps and a hold over 1.4 s.
    case mistyWillow

    /// 8 taps and a hold over 2.1 s.
    case mossyFjord

    /// 5 taps and 4 holds over 1.6 s.
    case nobleLagoon

    /// 2 taps and a hold over 390 ms.
    case stormyDelta

    /// 5 taps and a hold over 445 ms.
    case mossyDune

    /// 5 taps and a hold over 805 ms.
    case umberNimbus

    /// A tap and 8 holds over 1.1 s.
    case copperSpire

    /// 5 taps and a hold over 708 ms.
    case feralSaga

    /// 2 taps and 9 holds over 1.2 s.
    case luckyIris

    /// 5 taps and 6 holds over 1.2 s.
    case umberSonnet

    /// 4 taps and 2 holds over 778 ms.
    case wovenPebble

    /// 4 taps and 3 holds over 1.0 s.
    case solarSaga

    /// 8 taps and a hold over 713 ms.
    case scarletMonsoon

    /// 4 taps and a hold over 742 ms.
    case obsidianHorizon

    /// 3 taps and 3 holds over 1.3 s.
    case cosmicHarbor

    /// A tap and 2 holds over 498 ms.
    case emeraldHorizon

    /// 2 taps and 2 holds over 540 ms.
    case lunarAnchor

    /// 3 taps and 2 holds over 607 ms.
    case frostyNebula

    /// 2 taps and a hold over 150 ms.
    case ashenTalisman

    /// A tap and a hold over 138 ms.
    case rusticTundra

    /// 2 taps over 78 ms.
    case zestyHaven

    /// 3 taps over 200 ms.
    case nobleQuasar

    /// 3 taps and 2 holds over 570 ms.
    case silverMeadow

    /// 3 taps and a hold over 622 ms.
    case sableRhapsody

    /// 2 taps and 2 holds over 569 ms.
    case goldenMeadow

    /// 4 taps and a hold over 427 ms.
    case rubyMirage

    /// 3 holds over 240 ms.
    case emeraldFable

    /// A tap and 5 holds over 1.5 s.
    case twilightZenith

    /// 4 taps and 2 holds over 1.0 s.
    case opalMarble

    /// 5 taps over 509 ms.
    case mossyYarrow

    /// 3 taps and 9 holds over 1.5 s.
    case bronzeTalisman

    /// 7 taps over 945 ms.
    case mistyAnchor

    /// 8 taps over 1.2 s.
    case opalCanyon

    /// 7 taps over 1.8 s.
    case sunlitSparrow

    /// 7 taps over 1.2 s.
    case pastelWhisper

    /// 4 taps and 4 holds over 1.5 s.
    case tealComet

    /// 2 taps over 104 ms.
    case emeraldAtlas

    /// 5 taps and a hold over 904 ms.
    case mellowThistle

    /// 3 taps and 9 holds over 1.4 s.
    case opalDelta

    /// 7 taps over 1.6 s.
    case copperComet

    /// 7 taps and 3 holds over 1.1 s.
    case jadePebble

    /// 3 taps and 7 holds over 1.1 s.
    case wovenGalaxy

    /// 4 taps and 3 holds over 1.2 s.
    case luckyMosaic

    /// A tap and 2 holds over 188 ms.
    case zestyNebula

    /// 3 holds over 555 ms.
    case pastelWren

    /// 8 taps and a hold over 1.2 s.
    case mellowHaven

    /// 3 taps and a hold over 464 ms.
    case luckyUtopia

    /// 3 taps over 162 ms.
    case glacialBlueKite

    /// 4 holds over 1.0 s.
    case neonNimbus

    /// 4 taps and a hold over 522 ms.
    case ochreTalisman

    /// A tap and 8 holds over 1.3 s.
    case indigoYarrow

    /// 3 taps and 2 holds over 887 ms.
    case ashenReef

    /// 2 taps and 5 holds over 845 ms.
    case emberRhapsody

    /// 6 holds over 788 ms.
    case emberOasis

    /// 4 taps and a hold over 440 ms.
    case emberMonsoon

    /// 3 taps over 173 ms.
    case pastelKestrel

    /// 3 taps and a hold over 353 ms.
    case vividComet

    /// 9 taps and a hold over 1.4 s.
    case nobleDriftwood

    /// 4 taps and 3 holds over 673 ms.
    case wildHarbor

    /// 2 taps and 10 holds over 1.5 s.
    case cosmicDune

    /// A tap and 4 holds over 581 ms.
    case stormyStarling

    /// 3 taps and a hold over 501 ms.
    case silverMarble

    /// 5 taps and a hold over 1.1 s.
    case gildedFjord

    /// 2 taps and a hold over 456 ms.
    case gildedGalaxy

    /// 9 taps and a hold over 494 ms.
    case copperMirage

    /// 8 taps over 1.9 s.
    case sableQuartz

    /// 9 taps and a hold over 1.2 s.
    case lunarNimbus

    /// 4 taps and a hold over 311 ms.
    case frostyKestrel

    /// 5 taps and 2 holds over 1.4 s.
    case hollowDelta

    /// 8 taps over 925 ms.
    case jaggedDriftwood

    /// A tap and a hold over 107 ms.
    case tealDriftwood

    /// 2 taps and a hold over 153 ms.
    case ashenVale

    /// A tap and 8 holds over 1.0 s.
    case arcticHarbor

    /// 3 taps over 154 ms.
    case goldenJuniper

    /// 2 taps and 2 holds over 701 ms.
    case lunarJuniper

    /// 6 taps and 3 holds over 1.6 s.
    case luckyNebula

    /// 3 taps over 158 ms.
    case mellowGlacier

    /// 5 taps and a hold over 751 ms.
    case ashenPinnacle

    /// 2 taps and a hold over 597 ms.
    case indigoVortex

    /// A tap and 5 holds over 807 ms.
    case mistyDelta

    /// 2 taps and 2 holds over 647 ms.
    case ochreDelta

    /// 3 taps and a hold over 492 ms.
    case paleHarbor

    /// 3 taps and 5 holds over 1.0 s.
    case paleJuniper

    /// 4 taps over 776 ms.
    case swiftReef

    /// 5 taps and 4 holds over 1.6 s.
    case pastelPinnacle

    /// 2 taps over 78 ms.
    case rubyLotus

    /// 3 taps and 6 holds over 942 ms.
    case paleVortex

    /// 4 taps and 4 holds over 1.1 s.
    case zestySparrow

    /// 7 taps over 1.1 s.
    case azureLotus

    /// 2 taps and a hold over 149 ms.
    case silverGalaxy

    /// A tap and 3 holds over 267 ms.
    case cosmicKite

    /// 7 taps over 1.3 s.
    case sableHorizon

    /// 9 holds over 1.2 s.
    case amberMirage

    /// 5 taps and 2 holds over 1.0 s.
    case gildedSpire

    /// A tap and 7 holds over 910 ms.
    case zestyOrchid

    /// 6 holds over 815 ms.
    case cosmicFable

    /// 2 taps over 89 ms.
    case opalHarbor

    /// A tap and 6 holds over 883 ms.
    case arcticQuasar

    /// 9 taps over 2.3 s.
    case crimsonBlossom

    /// 5 taps and 3 holds over 1.6 s.
    case indigoPinnacle

    /// 2 taps over 36 ms.
    case emberStarling

    /// 7 taps over 1.6 s.
    case amberTundra

    /// 3 taps and a hold over 391 ms.
    case crimsonLagoon

    /// 2 taps and a hold over 149 ms.
    case duskyReef

    /// A tap and 9 holds over 1.0 s.
    case wistfulSaga

    /// 7 taps and 2 holds over 1.2 s.
    case scarletVortex

    /// 4 taps and 2 holds over 609 ms.
    case solarWillow

    /// 2 taps and a hold over 396 ms.
    case cosmicLighthouse

    /// 2 taps and 2 holds over 593 ms.
    case stormyComet

    /// 2 taps and 6 holds over 1.0 s.
    case glacialBlueJubilee

    /// 3 taps over 197 ms.
    case twilightReef

    /// 2 taps and a hold over 372 ms.
    case violetTalisman

    /// 3 taps and 2 holds over 670 ms.
    case stormyDriftwood

    /// 2 taps and 3 holds over 434 ms.
    case goldenCascade

    /// 2 taps over 42 ms.
    case bronzeFjord

    /// 5 taps over 1.1 s.
    case umberLotus

    /// 2 taps and a hold over 399 ms.
    case azureJuniper

    /// 5 taps and 2 holds over 1.1 s.
    case emberZenith

    /// 5 taps over 1.2 s.
    case feralOasis

    /// 2 holds over 116 ms.
    case hollowDriftwood

    /// 4 taps and a hold over 695 ms.
    case arcticTalisman

    /// 6 taps over 766 ms.
    case nobleOasis

    /// 4 taps over 340 ms.
    case azureCanyon

    /// 4 taps and 4 holds over 1.3 s.
    case indigoSparrow

    /// 3 taps and 2 holds over 402 ms.
    case neonComet

    /// 2 taps and a hold over 117 ms.
    case frostyHarbor

    /// A tap and 5 holds over 699 ms.
    case silverMonsoon

    /// 3 taps and 9 holds over 1.6 s.
    case pastelSonnet

    /// 4 taps and a hold over 827 ms.
    case scarletKestrel

    /// 2 holds over 247 ms.
    case mistyOasis

    /// 2 taps and 2 holds over 188 ms.
    case violetGlacier

    /// 3 taps and a hold over 119 ms.
    case umberSparrow

    /// A tap and 11 holds over 1.5 s.
    case gildedGlacier

    /// 3 taps over 115 ms.
    case arcticDriftwood

    /// 5 taps and 4 holds over 2.2 s.
    case bronzeLighthouse

    /// 2 taps over 89 ms.
    case violetOrchid

    /// 3 taps and a hold over 173 ms.
    case cobaltDriftwood

    /// 6 taps over 644 ms.
    case ashenMosaic

    /// A tap and 7 holds over 1.1 s.
    case tealThistle

    /// 4 taps and 3 holds over 1.1 s.
    case tealDune

    /// 3 taps and 9 holds over 1.4 s.
    case coralMarble

    /// 7 taps and 2 holds over 1.0 s.
    case jaggedOrchid

    /// A tap and 11 holds over 1.6 s.
    case luckyRhapsody

    /// 9 taps and a hold over 1.1 s.
    case prismMirage

    /// 5 taps and a hold over 968 ms.
    case glacialBlueBlossom

    /// 3 taps and a hold over 663 ms.
    case gildedMirage

    /// 8 holds over 1.2 s.
    case mellowNimbus

    /// 4 taps over 205 ms.
    case lunarWhisper

    /// 3 taps and 3 holds over 1.1 s.
    case wovenKite

    /// 3 taps and 3 holds over 1.1 s.
    case saffronSparrow

    /// 3 taps and 7 holds over 1.1 s.
    case indigoDriftwood

    /// A tap and 2 holds over 757 ms.
    case obsidianIris

    /// 3 taps and a hold over 429 ms.
    case feralDune

    /// 2 taps over 41 ms.
    case pastelMeadow

    /// 3 taps and 3 holds over 1.0 s.
    case opalSpire

    /// 6 taps and a hold over 1.6 s.
    case wovenWhisper

    /// 3 taps over 120 ms.
    case vividMeadow

    /// 3 taps and 2 holds over 1.0 s.
    case cosmicZenith

    /// 2 taps and 10 holds over 1.6 s.
    case tealFjord

    /// 5 holds over 849 ms.
    case wovenQuasar

    /// 11 holds over 1.3 s.
    case indigoNebula

    /// 2 taps and 8 holds over 1.1 s.
    case velvetRhapsody

    /// 2 taps over 81 ms.
    case mossyTalisman

    /// 2 taps and a hold over 389 ms.
    case scarletPinnacle

    /// 2 taps over 87 ms.
    case rubyMonsoon

    /// 9 taps and a hold over 1.6 s.
    case obsidianHarbor

    /// 3 taps and 6 holds over 840 ms.
    case stormyNimbus

    /// A tap and 6 holds over 791 ms.
    case swiftStarling

    /// 2 taps and 2 holds over 416 ms.
    case scarletKite

    /// 6 taps and a hold over 492 ms.
    case emberTundra

    /// 4 taps and 3 holds over 402 ms.
    case zestyOasis

    /// A tap and a hold over 82 ms.
    case prismSaga

    /// 3 taps and 3 holds over 1.3 s.
    case rubySparrow

    /// 4 taps and a hold over 1.3 s.
    case jadeQuasar

    /// 3 taps and a hold over 490 ms.
    case swiftFjord

    /// 2 taps and 5 holds over 846 ms.
    case pastelTalisman

    /// 7 taps and a hold over 779 ms.
    case cobaltLantern

    /// 3 taps and 3 holds over 1.3 s.
    case velvetVortex

    /// 5 taps and 2 holds over 1.0 s.
    case cobaltNebula

    /// A tap and 5 holds over 721 ms.
    case azureGlacier

    /// 5 taps and a hold over 1.3 s.
    case wovenComet

    /// 6 taps and a hold over 1.1 s.
    case prismSparrow

    /// 2 taps over 42 ms.
    case rusticTalisman

    /// 4 taps over 430 ms.
    case neonStarling

    /// 3 taps and 2 holds over 645 ms.
    case rubyGlacier

    /// 6 taps over 884 ms.
    case indigoPebble

    /// 3 taps and 4 holds over 1.2 s.
    case hollowReef

    /// 6 taps over 451 ms.
    case dappledAtlas

    /// 2 taps and a hold over 469 ms.
    case tidalHarbor

    /// 4 taps over 678 ms.
    case jadeIris

    /// A tap and 8 holds over 1.2 s.
    case solarWhisper

    /// 2 taps and 2 holds over 538 ms.
    case cobaltQuill

    /// 3 taps and 3 holds over 806 ms.
    case indigoWhisper

    /// 2 taps and 5 holds over 1.3 s.
    case umberNebula

    /// 2 taps and 2 holds over 554 ms.
    case duskyStarling

    /// 3 taps over 153 ms.
    case goldenDelta

    /// 5 taps and a hold over 471 ms.
    case obsidianThistle

    /// 8 taps and a hold over 1.3 s.
    case jadePrairie

    /// 2 taps and a hold over 248 ms.
    case wildOasis

    /// A tap and 4 holds over 1.0 s.
    case coralJuniper

    /// 7 taps and 3 holds over 827 ms.
    case saffronMosaic

    /// A tap and a hold over 226 ms.
    case indigoLotus

    /// 2 taps and 2 holds over 225 ms.
    case nobleHaven

    /// 7 taps over 971 ms.
    case luckyVortex

    /// 3 taps and 3 holds over 968 ms.
    case nobleFable

    /// 2 taps and 3 holds over 839 ms.
    case copperQuasar

    /// 6 taps over 464 ms.
    case sunlitQuartz

    /// 4 taps and a hold over 1.1 s.
    case hollowEmberGlow

    /// A tap and 3 holds over 387 ms.
    case emeraldHaven

    /// 3 taps and a hold over 611 ms.
    case lunarMosaic

    /// 3 taps and a hold over 467 ms.
    case glacialBlueReef

    /// 2 taps and 2 holds over 1.1 s.
    case zestyCanyon

    /// 3 taps over 149 ms.
    case lunarSparrow

    /// 3 taps and 2 holds over 617 ms.
    case silverTundra

    /// 2 taps and 7 holds over 1.1 s.
    case umberLagoon

    /// 9 taps over 1.9 s.
    case solarAnchor

    /// 6 taps over 1.2 s.
    case indigoMarble

    /// 2 taps and a hold over 347 ms.
    case gildedCanyon

    /// A tap and 8 holds over 1.2 s.
    case ochreFjord

    /// 10 taps over 1.6 s.
    case ochreJuniper

    /// 3 taps and a hold over 469 ms.
    case ochreMarble

    /// 2 taps and 2 holds over 296 ms.
    case stormyVale

    /// 4 taps and 3 holds over 568 ms.
    case ochreKestrel

    /// 2 taps over 37 ms.
    case coralOrchid

    /// 2 taps and a hold over 326 ms.
    case indigoIris

    /// 6 holds over 788 ms.
    case stormyMonsoon

    /// 5 taps and 4 holds over 1.5 s.
    case silverYarrow

    /// 3 taps and a hold over 370 ms.
    case violetZenith

    /// 2 taps and 6 holds over 861 ms.
    case saffronUtopia

    /// A tap and 3 holds over 259 ms.
    case luckyBlossom

    /// 2 taps and a hold over 86 ms.
    case mistyFable

    /// 3 taps and 2 holds over 559 ms.
    case gildedHaven

    /// 4 taps and 2 holds over 432 ms.
    case electricHorizon

    /// A tap and a hold over 115 ms.
    case bronzeSpire

    /// A tap and 3 holds over 855 ms.
    case cobaltPinnacle

    /// 2 taps and 10 holds over 1.6 s.
    case rubyWillow

    /// 6 taps over 824 ms.
    case bronzeWhisper

    /// 7 taps and a hold over 638 ms.
    case swiftGlacier

    /// 4 taps and a hold over 603 ms.
    case opalSparrow

    /// 6 taps and a hold over 328 ms.
    case twilightCanyon

    /// A tap and 2 holds over 368 ms.
    case gildedHorizon

    /// 3 taps over 132 ms.
    case azureQuasar

    /// 4 holds over 1.2 s.
    case pastelDune

    /// 2 taps and 2 holds over 777 ms.
    case prismDelta

    /// 2 taps and a hold over 118 ms.
    case stormyFable

    /// 2 taps over 85 ms.
    case sunlitPebble

    /// 3 taps and 8 holds over 1.1 s.
    case emeraldZenith

    /// 3 taps and 2 holds over 807 ms.
    case paleWren

    /// 4 taps and 3 holds over 1.4 s.
    case sableHarbor

    /// A tap and 6 holds over 1.4 s.
    case violetIris

    /// 3 taps and a hold over 621 ms.
    case pastelNebula

    /// A tap and 7 holds over 1.1 s.
    case mistyLighthouse

    /// 3 taps over 210 ms.
    case amberQuartz

    /// 4 holds over 572 ms.
    case sunlitAtlas

    /// 5 taps over 742 ms.
    case wildDriftwood

    /// 3 taps and a hold over 438 ms.
    case rubyNimbus

    /// 5 taps over 629 ms.
    case wistfulUtopia

    /// 4 taps over 380 ms.
    case ochreHarbor

    /// 9 taps over 1.6 s.
    case mistyAtlas

    /// 3 taps over 128 ms.
    case solarPinnacle

    /// 7 taps over 1.2 s.
    case silverJubilee

    /// 6 taps over 1.4 s.
    case amberFjord

    /// 3 taps over 156 ms.
    case jaggedMarble

    /// 2 taps and 5 holds over 829 ms.
    case swiftGalaxy

    /// 2 taps and 2 holds over 763 ms.
    case scarletGlacier

    /// 2 taps over 63 ms.
    case wistfulThistle

    /// A tap and 2 holds over 459 ms.
    case umberLighthouse

    /// 7 taps and a hold over 1.5 s.
    case lunarPinnacle

    /// 6 taps over 1.2 s.
    case copperKestrel

    /// 4 taps and a hold over 679 ms.
    case scarletAnchor

    /// 4 taps over 429 ms.
    case nobleLighthouse

    /// 3 taps over 347 ms.
    case bronzeGalaxy

    /// 3 taps and 3 holds over 942 ms.
    case copperHorizon

    /// 4 taps and 3 holds over 1.2 s.
    case hollowMarble

    /// 7 taps and a hold over 644 ms.
    case emberKite

    /// 4 taps over 487 ms.
    case sunlitWillow

    /// A tap and 7 holds over 1.2 s.
    case sableMarble

    /// A tap and 11 holds over 1.7 s.
    case dappledAnchor

    /// 2 taps and a hold over 129 ms.
    case paleLotus

    /// 2 taps over 47 ms.
    case jadeMeadow

    /// 2 taps and 4 holds over 657 ms.
    case pastelQuasar

    /// 2 taps over 84 ms.
    case saffronQuasar

    /// 2 taps and 3 holds over 961 ms.
    case coralMonsoon

    /// 3 taps and a hold over 467 ms.
    case velvetPinnacle

    /// 5 taps and 2 holds over 1.0 s.
    case sunlitIris

    /// 4 taps and 2 holds over 830 ms.
    case wildVortex

    /// 8 taps over 2.2 s.
    case silverKestrel

    /// 4 taps and a hold over 881 ms.
    case silverDelta

    /// 6 taps and 2 holds over 1.2 s.
    case luckyCascade

    /// 2 taps and a hold over 472 ms.
    case tidalLighthouse

    /// 5 taps and 2 holds over 954 ms.
    case glacialBlueFable

    /// A tap and 3 holds over 428 ms.
    case glacialBlueDriftwood

    /// 5 taps and a hold over 983 ms.
    case gildedCascade

    /// 4 taps over 305 ms.
    case sunlitReef

    /// 2 taps and 3 holds over 770 ms.
    case hazyWillow

    /// 4 taps and 5 holds over 818 ms.
    case silverNebula

    /// 3 taps and 2 holds over 964 ms.
    case jadeMonsoon

    /// 4 taps and 2 holds over 553 ms.
    case swiftWhisper

    /// 4 taps and 7 holds over 1.1 s.
    case hollowSpire

    /// 6 taps over 737 ms.
    case velvetZenith

    /// A tap and 9 holds over 1.1 s.
    case hazyReef

    /// 6 taps over 648 ms.
    case jaggedQuartz

    /// 7 taps and a hold over 1.6 s.
    case jaggedSparrow

    /// A tap and 4 holds over 1.1 s.
    case twilightKite

    /// 5 taps over 730 ms.
    case wovenHorizon

    /// A tap and 5 holds over 1.3 s.
    case frostyLagoon

    /// 4 taps and 3 holds over 1.1 s.
    case wildMarble

    /// 8 taps over 1.4 s.
    case vividPinnacle

    /// 4 taps and 2 holds over 600 ms.
    case hazyHarbor

    /// 5 taps and 4 holds over 1.0 s.
    case dappledQuartz

    /// 4 taps and a hold over 719 ms.
    case rubyThistle

    /// 6 taps over 1.4 s.
    case velvetAnchor

    /// 5 taps over 759 ms.
    case mistySpire

    /// A tap and 7 holds over 913 ms.
    case bronzeCanyon

    /// 3 taps and a hold over 265 ms.
    case amberKestrel

    /// 5 taps over 364 ms.
    case emeraldSonnet

    /// 2 taps and 5 holds over 1.0 s.
    case crimsonLighthouse

    /// 3 taps over 262 ms.
    case sunlitHorizon

    /// 4 taps and 3 holds over 1.4 s.
    case coralTalisman

    /// 4 taps over 624 ms.
    case electricTalisman

    /// 3 taps and a hold over 431 ms.
    case arcticFjord

    /// A tap and a hold over 265 ms.
    case tealZenith

    /// 2 taps over 84 ms.
    case lunarCascade

    /// 4 taps and a hold over 511 ms.
    case paleJubilee

    /// 4 taps over 141 ms.
    case emeraldMonsoon

    /// 6 taps and 2 holds over 795 ms.
    case velvetWillow

    /// 4 holds over 614 ms.
    case bronzeJuniper

    /// 2 taps and a hold over 679 ms.
    case swiftZephyr

    /// 2 taps and 3 holds over 574 ms.
    case cobaltMeadow

    /// 6 taps over 670 ms.
    case umberVortex

    /// 3 taps over 130 ms.
    case opalYarrow

    /// 4 taps and a hold over 674 ms.
    case jadeNebula

    /// 5 taps and a hold over 334 ms.
    case tidalMonsoon

    /// A tap and 11 holds over 1.8 s.
    case sableEmberGlow

    /// 3 taps and a hold over 168 ms.
    case silverQuill

    /// 2 taps and 3 holds over 469 ms.
    case zestyLagoon

    /// 4 taps over 608 ms.
    case opalMosaic

    /// 2 taps and 9 holds over 1.1 s.
    case sableCascade

    /// 5 taps and 2 holds over 1.2 s.
    case neonMonsoon

    /// A tap and 4 holds over 934 ms.
    case cobaltComet

    /// A tap and 3 holds over 233 ms.
    case ochreSonnet

    /// 5 taps over 896 ms.
    case electricDelta

    /// 5 taps and 4 holds over 1.7 s.
    case vividQuasar

    /// 3 taps and 4 holds over 1.5 s.
    case rusticKite

    /// 4 taps over 231 ms.
    case lunarIris

    /// A tap and a hold over 117 ms.
    case duskyOrchid

    /// A tap and 7 holds over 1.9 s.
    case duskyComet

    /// 5 taps and 2 holds over 657 ms.
    case feralZenith

    /// A tap and 2 holds over 159 ms.
    case dappledDune

    /// 4 taps and 3 holds over 1.0 s.
    case zestyMarble

    /// 4 taps and a hold over 418 ms.
    case sunlitTalisman

    /// 2 taps and 2 holds over 578 ms.
    case pastelCanyon

    /// 3 taps and 6 holds over 995 ms.
    case saffronBlossom

    /// A tap and 5 holds over 602 ms.
    case feralHaven

    /// 2 taps over 63 ms.
    case dappledLighthouse

    /// 3 taps and a hold over 708 ms.
    case cosmicWhisper

    /// 7 taps over 794 ms.
    case velvetKite

    /// 4 taps and a hold over 488 ms.
    case ashenNimbus

    /// 4 taps and 4 holds over 1.3 s.
    case crimsonZephyr

    /// 3 taps over 190 ms.
    case copperQuartz

    /// 6 taps and 2 holds over 1.5 s.
    case luckyGlacier

    /// 5 taps over 1.1 s.
    case wistfulZenith

    /// 4 taps and a hold over 413 ms.
    case copperDune

    /// 3 taps and a hold over 433 ms.
    case indigoOasis

    /// 3 taps and 6 holds over 782 ms.
    case prismMarble

    /// 3 taps and 2 holds over 656 ms.
    case glacialBlueSpire

    /// A tap and 10 holds over 1.7 s.
    case indigoComet

    /// 8 taps over 2.0 s.
    case azureMeadow

    /// 3 taps and a hold over 636 ms.
    case azureYarrow

    /// 8 taps over 1.4 s.
    case crimsonLantern

    /// 3 taps over 112 ms.
    case nobleCascade

    /// 2 taps and 10 holds over 1.4 s.
    case electricSpire

    /// A tap and 3 holds over 353 ms.
    case paleCascade

    /// 7 taps over 1.1 s.
    case saffronPinnacle

    /// 2 taps and 3 holds over 933 ms.
    case zestyLotus

    /// 7 taps and a hold over 1.4 s.
    case duskyZenith

    /// 4 taps and 3 holds over 1.0 s.
    case solarMonsoon

    /// A tap and a hold over 41 ms.
    case wistfulPrairie

    /// 2 taps and 2 holds over 191 ms.
    case swiftMosaic

    /// 2 taps and a hold over 293 ms.
    case hollowHarbor

    /// 5 taps and a hold over 718 ms.
    case sunlitMeadow

    /// A tap and 3 holds over 663 ms.
    case luckyNimbus

    /// 3 taps over 163 ms.
    case coralFjord

    /// 8 taps and a hold over 946 ms.
    case cosmicLotus

    /// 2 taps and 2 holds over 337 ms.
    case bronzeMarble

    /// 2 taps and 7 holds over 1.0 s.
    case mossyMosaic

    /// 2 taps and 3 holds over 312 ms.
    case coralJubilee

    /// 2 taps and a hold over 117 ms.
    case ivoryNimbus

    /// 6 taps and 6 holds over 864 ms.
    case coralLotus

    /// 2 taps and 10 holds over 1.4 s.
    case twilightTundra

    /// 8 taps over 1.2 s.
    case nobleCanyon

    /// 2 taps and 3 holds over 513 ms.
    case emberGalaxy

    /// 3 taps and 2 holds over 697 ms.
    case lunarMonsoon

    /// 4 taps over 191 ms.
    case wildZephyr

    /// 2 holds over 293 ms.
    case rubyVale

    /// 3 taps and 2 holds over 650 ms.
    case emeraldJubilee

    /// A tap and a hold over 142 ms.
    case sableDriftwood

    /// 4 taps and a hold over 528 ms.
    case swiftHorizon

    /// 3 taps over 275 ms.
    case violetWillow

    /// 4 taps and 2 holds over 717 ms.
    case tealHarbor

    /// 4 taps and a hold over 481 ms.
    case amberEmberGlow

    /// 2 taps and 2 holds over 279 ms.
    case hazyGalaxy

    /// 3 taps and a hold over 660 ms.
    case prismLotus

    /// 2 taps and 3 holds over 1.0 s.
    case gildedOrchid

    /// 2 taps and 8 holds over 1.2 s.
    case velvetLagoon

    /// 2 taps over 33 ms.
    case gildedZenith

    /// 6 taps over 457 ms.
    case wistfulAtlas

    /// 3 taps and 2 holds over 557 ms.
    case scarletWren

    /// 3 taps and 2 holds over 323 ms.
    case gildedFable

    /// 8 taps and a hold over 1.7 s.
    case neonRhapsody

    /// 3 taps over 251 ms.
    case scarletMirage

    /// 3 taps and 2 holds over 476 ms.
    case luckyMeadow

    /// 4 taps and a hold over 427 ms.
    case mistyQuartz

    /// 2 taps and a hold over 181 ms.
    case wovenThistle

    /// 7 taps over 1.6 s.
    case crimsonGalaxy

    /// 6 taps over 453 ms.
    case pastelOrchid

    /// 5 taps over 645 ms.
    case sunlitCanyon

    /// 3 taps and 4 holds over 481 ms.
    case umberKestrel

    /// A tap and 2 holds over 135 ms.
    case ivoryCanyon

    /// 6 taps and 4 holds over 1.1 s.
    case indigoJuniper

    /// 4 taps over 357 ms.
    case wistfulCascade

    /// 8 taps and a hold over 1.6 s.
    case crimsonReef

    /// 3 taps and 5 holds over 583 ms.
    case rusticZenith

    /// 5 taps and 2 holds over 1.4 s.
    case mellowTundra

    /// 3 taps and a hold over 507 ms.
    case copperLighthouse

    /// A tap and 2 holds over 547 ms.
    case feralPinnacle

    /// 2 taps and a hold over 92 ms.
    case mossyJubilee

    /// 2 taps and a hold over 136 ms.
    case wovenTalisman

    /// 2 taps over 36 ms.
    case jadeComet

    /// 8 taps and a hold over 1.3 s.
    case goldenHarbor

    /// A tap and 2 holds over 552 ms.
    case violetFjord

    /// 2 taps and a hold over 174 ms.
    case crimsonQuill

    /// 2 taps over 86 ms.
    case velvetComet

    /// 4 taps and 2 holds over 315 ms.
    case velvetNebula

    /// 2 taps and a hold over 102 ms.
    case scarletZenith

    /// 2 taps and 2 holds over 227 ms.
    case emberZephyr

    /// 2 taps and 2 holds over 681 ms.
    case copperAtlas

    /// 11 holds over 1.7 s.
    case mossyOasis

    /// 3 taps and 3 holds over 436 ms.
    case noblePebble

    /// A tap and a hold over 77 ms.
    case scarletDune

    /// A tap and 5 holds over 1.5 s.
    case saffronCascade

    /// 11 holds over 1.6 s.
    case violetTundra

    /// 6 taps and a hold over 1.3 s.
    case copperWillow

    /// 3 taps and 4 holds over 728 ms.
    case hollowOrchid

    /// 3 taps and 7 holds over 952 ms.
    case stormyZephyr

    /// 3 taps and a hold over 723 ms.
    case ashenFjord

    /// 3 taps and a hold over 174 ms.
    case zestyKestrel

    /// 9 taps and a hold over 1.5 s.
    case feralEmberGlow

    /// 3 taps and 4 holds over 642 ms.
    case vividPebble

    /// A tap and 5 holds over 605 ms.
    case cosmicQuartz

    /// 3 taps over 229 ms.
    case obsidianLighthouse

    /// 2 taps and a hold over 479 ms.
    case cosmicSparrow

    /// 4 taps over 388 ms.
    case mistyHaven

    /// 3 taps and a hold over 294 ms.
    case twilightWren

    /// 2 taps and 2 holds over 317 ms.
    case coralMirage

    /// 2 taps over 61 ms.
    case arcticHaven

    /// 3 taps and 4 holds over 1.6 s.
    case duskyMirage

    /// 6 taps and 3 holds over 1.0 s.
    case rusticBlossom

    /// 4 taps and 3 holds over 872 ms.
    case gildedKite

    /// 5 taps and 4 holds over 1.9 s.
    case arcticVale

    /// A tap and 7 holds over 923 ms.
    case neonMirage

    /// 4 taps and 3 holds over 909 ms.
    case ochreWren

    /// A tap and a hold over 149 ms.
    case silverKite

    /// 4 taps and a hold over 674 ms.
    case ashenDriftwood

    /// 3 holds over 681 ms.
    case bronzeDune

    /// 2 taps and 7 holds over 1.1 s.
    case hollowWhisper

    /// 6 taps over 754 ms.
    case mossyGlacier

    /// 5 taps and 3 holds over 1.7 s.
    case electricDune

    /// 2 taps and 5 holds over 604 ms.
    case dappledQuasar

    /// 5 taps and a hold over 951 ms.
    case saffronThistle

    /// 7 taps and 2 holds over 734 ms.
    case hollowCascade

    /// 3 taps and 3 holds over 897 ms.
    case jadeHorizon

    /// 2 taps and 2 holds over 142 ms.
    case solarCanyon

    /// 7 taps over 1.6 s.
    case glacialBlueOrchid

    /// 3 taps over 243 ms.
    case mossyNebula

    /// 7 taps over 1.3 s.
    case duskySpire

    /// 5 taps and 4 holds over 549 ms.
    case neonHarbor

    /// 7 taps over 1.2 s.
    case scarletLighthouse

    /// 3 taps over 137 ms.
    case arcticCanyon

    /// 2 taps and 3 holds over 582 ms.
    case mistyBlossom

    /// 3 taps and 6 holds over 847 ms.
    case indigoDelta

    /// 3 taps and a hold over 191 ms.
    case emberCascade

    /// 4 taps and 2 holds over 471 ms.
    case pastelCascade

    /// 2 taps over 67 ms.
    case neonKite

    /// 3 taps over 289 ms.
    case duskyLantern

    /// 2 taps over 62 ms.
    case glacialBlueWren
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
