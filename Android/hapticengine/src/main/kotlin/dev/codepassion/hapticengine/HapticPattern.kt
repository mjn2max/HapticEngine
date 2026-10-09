package dev.codepassion.hapticengine

/**
 * A built-in haptic pattern. Pass one to [HapticEngine.play]. Mirrors `HapticPattern` on iOS, in the
 * same order: each iOS case is an entry here, named the same with a capital first letter, so iOS's
 * `heavyMetalHit` is [HeavyMetalHit].
 *
 * ```kotlin
 * haptics.play(HapticPattern.Success)
 * ```
 *
 * There are 4,000. The first ten were the library's first. Then ninety more built by hand, then 2,900
 * generated in families, each a variant at one of several levels: 900 in ten families of ninety, like
 * [HeavyMetalHit] or [WaltzAllegro], then 2,000 in forty sets of fifty, like [HugeBark], [FirmButton] or
 * [TripleGem], then 1,000 drawn at random from a fixed seed, like [EmberNebula]. Every one feels the same as
 * on iOS, as far as the phone's vibrator allows: see [HapticEngine].
 */
public enum class HapticPattern {
    /** One sharp tap followed by nine taps of rising strength over about one second. */
    Simple,

    /** Four 1.5 second segments: medium, hard, soft, hard. */
    Complex,

    /** One light, crisp tap. */
    Tick,

    /** A soft tap followed by a strong sharp tap, to confirm something worked. */
    Success,

    /** A strong tap followed by a weaker one, to draw attention. */
    Warning,

    /** Three strong, sharp taps in quick succession, to signal a failure. */
    Error,

    /** Two "lub-dub" heartbeats over about one second. */
    Heartbeat,

    /** Three firm, dull taps, like knocking on a door. */
    Knock,

    /** A strong, low rumble for 0.8 seconds. */
    Rumble,

    /** Five short bursts over about one second. */
    Pulse,

    // BEGIN GENERATED PATTERNS: written by Android/scripts/export-patterns.sh from the iOS patterns. Don't edit by hand.

    // Feedback

    /** A faint, crisp tick, like a picker wheel moving one row. */
    Selection,

    /** A light, medium-sharp tap. */
    LightImpact,

    /** A moderate, medium-sharp tap. */
    MediumImpact,

    /** A heavy, dull tap. */
    HeavyImpact,

    /** A soft, rounded tap. */
    SoftImpact,

    /** A firm, very crisp tap. */
    RigidImpact,

    /** A soft tap then a crisp one, like a switch turning on. */
    ToggleOn,

    /** A crisp tap then a soft one, like a switch turning off. */
    ToggleOff,

    /** A press and a lighter release, like a physical button. */
    ButtonPress,

    /** Pressure building for 0.4 seconds, then a firm click. */
    LongPress,

    /** A tap and a lighter follow-up, as an item lifts to be dragged. */
    DragStart,

    /** A dull tap and a small settle, as a dragged item is dropped. */
    Drop,

    /** A light touch, then a sharp click into place. */
    Snap,

    /** A brief vibration that swells, following a swipe. */
    Swipe,

    /** Rising taps ending in a crisp click, for pull to refresh. */
    Refresh,

    /** A tap, then a short crumple, for deleting something. */
    Delete,

    /** A tap and a softer one, stepping back. */
    Undo,

    /** Two even taps in quick succession. */
    DoubleTap,

    // Alerts

    /** Two even taps, for a general notification. */
    Notification,

    /** Three quick taps that rise and fall, for a new message. */
    Message,

    /** Four rapid crisp taps, for a mention. */
    Mention,

    /** Two gentle buzzes, for a reminder. */
    Reminder,

    /** Three bursts of four rapid taps, like an alarm clock. */
    Alarm,

    /** Two pairs of rings, like a phone ringing. */
    Ring,

    /** A bright "ding" and a lower "dong". */
    Doorbell,

    /** A vibration that alternates between high and low, like a siren. */
    Siren,

    /** Three steady taps, then a strong final one. */
    Countdown,

    /** Two sets of three taps, for a finished timer. */
    TimerDone,

    /** Three taps that fade, for low battery. */
    LowBattery,

    /** "SOS" in Morse code: three short, three long, three short. */
    Sos,

    // Rhythm

    /** Sixteen rapid taps that build in strength. */
    Drumroll,

    /** Three "da-da-dum" beats, like a galloping horse. */
    Gallop,

    /** Four steady steps, strong and weak in turn. */
    March,

    /** Two bars of three beats, the first of each accented. */
    Waltz,

    /** A crisp "tick" and a duller "tock", twice. */
    ClockTick,

    /** Four evenly spaced crisp beats, the first accented. */
    Metronome,

    /** Four quick heartbeats. */
    RacingHeart,

    /** Two slow, soft heartbeats. */
    RestingHeart,

    /** Four dull steps, alternating feet. */
    Footsteps,

    /** Three sharp claps. */
    Clap,

    /** A ball bouncing: taps that come faster and fade. */
    Bounce,

    /** A tap that repeats and fades, like an echo. */
    Echo,

    /** An off-beat rhythm of five taps. */
    Syncopation,

    // Texture

    /** A crisp, steady buzz for half a second. */
    Buzz,

    /** A soft, low hum for one second. */
    Hum,

    /** A gentle fluttering vibration, like a cat purring. */
    Purr,

    /** Twenty tiny taps in a fast run, like a zipper. */
    Zipper,

    /** A rough, fine-grained texture. */
    Sandpaper,

    /** A coarse, uneven texture. */
    Gravel,

    /** Small taps at uneven intervals, like rising bubbles. */
    Bubbles,

    /** Tiny, bright taps that shimmer. */
    Sparkle,

    /** A vibration that grows from faint to full strength. */
    Crescendo,

    /** A vibration that fades from full strength to faint. */
    FadeOut,

    /** A vibration that swings between strong and weak. */
    Wobble,

    /** Four heavy, dull pulses. */
    Throb,

    // Nature

    /** A single light, crisp drop. */
    Raindrop,

    /** Light taps falling at random, like rain. */
    Rain,

    /** A sharp crack, then a rolling rumble that fades. */
    Thunder,

    /** A deep, uneven shaking that dies away. */
    Earthquake,

    /** A vibration that swells and recedes, like a wave. */
    OceanWave,

    /** A short rush of wind that builds and falls. */
    Gust,

    /** A slow swell and release, to pace a calm breath. */
    Breathe,

    /** Three quick chirps. */
    Crickets,

    /** Eight rapid, firm pecks. */
    Woodpecker,

    /** Crackles over a faint glow, like a campfire. */
    Campfire,

    /** A hard, rapid clatter, like hail. */
    Hail,

    /** Taps that come faster and stronger, then a heavy rumble. */
    Avalanche,

    // Mechanical

    /** Uneven key strikes, then the carriage bell. */
    Typewriter,

    /** Eight quick, crisp clicks. */
    Ratchet,

    /** Five light detents, then a firm stop, like a dial. */
    Dial,

    /** A bouncy vibration that settles, like a spring. */
    Spring,

    /** The engine cranks, catches, then idles. */
    EngineStart,

    /** An engine revving up and back down. */
    EngineRev,

    /** A quick two-part click, like a camera shutter. */
    Shutter,

    /** A click, then a solid clunk. */
    Lock,

    /** A clunk, then a light click. */
    Unlock,

    /** Interlocking clicks, like turning gears. */
    Gears,

    /** A drill spinning up, then running. */
    Drill,

    // Game

    /** Two bright taps, like collecting a coin. */
    Coin,

    /** Taps that rise in strength and sharpness. */
    PowerUp,

    /** Four rising taps and a bright hold. */
    LevelUp,

    /** A short upward push. */
    Jump,

    /** A heavy thud and a brief settle. */
    Landing,

    /** A solid hit with a small rebound. */
    Hit,

    /** A sharp strike, a heavy blow, then a shudder. */
    CriticalHit,

    /** A blast, then a rumble that dies away. */
    Explosion,

    /** A short zap that loses its edge. */
    Laser,

    /** A shimmering hold between two bright taps. */
    Shield,

    /** Four falling taps and a low fade. */
    GameOver,

    /** Three quick taps and a triumphant hold. */
    Victory,

    // Impacts: a hit on a material, from feather-light to crushing

    /** A feather-light hit on wood, a hollow knock. */
    FeatherWoodHit,

    /** A light hit on wood, a hollow knock. */
    LightWoodHit,

    /** A soft hit on wood, a hollow knock. */
    SoftWoodHit,

    /** A gentle hit on wood, a hollow knock. */
    GentleWoodHit,

    /** A medium hit on wood, a hollow knock. */
    MediumWoodHit,

    /** A firm hit on wood, a hollow knock. */
    FirmWoodHit,

    /** A heavy hit on wood, a hollow knock. */
    HeavyWoodHit,

    /** A hard hit on wood, a hollow knock. */
    HardWoodHit,

    /** A crushing hit on wood, a hollow knock. */
    CrushingWoodHit,

    /** A feather-light hit on metal, ringing on. */
    FeatherMetalHit,

    /** A light hit on metal, ringing on. */
    LightMetalHit,

    /** A soft hit on metal, ringing on. */
    SoftMetalHit,

    /** A gentle hit on metal, ringing on. */
    GentleMetalHit,

    /** A medium hit on metal, ringing on. */
    MediumMetalHit,

    /** A firm hit on metal, ringing on. */
    FirmMetalHit,

    /** A heavy hit on metal, ringing on. */
    HeavyMetalHit,

    /** A hard hit on metal, ringing on. */
    HardMetalHit,

    /** A crushing hit on metal, ringing on. */
    CrushingMetalHit,

    /** A feather-light hit on glass, with a tinkle. */
    FeatherGlassHit,

    /** A light hit on glass, with a tinkle. */
    LightGlassHit,

    /** A soft hit on glass, with a tinkle. */
    SoftGlassHit,

    /** A gentle hit on glass, with a tinkle. */
    GentleGlassHit,

    /** A medium hit on glass, with a tinkle. */
    MediumGlassHit,

    /** A firm hit on glass, with a tinkle. */
    FirmGlassHit,

    /** A heavy hit on glass, with a tinkle. */
    HeavyGlassHit,

    /** A hard hit on glass, with a tinkle. */
    HardGlassHit,

    /** A crushing hit on glass, with a tinkle. */
    CrushingGlassHit,

    /** A feather-light hit on stone, dull and solid. */
    FeatherStoneHit,

    /** A light hit on stone, dull and solid. */
    LightStoneHit,

    /** A soft hit on stone, dull and solid. */
    SoftStoneHit,

    /** A gentle hit on stone, dull and solid. */
    GentleStoneHit,

    /** A medium hit on stone, dull and solid. */
    MediumStoneHit,

    /** A firm hit on stone, dull and solid. */
    FirmStoneHit,

    /** A heavy hit on stone, dull and solid. */
    HeavyStoneHit,

    /** A hard hit on stone, dull and solid. */
    HardStoneHit,

    /** A crushing hit on stone, dull and solid. */
    CrushingStoneHit,

    /** A feather-light hit on rubber, bouncing back. */
    FeatherRubberHit,

    /** A light hit on rubber, bouncing back. */
    LightRubberHit,

    /** A soft hit on rubber, bouncing back. */
    SoftRubberHit,

    /** A gentle hit on rubber, bouncing back. */
    GentleRubberHit,

    /** A medium hit on rubber, bouncing back. */
    MediumRubberHit,

    /** A firm hit on rubber, bouncing back. */
    FirmRubberHit,

    /** A heavy hit on rubber, bouncing back. */
    HeavyRubberHit,

    /** A hard hit on rubber, bouncing back. */
    HardRubberHit,

    /** A crushing hit on rubber, bouncing back. */
    CrushingRubberHit,

    /** A feather-light hit on plastic, with a click. */
    FeatherPlasticHit,

    /** A light hit on plastic, with a click. */
    LightPlasticHit,

    /** A soft hit on plastic, with a click. */
    SoftPlasticHit,

    /** A gentle hit on plastic, with a click. */
    GentlePlasticHit,

    /** A medium hit on plastic, with a click. */
    MediumPlasticHit,

    /** A firm hit on plastic, with a click. */
    FirmPlasticHit,

    /** A heavy hit on plastic, with a click. */
    HeavyPlasticHit,

    /** A hard hit on plastic, with a click. */
    HardPlasticHit,

    /** A crushing hit on plastic, with a click. */
    CrushingPlasticHit,

    /** A feather-light hit on paper, with a rustle. */
    FeatherPaperHit,

    /** A light hit on paper, with a rustle. */
    LightPaperHit,

    /** A soft hit on paper, with a rustle. */
    SoftPaperHit,

    /** A gentle hit on paper, with a rustle. */
    GentlePaperHit,

    /** A medium hit on paper, with a rustle. */
    MediumPaperHit,

    /** A firm hit on paper, with a rustle. */
    FirmPaperHit,

    /** A heavy hit on paper, with a rustle. */
    HeavyPaperHit,

    /** A hard hit on paper, with a rustle. */
    HardPaperHit,

    /** A crushing hit on paper, with a rustle. */
    CrushingPaperHit,

    /** A feather-light hit on cloth, muffled. */
    FeatherClothHit,

    /** A light hit on cloth, muffled. */
    LightClothHit,

    /** A soft hit on cloth, muffled. */
    SoftClothHit,

    /** A gentle hit on cloth, muffled. */
    GentleClothHit,

    /** A medium hit on cloth, muffled. */
    MediumClothHit,

    /** A firm hit on cloth, muffled. */
    FirmClothHit,

    /** A heavy hit on cloth, muffled. */
    HeavyClothHit,

    /** A hard hit on cloth, muffled. */
    HardClothHit,

    /** A crushing hit on cloth, muffled. */
    CrushingClothHit,

    /** A feather-light hit on water, with a splash. */
    FeatherWaterHit,

    /** A light hit on water, with a splash. */
    LightWaterHit,

    /** A soft hit on water, with a splash. */
    SoftWaterHit,

    /** A gentle hit on water, with a splash. */
    GentleWaterHit,

    /** A medium hit on water, with a splash. */
    MediumWaterHit,

    /** A firm hit on water, with a splash. */
    FirmWaterHit,

    /** A heavy hit on water, with a splash. */
    HeavyWaterHit,

    /** A hard hit on water, with a splash. */
    HardWaterHit,

    /** A crushing hit on water, with a splash. */
    CrushingWaterHit,

    /** A feather-light hit on ceramic, with a clink. */
    FeatherCeramicHit,

    /** A light hit on ceramic, with a clink. */
    LightCeramicHit,

    /** A soft hit on ceramic, with a clink. */
    SoftCeramicHit,

    /** A gentle hit on ceramic, with a clink. */
    GentleCeramicHit,

    /** A medium hit on ceramic, with a clink. */
    MediumCeramicHit,

    /** A firm hit on ceramic, with a clink. */
    FirmCeramicHit,

    /** A heavy hit on ceramic, with a clink. */
    HeavyCeramicHit,

    /** A hard hit on ceramic, with a clink. */
    HardCeramicHit,

    /** A crushing hit on ceramic, with a clink. */
    CrushingCeramicHit,

    // Tap counts: two to eleven taps, from a lazy pace to a rapid one

    /** Two taps at a lazy pace, the last strongest. */
    TwoTapsLazy,

    /** Two taps at a slow pace, the last strongest. */
    TwoTapsSlow,

    /** Two taps at a relaxed pace, the last strongest. */
    TwoTapsRelaxed,

    /** Two taps at a easy pace, the last strongest. */
    TwoTapsEasy,

    /** Two taps at a steady pace, the last strongest. */
    TwoTapsSteady,

    /** Two taps at a brisk pace, the last strongest. */
    TwoTapsBrisk,

    /** Two taps at a quick pace, the last strongest. */
    TwoTapsQuick,

    /** Two taps at a fast pace, the last strongest. */
    TwoTapsFast,

    /** Two taps at a rapid pace, the last strongest. */
    TwoTapsRapid,

    /** Three taps at a lazy pace, the last strongest. */
    ThreeTapsLazy,

    /** Three taps at a slow pace, the last strongest. */
    ThreeTapsSlow,

    /** Three taps at a relaxed pace, the last strongest. */
    ThreeTapsRelaxed,

    /** Three taps at a easy pace, the last strongest. */
    ThreeTapsEasy,

    /** Three taps at a steady pace, the last strongest. */
    ThreeTapsSteady,

    /** Three taps at a brisk pace, the last strongest. */
    ThreeTapsBrisk,

    /** Three taps at a quick pace, the last strongest. */
    ThreeTapsQuick,

    /** Three taps at a fast pace, the last strongest. */
    ThreeTapsFast,

    /** Three taps at a rapid pace, the last strongest. */
    ThreeTapsRapid,

    /** Four taps at a lazy pace, the last strongest. */
    FourTapsLazy,

    /** Four taps at a slow pace, the last strongest. */
    FourTapsSlow,

    /** Four taps at a relaxed pace, the last strongest. */
    FourTapsRelaxed,

    /** Four taps at a easy pace, the last strongest. */
    FourTapsEasy,

    /** Four taps at a steady pace, the last strongest. */
    FourTapsSteady,

    /** Four taps at a brisk pace, the last strongest. */
    FourTapsBrisk,

    /** Four taps at a quick pace, the last strongest. */
    FourTapsQuick,

    /** Four taps at a fast pace, the last strongest. */
    FourTapsFast,

    /** Four taps at a rapid pace, the last strongest. */
    FourTapsRapid,

    /** Five taps at a lazy pace, the last strongest. */
    FiveTapsLazy,

    /** Five taps at a slow pace, the last strongest. */
    FiveTapsSlow,

    /** Five taps at a relaxed pace, the last strongest. */
    FiveTapsRelaxed,

    /** Five taps at a easy pace, the last strongest. */
    FiveTapsEasy,

    /** Five taps at a steady pace, the last strongest. */
    FiveTapsSteady,

    /** Five taps at a brisk pace, the last strongest. */
    FiveTapsBrisk,

    /** Five taps at a quick pace, the last strongest. */
    FiveTapsQuick,

    /** Five taps at a fast pace, the last strongest. */
    FiveTapsFast,

    /** Five taps at a rapid pace, the last strongest. */
    FiveTapsRapid,

    /** Six taps at a lazy pace, the last strongest. */
    SixTapsLazy,

    /** Six taps at a slow pace, the last strongest. */
    SixTapsSlow,

    /** Six taps at a relaxed pace, the last strongest. */
    SixTapsRelaxed,

    /** Six taps at a easy pace, the last strongest. */
    SixTapsEasy,

    /** Six taps at a steady pace, the last strongest. */
    SixTapsSteady,

    /** Six taps at a brisk pace, the last strongest. */
    SixTapsBrisk,

    /** Six taps at a quick pace, the last strongest. */
    SixTapsQuick,

    /** Six taps at a fast pace, the last strongest. */
    SixTapsFast,

    /** Six taps at a rapid pace, the last strongest. */
    SixTapsRapid,

    /** Seven taps at a lazy pace, the last strongest. */
    SevenTapsLazy,

    /** Seven taps at a slow pace, the last strongest. */
    SevenTapsSlow,

    /** Seven taps at a relaxed pace, the last strongest. */
    SevenTapsRelaxed,

    /** Seven taps at a easy pace, the last strongest. */
    SevenTapsEasy,

    /** Seven taps at a steady pace, the last strongest. */
    SevenTapsSteady,

    /** Seven taps at a brisk pace, the last strongest. */
    SevenTapsBrisk,

    /** Seven taps at a quick pace, the last strongest. */
    SevenTapsQuick,

    /** Seven taps at a fast pace, the last strongest. */
    SevenTapsFast,

    /** Seven taps at a rapid pace, the last strongest. */
    SevenTapsRapid,

    /** Eight taps at a lazy pace, the last strongest. */
    EightTapsLazy,

    /** Eight taps at a slow pace, the last strongest. */
    EightTapsSlow,

    /** Eight taps at a relaxed pace, the last strongest. */
    EightTapsRelaxed,

    /** Eight taps at a easy pace, the last strongest. */
    EightTapsEasy,

    /** Eight taps at a steady pace, the last strongest. */
    EightTapsSteady,

    /** Eight taps at a brisk pace, the last strongest. */
    EightTapsBrisk,

    /** Eight taps at a quick pace, the last strongest. */
    EightTapsQuick,

    /** Eight taps at a fast pace, the last strongest. */
    EightTapsFast,

    /** Eight taps at a rapid pace, the last strongest. */
    EightTapsRapid,

    /** Nine taps at a lazy pace, the last strongest. */
    NineTapsLazy,

    /** Nine taps at a slow pace, the last strongest. */
    NineTapsSlow,

    /** Nine taps at a relaxed pace, the last strongest. */
    NineTapsRelaxed,

    /** Nine taps at a easy pace, the last strongest. */
    NineTapsEasy,

    /** Nine taps at a steady pace, the last strongest. */
    NineTapsSteady,

    /** Nine taps at a brisk pace, the last strongest. */
    NineTapsBrisk,

    /** Nine taps at a quick pace, the last strongest. */
    NineTapsQuick,

    /** Nine taps at a fast pace, the last strongest. */
    NineTapsFast,

    /** Nine taps at a rapid pace, the last strongest. */
    NineTapsRapid,

    /** Ten taps at a lazy pace, the last strongest. */
    TenTapsLazy,

    /** Ten taps at a slow pace, the last strongest. */
    TenTapsSlow,

    /** Ten taps at a relaxed pace, the last strongest. */
    TenTapsRelaxed,

    /** Ten taps at a easy pace, the last strongest. */
    TenTapsEasy,

    /** Ten taps at a steady pace, the last strongest. */
    TenTapsSteady,

    /** Ten taps at a brisk pace, the last strongest. */
    TenTapsBrisk,

    /** Ten taps at a quick pace, the last strongest. */
    TenTapsQuick,

    /** Ten taps at a fast pace, the last strongest. */
    TenTapsFast,

    /** Ten taps at a rapid pace, the last strongest. */
    TenTapsRapid,

    /** Eleven taps at a lazy pace, the last strongest. */
    ElevenTapsLazy,

    /** Eleven taps at a slow pace, the last strongest. */
    ElevenTapsSlow,

    /** Eleven taps at a relaxed pace, the last strongest. */
    ElevenTapsRelaxed,

    /** Eleven taps at a easy pace, the last strongest. */
    ElevenTapsEasy,

    /** Eleven taps at a steady pace, the last strongest. */
    ElevenTapsSteady,

    /** Eleven taps at a brisk pace, the last strongest. */
    ElevenTapsBrisk,

    /** Eleven taps at a quick pace, the last strongest. */
    ElevenTapsQuick,

    /** Eleven taps at a fast pace, the last strongest. */
    ElevenTapsFast,

    /** Eleven taps at a rapid pace, the last strongest. */
    ElevenTapsRapid,

    // Signals: attention signals, from calm to critical

    /** A crisp ping, once calmly. */
    CalmPing,

    /** A crisp ping, once softly. */
    SoftPing,

    /** A crisp ping, twice gently. */
    GentlePing,

    /** A crisp ping, twice clearly. */
    ClearPing,

    /** A crisp ping, three times firmly. */
    FirmPing,

    /** A crisp ping, three times promptly. */
    PromptPing,

    /** A crisp ping, four times insistently. */
    PressingPing,

    /** A crisp ping, four times urgently. */
    UrgentPing,

    /** A crisp ping, five times with alarm. */
    CriticalPing,

    /** A chime that rings on, once calmly. */
    CalmChime,

    /** A chime that rings on, once softly. */
    SoftChime,

    /** A chime that rings on, twice gently. */
    GentleChime,

    /** A chime that rings on, twice clearly. */
    ClearChime,

    /** A chime that rings on, three times firmly. */
    FirmChime,

    /** A chime that rings on, three times promptly. */
    PromptChime,

    /** A chime that rings on, four times insistently. */
    PressingChime,

    /** A chime that rings on, four times urgently. */
    UrgentChime,

    /** A chime that rings on, five times with alarm. */
    CriticalChime,

    /** A bell that fades, once calmly. */
    CalmBell,

    /** A bell that fades, once softly. */
    SoftBell,

    /** A bell that fades, twice gently. */
    GentleBell,

    /** A bell that fades, twice clearly. */
    ClearBell,

    /** A bell that fades, three times firmly. */
    FirmBell,

    /** A bell that fades, three times promptly. */
    PromptBell,

    /** A bell that fades, four times insistently. */
    PressingBell,

    /** A bell that fades, four times urgently. */
    UrgentBell,

    /** A bell that fades, five times with alarm. */
    CriticalBell,

    /** A short beep, once calmly. */
    CalmBeep,

    /** A short beep, once softly. */
    SoftBeep,

    /** A short beep, twice gently. */
    GentleBeep,

    /** A short beep, twice clearly. */
    ClearBeep,

    /** A short beep, three times firmly. */
    FirmBeep,

    /** A short beep, three times promptly. */
    PromptBeep,

    /** A short beep, four times insistently. */
    PressingBeep,

    /** A short beep, four times urgently. */
    UrgentBeep,

    /** A short beep, five times with alarm. */
    CriticalBeep,

    /** A low buzz, once calmly. */
    CalmBuzz,

    /** A low buzz, once softly. */
    SoftBuzz,

    /** A low buzz, twice gently. */
    GentleBuzz,

    /** A low buzz, twice clearly. */
    ClearBuzz,

    /** A low buzz, three times firmly. */
    FirmBuzz,

    /** A low buzz, three times promptly. */
    PromptBuzz,

    /** A low buzz, four times insistently. */
    PressingBuzz,

    /** A low buzz, four times urgently. */
    UrgentBuzz,

    /** A low buzz, five times with alarm. */
    CriticalBuzz,

    /** A rising two-note ding, once calmly. */
    CalmDing,

    /** A rising two-note ding, once softly. */
    SoftDing,

    /** A rising two-note ding, twice gently. */
    GentleDing,

    /** A rising two-note ding, twice clearly. */
    ClearDing,

    /** A rising two-note ding, three times firmly. */
    FirmDing,

    /** A rising two-note ding, three times promptly. */
    PromptDing,

    /** A rising two-note ding, four times insistently. */
    PressingDing,

    /** A rising two-note ding, four times urgently. */
    UrgentDing,

    /** A rising two-note ding, five times with alarm. */
    CriticalDing,

    /** A quick double pip, once calmly. */
    CalmPip,

    /** A quick double pip, once softly. */
    SoftPip,

    /** A quick double pip, twice gently. */
    GentlePip,

    /** A quick double pip, twice clearly. */
    ClearPip,

    /** A quick double pip, three times firmly. */
    FirmPip,

    /** A quick double pip, three times promptly. */
    PromptPip,

    /** A quick double pip, four times insistently. */
    PressingPip,

    /** A quick double pip, four times urgently. */
    UrgentPip,

    /** A quick double pip, five times with alarm. */
    CriticalPip,

    /** A long, even tone, once calmly. */
    CalmTone,

    /** A long, even tone, once softly. */
    SoftTone,

    /** A long, even tone, twice gently. */
    GentleTone,

    /** A long, even tone, twice clearly. */
    ClearTone,

    /** A long, even tone, three times firmly. */
    FirmTone,

    /** A long, even tone, three times promptly. */
    PromptTone,

    /** A long, even tone, four times insistently. */
    PressingTone,

    /** A long, even tone, four times urgently. */
    UrgentTone,

    /** A long, even tone, five times with alarm. */
    CriticalTone,

    /** A wavering siren, once calmly. */
    CalmSiren,

    /** A wavering siren, once softly. */
    SoftSiren,

    /** A wavering siren, twice gently. */
    GentleSiren,

    /** A wavering siren, twice clearly. */
    ClearSiren,

    /** A wavering siren, three times firmly. */
    FirmSiren,

    /** A wavering siren, three times promptly. */
    PromptSiren,

    /** A wavering siren, four times insistently. */
    PressingSiren,

    /** A wavering siren, four times urgently. */
    UrgentSiren,

    /** A wavering siren, five times with alarm. */
    CriticalSiren,

    /** A two-blast horn, once calmly. */
    CalmHorn,

    /** A two-blast horn, once softly. */
    SoftHorn,

    /** A two-blast horn, twice gently. */
    GentleHorn,

    /** A two-blast horn, twice clearly. */
    ClearHorn,

    /** A two-blast horn, three times firmly. */
    FirmHorn,

    /** A two-blast horn, three times promptly. */
    PromptHorn,

    /** A two-blast horn, four times insistently. */
    PressingHorn,

    /** A two-blast horn, four times urgently. */
    UrgentHorn,

    /** A two-blast horn, five times with alarm. */
    CriticalHorn,

    // Meters: one bar of a meter, from 60 to 180 beats per minute

    /** One bar of march at 60 BPM. */
    MarchLargo,

    /** One bar of march at 75 BPM. */
    MarchLarghetto,

    /** One bar of march at 90 BPM. */
    MarchAdagio,

    /** One bar of march at 105 BPM. */
    MarchAndante,

    /** One bar of march at 120 BPM. */
    MarchModerato,

    /** One bar of march at 135 BPM. */
    MarchAllegretto,

    /** One bar of march at 150 BPM. */
    MarchAllegro,

    /** One bar of march at 165 BPM. */
    MarchVivace,

    /** One bar of march at 180 BPM. */
    MarchPresto,

    /** One bar of waltz at 60 BPM. */
    WaltzLargo,

    /** One bar of waltz at 75 BPM. */
    WaltzLarghetto,

    /** One bar of waltz at 90 BPM. */
    WaltzAdagio,

    /** One bar of waltz at 105 BPM. */
    WaltzAndante,

    /** One bar of waltz at 120 BPM. */
    WaltzModerato,

    /** One bar of waltz at 135 BPM. */
    WaltzAllegretto,

    /** One bar of waltz at 150 BPM. */
    WaltzAllegro,

    /** One bar of waltz at 165 BPM. */
    WaltzVivace,

    /** One bar of waltz at 180 BPM. */
    WaltzPresto,

    /** One bar of four-four at 60 BPM. */
    FourFourLargo,

    /** One bar of four-four at 75 BPM. */
    FourFourLarghetto,

    /** One bar of four-four at 90 BPM. */
    FourFourAdagio,

    /** One bar of four-four at 105 BPM. */
    FourFourAndante,

    /** One bar of four-four at 120 BPM. */
    FourFourModerato,

    /** One bar of four-four at 135 BPM. */
    FourFourAllegretto,

    /** One bar of four-four at 150 BPM. */
    FourFourAllegro,

    /** One bar of four-four at 165 BPM. */
    FourFourVivace,

    /** One bar of four-four at 180 BPM. */
    FourFourPresto,

    /** One bar of five-four at 60 BPM. */
    FiveFourLargo,

    /** One bar of five-four at 75 BPM. */
    FiveFourLarghetto,

    /** One bar of five-four at 90 BPM. */
    FiveFourAdagio,

    /** One bar of five-four at 105 BPM. */
    FiveFourAndante,

    /** One bar of five-four at 120 BPM. */
    FiveFourModerato,

    /** One bar of five-four at 135 BPM. */
    FiveFourAllegretto,

    /** One bar of five-four at 150 BPM. */
    FiveFourAllegro,

    /** One bar of five-four at 165 BPM. */
    FiveFourVivace,

    /** One bar of five-four at 180 BPM. */
    FiveFourPresto,

    /** One bar of jig at 60 BPM. */
    JigLargo,

    /** One bar of jig at 75 BPM. */
    JigLarghetto,

    /** One bar of jig at 90 BPM. */
    JigAdagio,

    /** One bar of jig at 105 BPM. */
    JigAndante,

    /** One bar of jig at 120 BPM. */
    JigModerato,

    /** One bar of jig at 135 BPM. */
    JigAllegretto,

    /** One bar of jig at 150 BPM. */
    JigAllegro,

    /** One bar of jig at 165 BPM. */
    JigVivace,

    /** One bar of jig at 180 BPM. */
    JigPresto,

    /** One bar of seven-eight at 60 BPM. */
    SevenEightLargo,

    /** One bar of seven-eight at 75 BPM. */
    SevenEightLarghetto,

    /** One bar of seven-eight at 90 BPM. */
    SevenEightAdagio,

    /** One bar of seven-eight at 105 BPM. */
    SevenEightAndante,

    /** One bar of seven-eight at 120 BPM. */
    SevenEightModerato,

    /** One bar of seven-eight at 135 BPM. */
    SevenEightAllegretto,

    /** One bar of seven-eight at 150 BPM. */
    SevenEightAllegro,

    /** One bar of seven-eight at 165 BPM. */
    SevenEightVivace,

    /** One bar of seven-eight at 180 BPM. */
    SevenEightPresto,

    /** One bar of swing at 60 BPM. */
    SwingLargo,

    /** One bar of swing at 75 BPM. */
    SwingLarghetto,

    /** One bar of swing at 90 BPM. */
    SwingAdagio,

    /** One bar of swing at 105 BPM. */
    SwingAndante,

    /** One bar of swing at 120 BPM. */
    SwingModerato,

    /** One bar of swing at 135 BPM. */
    SwingAllegretto,

    /** One bar of swing at 150 BPM. */
    SwingAllegro,

    /** One bar of swing at 165 BPM. */
    SwingVivace,

    /** One bar of swing at 180 BPM. */
    SwingPresto,

    /** One bar of shuffle at 60 BPM. */
    ShuffleLargo,

    /** One bar of shuffle at 75 BPM. */
    ShuffleLarghetto,

    /** One bar of shuffle at 90 BPM. */
    ShuffleAdagio,

    /** One bar of shuffle at 105 BPM. */
    ShuffleAndante,

    /** One bar of shuffle at 120 BPM. */
    ShuffleModerato,

    /** One bar of shuffle at 135 BPM. */
    ShuffleAllegretto,

    /** One bar of shuffle at 150 BPM. */
    ShuffleAllegro,

    /** One bar of shuffle at 165 BPM. */
    ShuffleVivace,

    /** One bar of shuffle at 180 BPM. */
    ShufflePresto,

    /** One bar of son clave at 60 BPM. */
    ClaveLargo,

    /** One bar of son clave at 75 BPM. */
    ClaveLarghetto,

    /** One bar of son clave at 90 BPM. */
    ClaveAdagio,

    /** One bar of son clave at 105 BPM. */
    ClaveAndante,

    /** One bar of son clave at 120 BPM. */
    ClaveModerato,

    /** One bar of son clave at 135 BPM. */
    ClaveAllegretto,

    /** One bar of son clave at 150 BPM. */
    ClaveAllegro,

    /** One bar of son clave at 165 BPM. */
    ClaveVivace,

    /** One bar of son clave at 180 BPM. */
    ClavePresto,

    /** One bar of bossa nova at 60 BPM. */
    BossaNovaLargo,

    /** One bar of bossa nova at 75 BPM. */
    BossaNovaLarghetto,

    /** One bar of bossa nova at 90 BPM. */
    BossaNovaAdagio,

    /** One bar of bossa nova at 105 BPM. */
    BossaNovaAndante,

    /** One bar of bossa nova at 120 BPM. */
    BossaNovaModerato,

    /** One bar of bossa nova at 135 BPM. */
    BossaNovaAllegretto,

    /** One bar of bossa nova at 150 BPM. */
    BossaNovaAllegro,

    /** One bar of bossa nova at 165 BPM. */
    BossaNovaVivace,

    /** One bar of bossa nova at 180 BPM. */
    BossaNovaPresto,

    // Surfaces: a finger drawn across a surface, from a crawl to a rush

    /** A finger across sand, barely moving. */
    CrawlOverSand,

    /** A finger across sand, creeping. */
    CreepOverSand,

    /** A finger across sand, drifting. */
    DriftOverSand,

    /** A finger across sand, at a stroll. */
    StrollOverSand,

    /** A finger across sand, at a walk. */
    WalkOverSand,

    /** A finger across sand, jogging. */
    JogOverSand,

    /** A finger across sand, running. */
    RunOverSand,

    /** A finger across sand, sprinting. */
    SprintOverSand,

    /** A finger across sand, in a rush. */
    RushOverSand,

    /** A finger across gravel, barely moving. */
    CrawlOverGravel,

    /** A finger across gravel, creeping. */
    CreepOverGravel,

    /** A finger across gravel, drifting. */
    DriftOverGravel,

    /** A finger across gravel, at a stroll. */
    StrollOverGravel,

    /** A finger across gravel, at a walk. */
    WalkOverGravel,

    /** A finger across gravel, jogging. */
    JogOverGravel,

    /** A finger across gravel, running. */
    RunOverGravel,

    /** A finger across gravel, sprinting. */
    SprintOverGravel,

    /** A finger across gravel, in a rush. */
    RushOverGravel,

    /** A finger across silk, barely moving. */
    CrawlOverSilk,

    /** A finger across silk, creeping. */
    CreepOverSilk,

    /** A finger across silk, drifting. */
    DriftOverSilk,

    /** A finger across silk, at a stroll. */
    StrollOverSilk,

    /** A finger across silk, at a walk. */
    WalkOverSilk,

    /** A finger across silk, jogging. */
    JogOverSilk,

    /** A finger across silk, running. */
    RunOverSilk,

    /** A finger across silk, sprinting. */
    SprintOverSilk,

    /** A finger across silk, in a rush. */
    RushOverSilk,

    /** A finger across velvet, barely moving. */
    CrawlOverVelvet,

    /** A finger across velvet, creeping. */
    CreepOverVelvet,

    /** A finger across velvet, drifting. */
    DriftOverVelvet,

    /** A finger across velvet, at a stroll. */
    StrollOverVelvet,

    /** A finger across velvet, at a walk. */
    WalkOverVelvet,

    /** A finger across velvet, jogging. */
    JogOverVelvet,

    /** A finger across velvet, running. */
    RunOverVelvet,

    /** A finger across velvet, sprinting. */
    SprintOverVelvet,

    /** A finger across velvet, in a rush. */
    RushOverVelvet,

    /** A finger across corduroy, barely moving. */
    CrawlOverCorduroy,

    /** A finger across corduroy, creeping. */
    CreepOverCorduroy,

    /** A finger across corduroy, drifting. */
    DriftOverCorduroy,

    /** A finger across corduroy, at a stroll. */
    StrollOverCorduroy,

    /** A finger across corduroy, at a walk. */
    WalkOverCorduroy,

    /** A finger across corduroy, jogging. */
    JogOverCorduroy,

    /** A finger across corduroy, running. */
    RunOverCorduroy,

    /** A finger across corduroy, sprinting. */
    SprintOverCorduroy,

    /** A finger across corduroy, in a rush. */
    RushOverCorduroy,

    /** A finger across brick, barely moving. */
    CrawlOverBrick,

    /** A finger across brick, creeping. */
    CreepOverBrick,

    /** A finger across brick, drifting. */
    DriftOverBrick,

    /** A finger across brick, at a stroll. */
    StrollOverBrick,

    /** A finger across brick, at a walk. */
    WalkOverBrick,

    /** A finger across brick, jogging. */
    JogOverBrick,

    /** A finger across brick, running. */
    RunOverBrick,

    /** A finger across brick, sprinting. */
    SprintOverBrick,

    /** A finger across brick, in a rush. */
    RushOverBrick,

    /** A finger across tile, barely moving. */
    CrawlOverTile,

    /** A finger across tile, creeping. */
    CreepOverTile,

    /** A finger across tile, drifting. */
    DriftOverTile,

    /** A finger across tile, at a stroll. */
    StrollOverTile,

    /** A finger across tile, at a walk. */
    WalkOverTile,

    /** A finger across tile, jogging. */
    JogOverTile,

    /** A finger across tile, running. */
    RunOverTile,

    /** A finger across tile, sprinting. */
    SprintOverTile,

    /** A finger across tile, in a rush. */
    RushOverTile,

    /** A finger across ice, barely moving. */
    CrawlOverIce,

    /** A finger across ice, creeping. */
    CreepOverIce,

    /** A finger across ice, drifting. */
    DriftOverIce,

    /** A finger across ice, at a stroll. */
    StrollOverIce,

    /** A finger across ice, at a walk. */
    WalkOverIce,

    /** A finger across ice, jogging. */
    JogOverIce,

    /** A finger across ice, running. */
    RunOverIce,

    /** A finger across ice, sprinting. */
    SprintOverIce,

    /** A finger across ice, in a rush. */
    RushOverIce,

    /** A finger across bark, barely moving. */
    CrawlOverBark,

    /** A finger across bark, creeping. */
    CreepOverBark,

    /** A finger across bark, drifting. */
    DriftOverBark,

    /** A finger across bark, at a stroll. */
    StrollOverBark,

    /** A finger across bark, at a walk. */
    WalkOverBark,

    /** A finger across bark, jogging. */
    JogOverBark,

    /** A finger across bark, running. */
    RunOverBark,

    /** A finger across bark, sprinting. */
    SprintOverBark,

    /** A finger across bark, in a rush. */
    RushOverBark,

    /** A finger across carpet, barely moving. */
    CrawlOverCarpet,

    /** A finger across carpet, creeping. */
    CreepOverCarpet,

    /** A finger across carpet, drifting. */
    DriftOverCarpet,

    /** A finger across carpet, at a stroll. */
    StrollOverCarpet,

    /** A finger across carpet, at a walk. */
    WalkOverCarpet,

    /** A finger across carpet, jogging. */
    JogOverCarpet,

    /** A finger across carpet, running. */
    RunOverCarpet,

    /** A finger across carpet, sprinting. */
    SprintOverCarpet,

    /** A finger across carpet, in a rush. */
    RushOverCarpet,

    // Waves: waveforms over a second and a half, from one cycle to five

    /** Swelling and easing smoothly, once. */
    GlacialSwell,

    /** Swelling and easing smoothly, one and a half times. */
    LanguidSwell,

    /** Swelling and easing smoothly, twice. */
    SlowSwell,

    /** Swelling and easing smoothly, two and a half times. */
    EasySwell,

    /** Swelling and easing smoothly, three times. */
    ModerateSwell,

    /** Swelling and easing smoothly, three and a half times. */
    LivelySwell,

    /** Swelling and easing smoothly, four times. */
    FastSwell,

    /** Swelling and easing smoothly, four and a half times. */
    RapidSwell,

    /** Swelling and easing smoothly, five times. */
    FranticSwell,

    /** Rising, then dropping back, once. */
    GlacialRise,

    /** Rising, then dropping back, one and a half times. */
    LanguidRise,

    /** Rising, then dropping back, twice. */
    SlowRise,

    /** Rising, then dropping back, two and a half times. */
    EasyRise,

    /** Rising, then dropping back, three times. */
    ModerateRise,

    /** Rising, then dropping back, three and a half times. */
    LivelyRise,

    /** Rising, then dropping back, four times. */
    FastRise,

    /** Rising, then dropping back, four and a half times. */
    RapidRise,

    /** Rising, then dropping back, five times. */
    FranticRise,

    /** Falling, then jumping back, once. */
    GlacialFall,

    /** Falling, then jumping back, one and a half times. */
    LanguidFall,

    /** Falling, then jumping back, twice. */
    SlowFall,

    /** Falling, then jumping back, two and a half times. */
    EasyFall,

    /** Falling, then jumping back, three times. */
    ModerateFall,

    /** Falling, then jumping back, three and a half times. */
    LivelyFall,

    /** Falling, then jumping back, four times. */
    FastFall,

    /** Falling, then jumping back, four and a half times. */
    RapidFall,

    /** Falling, then jumping back, five times. */
    FranticFall,

    /** Switching hard on and off, once. */
    GlacialSquare,

    /** Switching hard on and off, one and a half times. */
    LanguidSquare,

    /** Switching hard on and off, twice. */
    SlowSquare,

    /** Switching hard on and off, two and a half times. */
    EasySquare,

    /** Switching hard on and off, three times. */
    ModerateSquare,

    /** Switching hard on and off, three and a half times. */
    LivelySquare,

    /** Switching hard on and off, four times. */
    FastSquare,

    /** Switching hard on and off, four and a half times. */
    RapidSquare,

    /** Switching hard on and off, five times. */
    FranticSquare,

    /** Rising and falling evenly, once. */
    GlacialTriangle,

    /** Rising and falling evenly, one and a half times. */
    LanguidTriangle,

    /** Rising and falling evenly, twice. */
    SlowTriangle,

    /** Rising and falling evenly, two and a half times. */
    EasyTriangle,

    /** Rising and falling evenly, three times. */
    ModerateTriangle,

    /** Rising and falling evenly, three and a half times. */
    LivelyTriangle,

    /** Rising and falling evenly, four times. */
    FastTriangle,

    /** Rising and falling evenly, four and a half times. */
    RapidTriangle,

    /** Rising and falling evenly, five times. */
    FranticTriangle,

    /** Flickering crisp and soft, once. */
    GlacialFlutter,

    /** Flickering crisp and soft, one and a half times. */
    LanguidFlutter,

    /** Flickering crisp and soft, twice. */
    SlowFlutter,

    /** Flickering crisp and soft, two and a half times. */
    EasyFlutter,

    /** Flickering crisp and soft, three times. */
    ModerateFlutter,

    /** Flickering crisp and soft, three and a half times. */
    LivelyFlutter,

    /** Flickering crisp and soft, four times. */
    FastFlutter,

    /** Flickering crisp and soft, four and a half times. */
    RapidFlutter,

    /** Flickering crisp and soft, five times. */
    FranticFlutter,

    /** Peaking in sharp throbs, once. */
    GlacialThrob,

    /** Peaking in sharp throbs, one and a half times. */
    LanguidThrob,

    /** Peaking in sharp throbs, twice. */
    SlowThrob,

    /** Peaking in sharp throbs, two and a half times. */
    EasyThrob,

    /** Peaking in sharp throbs, three times. */
    ModerateThrob,

    /** Peaking in sharp throbs, three and a half times. */
    LivelyThrob,

    /** Peaking in sharp throbs, four times. */
    FastThrob,

    /** Peaking in sharp throbs, four and a half times. */
    RapidThrob,

    /** Peaking in sharp throbs, five times. */
    FranticThrob,

    /** Breathing softly in and out, once. */
    GlacialBreath,

    /** Breathing softly in and out, one and a half times. */
    LanguidBreath,

    /** Breathing softly in and out, twice. */
    SlowBreath,

    /** Breathing softly in and out, two and a half times. */
    EasyBreath,

    /** Breathing softly in and out, three times. */
    ModerateBreath,

    /** Breathing softly in and out, three and a half times. */
    LivelyBreath,

    /** Breathing softly in and out, four times. */
    FastBreath,

    /** Breathing softly in and out, four and a half times. */
    RapidBreath,

    /** Breathing softly in and out, five times. */
    FranticBreath,

    /** Rippling as it fades, once. */
    GlacialRipple,

    /** Rippling as it fades, one and a half times. */
    LanguidRipple,

    /** Rippling as it fades, twice. */
    SlowRipple,

    /** Rippling as it fades, two and a half times. */
    EasyRipple,

    /** Rippling as it fades, three times. */
    ModerateRipple,

    /** Rippling as it fades, three and a half times. */
    LivelyRipple,

    /** Rippling as it fades, four times. */
    FastRipple,

    /** Rippling as it fades, four and a half times. */
    RapidRipple,

    /** Rippling as it fades, five times. */
    FranticRipple,

    /** Wavering in sharpness, once. */
    GlacialWobble,

    /** Wavering in sharpness, one and a half times. */
    LanguidWobble,

    /** Wavering in sharpness, twice. */
    SlowWobble,

    /** Wavering in sharpness, two and a half times. */
    EasyWobble,

    /** Wavering in sharpness, three times. */
    ModerateWobble,

    /** Wavering in sharpness, three and a half times. */
    LivelyWobble,

    /** Wavering in sharpness, four times. */
    FastWobble,

    /** Wavering in sharpness, four and a half times. */
    RapidWobble,

    /** Wavering in sharpness, five times. */
    FranticWobble,

    // Dynamics: changes in strength or sharpness, from 0.2 to 1.8 seconds long

    /** Growing steadily stronger over 0.2 s. */
    FlashCrescendo,

    /** Growing steadily stronger over 0.4 s. */
    QuickCrescendo,

    /** Growing steadily stronger over 0.6 s. */
    ShortCrescendo,

    /** Growing steadily stronger over 0.8 s. */
    MeasuredCrescendo,

    /** Growing steadily stronger over 1.0 s. */
    MediumCrescendo,

    /** Growing steadily stronger over 1.2 s. */
    LongCrescendo,

    /** Growing steadily stronger over 1.4 s. */
    ExtendedCrescendo,

    /** Growing steadily stronger over 1.6 s. */
    SlowCrescendo,

    /** Growing steadily stronger over 1.8 s. */
    SustainedCrescendo,

    /** Fading steadily weaker over 0.2 s. */
    FlashDecrescendo,

    /** Fading steadily weaker over 0.4 s. */
    QuickDecrescendo,

    /** Fading steadily weaker over 0.6 s. */
    ShortDecrescendo,

    /** Fading steadily weaker over 0.8 s. */
    MeasuredDecrescendo,

    /** Fading steadily weaker over 1.0 s. */
    MediumDecrescendo,

    /** Fading steadily weaker over 1.2 s. */
    LongDecrescendo,

    /** Fading steadily weaker over 1.4 s. */
    ExtendedDecrescendo,

    /** Fading steadily weaker over 1.6 s. */
    SlowDecrescendo,

    /** Fading steadily weaker over 1.8 s. */
    SustainedDecrescendo,

    /** A quick rise and a slow fall over 0.2 s. */
    FlashSurge,

    /** A quick rise and a slow fall over 0.4 s. */
    QuickSurge,

    /** A quick rise and a slow fall over 0.6 s. */
    ShortSurge,

    /** A quick rise and a slow fall over 0.8 s. */
    MeasuredSurge,

    /** A quick rise and a slow fall over 1.0 s. */
    MediumSurge,

    /** A quick rise and a slow fall over 1.2 s. */
    LongSurge,

    /** A quick rise and a slow fall over 1.4 s. */
    ExtendedSurge,

    /** A quick rise and a slow fall over 1.6 s. */
    SlowSurge,

    /** A quick rise and a slow fall over 1.8 s. */
    SustainedSurge,

    /** A slow fall and a small return over 0.2 s. */
    FlashEbb,

    /** A slow fall and a small return over 0.4 s. */
    QuickEbb,

    /** A slow fall and a small return over 0.6 s. */
    ShortEbb,

    /** A slow fall and a small return over 0.8 s. */
    MeasuredEbb,

    /** A slow fall and a small return over 1.0 s. */
    MediumEbb,

    /** A slow fall and a small return over 1.2 s. */
    LongEbb,

    /** A slow fall and a small return over 1.4 s. */
    ExtendedEbb,

    /** A slow fall and a small return over 1.6 s. */
    SlowEbb,

    /** A slow fall and a small return over 1.8 s. */
    SustainedEbb,

    /** Taps climbing in strength over 0.2 s. */
    FlashClimb,

    /** Taps climbing in strength over 0.4 s. */
    QuickClimb,

    /** Taps climbing in strength over 0.6 s. */
    ShortClimb,

    /** Taps climbing in strength over 0.8 s. */
    MeasuredClimb,

    /** Taps climbing in strength over 1.0 s. */
    MediumClimb,

    /** Taps climbing in strength over 1.2 s. */
    LongClimb,

    /** Taps climbing in strength over 1.4 s. */
    ExtendedClimb,

    /** Taps climbing in strength over 1.6 s. */
    SlowClimb,

    /** Taps climbing in strength over 1.8 s. */
    SustainedClimb,

    /** Taps dropping in strength over 0.2 s. */
    FlashPlunge,

    /** Taps dropping in strength over 0.4 s. */
    QuickPlunge,

    /** Taps dropping in strength over 0.6 s. */
    ShortPlunge,

    /** Taps dropping in strength over 0.8 s. */
    MeasuredPlunge,

    /** Taps dropping in strength over 1.0 s. */
    MediumPlunge,

    /** Taps dropping in strength over 1.2 s. */
    LongPlunge,

    /** Taps dropping in strength over 1.4 s. */
    ExtendedPlunge,

    /** Taps dropping in strength over 1.6 s. */
    SlowPlunge,

    /** Taps dropping in strength over 1.8 s. */
    SustainedPlunge,

    /** Steady, growing sharper over 0.2 s. */
    FlashBloom,

    /** Steady, growing sharper over 0.4 s. */
    QuickBloom,

    /** Steady, growing sharper over 0.6 s. */
    ShortBloom,

    /** Steady, growing sharper over 0.8 s. */
    MeasuredBloom,

    /** Steady, growing sharper over 1.0 s. */
    MediumBloom,

    /** Steady, growing sharper over 1.2 s. */
    LongBloom,

    /** Steady, growing sharper over 1.4 s. */
    ExtendedBloom,

    /** Steady, growing sharper over 1.6 s. */
    SlowBloom,

    /** Steady, growing sharper over 1.8 s. */
    SustainedBloom,

    /** Softening and dulling over 0.2 s. */
    FlashWilt,

    /** Softening and dulling over 0.4 s. */
    QuickWilt,

    /** Softening and dulling over 0.6 s. */
    ShortWilt,

    /** Softening and dulling over 0.8 s. */
    MeasuredWilt,

    /** Softening and dulling over 1.0 s. */
    MediumWilt,

    /** Softening and dulling over 1.2 s. */
    LongWilt,

    /** Softening and dulling over 1.4 s. */
    ExtendedWilt,

    /** Softening and dulling over 1.6 s. */
    SlowWilt,

    /** Softening and dulling over 1.8 s. */
    SustainedWilt,

    /** A sharp peak, then a low hum over 0.2 s. */
    FlashSpike,

    /** A sharp peak, then a low hum over 0.4 s. */
    QuickSpike,

    /** A sharp peak, then a low hum over 0.6 s. */
    ShortSpike,

    /** A sharp peak, then a low hum over 0.8 s. */
    MeasuredSpike,

    /** A sharp peak, then a low hum over 1.0 s. */
    MediumSpike,

    /** A sharp peak, then a low hum over 1.2 s. */
    LongSpike,

    /** A sharp peak, then a low hum over 1.4 s. */
    ExtendedSpike,

    /** A sharp peak, then a low hum over 1.6 s. */
    SlowSpike,

    /** A sharp peak, then a low hum over 1.8 s. */
    SustainedSpike,

    /** Rising, holding, then falling over 0.2 s. */
    FlashPlateau,

    /** Rising, holding, then falling over 0.4 s. */
    QuickPlateau,

    /** Rising, holding, then falling over 0.6 s. */
    ShortPlateau,

    /** Rising, holding, then falling over 0.8 s. */
    MeasuredPlateau,

    /** Rising, holding, then falling over 1.0 s. */
    MediumPlateau,

    /** Rising, holding, then falling over 1.2 s. */
    LongPlateau,

    /** Rising, holding, then falling over 1.4 s. */
    ExtendedPlateau,

    /** Rising, holding, then falling over 1.6 s. */
    SlowPlateau,

    /** Rising, holding, then falling over 1.8 s. */
    SustainedPlateau,

    // Weather: weather and water, from faint to extreme

    /** Fine, scattered drops, faint. */
    FaintDrizzle,

    /** Fine, scattered drops, light. */
    LightDrizzle,

    /** Fine, scattered drops, gentle. */
    GentleDrizzle,

    /** Fine, scattered drops, moderate. */
    ModerateDrizzle,

    /** Fine, scattered drops, steady. */
    SteadyDrizzle,

    /** Fine, scattered drops, strong. */
    StrongDrizzle,

    /** Fine, scattered drops, heavy. */
    HeavyDrizzle,

    /** Fine, scattered drops, intense. */
    IntenseDrizzle,

    /** Fine, scattered drops, extreme. */
    ExtremeDrizzle,

    /** Drops falling at random, faint. */
    FaintRain,

    /** Drops falling at random, light. */
    LightRain,

    /** Drops falling at random, gentle. */
    GentleRain,

    /** Drops falling at random, moderate. */
    ModerateRain,

    /** Drops falling at random, steady. */
    SteadyRain,

    /** Drops falling at random, strong. */
    StrongRain,

    /** Drops falling at random, heavy. */
    HeavyRain,

    /** Drops falling at random, intense. */
    IntenseRain,

    /** Drops falling at random, extreme. */
    ExtremeRain,

    /** Hard, sharp pellets, faint. */
    FaintHail,

    /** Hard, sharp pellets, light. */
    LightHail,

    /** Hard, sharp pellets, gentle. */
    GentleHail,

    /** Hard, sharp pellets, moderate. */
    ModerateHail,

    /** Hard, sharp pellets, steady. */
    SteadyHail,

    /** Hard, sharp pellets, strong. */
    StrongHail,

    /** Hard, sharp pellets, heavy. */
    HeavyHail,

    /** Hard, sharp pellets, intense. */
    IntenseHail,

    /** Hard, sharp pellets, extreme. */
    ExtremeHail,

    /** Gusts rising and falling, faint. */
    FaintWind,

    /** Gusts rising and falling, light. */
    LightWind,

    /** Gusts rising and falling, gentle. */
    GentleWind,

    /** Gusts rising and falling, moderate. */
    ModerateWind,

    /** Gusts rising and falling, steady. */
    SteadyWind,

    /** Gusts rising and falling, strong. */
    StrongWind,

    /** Gusts rising and falling, heavy. */
    HeavyWind,

    /** Gusts rising and falling, intense. */
    IntenseWind,

    /** Gusts rising and falling, extreme. */
    ExtremeWind,

    /** A crack, then a rolling rumble, faint. */
    FaintThunder,

    /** A crack, then a rolling rumble, light. */
    LightThunder,

    /** A crack, then a rolling rumble, gentle. */
    GentleThunder,

    /** A crack, then a rolling rumble, moderate. */
    ModerateThunder,

    /** A crack, then a rolling rumble, steady. */
    SteadyThunder,

    /** A crack, then a rolling rumble, strong. */
    StrongThunder,

    /** A crack, then a rolling rumble, heavy. */
    HeavyThunder,

    /** A crack, then a rolling rumble, intense. */
    IntenseThunder,

    /** A crack, then a rolling rumble, extreme. */
    ExtremeThunder,

    /** Waves rolling in, faint. */
    FaintSurf,

    /** Waves rolling in, light. */
    LightSurf,

    /** Waves rolling in, gentle. */
    GentleSurf,

    /** Waves rolling in, moderate. */
    ModerateSurf,

    /** Waves rolling in, steady. */
    SteadySurf,

    /** Waves rolling in, strong. */
    StrongSurf,

    /** Waves rolling in, heavy. */
    HeavySurf,

    /** Waves rolling in, intense. */
    IntenseSurf,

    /** Waves rolling in, extreme. */
    ExtremeSurf,

    /** Water running over stones, faint. */
    FaintStream,

    /** Water running over stones, light. */
    LightStream,

    /** Water running over stones, gentle. */
    GentleStream,

    /** Water running over stones, moderate. */
    ModerateStream,

    /** Water running over stones, steady. */
    SteadyStream,

    /** Water running over stones, strong. */
    StrongStream,

    /** Water running over stones, heavy. */
    HeavyStream,

    /** Water running over stones, intense. */
    IntenseStream,

    /** Water running over stones, extreme. */
    ExtremeStream,

    /** The ground shaking, faint. */
    FaintTremor,

    /** The ground shaking, light. */
    LightTremor,

    /** The ground shaking, gentle. */
    GentleTremor,

    /** The ground shaking, moderate. */
    ModerateTremor,

    /** The ground shaking, steady. */
    SteadyTremor,

    /** The ground shaking, strong. */
    StrongTremor,

    /** The ground shaking, heavy. */
    HeavyTremor,

    /** The ground shaking, intense. */
    IntenseTremor,

    /** The ground shaking, extreme. */
    ExtremeTremor,

    /** A crackling fire, faint. */
    FaintFire,

    /** A crackling fire, light. */
    LightFire,

    /** A crackling fire, gentle. */
    GentleFire,

    /** A crackling fire, moderate. */
    ModerateFire,

    /** A crackling fire, steady. */
    SteadyFire,

    /** A crackling fire, strong. */
    StrongFire,

    /** A crackling fire, heavy. */
    HeavyFire,

    /** A crackling fire, intense. */
    IntenseFire,

    /** A crackling fire, extreme. */
    ExtremeFire,

    /** Icy drops in a cold hiss, faint. */
    FaintSleet,

    /** Icy drops in a cold hiss, light. */
    LightSleet,

    /** Icy drops in a cold hiss, gentle. */
    GentleSleet,

    /** Icy drops in a cold hiss, moderate. */
    ModerateSleet,

    /** Icy drops in a cold hiss, steady. */
    SteadySleet,

    /** Icy drops in a cold hiss, strong. */
    StrongSleet,

    /** Icy drops in a cold hiss, heavy. */
    HeavySleet,

    /** Icy drops in a cold hiss, intense. */
    IntenseSleet,

    /** Icy drops in a cold hiss, extreme. */
    ExtremeSleet,

    // Machines: machines running, from idle to the redline

    /** A humming motor, at idle. */
    IdleMotor,

    /** A humming motor, turning slowly. */
    LowMotor,

    /** A humming motor, at an easy pace. */
    EasyMotor,

    /** A humming motor, cruising. */
    CruisingMotor,

    /** A humming motor, running steadily. */
    SteadyMotor,

    /** A humming motor, working hard. */
    BusyMotor,

    /** A humming motor, at high speed. */
    HighMotor,

    /** A humming motor, racing. */
    RacingMotor,

    /** A humming motor, at the redline. */
    RedlineMotor,

    /** An engine's firing strokes, at idle. */
    IdleEngine,

    /** An engine's firing strokes, turning slowly. */
    LowEngine,

    /** An engine's firing strokes, at an easy pace. */
    EasyEngine,

    /** An engine's firing strokes, cruising. */
    CruisingEngine,

    /** An engine's firing strokes, running steadily. */
    SteadyEngine,

    /** An engine's firing strokes, working hard. */
    BusyEngine,

    /** An engine's firing strokes, at high speed. */
    HighEngine,

    /** An engine's firing strokes, racing. */
    RacingEngine,

    /** An engine's firing strokes, at the redline. */
    RedlineEngine,

    /** Fan blades sweeping past, at idle. */
    IdleFan,

    /** Fan blades sweeping past, turning slowly. */
    LowFan,

    /** Fan blades sweeping past, at an easy pace. */
    EasyFan,

    /** Fan blades sweeping past, cruising. */
    CruisingFan,

    /** Fan blades sweeping past, running steadily. */
    SteadyFan,

    /** Fan blades sweeping past, working hard. */
    BusyFan,

    /** Fan blades sweeping past, at high speed. */
    HighFan,

    /** Fan blades sweeping past, racing. */
    RacingFan,

    /** Fan blades sweeping past, at the redline. */
    RedlineFan,

    /** A drill bit spinning, at idle. */
    IdleDrill,

    /** A drill bit spinning, turning slowly. */
    LowDrill,

    /** A drill bit spinning, at an easy pace. */
    EasyDrill,

    /** A drill bit spinning, cruising. */
    CruisingDrill,

    /** A drill bit spinning, running steadily. */
    SteadyDrill,

    /** A drill bit spinning, working hard. */
    BusyDrill,

    /** A drill bit spinning, at high speed. */
    HighDrill,

    /** A drill bit spinning, racing. */
    RacingDrill,

    /** A drill bit spinning, at the redline. */
    RedlineDrill,

    /** A pump pushing and releasing, at idle. */
    IdlePump,

    /** A pump pushing and releasing, turning slowly. */
    LowPump,

    /** A pump pushing and releasing, at an easy pace. */
    EasyPump,

    /** A pump pushing and releasing, cruising. */
    CruisingPump,

    /** A pump pushing and releasing, running steadily. */
    SteadyPump,

    /** A pump pushing and releasing, working hard. */
    BusyPump,

    /** A pump pushing and releasing, at high speed. */
    HighPump,

    /** A pump pushing and releasing, racing. */
    RacingPump,

    /** A pump pushing and releasing, at the redline. */
    RedlinePump,

    /** A saw rasping back and forth, at idle. */
    IdleSaw,

    /** A saw rasping back and forth, turning slowly. */
    LowSaw,

    /** A saw rasping back and forth, at an easy pace. */
    EasySaw,

    /** A saw rasping back and forth, cruising. */
    CruisingSaw,

    /** A saw rasping back and forth, running steadily. */
    SteadySaw,

    /** A saw rasping back and forth, working hard. */
    BusySaw,

    /** A saw rasping back and forth, at high speed. */
    HighSaw,

    /** A saw rasping back and forth, racing. */
    RacingSaw,

    /** A saw rasping back and forth, at the redline. */
    RedlineSaw,

    /** Gears meshing, at idle. */
    IdleGearbox,

    /** Gears meshing, turning slowly. */
    LowGearbox,

    /** Gears meshing, at an easy pace. */
    EasyGearbox,

    /** Gears meshing, cruising. */
    CruisingGearbox,

    /** Gears meshing, running steadily. */
    SteadyGearbox,

    /** Gears meshing, working hard. */
    BusyGearbox,

    /** Gears meshing, at high speed. */
    HighGearbox,

    /** Gears meshing, racing. */
    RacingGearbox,

    /** Gears meshing, at the redline. */
    RedlineGearbox,

    /** A ratchet clicking, at idle. */
    IdleRatchet,

    /** A ratchet clicking, turning slowly. */
    LowRatchet,

    /** A ratchet clicking, at an easy pace. */
    EasyRatchet,

    /** A ratchet clicking, cruising. */
    CruisingRatchet,

    /** A ratchet clicking, running steadily. */
    SteadyRatchet,

    /** A ratchet clicking, working hard. */
    BusyRatchet,

    /** A ratchet clicking, at high speed. */
    HighRatchet,

    /** A ratchet clicking, racing. */
    RacingRatchet,

    /** A ratchet clicking, at the redline. */
    RedlineRatchet,

    /** Clockwork ticking, at idle. */
    IdleClockwork,

    /** Clockwork ticking, turning slowly. */
    LowClockwork,

    /** Clockwork ticking, at an easy pace. */
    EasyClockwork,

    /** Clockwork ticking, cruising. */
    CruisingClockwork,

    /** Clockwork ticking, running steadily. */
    SteadyClockwork,

    /** Clockwork ticking, working hard. */
    BusyClockwork,

    /** Clockwork ticking, at high speed. */
    HighClockwork,

    /** Clockwork ticking, racing. */
    RacingClockwork,

    /** Clockwork ticking, at the redline. */
    RedlineClockwork,

    /** A needle stitching, at idle. */
    IdleSewingMachine,

    /** A needle stitching, turning slowly. */
    LowSewingMachine,

    /** A needle stitching, at an easy pace. */
    EasySewingMachine,

    /** A needle stitching, cruising. */
    CruisingSewingMachine,

    /** A needle stitching, running steadily. */
    SteadySewingMachine,

    /** A needle stitching, working hard. */
    BusySewingMachine,

    /** A needle stitching, at high speed. */
    HighSewingMachine,

    /** A needle stitching, racing. */
    RacingSewingMachine,

    /** A needle stitching, at the redline. */
    RedlineSewingMachine,

    // Arcade: game actions, from tiny to epic

    /** A push upward, tiny. */
    TinyJump,

    /** A push upward, small. */
    SmallJump,

    /** A push upward, light. */
    LightJump,

    /** A push upward, medium. */
    MediumJump,

    /** A push upward, big. */
    BigJump,

    /** A push upward, heavy. */
    HeavyJump,

    /** A push upward, huge. */
    HugeJump,

    /** A push upward, giant. */
    GiantJump,

    /** A push upward, epic. */
    EpicJump,

    /** A thud and a settle, tiny. */
    TinyLanding,

    /** A thud and a settle, small. */
    SmallLanding,

    /** A thud and a settle, light. */
    LightLanding,

    /** A thud and a settle, medium. */
    MediumLanding,

    /** A thud and a settle, big. */
    BigLanding,

    /** A thud and a settle, heavy. */
    HeavyLanding,

    /** A thud and a settle, huge. */
    HugeLanding,

    /** A thud and a settle, giant. */
    GiantLanding,

    /** A thud and a settle, epic. */
    EpicLanding,

    /** A strike and a rebound, tiny. */
    TinyHit,

    /** A strike and a rebound, small. */
    SmallHit,

    /** A strike and a rebound, light. */
    LightHit,

    /** A strike and a rebound, medium. */
    MediumHit,

    /** A strike and a rebound, big. */
    BigHit,

    /** A strike and a rebound, heavy. */
    HeavyHit,

    /** A strike and a rebound, huge. */
    HugeHit,

    /** A strike and a rebound, giant. */
    GiantHit,

    /** A strike and a rebound, epic. */
    EpicHit,

    /** A quick burst forward, tiny. */
    TinyDash,

    /** A quick burst forward, small. */
    SmallDash,

    /** A quick burst forward, light. */
    LightDash,

    /** A quick burst forward, medium. */
    MediumDash,

    /** A quick burst forward, big. */
    BigDash,

    /** A quick burst forward, heavy. */
    HeavyDash,

    /** A quick burst forward, huge. */
    HugeDash,

    /** A quick burst forward, giant. */
    GiantDash,

    /** A quick burst forward, epic. */
    EpicDash,

    /** A crisp shot and its kick, tiny. */
    TinyShot,

    /** A crisp shot and its kick, small. */
    SmallShot,

    /** A crisp shot and its kick, light. */
    LightShot,

    /** A crisp shot and its kick, medium. */
    MediumShot,

    /** A crisp shot and its kick, big. */
    BigShot,

    /** A crisp shot and its kick, heavy. */
    HeavyShot,

    /** A crisp shot and its kick, huge. */
    HugeShot,

    /** A crisp shot and its kick, giant. */
    GiantShot,

    /** A crisp shot and its kick, epic. */
    EpicShot,

    /** Power building up, tiny. */
    TinyCharge,

    /** Power building up, small. */
    SmallCharge,

    /** Power building up, light. */
    LightCharge,

    /** Power building up, medium. */
    MediumCharge,

    /** Power building up, big. */
    BigCharge,

    /** Power building up, heavy. */
    HeavyCharge,

    /** Power building up, huge. */
    HugeCharge,

    /** Power building up, giant. */
    GiantCharge,

    /** Power building up, epic. */
    EpicCharge,

    /** Bright rising taps, tiny. */
    TinyPickup,

    /** Bright rising taps, small. */
    SmallPickup,

    /** Bright rising taps, light. */
    LightPickup,

    /** Bright rising taps, medium. */
    MediumPickup,

    /** Bright rising taps, big. */
    BigPickup,

    /** Bright rising taps, heavy. */
    HeavyPickup,

    /** Bright rising taps, huge. */
    HugePickup,

    /** Bright rising taps, giant. */
    GiantPickup,

    /** Bright rising taps, epic. */
    EpicPickup,

    /** Rising taps and a bright hold, tiny. */
    TinyLevelUp,

    /** Rising taps and a bright hold, small. */
    SmallLevelUp,

    /** Rising taps and a bright hold, light. */
    LightLevelUp,

    /** Rising taps and a bright hold, medium. */
    MediumLevelUp,

    /** Rising taps and a bright hold, big. */
    BigLevelUp,

    /** Rising taps and a bright hold, heavy. */
    HeavyLevelUp,

    /** Rising taps and a bright hold, huge. */
    HugeLevelUp,

    /** Rising taps and a bright hold, giant. */
    GiantLevelUp,

    /** Rising taps and a bright hold, epic. */
    EpicLevelUp,

    /** A blow and a shake, tiny. */
    TinyDamage,

    /** A blow and a shake, small. */
    SmallDamage,

    /** A blow and a shake, light. */
    LightDamage,

    /** A blow and a shake, medium. */
    MediumDamage,

    /** A blow and a shake, big. */
    BigDamage,

    /** A blow and a shake, heavy. */
    HeavyDamage,

    /** A blow and a shake, huge. */
    HugeDamage,

    /** A blow and a shake, giant. */
    GiantDamage,

    /** A blow and a shake, epic. */
    EpicDamage,

    /** A shimmering barrier, tiny. */
    TinyShield,

    /** A shimmering barrier, small. */
    SmallShield,

    /** A shimmering barrier, light. */
    LightShield,

    /** A shimmering barrier, medium. */
    MediumShield,

    /** A shimmering barrier, big. */
    BigShield,

    /** A shimmering barrier, heavy. */
    HeavyShield,

    /** A shimmering barrier, huge. */
    HugeShield,

    /** A shimmering barrier, giant. */
    GiantShield,

    /** A shimmering barrier, epic. */
    EpicShield,

    // Animals: animal sounds and movements, from tiny to huge

    /** A cat's purr, tiny. */
    TinyPurr,

    /** A cat's purr, small. */
    SmallPurr,

    /** A cat's purr, medium. */
    MediumPurr,

    /** A cat's purr, large. */
    LargePurr,

    /** A cat's purr, huge. */
    HugePurr,

    /** A dog's bark, tiny. */
    TinyBark,

    /** A dog's bark, small. */
    SmallBark,

    /** A dog's bark, medium. */
    MediumBark,

    /** A dog's bark, large. */
    LargeBark,

    /** A dog's bark, huge. */
    HugeBark,

    /** Hooves on the ground, tiny. */
    TinyHoofbeats,

    /** Hooves on the ground, small. */
    SmallHoofbeats,

    /** Hooves on the ground, medium. */
    MediumHoofbeats,

    /** Hooves on the ground, large. */
    LargeHoofbeats,

    /** Hooves on the ground, huge. */
    HugeHoofbeats,

    /** A rabbit's hops, tiny. */
    TinyHop,

    /** A rabbit's hops, small. */
    SmallHop,

    /** A rabbit's hops, medium. */
    MediumHop,

    /** A rabbit's hops, large. */
    LargeHop,

    /** A rabbit's hops, huge. */
    HugeHop,

    /** A bird pecking, tiny. */
    TinyPeck,

    /** A bird pecking, small. */
    SmallPeck,

    /** A bird pecking, medium. */
    MediumPeck,

    /** A bird pecking, large. */
    LargePeck,

    /** A bird pecking, huge. */
    HugePeck,

    /** Wings beating, tiny. */
    TinyWingbeat,

    /** Wings beating, small. */
    SmallWingbeat,

    /** Wings beating, medium. */
    MediumWingbeat,

    /** Wings beating, large. */
    LargeWingbeat,

    /** Wings beating, huge. */
    HugeWingbeat,

    /** Soft paws padding, tiny. */
    TinyPaws,

    /** Soft paws padding, small. */
    SmallPaws,

    /** Soft paws padding, medium. */
    MediumPaws,

    /** Soft paws padding, large. */
    LargePaws,

    /** Soft paws padding, huge. */
    HugePaws,

    /** A snake slithering, tiny. */
    TinySlither,

    /** A snake slithering, small. */
    SmallSlither,

    /** A snake slithering, medium. */
    MediumSlither,

    /** A snake slithering, large. */
    LargeSlither,

    /** A snake slithering, huge. */
    HugeSlither,

    /** A bee buzzing, tiny. */
    TinyBee,

    /** A bee buzzing, small. */
    SmallBee,

    /** A bee buzzing, medium. */
    MediumBee,

    /** A bee buzzing, large. */
    LargeBee,

    /** A bee buzzing, huge. */
    HugeBee,

    /** A whale's song, tiny. */
    TinyWhale,

    /** A whale's song, small. */
    SmallWhale,

    /** A whale's song, medium. */
    MediumWhale,

    /** A whale's song, large. */
    LargeWhale,

    /** A whale's song, huge. */
    HugeWhale,

    // Emotions: feelings, from tiny to huge

    /** Rising bright taps, tiny. */
    TinyJoy,

    /** Rising bright taps, small. */
    SmallJoy,

    /** Rising bright taps, medium. */
    MediumJoy,

    /** Rising bright taps, large. */
    LargeJoy,

    /** Rising bright taps, huge. */
    HugeJoy,

    /** A slow, soft swell, tiny. */
    TinyCalm,

    /** A slow, soft swell, small. */
    SmallCalm,

    /** A slow, soft swell, medium. */
    MediumCalm,

    /** A slow, soft swell, large. */
    LargeCalm,

    /** A slow, soft swell, huge. */
    HugeCalm,

    /** A sudden sharp tap, tiny. */
    TinySurprise,

    /** A sudden sharp tap, small. */
    SmallSurprise,

    /** A sudden sharp tap, medium. */
    MediumSurprise,

    /** A sudden sharp tap, large. */
    LargeSurprise,

    /** A sudden sharp tap, huge. */
    HugeSurprise,

    /** Hard, pounding pulses, tiny. */
    TinyAnger,

    /** Hard, pounding pulses, small. */
    SmallAnger,

    /** Hard, pounding pulses, medium. */
    MediumAnger,

    /** Hard, pounding pulses, large. */
    LargeAnger,

    /** Hard, pounding pulses, huge. */
    HugeAnger,

    /** A slowly fading weight, tiny. */
    TinySadness,

    /** A slowly fading weight, small. */
    SmallSadness,

    /** A slowly fading weight, medium. */
    MediumSadness,

    /** A slowly fading weight, large. */
    LargeSadness,

    /** A slowly fading weight, huge. */
    HugeSadness,

    /** A quick trembling, tiny. */
    TinyFear,

    /** A quick trembling, small. */
    SmallFear,

    /** A quick trembling, medium. */
    MediumFear,

    /** A quick trembling, large. */
    LargeFear,

    /** A quick trembling, huge. */
    HugeFear,

    /** A warm heartbeat, tiny. */
    TinyLove,

    /** A warm heartbeat, small. */
    SmallLove,

    /** A warm heartbeat, medium. */
    MediumLove,

    /** A warm heartbeat, large. */
    LargeLove,

    /** A warm heartbeat, huge. */
    HugeLove,

    /** Bubbling, bouncing taps, tiny. */
    TinyLaughter,

    /** Bubbling, bouncing taps, small. */
    SmallLaughter,

    /** Bubbling, bouncing taps, medium. */
    MediumLaughter,

    /** Bubbling, bouncing taps, large. */
    LargeLaughter,

    /** Bubbling, bouncing taps, huge. */
    HugeLaughter,

    /** A breath in and out, tiny. */
    TinySigh,

    /** A breath in and out, small. */
    SmallSigh,

    /** A breath in and out, medium. */
    MediumSigh,

    /** A breath in and out, large. */
    LargeSigh,

    /** A breath in and out, huge. */
    HugeSigh,

    /** Taps quickening with excitement, tiny. */
    TinyExcitement,

    /** Taps quickening with excitement, small. */
    SmallExcitement,

    /** Taps quickening with excitement, medium. */
    MediumExcitement,

    /** Taps quickening with excitement, large. */
    LargeExcitement,

    /** Taps quickening with excitement, huge. */
    HugeExcitement,

    // Sports: moments of play, from faint to intense

    /** A boot striking a ball, faint. */
    FaintKick,

    /** A boot striking a ball, soft. */
    SoftKick,

    /** A boot striking a ball, firm. */
    FirmKick,

    /** A boot striking a ball, strong. */
    StrongKick,

    /** A boot striking a ball, intense. */
    IntenseKick,

    /** A ball bouncing down, faint. */
    FaintDribble,

    /** A ball bouncing down, soft. */
    SoftDribble,

    /** A ball bouncing down, firm. */
    FirmDribble,

    /** A ball bouncing down, strong. */
    StrongDribble,

    /** A ball bouncing down, intense. */
    IntenseDribble,

    /** A toss and a crisp serve, faint. */
    FaintServe,

    /** A toss and a crisp serve, soft. */
    SoftServe,

    /** A toss and a crisp serve, firm. */
    FirmServe,

    /** A toss and a crisp serve, strong. */
    StrongServe,

    /** A toss and a crisp serve, intense. */
    IntenseServe,

    /** A clean swish, faint. */
    FaintSwish,

    /** A clean swish, soft. */
    SoftSwish,

    /** A clean swish, firm. */
    FirmSwish,

    /** A clean swish, strong. */
    StrongSwish,

    /** A clean swish, intense. */
    IntenseSwish,

    /** The crack of a bat, faint. */
    FaintBat,

    /** The crack of a bat, soft. */
    SoftBat,

    /** The crack of a bat, firm. */
    FirmBat,

    /** The crack of a bat, strong. */
    StrongBat,

    /** The crack of a bat, intense. */
    IntenseBat,

    /** A referee's whistle, faint. */
    FaintWhistle,

    /** A referee's whistle, soft. */
    SoftWhistle,

    /** A referee's whistle, firm. */
    FirmWhistle,

    /** A referee's whistle, strong. */
    StrongWhistle,

    /** A referee's whistle, intense. */
    IntenseWhistle,

    /** A goal and a cheer, faint. */
    FaintGoal,

    /** A goal and a cheer, soft. */
    SoftGoal,

    /** A goal and a cheer, firm. */
    FirmGoal,

    /** A goal and a cheer, strong. */
    StrongGoal,

    /** A goal and a cheer, intense. */
    IntenseGoal,

    /** A rally of volleys, faint. */
    FaintVolley,

    /** A rally of volleys, soft. */
    SoftVolley,

    /** A rally of volleys, firm. */
    FirmVolley,

    /** A rally of volleys, strong. */
    StrongVolley,

    /** A rally of volleys, intense. */
    IntenseVolley,

    /** Two quick punches, faint. */
    FaintPunch,

    /** Two quick punches, soft. */
    SoftPunch,

    /** Two quick punches, firm. */
    FirmPunch,

    /** Two quick punches, strong. */
    StrongPunch,

    /** Two quick punches, intense. */
    IntensePunch,

    /** A sprint to the line, faint. */
    FaintFinishLine,

    /** A sprint to the line, soft. */
    SoftFinishLine,

    /** A sprint to the line, firm. */
    FirmFinishLine,

    /** A sprint to the line, strong. */
    StrongFinishLine,

    /** A sprint to the line, intense. */
    IntenseFinishLine,

    // Instruments: notes and hits, from faint to intense

    /** A crisp snare hit, faint. */
    FaintSnare,

    /** A crisp snare hit, soft. */
    SoftSnare,

    /** A crisp snare hit, firm. */
    FirmSnare,

    /** A crisp snare hit, strong. */
    StrongSnare,

    /** A crisp snare hit, intense. */
    IntenseSnare,

    /** A deep kick drum, faint. */
    FaintKickDrum,

    /** A deep kick drum, soft. */
    SoftKickDrum,

    /** A deep kick drum, firm. */
    FirmKickDrum,

    /** A deep kick drum, strong. */
    StrongKickDrum,

    /** A deep kick drum, intense. */
    IntenseKickDrum,

    /** A shimmering cymbal, faint. */
    FaintCymbal,

    /** A shimmering cymbal, soft. */
    SoftCymbal,

    /** A shimmering cymbal, firm. */
    FirmCymbal,

    /** A shimmering cymbal, strong. */
    StrongCymbal,

    /** A shimmering cymbal, intense. */
    IntenseCymbal,

    /** A plucked bass note, faint. */
    FaintBass,

    /** A plucked bass note, soft. */
    SoftBass,

    /** A plucked bass note, firm. */
    FirmBass,

    /** A plucked bass note, strong. */
    StrongBass,

    /** A plucked bass note, intense. */
    IntenseBass,

    /** A strummed chord, faint. */
    FaintStrum,

    /** A strummed chord, soft. */
    SoftStrum,

    /** A strummed chord, firm. */
    FirmStrum,

    /** A strummed chord, strong. */
    StrongStrum,

    /** A strummed chord, intense. */
    IntenseStrum,

    /** A rolled piano chord, faint. */
    FaintChord,

    /** A rolled piano chord, soft. */
    SoftChord,

    /** A rolled piano chord, firm. */
    FirmChord,

    /** A rolled piano chord, strong. */
    StrongChord,

    /** A rolled piano chord, intense. */
    IntenseChord,

    /** A rising harp glissando, faint. */
    FaintHarp,

    /** A rising harp glissando, soft. */
    SoftHarp,

    /** A rising harp glissando, firm. */
    FirmHarp,

    /** A rising harp glissando, strong. */
    StrongHarp,

    /** A rising harp glissando, intense. */
    IntenseHarp,

    /** Rising xylophone notes, faint. */
    FaintXylophone,

    /** Rising xylophone notes, soft. */
    SoftXylophone,

    /** Rising xylophone notes, firm. */
    FirmXylophone,

    /** Rising xylophone notes, strong. */
    StrongXylophone,

    /** Rising xylophone notes, intense. */
    IntenseXylophone,

    /** A ringing gong, faint. */
    FaintGong,

    /** A ringing gong, soft. */
    SoftGong,

    /** A ringing gong, firm. */
    FirmGong,

    /** A ringing gong, strong. */
    StrongGong,

    /** A ringing gong, intense. */
    IntenseGong,

    /** A triangle's ring, faint. */
    FaintTriangle,

    /** A triangle's ring, soft. */
    SoftTriangle,

    /** A triangle's ring, firm. */
    FirmTriangle,

    /** A triangle's ring, strong. */
    StrongTriangle,

    /** A triangle's ring, intense. */
    IntenseTriangle,

    // Vehicles: on the move, from slow to rapid

    /** Wheels clacking over rails, slow. */
    SlowTrain,

    /** Wheels clacking over rails, easy. */
    EasyTrain,

    /** Wheels clacking over rails, steady. */
    SteadyTrain,

    /** Wheels clacking over rails, quick. */
    QuickTrain,

    /** Wheels clacking over rails, rapid. */
    RapidTrain,

    /** A motorbike revving, slow. */
    SlowMotorbike,

    /** A motorbike revving, easy. */
    EasyMotorbike,

    /** A motorbike revving, steady. */
    SteadyMotorbike,

    /** A motorbike revving, quick. */
    QuickMotorbike,

    /** A motorbike revving, rapid. */
    RapidMotorbike,

    /** Helicopter blades thumping, slow. */
    SlowHelicopter,

    /** Helicopter blades thumping, easy. */
    EasyHelicopter,

    /** Helicopter blades thumping, steady. */
    SteadyHelicopter,

    /** Helicopter blades thumping, quick. */
    QuickHelicopter,

    /** Helicopter blades thumping, rapid. */
    RapidHelicopter,

    /** A boat on the swell, slow. */
    SlowBoat,

    /** A boat on the swell, easy. */
    EasyBoat,

    /** A boat on the swell, steady. */
    SteadyBoat,

    /** A boat on the swell, quick. */
    QuickBoat,

    /** A boat on the swell, rapid. */
    RapidBoat,

    /** A bicycle bell, slow. */
    SlowBicycleBell,

    /** A bicycle bell, easy. */
    EasyBicycleBell,

    /** A bicycle bell, steady. */
    SteadyBicycleBell,

    /** A bicycle bell, quick. */
    QuickBicycleBell,

    /** A bicycle bell, rapid. */
    RapidBicycleBell,

    /** A skateboard over joints, slow. */
    SlowSkateboard,

    /** A skateboard over joints, easy. */
    EasySkateboard,

    /** A skateboard over joints, steady. */
    SteadySkateboard,

    /** A skateboard over joints, quick. */
    QuickSkateboard,

    /** A skateboard over joints, rapid. */
    RapidSkateboard,

    /** A subway stop, slow. */
    SlowSubway,

    /** A subway stop, easy. */
    EasySubway,

    /** A subway stop, steady. */
    SteadySubway,

    /** A subway stop, quick. */
    QuickSubway,

    /** A subway stop, rapid. */
    RapidSubway,

    /** A rocket climbing, slow. */
    SlowRocket,

    /** A rocket climbing, easy. */
    EasyRocket,

    /** A rocket climbing, steady. */
    SteadyRocket,

    /** A rocket climbing, quick. */
    QuickRocket,

    /** A rocket climbing, rapid. */
    RapidRocket,

    /** A cable car's bell and roll, slow. */
    SlowCableCar,

    /** A cable car's bell and roll, easy. */
    EasyCableCar,

    /** A cable car's bell and roll, steady. */
    SteadyCableCar,

    /** A cable car's bell and roll, quick. */
    QuickCableCar,

    /** A cable car's bell and roll, rapid. */
    RapidCableCar,

    /** A jet passing over, slow. */
    SlowJet,

    /** A jet passing over, easy. */
    EasyJet,

    /** A jet passing over, steady. */
    SteadyJet,

    /** A jet passing over, quick. */
    QuickJet,

    /** A jet passing over, rapid. */
    RapidJet,

    // Controls: interface feedback, from faint to intense

    /** A switch flipped on, faint. */
    FaintSwitch,

    /** A switch flipped on, soft. */
    SoftSwitch,

    /** A switch flipped on, firm. */
    FirmSwitch,

    /** A switch flipped on, strong. */
    StrongSwitch,

    /** A switch flipped on, intense. */
    IntenseSwitch,

    /** A slider's detents, faint. */
    FaintSlider,

    /** A slider's detents, soft. */
    SoftSlider,

    /** A slider's detents, firm. */
    FirmSlider,

    /** A slider's detents, strong. */
    StrongSlider,

    /** A slider's detents, intense. */
    IntenseSlider,

    /** A stepper's click, faint. */
    FaintStepper,

    /** A stepper's click, soft. */
    SoftStepper,

    /** A stepper's click, firm. */
    FirmStepper,

    /** A stepper's click, strong. */
    StrongStepper,

    /** A stepper's click, intense. */
    IntenseStepper,

    /** Pulling, then a snap, faint. */
    FaintPullToRefresh,

    /** Pulling, then a snap, soft. */
    SoftPullToRefresh,

    /** Pulling, then a snap, firm. */
    FirmPullToRefresh,

    /** Pulling, then a snap, strong. */
    StrongPullToRefresh,

    /** Pulling, then a snap, intense. */
    IntensePullToRefresh,

    /** A page turning, faint. */
    FaintPageTurn,

    /** A page turning, soft. */
    SoftPageTurn,

    /** A page turning, firm. */
    FirmPageTurn,

    /** A page turning, strong. */
    StrongPageTurn,

    /** A page turning, intense. */
    IntensePageTurn,

    /** A key pressed, faint. */
    FaintKeyPress,

    /** A key pressed, soft. */
    SoftKeyPress,

    /** A key pressed, firm. */
    FirmKeyPress,

    /** A key pressed, strong. */
    StrongKeyPress,

    /** A key pressed, intense. */
    IntenseKeyPress,

    /** A scroll settling, faint. */
    FaintScrollStop,

    /** A scroll settling, soft. */
    SoftScrollStop,

    /** A scroll settling, firm. */
    FirmScrollStop,

    /** A scroll settling, strong. */
    StrongScrollStop,

    /** A scroll settling, intense. */
    IntenseScrollStop,

    /** A button popping, faint. */
    FaintPop,

    /** A button popping, soft. */
    SoftPop,

    /** A button popping, firm. */
    FirmPop,

    /** A button popping, strong. */
    StrongPop,

    /** A button popping, intense. */
    IntensePop,

    /** Springing back, faint. */
    FaintSnapBack,

    /** Springing back, soft. */
    SoftSnapBack,

    /** Springing back, firm. */
    FirmSnapBack,

    /** Springing back, strong. */
    StrongSnapBack,

    /** Springing back, intense. */
    IntenseSnapBack,

    /** An item grabbed, faint. */
    FaintGrab,

    /** An item grabbed, soft. */
    SoftGrab,

    /** An item grabbed, firm. */
    FirmGrab,

    /** An item grabbed, strong. */
    StrongGrab,

    /** An item grabbed, intense. */
    IntenseGrab,

    // Body: the body's rhythms, from faint to intense

    /** Two slow breaths, faint. */
    FaintBreath,

    /** Two slow breaths, soft. */
    SoftBreath,

    /** Two slow breaths, firm. */
    FirmBreath,

    /** Two slow breaths, strong. */
    StrongBreath,

    /** Two slow breaths, intense. */
    IntenseBreath,

    /** Two footsteps, faint. */
    FaintFootstep,

    /** Two footsteps, soft. */
    SoftFootstep,

    /** Two footsteps, firm. */
    FirmFootstep,

    /** Two footsteps, strong. */
    StrongFootstep,

    /** Two footsteps, intense. */
    IntenseFootstep,

    /** A finger snap, faint. */
    FaintFingerSnap,

    /** A finger snap, soft. */
    SoftFingerSnap,

    /** A finger snap, firm. */
    FirmFingerSnap,

    /** A finger snap, strong. */
    StrongFingerSnap,

    /** A finger snap, intense. */
    IntenseFingerSnap,

    /** Cracking knuckles, faint. */
    FaintKnuckles,

    /** Cracking knuckles, soft. */
    SoftKnuckles,

    /** Cracking knuckles, firm. */
    FirmKnuckles,

    /** Cracking knuckles, strong. */
    StrongKnuckles,

    /** Cracking knuckles, intense. */
    IntenseKnuckles,

    /** A shiver, faint. */
    FaintShiver,

    /** A shiver, soft. */
    SoftShiver,

    /** A shiver, firm. */
    FirmShiver,

    /** A shiver, strong. */
    StrongShiver,

    /** A shiver, intense. */
    IntenseShiver,

    /** A long yawn, faint. */
    FaintYawn,

    /** A long yawn, soft. */
    SoftYawn,

    /** A long yawn, firm. */
    FirmYawn,

    /** A long yawn, strong. */
    StrongYawn,

    /** A long yawn, intense. */
    IntenseYawn,

    /** Two hiccups, faint. */
    FaintHiccup,

    /** Two hiccups, soft. */
    SoftHiccup,

    /** Two hiccups, firm. */
    FirmHiccup,

    /** Two hiccups, strong. */
    StrongHiccup,

    /** Two hiccups, intense. */
    IntenseHiccup,

    /** A building sneeze, faint. */
    FaintSneeze,

    /** A building sneeze, soft. */
    SoftSneeze,

    /** A building sneeze, firm. */
    FirmSneeze,

    /** A building sneeze, strong. */
    StrongSneeze,

    /** A building sneeze, intense. */
    IntenseSneeze,

    /** A warm hug, faint. */
    FaintHug,

    /** A warm hug, soft. */
    SoftHug,

    /** A warm hug, firm. */
    FirmHug,

    /** A warm hug, strong. */
    StrongHug,

    /** A warm hug, intense. */
    IntenseHug,

    /** A fluttering heart, faint. */
    FaintFlutter,

    /** A fluttering heart, soft. */
    SoftFlutter,

    /** A fluttering heart, firm. */
    FirmFlutter,

    /** A fluttering heart, strong. */
    StrongFlutter,

    /** A fluttering heart, intense. */
    IntenseFlutter,

    // Kitchen: cooking sounds, from slow to rapid

    /** A knife chopping, slow. */
    SlowChop,

    /** A knife chopping, easy. */
    EasyChop,

    /** A knife chopping, steady. */
    SteadyChop,

    /** A knife chopping, quick. */
    QuickChop,

    /** A knife chopping, rapid. */
    RapidChop,

    /** Oil sizzling, slow. */
    SlowSizzle,

    /** Oil sizzling, easy. */
    EasySizzle,

    /** Oil sizzling, steady. */
    SteadySizzle,

    /** Oil sizzling, quick. */
    QuickSizzle,

    /** Oil sizzling, rapid. */
    RapidSizzle,

    /** Water bubbling, slow. */
    SlowBoil,

    /** Water bubbling, easy. */
    EasyBoil,

    /** Water bubbling, steady. */
    SteadyBoil,

    /** Water bubbling, quick. */
    QuickBoil,

    /** Water bubbling, rapid. */
    RapidBoil,

    /** A whisk beating, slow. */
    SlowWhisk,

    /** A whisk beating, easy. */
    EasyWhisk,

    /** A whisk beating, steady. */
    SteadyWhisk,

    /** A whisk beating, quick. */
    QuickWhisk,

    /** A whisk beating, rapid. */
    RapidWhisk,

    /** Liquid pouring, slow. */
    SlowPour,

    /** Liquid pouring, easy. */
    EasyPour,

    /** Liquid pouring, steady. */
    SteadyPour,

    /** Liquid pouring, quick. */
    QuickPour,

    /** Liquid pouring, rapid. */
    RapidPour,

    /** A kettle coming to the boil, slow. */
    SlowKettle,

    /** A kettle coming to the boil, easy. */
    EasyKettle,

    /** A kettle coming to the boil, steady. */
    SteadyKettle,

    /** A kettle coming to the boil, quick. */
    QuickKettle,

    /** A kettle coming to the boil, rapid. */
    RapidKettle,

    /** Bread popping up, slow. */
    SlowToaster,

    /** Bread popping up, easy. */
    EasyToaster,

    /** Bread popping up, steady. */
    SteadyToaster,

    /** Bread popping up, quick. */
    QuickToaster,

    /** Bread popping up, rapid. */
    RapidToaster,

    /** A microwave finishing, slow. */
    SlowMicrowave,

    /** A microwave finishing, easy. */
    EasyMicrowave,

    /** A microwave finishing, steady. */
    SteadyMicrowave,

    /** A microwave finishing, quick. */
    QuickMicrowave,

    /** A microwave finishing, rapid. */
    RapidMicrowave,

    /** A blender whirring, slow. */
    SlowBlender,

    /** A blender whirring, easy. */
    EasyBlender,

    /** A blender whirring, steady. */
    SteadyBlender,

    /** A blender whirring, quick. */
    QuickBlender,

    /** A blender whirring, rapid. */
    RapidBlender,

    /** A kitchen timer, slow. */
    SlowTimerDing,

    /** A kitchen timer, easy. */
    EasyTimerDing,

    /** A kitchen timer, steady. */
    SteadyTimerDing,

    /** A kitchen timer, quick. */
    QuickTimerDing,

    /** A kitchen timer, rapid. */
    RapidTimerDing,

    // Tools: work in progress, from faint to intense

    /** Three hammer blows, faint. */
    FaintHammer,

    /** Three hammer blows, soft. */
    SoftHammer,

    /** Three hammer blows, firm. */
    FirmHammer,

    /** Three hammer blows, strong. */
    StrongHammer,

    /** Three hammer blows, intense. */
    IntenseHammer,

    /** A saw cutting, faint. */
    FaintHandSaw,

    /** A saw cutting, soft. */
    SoftHandSaw,

    /** A saw cutting, firm. */
    FirmHandSaw,

    /** A saw cutting, strong. */
    StrongHandSaw,

    /** A saw cutting, intense. */
    IntenseHandSaw,

    /** A screwdriver turning, faint. */
    FaintScrewdriver,

    /** A screwdriver turning, soft. */
    SoftScrewdriver,

    /** A screwdriver turning, firm. */
    FirmScrewdriver,

    /** A screwdriver turning, strong. */
    StrongScrewdriver,

    /** A screwdriver turning, intense. */
    IntenseScrewdriver,

    /** A wrench tightening, faint. */
    FaintWrench,

    /** A wrench tightening, soft. */
    SoftWrench,

    /** A wrench tightening, firm. */
    FirmWrench,

    /** A wrench tightening, strong. */
    StrongWrench,

    /** A wrench tightening, intense. */
    IntenseWrench,

    /** A drill spinning up, faint. */
    FaintPowerDrill,

    /** A drill spinning up, soft. */
    SoftPowerDrill,

    /** A drill spinning up, firm. */
    FirmPowerDrill,

    /** A drill spinning up, strong. */
    StrongPowerDrill,

    /** A drill spinning up, intense. */
    IntensePowerDrill,

    /** A sander buzzing, faint. */
    FaintSander,

    /** A sander buzzing, soft. */
    SoftSander,

    /** A sander buzzing, firm. */
    FirmSander,

    /** A sander buzzing, strong. */
    StrongSander,

    /** A sander buzzing, intense. */
    IntenseSander,

    /** A stapler pressed, faint. */
    FaintStapler,

    /** A stapler pressed, soft. */
    SoftStapler,

    /** A stapler pressed, firm. */
    FirmStapler,

    /** A stapler pressed, strong. */
    StrongStapler,

    /** A stapler pressed, intense. */
    IntenseStapler,

    /** A nail gun firing, faint. */
    FaintNailGun,

    /** A nail gun firing, soft. */
    SoftNailGun,

    /** A nail gun firing, firm. */
    FirmNailGun,

    /** A nail gun firing, strong. */
    StrongNailGun,

    /** A nail gun firing, intense. */
    IntenseNailGun,

    /** A tape measure reeling, faint. */
    FaintTapeMeasure,

    /** A tape measure reeling, soft. */
    SoftTapeMeasure,

    /** A tape measure reeling, firm. */
    FirmTapeMeasure,

    /** A tape measure reeling, strong. */
    StrongTapeMeasure,

    /** A tape measure reeling, intense. */
    IntenseTapeMeasure,

    /** A chisel tapped, faint. */
    FaintChisel,

    /** A chisel tapped, soft. */
    SoftChisel,

    /** A chisel tapped, firm. */
    FirmChisel,

    /** A chisel tapped, strong. */
    StrongChisel,

    /** A chisel tapped, intense. */
    IntenseChisel,

    // Space: out in orbit, from tiny to huge

    /** A launch rumbling up, tiny. */
    TinyLaunch,

    /** A launch rumbling up, small. */
    SmallLaunch,

    /** A launch rumbling up, medium. */
    MediumLaunch,

    /** A launch rumbling up, large. */
    LargeLaunch,

    /** A launch rumbling up, huge. */
    HugeLaunch,

    /** Circling in orbit, tiny. */
    TinyOrbit,

    /** Circling in orbit, small. */
    SmallOrbit,

    /** Circling in orbit, medium. */
    MediumOrbit,

    /** Circling in orbit, large. */
    LargeOrbit,

    /** Circling in orbit, huge. */
    HugeOrbit,

    /** A blinking beacon, tiny. */
    TinyBeacon,

    /** A blinking beacon, small. */
    SmallBeacon,

    /** A blinking beacon, medium. */
    MediumBeacon,

    /** A blinking beacon, large. */
    LargeBeacon,

    /** A blinking beacon, huge. */
    HugeBeacon,

    /** Jumping to warp, tiny. */
    TinyWarp,

    /** Jumping to warp, small. */
    SmallWarp,

    /** Jumping to warp, medium. */
    MediumWarp,

    /** Jumping to warp, large. */
    LargeWarp,

    /** Jumping to warp, huge. */
    HugeWarp,

    /** Docking, step by step, tiny. */
    TinyDocking,

    /** Docking, step by step, small. */
    SmallDocking,

    /** Docking, step by step, medium. */
    MediumDocking,

    /** Docking, step by step, large. */
    LargeDocking,

    /** Docking, step by step, huge. */
    HugeDocking,

    /** A meteor striking, tiny. */
    TinyMeteor,

    /** A meteor striking, small. */
    SmallMeteor,

    /** A meteor striking, medium. */
    MediumMeteor,

    /** A meteor striking, large. */
    LargeMeteor,

    /** A meteor striking, huge. */
    HugeMeteor,

    /** Thrusters firing, tiny. */
    TinyThruster,

    /** Thrusters firing, small. */
    SmallThruster,

    /** Thrusters firing, medium. */
    MediumThruster,

    /** Thrusters firing, large. */
    LargeThruster,

    /** Thrusters firing, huge. */
    HugeThruster,

    /** A fading signal, tiny. */
    TinySignal,

    /** A fading signal, small. */
    SmallSignal,

    /** A fading signal, medium. */
    MediumSignal,

    /** A fading signal, large. */
    LargeSignal,

    /** A fading signal, huge. */
    HugeSignal,

    /** A comet's tail, tiny. */
    TinyComet,

    /** A comet's tail, small. */
    SmallComet,

    /** A comet's tail, medium. */
    MediumComet,

    /** A comet's tail, large. */
    LargeComet,

    /** A comet's tail, huge. */
    HugeComet,

    /** Pulled into a black hole, tiny. */
    TinyBlackHole,

    /** Pulled into a black hole, small. */
    SmallBlackHole,

    /** Pulled into a black hole, medium. */
    MediumBlackHole,

    /** Pulled into a black hole, large. */
    LargeBlackHole,

    /** Pulled into a black hole, huge. */
    HugeBlackHole,

    // Ocean: by and under the sea, from tiny to huge

    /** The tide rolling in, tiny. */
    TinyTide,

    /** The tide rolling in, small. */
    SmallTide,

    /** The tide rolling in, medium. */
    MediumTide,

    /** The tide rolling in, large. */
    LargeTide,

    /** The tide rolling in, huge. */
    HugeTide,

    /** A sonar ping and echo, tiny. */
    TinySonar,

    /** A sonar ping and echo, small. */
    SmallSonar,

    /** A sonar ping and echo, medium. */
    MediumSonar,

    /** A sonar ping and echo, large. */
    LargeSonar,

    /** A sonar ping and echo, huge. */
    HugeSonar,

    /** Bubbles rising, tiny. */
    TinyBubbles,

    /** Bubbles rising, small. */
    SmallBubbles,

    /** Bubbles rising, medium. */
    MediumBubbles,

    /** Bubbles rising, large. */
    LargeBubbles,

    /** Bubbles rising, huge. */
    HugeBubbles,

    /** A splash and drips, tiny. */
    TinySplash,

    /** A splash and drips, small. */
    SmallSplash,

    /** A splash and drips, medium. */
    MediumSplash,

    /** A splash and drips, large. */
    LargeSplash,

    /** A splash and drips, huge. */
    HugeSplash,

    /** A steady current, tiny. */
    TinyCurrent,

    /** A steady current, small. */
    SmallCurrent,

    /** A steady current, medium. */
    MediumCurrent,

    /** A steady current, large. */
    LargeCurrent,

    /** A steady current, huge. */
    HugeCurrent,

    /** A buoy's bell, tiny. */
    TinyBuoyBell,

    /** A buoy's bell, small. */
    SmallBuoyBell,

    /** A buoy's bell, medium. */
    MediumBuoyBell,

    /** A buoy's bell, large. */
    LargeBuoyBell,

    /** A buoy's bell, huge. */
    HugeBuoyBell,

    /** A pulling undertow, tiny. */
    TinyUndertow,

    /** A pulling undertow, small. */
    SmallUndertow,

    /** A pulling undertow, medium. */
    MediumUndertow,

    /** A pulling undertow, large. */
    LargeUndertow,

    /** A pulling undertow, huge. */
    HugeUndertow,

    /** Sea spray, tiny. */
    TinySeaSpray,

    /** Sea spray, small. */
    SmallSeaSpray,

    /** Sea spray, medium. */
    MediumSeaSpray,

    /** Sea spray, large. */
    LargeSeaSpray,

    /** Sea spray, huge. */
    HugeSeaSpray,

    /** Dolphin clicks, tiny. */
    TinyDolphin,

    /** Dolphin clicks, small. */
    SmallDolphin,

    /** Dolphin clicks, medium. */
    MediumDolphin,

    /** Dolphin clicks, large. */
    LargeDolphin,

    /** Dolphin clicks, huge. */
    HugeDolphin,

    /** A ship's horn, tiny. */
    TinyShipHorn,

    /** A ship's horn, small. */
    SmallShipHorn,

    /** A ship's horn, medium. */
    MediumShipHorn,

    /** A ship's horn, large. */
    LargeShipHorn,

    /** A ship's horn, huge. */
    HugeShipHorn,

    // City: street sounds, from faint to intense

    /** Traffic rumbling, faint. */
    FaintTraffic,

    /** Traffic rumbling, soft. */
    SoftTraffic,

    /** Traffic rumbling, firm. */
    FirmTraffic,

    /** Traffic rumbling, strong. */
    StrongTraffic,

    /** Traffic rumbling, intense. */
    IntenseTraffic,

    /** A crosswalk ticking, faint. */
    FaintCrosswalk,

    /** A crosswalk ticking, soft. */
    SoftCrosswalk,

    /** A crosswalk ticking, firm. */
    FirmCrosswalk,

    /** A crosswalk ticking, strong. */
    StrongCrosswalk,

    /** A crosswalk ticking, intense. */
    IntenseCrosswalk,

    /** An elevator arriving, faint. */
    FaintElevator,

    /** An elevator arriving, soft. */
    SoftElevator,

    /** An elevator arriving, firm. */
    FirmElevator,

    /** An elevator arriving, strong. */
    StrongElevator,

    /** An elevator arriving, intense. */
    IntenseElevator,

    /** A turnstile turning, faint. */
    FaintTurnstile,

    /** A turnstile turning, soft. */
    SoftTurnstile,

    /** A turnstile turning, firm. */
    FirmTurnstile,

    /** A turnstile turning, strong. */
    StrongTurnstile,

    /** A turnstile turning, intense. */
    IntenseTurnstile,

    /** A jackhammer, faint. */
    FaintJackhammer,

    /** A jackhammer, soft. */
    SoftJackhammer,

    /** A jackhammer, firm. */
    FirmJackhammer,

    /** A jackhammer, strong. */
    StrongJackhammer,

    /** A jackhammer, intense. */
    IntenseJackhammer,

    /** A car horn, faint. */
    FaintCarHorn,

    /** A car horn, soft. */
    SoftCarHorn,

    /** A car horn, firm. */
    FirmCarHorn,

    /** A car horn, strong. */
    StrongCarHorn,

    /** A car horn, intense. */
    IntenseCarHorn,

    /** Doors closing, faint. */
    FaintTrainDoors,

    /** Doors closing, soft. */
    SoftTrainDoors,

    /** Doors closing, firm. */
    FirmTrainDoors,

    /** Doors closing, strong. */
    StrongTrainDoors,

    /** Doors closing, intense. */
    IntenseTrainDoors,

    /** A bus pulling in, faint. */
    FaintBusStop,

    /** A bus pulling in, soft. */
    SoftBusStop,

    /** A bus pulling in, firm. */
    FirmBusStop,

    /** A bus pulling in, strong. */
    StrongBusStop,

    /** A bus pulling in, intense. */
    IntenseBusStop,

    /** Parking sensors, faint. */
    FaintParking,

    /** Parking sensors, soft. */
    SoftParking,

    /** Parking sensors, firm. */
    FirmParking,

    /** Parking sensors, strong. */
    StrongParking,

    /** Parking sensors, intense. */
    IntenseParking,

    /** Bells ringing, faint. */
    FaintChurchBells,

    /** Bells ringing, soft. */
    SoftChurchBells,

    /** Bells ringing, firm. */
    FirmChurchBells,

    /** Bells ringing, strong. */
    StrongChurchBells,

    /** Bells ringing, intense. */
    IntenseChurchBells,

    // Puzzle: puzzle game moments, from tiny to huge

    /** A match made, tiny. */
    TinyMatch,

    /** A match made, small. */
    SmallMatch,

    /** A match made, medium. */
    MediumMatch,

    /** A match made, large. */
    LargeMatch,

    /** A match made, huge. */
    HugeMatch,

    /** A rising combo, tiny. */
    TinyCombo,

    /** A rising combo, small. */
    SmallCombo,

    /** A rising combo, medium. */
    MediumCombo,

    /** A rising combo, large. */
    LargeCombo,

    /** A rising combo, huge. */
    HugeCombo,

    /** A line cleared, tiny. */
    TinyLineClear,

    /** A line cleared, small. */
    SmallLineClear,

    /** A line cleared, medium. */
    MediumLineClear,

    /** A line cleared, large. */
    LargeLineClear,

    /** A line cleared, huge. */
    HugeLineClear,

    /** A block landing, tiny. */
    TinyBlockDrop,

    /** A block landing, small. */
    SmallBlockDrop,

    /** A block landing, medium. */
    MediumBlockDrop,

    /** A block landing, large. */
    LargeBlockDrop,

    /** A block landing, huge. */
    HugeBlockDrop,

    /** A piece rotated, tiny. */
    TinyRotate,

    /** A piece rotated, small. */
    SmallRotate,

    /** A piece rotated, medium. */
    MediumRotate,

    /** A piece rotated, large. */
    LargeRotate,

    /** A piece rotated, huge. */
    HugeRotate,

    /** Two pieces swapped, tiny. */
    TinySwap,

    /** Two pieces swapped, small. */
    SmallSwap,

    /** Two pieces swapped, medium. */
    MediumSwap,

    /** Two pieces swapped, large. */
    LargeSwap,

    /** Two pieces swapped, huge. */
    HugeSwap,

    /** A bonus earned, tiny. */
    TinyBonus,

    /** A bonus earned, small. */
    SmallBonus,

    /** A bonus earned, medium. */
    MediumBonus,

    /** A bonus earned, large. */
    LargeBonus,

    /** A bonus earned, huge. */
    HugeBonus,

    /** A missed move, tiny. */
    TinyMiss,

    /** A missed move, small. */
    SmallMiss,

    /** A missed move, medium. */
    MediumMiss,

    /** A missed move, large. */
    LargeMiss,

    /** A missed move, huge. */
    HugeMiss,

    /** A hint appearing, tiny. */
    TinyHint,

    /** A hint appearing, small. */
    SmallHint,

    /** A hint appearing, medium. */
    MediumHint,

    /** A hint appearing, large. */
    LargeHint,

    /** A hint appearing, huge. */
    HugeHint,

    /** A level cleared, tiny. */
    TinyLevelClear,

    /** A level cleared, small. */
    SmallLevelClear,

    /** A level cleared, medium. */
    MediumLevelClear,

    /** A level cleared, large. */
    LargeLevelClear,

    /** A level cleared, huge. */
    HugeLevelClear,

    // Grooves: one bar of a beat, from slow to rapid

    /** A rock beat, slow. */
    SlowRock,

    /** A rock beat, easy. */
    EasyRock,

    /** A rock beat, steady. */
    SteadyRock,

    /** A rock beat, quick. */
    QuickRock,

    /** A rock beat, rapid. */
    RapidRock,

    /** A funk groove, slow. */
    SlowFunk,

    /** A funk groove, easy. */
    EasyFunk,

    /** A funk groove, steady. */
    SteadyFunk,

    /** A funk groove, quick. */
    QuickFunk,

    /** A funk groove, rapid. */
    RapidFunk,

    /** A reggae one-drop, slow. */
    SlowReggae,

    /** A reggae one-drop, easy. */
    EasyReggae,

    /** A reggae one-drop, steady. */
    SteadyReggae,

    /** A reggae one-drop, quick. */
    QuickReggae,

    /** A reggae one-drop, rapid. */
    RapidReggae,

    /** A disco beat, slow. */
    SlowDisco,

    /** A disco beat, easy. */
    EasyDisco,

    /** A disco beat, steady. */
    SteadyDisco,

    /** A disco beat, quick. */
    QuickDisco,

    /** A disco beat, rapid. */
    RapidDisco,

    /** A hip hop beat, slow. */
    SlowHipHop,

    /** A hip hop beat, easy. */
    EasyHipHop,

    /** A hip hop beat, steady. */
    SteadyHipHop,

    /** A hip hop beat, quick. */
    QuickHipHop,

    /** A hip hop beat, rapid. */
    RapidHipHop,

    /** A samba rhythm, slow. */
    SlowSamba,

    /** A samba rhythm, easy. */
    EasySamba,

    /** A samba rhythm, steady. */
    SteadySamba,

    /** A samba rhythm, quick. */
    QuickSamba,

    /** A samba rhythm, rapid. */
    RapidSamba,

    /** A tango rhythm, slow. */
    SlowTango,

    /** A tango rhythm, easy. */
    EasyTango,

    /** A tango rhythm, steady. */
    SteadyTango,

    /** A tango rhythm, quick. */
    QuickTango,

    /** A tango rhythm, rapid. */
    RapidTango,

    /** A polka beat, slow. */
    SlowPolka,

    /** A polka beat, easy. */
    EasyPolka,

    /** A polka beat, steady. */
    SteadyPolka,

    /** A polka beat, quick. */
    QuickPolka,

    /** A polka beat, rapid. */
    RapidPolka,

    /** A techno pulse, slow. */
    SlowTechno,

    /** A techno pulse, easy. */
    EasyTechno,

    /** A techno pulse, steady. */
    SteadyTechno,

    /** A techno pulse, quick. */
    QuickTechno,

    /** A techno pulse, rapid. */
    RapidTechno,

    /** An afrobeat groove, slow. */
    SlowAfrobeat,

    /** An afrobeat groove, easy. */
    EasyAfrobeat,

    /** An afrobeat groove, steady. */
    SteadyAfrobeat,

    /** An afrobeat groove, quick. */
    QuickAfrobeat,

    /** An afrobeat groove, rapid. */
    RapidAfrobeat,

    // Notifications: alerts, from once to five times

    /** New mail, once. */
    SingleMail,

    /** New mail, twice. */
    DoubleMail,

    /** New mail, three times. */
    TripleMail,

    /** New mail, four times. */
    QuadrupleMail,

    /** New mail, five times. */
    QuintupleMail,

    /** A calendar alert, once. */
    SingleCalendar,

    /** A calendar alert, twice. */
    DoubleCalendar,

    /** A calendar alert, three times. */
    TripleCalendar,

    /** A calendar alert, four times. */
    QuadrupleCalendar,

    /** A calendar alert, five times. */
    QuintupleCalendar,

    /** A payment sent, once. */
    SinglePayment,

    /** A payment sent, twice. */
    DoublePayment,

    /** A payment sent, three times. */
    TriplePayment,

    /** A payment sent, four times. */
    QuadruplePayment,

    /** A payment sent, five times. */
    QuintuplePayment,

    /** A download done, once. */
    SingleDownload,

    /** A download done, twice. */
    DoubleDownload,

    /** A download done, three times. */
    TripleDownload,

    /** A download done, four times. */
    QuadrupleDownload,

    /** A download done, five times. */
    QuintupleDownload,

    /** An upload done, once. */
    SingleUpload,

    /** An upload done, twice. */
    DoubleUpload,

    /** An upload done, three times. */
    TripleUpload,

    /** An upload done, four times. */
    QuadrupleUpload,

    /** An upload done, five times. */
    QuintupleUpload,

    /** A battery warning, once. */
    SingleBattery,

    /** A battery warning, twice. */
    DoubleBattery,

    /** A battery warning, three times. */
    TripleBattery,

    /** A battery warning, four times. */
    QuadrupleBattery,

    /** A battery warning, five times. */
    QuintupleBattery,

    /** A new note, once. */
    SingleNote,

    /** A new note, twice. */
    DoubleNote,

    /** A new note, three times. */
    TripleNote,

    /** A new note, four times. */
    QuadrupleNote,

    /** A new note, five times. */
    QuintupleNote,

    /** A sync finished, once. */
    SingleSync,

    /** A sync finished, twice. */
    DoubleSync,

    /** A sync finished, three times. */
    TripleSync,

    /** A sync finished, four times. */
    QuadrupleSync,

    /** A sync finished, five times. */
    QuintupleSync,

    /** A friend request, once. */
    SingleFriend,

    /** A friend request, twice. */
    DoubleFriend,

    /** A friend request, three times. */
    TripleFriend,

    /** A friend request, four times. */
    QuadrupleFriend,

    /** A friend request, five times. */
    QuintupleFriend,

    /** Breaking news, once. */
    SingleNews,

    /** Breaking news, twice. */
    DoubleNews,

    /** Breaking news, three times. */
    TripleNews,

    /** Breaking news, four times. */
    QuadrupleNews,

    /** Breaking news, five times. */
    QuintupleNews,

    // Clocks: timekeeping, from slow to rapid

    /** A clock's tick-tock, slow. */
    SlowTickTock,

    /** A clock's tick-tock, easy. */
    EasyTickTock,

    /** A clock's tick-tock, steady. */
    SteadyTickTock,

    /** A clock's tick-tock, quick. */
    QuickTickTock,

    /** A clock's tick-tock, rapid. */
    RapidTickTock,

    /** An hour chiming, slow. */
    SlowHourChime,

    /** An hour chiming, easy. */
    EasyHourChime,

    /** An hour chiming, steady. */
    SteadyHourChime,

    /** An hour chiming, quick. */
    QuickHourChime,

    /** An hour chiming, rapid. */
    RapidHourChime,

    /** A cuckoo clock, slow. */
    SlowCuckoo,

    /** A cuckoo clock, easy. */
    EasyCuckoo,

    /** A cuckoo clock, steady. */
    SteadyCuckoo,

    /** A cuckoo clock, quick. */
    QuickCuckoo,

    /** A cuckoo clock, rapid. */
    RapidCuckoo,

    /** A stopwatch started, slow. */
    SlowStopwatch,

    /** A stopwatch started, easy. */
    EasyStopwatch,

    /** A stopwatch started, steady. */
    SteadyStopwatch,

    /** A stopwatch started, quick. */
    QuickStopwatch,

    /** A stopwatch started, rapid. */
    RapidStopwatch,

    /** Sand running through, slow. */
    SlowHourglass,

    /** Sand running through, easy. */
    EasyHourglass,

    /** Sand running through, steady. */
    SteadyHourglass,

    /** Sand running through, quick. */
    QuickHourglass,

    /** Sand running through, rapid. */
    RapidHourglass,

    /** A swinging pendulum, slow. */
    SlowPendulum,

    /** A swinging pendulum, easy. */
    EasyPendulum,

    /** A swinging pendulum, steady. */
    SteadyPendulum,

    /** A swinging pendulum, quick. */
    QuickPendulum,

    /** A swinging pendulum, rapid. */
    RapidPendulum,

    /** An alarm clock ringing, slow. */
    SlowAlarmClock,

    /** An alarm clock ringing, easy. */
    EasyAlarmClock,

    /** An alarm clock ringing, steady. */
    SteadyAlarmClock,

    /** An alarm clock ringing, quick. */
    QuickAlarmClock,

    /** An alarm clock ringing, rapid. */
    RapidAlarmClock,

    /** An egg timer ticking, slow. */
    SlowEggTimer,

    /** An egg timer ticking, easy. */
    EasyEggTimer,

    /** An egg timer ticking, steady. */
    SteadyEggTimer,

    /** An egg timer ticking, quick. */
    QuickEggTimer,

    /** An egg timer ticking, rapid. */
    RapidEggTimer,

    /** A grandfather clock striking, slow. */
    SlowGrandfatherClock,

    /** A grandfather clock striking, easy. */
    EasyGrandfatherClock,

    /** A grandfather clock striking, steady. */
    SteadyGrandfatherClock,

    /** A grandfather clock striking, quick. */
    QuickGrandfatherClock,

    /** A grandfather clock striking, rapid. */
    RapidGrandfatherClock,

    /** A digital beep, slow. */
    SlowDigital,

    /** A digital beep, easy. */
    EasyDigital,

    /** A digital beep, steady. */
    SteadyDigital,

    /** A digital beep, quick. */
    QuickDigital,

    /** A digital beep, rapid. */
    RapidDigital,

    // Elements: the elements, from tiny to huge

    /** Earth's heavy weight, tiny. */
    TinyEarth,

    /** Earth's heavy weight, small. */
    SmallEarth,

    /** Earth's heavy weight, medium. */
    MediumEarth,

    /** Earth's heavy weight, large. */
    LargeEarth,

    /** Earth's heavy weight, huge. */
    HugeEarth,

    /** Air moving, tiny. */
    TinyAir,

    /** Air moving, small. */
    SmallAir,

    /** Air moving, medium. */
    MediumAir,

    /** Air moving, large. */
    LargeAir,

    /** Air moving, huge. */
    HugeAir,

    /** Water flowing, tiny. */
    TinyWater,

    /** Water flowing, small. */
    SmallWater,

    /** Water flowing, medium. */
    MediumWater,

    /** Water flowing, large. */
    LargeWater,

    /** Water flowing, huge. */
    HugeWater,

    /** A lightning strike, tiny. */
    TinyLightning,

    /** A lightning strike, small. */
    SmallLightning,

    /** A lightning strike, medium. */
    MediumLightning,

    /** A lightning strike, large. */
    LargeLightning,

    /** A lightning strike, huge. */
    HugeLightning,

    /** Ice cracking, tiny. */
    TinyIce,

    /** Ice cracking, small. */
    SmallIce,

    /** Ice cracking, medium. */
    MediumIce,

    /** Ice cracking, large. */
    LargeIce,

    /** Ice cracking, huge. */
    HugeIce,

    /** Lava churning, tiny. */
    TinyLava,

    /** Lava churning, small. */
    SmallLava,

    /** Lava churning, medium. */
    MediumLava,

    /** Lava churning, large. */
    LargeLava,

    /** Lava churning, huge. */
    HugeLava,

    /** Steam hissing, tiny. */
    TinySteam,

    /** Steam hissing, small. */
    SmallSteam,

    /** Steam hissing, medium. */
    MediumSteam,

    /** Steam hissing, large. */
    LargeSteam,

    /** Steam hissing, huge. */
    HugeSteam,

    /** Sand shifting, tiny. */
    TinySand,

    /** Sand shifting, small. */
    SmallSand,

    /** Sand shifting, medium. */
    MediumSand,

    /** Sand shifting, large. */
    LargeSand,

    /** Sand shifting, huge. */
    HugeSand,

    /** Crystal chiming, tiny. */
    TinyCrystal,

    /** Crystal chiming, small. */
    SmallCrystal,

    /** Crystal chiming, medium. */
    MediumCrystal,

    /** Crystal chiming, large. */
    LargeCrystal,

    /** Crystal chiming, huge. */
    HugeCrystal,

    /** A storm raging, tiny. */
    TinyStorm,

    /** A storm raging, small. */
    SmallStorm,

    /** A storm raging, medium. */
    MediumStorm,

    /** A storm raging, large. */
    LargeStorm,

    /** A storm raging, huge. */
    HugeStorm,

    // Magic: spells and charms, from tiny to huge

    /** A spell cast, tiny. */
    TinySpell,

    /** A spell cast, small. */
    SmallSpell,

    /** A spell cast, medium. */
    MediumSpell,

    /** A spell cast, large. */
    LargeSpell,

    /** A spell cast, huge. */
    HugeSpell,

    /** A portal opening, tiny. */
    TinyPortal,

    /** A portal opening, small. */
    SmallPortal,

    /** A portal opening, medium. */
    MediumPortal,

    /** A portal opening, large. */
    LargePortal,

    /** A portal opening, huge. */
    HugePortal,

    /** A wand flick, tiny. */
    TinyWand,

    /** A wand flick, small. */
    SmallWand,

    /** A wand flick, medium. */
    MediumWand,

    /** A wand flick, large. */
    LargeWand,

    /** A wand flick, huge. */
    HugeWand,

    /** A charm, tiny. */
    TinyCharm,

    /** A charm, small. */
    SmallCharm,

    /** A charm, medium. */
    MediumCharm,

    /** A charm, large. */
    LargeCharm,

    /** A charm, huge. */
    HugeCharm,

    /** A curse falling, tiny. */
    TinyCurse,

    /** A curse falling, small. */
    SmallCurse,

    /** A curse falling, medium. */
    MediumCurse,

    /** A curse falling, large. */
    LargeCurse,

    /** A curse falling, huge. */
    HugeCurse,

    /** A healing glow, tiny. */
    TinyHeal,

    /** A healing glow, small. */
    SmallHeal,

    /** A healing glow, medium. */
    MediumHeal,

    /** A healing glow, large. */
    LargeHeal,

    /** A healing glow, huge. */
    HugeHeal,

    /** Vanishing and reappearing, tiny. */
    TinyTeleport,

    /** Vanishing and reappearing, small. */
    SmallTeleport,

    /** Vanishing and reappearing, medium. */
    MediumTeleport,

    /** Vanishing and reappearing, large. */
    LargeTeleport,

    /** Vanishing and reappearing, huge. */
    HugeTeleport,

    /** Something summoned, tiny. */
    TinySummon,

    /** Something summoned, small. */
    SmallSummon,

    /** Something summoned, medium. */
    MediumSummon,

    /** Something summoned, large. */
    LargeSummon,

    /** Something summoned, huge. */
    HugeSummon,

    /** A hex, tiny. */
    TinyHex,

    /** A hex, small. */
    SmallHex,

    /** A hex, medium. */
    MediumHex,

    /** A hex, large. */
    LargeHex,

    /** A hex, huge. */
    HugeHex,

    /** A spell fizzling, tiny. */
    TinyFizzle,

    /** A spell fizzling, small. */
    SmallFizzle,

    /** A spell fizzling, medium. */
    MediumFizzle,

    /** A spell fizzling, large. */
    LargeFizzle,

    /** A spell fizzling, huge. */
    HugeFizzle,

    // Morse: short words in Morse code, from 12 to 26 words a minute

    /** OK in Morse code at 12 words a minute. */
    OkInMorseSlow,

    /** OK in Morse code at 15 words a minute. */
    OkInMorseEasy,

    /** OK in Morse code at 18 words a minute. */
    OkInMorseSteady,

    /** OK in Morse code at 22 words a minute. */
    OkInMorseQuick,

    /** OK in Morse code at 26 words a minute. */
    OkInMorseRapid,

    /** YES in Morse code at 12 words a minute. */
    YesInMorseSlow,

    /** YES in Morse code at 15 words a minute. */
    YesInMorseEasy,

    /** YES in Morse code at 18 words a minute. */
    YesInMorseSteady,

    /** YES in Morse code at 22 words a minute. */
    YesInMorseQuick,

    /** YES in Morse code at 26 words a minute. */
    YesInMorseRapid,

    /** NO in Morse code at 12 words a minute. */
    NoInMorseSlow,

    /** NO in Morse code at 15 words a minute. */
    NoInMorseEasy,

    /** NO in Morse code at 18 words a minute. */
    NoInMorseSteady,

    /** NO in Morse code at 22 words a minute. */
    NoInMorseQuick,

    /** NO in Morse code at 26 words a minute. */
    NoInMorseRapid,

    /** HI in Morse code at 12 words a minute. */
    HiInMorseSlow,

    /** HI in Morse code at 15 words a minute. */
    HiInMorseEasy,

    /** HI in Morse code at 18 words a minute. */
    HiInMorseSteady,

    /** HI in Morse code at 22 words a minute. */
    HiInMorseQuick,

    /** HI in Morse code at 26 words a minute. */
    HiInMorseRapid,

    /** GO in Morse code at 12 words a minute. */
    GoInMorseSlow,

    /** GO in Morse code at 15 words a minute. */
    GoInMorseEasy,

    /** GO in Morse code at 18 words a minute. */
    GoInMorseSteady,

    /** GO in Morse code at 22 words a minute. */
    GoInMorseQuick,

    /** GO in Morse code at 26 words a minute. */
    GoInMorseRapid,

    /** ON in Morse code at 12 words a minute. */
    OnInMorseSlow,

    /** ON in Morse code at 15 words a minute. */
    OnInMorseEasy,

    /** ON in Morse code at 18 words a minute. */
    OnInMorseSteady,

    /** ON in Morse code at 22 words a minute. */
    OnInMorseQuick,

    /** ON in Morse code at 26 words a minute. */
    OnInMorseRapid,

    /** OFF in Morse code at 12 words a minute. */
    OffInMorseSlow,

    /** OFF in Morse code at 15 words a minute. */
    OffInMorseEasy,

    /** OFF in Morse code at 18 words a minute. */
    OffInMorseSteady,

    /** OFF in Morse code at 22 words a minute. */
    OffInMorseQuick,

    /** OFF in Morse code at 26 words a minute. */
    OffInMorseRapid,

    /** UP in Morse code at 12 words a minute. */
    UpInMorseSlow,

    /** UP in Morse code at 15 words a minute. */
    UpInMorseEasy,

    /** UP in Morse code at 18 words a minute. */
    UpInMorseSteady,

    /** UP in Morse code at 22 words a minute. */
    UpInMorseQuick,

    /** UP in Morse code at 26 words a minute. */
    UpInMorseRapid,

    /** WIN in Morse code at 12 words a minute. */
    WinInMorseSlow,

    /** WIN in Morse code at 15 words a minute. */
    WinInMorseEasy,

    /** WIN in Morse code at 18 words a minute. */
    WinInMorseSteady,

    /** WIN in Morse code at 22 words a minute. */
    WinInMorseQuick,

    /** WIN in Morse code at 26 words a minute. */
    WinInMorseRapid,

    /** END in Morse code at 12 words a minute. */
    EndInMorseSlow,

    /** END in Morse code at 15 words a minute. */
    EndInMorseEasy,

    /** END in Morse code at 18 words a minute. */
    EndInMorseSteady,

    /** END in Morse code at 22 words a minute. */
    EndInMorseQuick,

    /** END in Morse code at 26 words a minute. */
    EndInMorseRapid,

    // Electronics: devices at work, from faint to intense

    /** Powering on, faint. */
    FaintPowerOn,

    /** Powering on, soft. */
    SoftPowerOn,

    /** Powering on, firm. */
    FirmPowerOn,

    /** Powering on, strong. */
    StrongPowerOn,

    /** Powering on, intense. */
    IntensePowerOn,

    /** Powering off, faint. */
    FaintPowerOff,

    /** Powering off, soft. */
    SoftPowerOff,

    /** Powering off, firm. */
    FirmPowerOff,

    /** Powering off, strong. */
    StrongPowerOff,

    /** Powering off, intense. */
    IntensePowerOff,

    /** Charging up, faint. */
    FaintCharging,

    /** Charging up, soft. */
    SoftCharging,

    /** Charging up, firm. */
    FirmCharging,

    /** Charging up, strong. */
    StrongCharging,

    /** Charging up, intense. */
    IntenseCharging,

    /** A phone vibrating, faint. */
    FaintVibrate,

    /** A phone vibrating, soft. */
    SoftVibrate,

    /** A phone vibrating, firm. */
    FirmVibrate,

    /** A phone vibrating, strong. */
    StrongVibrate,

    /** A phone vibrating, intense. */
    IntenseVibrate,

    /** A scanner beam, faint. */
    FaintScanner,

    /** A scanner beam, soft. */
    SoftScanner,

    /** A scanner beam, firm. */
    FirmScanner,

    /** A scanner beam, strong. */
    StrongScanner,

    /** A scanner beam, intense. */
    IntenseScanner,

    /** A printer running, faint. */
    FaintPrinter,

    /** A printer running, soft. */
    SoftPrinter,

    /** A printer running, firm. */
    FirmPrinter,

    /** A printer running, strong. */
    StrongPrinter,

    /** A printer running, intense. */
    IntensePrinter,

    /** A modem connecting, faint. */
    FaintModem,

    /** A modem connecting, soft. */
    SoftModem,

    /** A modem connecting, firm. */
    FirmModem,

    /** A modem connecting, strong. */
    StrongModem,

    /** A modem connecting, intense. */
    IntenseModem,

    /** A glitch, faint. */
    FaintGlitch,

    /** A glitch, soft. */
    SoftGlitch,

    /** A glitch, firm. */
    FirmGlitch,

    /** A glitch, strong. */
    StrongGlitch,

    /** A glitch, intense. */
    IntenseGlitch,

    /** A mouse click, faint. */
    FaintClick,

    /** A mouse click, soft. */
    SoftClick,

    /** A mouse click, firm. */
    FirmClick,

    /** A mouse click, strong. */
    StrongClick,

    /** A mouse click, intense. */
    IntenseClick,

    /** Static noise, faint. */
    FaintStatic,

    /** Static noise, soft. */
    SoftStatic,

    /** Static noise, firm. */
    FirmStatic,

    /** Static noise, strong. */
    StrongStatic,

    /** Static noise, intense. */
    IntenseStatic,

    // Feedback taps: buttons and other targets, from faint to intense

    /** A button pressed, faint. */
    FaintButton,

    /** A button pressed, soft. */
    SoftButton,

    /** A button pressed, firm. */
    FirmButton,

    /** A button pressed, strong. */
    StrongButton,

    /** A button pressed, intense. */
    IntenseButton,

    /** A card tapped, faint. */
    FaintCardTap,

    /** A card tapped, soft. */
    SoftCardTap,

    /** A card tapped, firm. */
    FirmCardTap,

    /** A card tapped, strong. */
    StrongCardTap,

    /** A card tapped, intense. */
    IntenseCardTap,

    /** An icon tapped, faint. */
    FaintIconTap,

    /** An icon tapped, soft. */
    SoftIconTap,

    /** An icon tapped, firm. */
    FirmIconTap,

    /** An icon tapped, strong. */
    StrongIconTap,

    /** An icon tapped, intense. */
    IntenseIconTap,

    /** A chip selected, faint. */
    FaintChip,

    /** A chip selected, soft. */
    SoftChip,

    /** A chip selected, firm. */
    FirmChip,

    /** A chip selected, strong. */
    StrongChip,

    /** A chip selected, intense. */
    IntenseChip,

    /** A tab chosen, faint. */
    FaintTab,

    /** A tab chosen, soft. */
    SoftTab,

    /** A tab chosen, firm. */
    FirmTab,

    /** A tab chosen, strong. */
    StrongTab,

    /** A tab chosen, intense. */
    IntenseTab,

    /** A badge cleared, faint. */
    FaintBadge,

    /** A badge cleared, soft. */
    SoftBadge,

    /** A badge cleared, firm. */
    FirmBadge,

    /** A badge cleared, strong. */
    StrongBadge,

    /** A badge cleared, intense. */
    IntenseBadge,

    /** A box checked, faint. */
    FaintCheckbox,

    /** A box checked, soft. */
    SoftCheckbox,

    /** A box checked, firm. */
    FirmCheckbox,

    /** A box checked, strong. */
    StrongCheckbox,

    /** A box checked, intense. */
    IntenseCheckbox,

    /** A radio button chosen, faint. */
    FaintRadio,

    /** A radio button chosen, soft. */
    SoftRadio,

    /** A radio button chosen, firm. */
    FirmRadio,

    /** A radio button chosen, strong. */
    StrongRadio,

    /** A radio button chosen, intense. */
    IntenseRadio,

    /** A link followed, faint. */
    FaintLink,

    /** A link followed, soft. */
    SoftLink,

    /** A link followed, firm. */
    FirmLink,

    /** A link followed, strong. */
    StrongLink,

    /** A link followed, intense. */
    IntenseLink,

    /** A menu item chosen, faint. */
    FaintMenuItem,

    /** A menu item chosen, soft. */
    SoftMenuItem,

    /** A menu item chosen, firm. */
    FirmMenuItem,

    /** A menu item chosen, strong. */
    StrongMenuItem,

    /** A menu item chosen, intense. */
    IntenseMenuItem,

    // Feedback toggles: switches and catches, from tiny to huge

    /** Flipped over, tiny. */
    TinyFlip,

    /** Flipped over, small. */
    SmallFlip,

    /** Flipped over, medium. */
    MediumFlip,

    /** Flipped over, large. */
    LargeFlip,

    /** Flipped over, huge. */
    HugeFlip,

    /** A latch catching, tiny. */
    TinyLatch,

    /** A latch catching, small. */
    SmallLatch,

    /** A latch catching, medium. */
    MediumLatch,

    /** A latch catching, large. */
    LargeLatch,

    /** A latch catching, huge. */
    HugeLatch,

    /** A dial clicking round, tiny. */
    TinyDialClick,

    /** A dial clicking round, small. */
    SmallDialClick,

    /** A dial clicking round, medium. */
    MediumDialClick,

    /** A dial clicking round, large. */
    LargeDialClick,

    /** A dial clicking round, huge. */
    HugeDialClick,

    /** A lever pulled, tiny. */
    TinyLever,

    /** A lever pulled, small. */
    SmallLever,

    /** A lever pulled, medium. */
    MediumLever,

    /** A lever pulled, large. */
    LargeLever,

    /** A lever pulled, huge. */
    HugeLever,

    /** A knob turned, tiny. */
    TinyKnob,

    /** A knob turned, small. */
    SmallKnob,

    /** A knob turned, medium. */
    MediumKnob,

    /** A knob turned, large. */
    LargeKnob,

    /** A knob turned, huge. */
    HugeKnob,

    /** A rocker switch, tiny. */
    TinyRocker,

    /** A rocker switch, small. */
    SmallRocker,

    /** A rocker switch, medium. */
    MediumRocker,

    /** A rocker switch, large. */
    LargeRocker,

    /** A rocker switch, huge. */
    HugeRocker,

    /** A push button, tiny. */
    TinyPushButton,

    /** A push button, small. */
    SmallPushButton,

    /** A push button, medium. */
    MediumPushButton,

    /** A push button, large. */
    LargePushButton,

    /** A push button, huge. */
    HugePushButton,

    /** A lock slid open, tiny. */
    TinySlideLock,

    /** A lock slid open, small. */
    SmallSlideLock,

    /** A lock slid open, medium. */
    MediumSlideLock,

    /** A lock slid open, large. */
    LargeSlideLock,

    /** A lock slid open, huge. */
    HugeSlideLock,

    /** A thumb switch, tiny. */
    TinyThumbSwitch,

    /** A thumb switch, small. */
    SmallThumbSwitch,

    /** A thumb switch, medium. */
    MediumThumbSwitch,

    /** A thumb switch, large. */
    LargeThumbSwitch,

    /** A thumb switch, huge. */
    HugeThumbSwitch,

    /** A detent, tiny. */
    TinyDetent,

    /** A detent, small. */
    SmallDetent,

    /** A detent, medium. */
    MediumDetent,

    /** A detent, large. */
    LargeDetent,

    /** A detent, huge. */
    HugeDetent,

    // Feedback gestures: touches and swipes, from slow to rapid

    /** A fling, slow. */
    SlowFling,

    /** A fling, easy. */
    EasyFling,

    /** A fling, steady. */
    SteadyFling,

    /** A fling, quick. */
    QuickFling,

    /** A fling, rapid. */
    RapidFling,

    /** A pinch closing, slow. */
    SlowPinch,

    /** A pinch closing, easy. */
    EasyPinch,

    /** A pinch closing, steady. */
    SteadyPinch,

    /** A pinch closing, quick. */
    QuickPinch,

    /** A pinch closing, rapid. */
    RapidPinch,

    /** A pinch opening, slow. */
    SlowSpread,

    /** A pinch opening, easy. */
    EasySpread,

    /** A pinch opening, steady. */
    SteadySpread,

    /** A pinch opening, quick. */
    QuickSpread,

    /** A pinch opening, rapid. */
    RapidSpread,

    /** Dragged, then dropped, slow. */
    SlowDrag,

    /** Dragged, then dropped, easy. */
    EasyDrag,

    /** Dragged, then dropped, steady. */
    SteadyDrag,

    /** Dragged, then dropped, quick. */
    QuickDrag,

    /** Dragged, then dropped, rapid. */
    RapidDrag,

    /** Held, then released, slow. */
    SlowLongHold,

    /** Held, then released, easy. */
    EasyLongHold,

    /** Held, then released, steady. */
    SteadyLongHold,

    /** Held, then released, quick. */
    QuickLongHold,

    /** Held, then released, rapid. */
    RapidLongHold,

    /** A flick, slow. */
    SlowFlick,

    /** A flick, easy. */
    EasyFlick,

    /** A flick, steady. */
    SteadyFlick,

    /** A flick, quick. */
    QuickFlick,

    /** A flick, rapid. */
    RapidFlick,

    /** Panning around, slow. */
    SlowPan,

    /** Panning around, easy. */
    EasyPan,

    /** Panning around, steady. */
    SteadyPan,

    /** Panning around, quick. */
    QuickPan,

    /** Panning around, rapid. */
    RapidPan,

    /** A swipe from the edge, slow. */
    SlowEdgeSwipe,

    /** A swipe from the edge, easy. */
    EasyEdgeSwipe,

    /** A swipe from the edge, steady. */
    SteadyEdgeSwipe,

    /** A swipe from the edge, quick. */
    QuickEdgeSwipe,

    /** A swipe from the edge, rapid. */
    RapidEdgeSwipe,

    /** A twist, slow. */
    SlowTwist,

    /** A twist, easy. */
    EasyTwist,

    /** A twist, steady. */
    SteadyTwist,

    /** A twist, quick. */
    QuickTwist,

    /** A twist, rapid. */
    RapidTwist,

    /** Pressed twice, slow. */
    SlowDoublePress,

    /** Pressed twice, easy. */
    EasyDoublePress,

    /** Pressed twice, steady. */
    SteadyDoublePress,

    /** Pressed twice, quick. */
    QuickDoublePress,

    /** Pressed twice, rapid. */
    RapidDoublePress,

    // Feedback results: actions done, from once to five times

    /** Saved, once. */
    SingleSave,

    /** Saved, twice. */
    DoubleSave,

    /** Saved, three times. */
    TripleSave,

    /** Saved, four times. */
    QuadrupleSave,

    /** Saved, five times. */
    QuintupleSave,

    /** Sent, once. */
    SingleSend,

    /** Sent, twice. */
    DoubleSend,

    /** Sent, three times. */
    TripleSend,

    /** Sent, four times. */
    QuadrupleSend,

    /** Sent, five times. */
    QuintupleSend,

    /** Copied, once. */
    SingleCopy,

    /** Copied, twice. */
    DoubleCopy,

    /** Copied, three times. */
    TripleCopy,

    /** Copied, four times. */
    QuadrupleCopy,

    /** Copied, five times. */
    QuintupleCopy,

    /** Removed, once. */
    SingleRemoveItem,

    /** Removed, twice. */
    DoubleRemoveItem,

    /** Removed, three times. */
    TripleRemoveItem,

    /** Removed, four times. */
    QuadrupleRemoveItem,

    /** Removed, five times. */
    QuintupleRemoveItem,

    /** Reverted, once. */
    SingleRevert,

    /** Reverted, twice. */
    DoubleRevert,

    /** Reverted, three times. */
    TripleRevert,

    /** Reverted, four times. */
    QuadrupleRevert,

    /** Reverted, five times. */
    QuintupleRevert,

    /** Added, once. */
    SingleAdd,

    /** Added, twice. */
    DoubleAdd,

    /** Added, three times. */
    TripleAdd,

    /** Added, four times. */
    QuadrupleAdd,

    /** Added, five times. */
    QuintupleAdd,

    /** Discarded, once. */
    SingleDiscard,

    /** Discarded, twice. */
    DoubleDiscard,

    /** Discarded, three times. */
    TripleDiscard,

    /** Discarded, four times. */
    QuadrupleDiscard,

    /** Discarded, five times. */
    QuintupleDiscard,

    /** Uploaded, once. */
    SingleUploadDone,

    /** Uploaded, twice. */
    DoubleUploadDone,

    /** Uploaded, three times. */
    TripleUploadDone,

    /** Uploaded, four times. */
    QuadrupleUploadDone,

    /** Uploaded, five times. */
    QuintupleUploadDone,

    /** Liked, once. */
    SingleLike,

    /** Liked, twice. */
    DoubleLike,

    /** Liked, three times. */
    TripleLike,

    /** Liked, four times. */
    QuadrupleLike,

    /** Liked, five times. */
    QuintupleLike,

    /** Shared, once. */
    SingleShare,

    /** Shared, twice. */
    DoubleShare,

    /** Shared, three times. */
    TripleShare,

    /** Shared, four times. */
    QuadrupleShare,

    /** Shared, five times. */
    QuintupleShare,

    // Alert chimes: bells and tones, from once to five times

    /** A two-tone door chime, once. */
    SingleDoorChime,

    /** A two-tone door chime, twice. */
    DoubleDoorChime,

    /** A two-tone door chime, three times. */
    TripleDoorChime,

    /** A two-tone door chime, four times. */
    QuadrupleDoorChime,

    /** A two-tone door chime, five times. */
    QuintupleDoorChime,

    /** Wind chimes, once. */
    SingleWindChime,

    /** Wind chimes, twice. */
    DoubleWindChime,

    /** Wind chimes, three times. */
    TripleWindChime,

    /** Wind chimes, four times. */
    QuadrupleWindChime,

    /** Wind chimes, five times. */
    QuintupleWindChime,

    /** A pair of tones, once. */
    SingleTonePair,

    /** A pair of tones, twice. */
    DoubleTonePair,

    /** A pair of tones, three times. */
    TripleTonePair,

    /** A pair of tones, four times. */
    QuadrupleTonePair,

    /** A pair of tones, five times. */
    QuintupleTonePair,

    /** A rising arpeggio, once. */
    SingleArpeggio,

    /** A rising arpeggio, twice. */
    DoubleArpeggio,

    /** A rising arpeggio, three times. */
    TripleArpeggio,

    /** A rising arpeggio, four times. */
    QuadrupleArpeggio,

    /** A rising arpeggio, five times. */
    QuintupleArpeggio,

    /** A low bell, once. */
    SingleLowBell,

    /** A low bell, twice. */
    DoubleLowBell,

    /** A low bell, three times. */
    TripleLowBell,

    /** A low bell, four times. */
    QuadrupleLowBell,

    /** A low bell, five times. */
    QuintupleLowBell,

    /** A held harmonic, once. */
    SingleHarmonic,

    /** A held harmonic, twice. */
    DoubleHarmonic,

    /** A held harmonic, three times. */
    TripleHarmonic,

    /** A held harmonic, four times. */
    QuadrupleHarmonic,

    /** A held harmonic, five times. */
    QuintupleHarmonic,

    /** A glass chime, once. */
    SingleGlassChime,

    /** A glass chime, twice. */
    DoubleGlassChime,

    /** A glass chime, three times. */
    TripleGlassChime,

    /** A glass chime, four times. */
    QuadrupleGlassChime,

    /** A glass chime, five times. */
    QuintupleGlassChime,

    /** Twin bells, once. */
    SingleTwinBell,

    /** Twin bells, twice. */
    DoubleTwinBell,

    /** Twin bells, three times. */
    TripleTwinBell,

    /** Twin bells, four times. */
    QuadrupleTwinBell,

    /** Twin bells, five times. */
    QuintupleTwinBell,

    /** A soft gong, once. */
    SingleSoftGong,

    /** A soft gong, twice. */
    DoubleSoftGong,

    /** A soft gong, three times. */
    TripleSoftGong,

    /** A soft gong, four times. */
    QuadrupleSoftGong,

    /** A soft gong, five times. */
    QuintupleSoftGong,

    /** A bright tone, once. */
    SingleBrightTone,

    /** A bright tone, twice. */
    DoubleBrightTone,

    /** A bright tone, three times. */
    TripleBrightTone,

    /** A bright tone, four times. */
    QuadrupleBrightTone,

    /** A bright tone, five times. */
    QuintupleBrightTone,

    // Alert calls: rings and calls, from slow to rapid

    /** A phone ringing, slow. */
    SlowRingtone,

    /** A phone ringing, easy. */
    EasyRingtone,

    /** A phone ringing, steady. */
    SteadyRingtone,

    /** A phone ringing, quick. */
    QuickRingtone,

    /** A phone ringing, rapid. */
    RapidRingtone,

    /** An intercom buzz, slow. */
    SlowIntercom,

    /** An intercom buzz, easy. */
    EasyIntercom,

    /** An intercom buzz, steady. */
    SteadyIntercom,

    /** An intercom buzz, quick. */
    QuickIntercom,

    /** An intercom buzz, rapid. */
    RapidIntercom,

    /** A pager going off, slow. */
    SlowPager,

    /** A pager going off, easy. */
    EasyPager,

    /** A pager going off, steady. */
    SteadyPager,

    /** A pager going off, quick. */
    QuickPager,

    /** A pager going off, rapid. */
    RapidPager,

    /** A walkie-talkie click, slow. */
    SlowWalkieTalkie,

    /** A walkie-talkie click, easy. */
    EasyWalkieTalkie,

    /** A walkie-talkie click, steady. */
    SteadyWalkieTalkie,

    /** A walkie-talkie click, quick. */
    QuickWalkieTalkie,

    /** A walkie-talkie click, rapid. */
    RapidWalkieTalkie,

    /** A long buzzer, slow. */
    SlowBuzzer,

    /** A long buzzer, easy. */
    EasyBuzzer,

    /** A long buzzer, steady. */
    SteadyBuzzer,

    /** A long buzzer, quick. */
    QuickBuzzer,

    /** A long buzzer, rapid. */
    RapidBuzzer,

    /** A hotline ringing, slow. */
    SlowHotline,

    /** A hotline ringing, easy. */
    EasyHotline,

    /** A hotline ringing, steady. */
    SteadyHotline,

    /** A hotline ringing, quick. */
    QuickHotline,

    /** A hotline ringing, rapid. */
    RapidHotline,

    /** A telegraph key, slow. */
    SlowTelegraph,

    /** A telegraph key, easy. */
    EasyTelegraph,

    /** A telegraph key, steady. */
    SteadyTelegraph,

    /** A telegraph key, quick. */
    QuickTelegraph,

    /** A telegraph key, rapid. */
    RapidTelegraph,

    /** On hold, slow. */
    SlowHoldMusic,

    /** On hold, easy. */
    EasyHoldMusic,

    /** On hold, steady. */
    SteadyHoldMusic,

    /** On hold, quick. */
    QuickHoldMusic,

    /** On hold, rapid. */
    RapidHoldMusic,

    /** A busy signal, slow. */
    SlowBusySignal,

    /** A busy signal, easy. */
    EasyBusySignal,

    /** A busy signal, steady. */
    SteadyBusySignal,

    /** A busy signal, quick. */
    QuickBusySignal,

    /** A busy signal, rapid. */
    RapidBusySignal,

    /** A voicemail waiting, slow. */
    SlowVoicemail,

    /** A voicemail waiting, easy. */
    EasyVoicemail,

    /** A voicemail waiting, steady. */
    SteadyVoicemail,

    /** A voicemail waiting, quick. */
    QuickVoicemail,

    /** A voicemail waiting, rapid. */
    RapidVoicemail,

    // Alert warnings: something's wrong, from faint to intense

    /** Caution, faint. */
    FaintCaution,

    /** Caution, soft. */
    SoftCaution,

    /** Caution, firm. */
    FirmCaution,

    /** Caution, strong. */
    StrongCaution,

    /** Caution, intense. */
    IntenseCaution,

    /** A hazard flashing, faint. */
    FaintHazard,

    /** A hazard flashing, soft. */
    SoftHazard,

    /** A hazard flashing, firm. */
    FirmHazard,

    /** A hazard flashing, strong. */
    StrongHazard,

    /** A hazard flashing, intense. */
    IntenseHazard,

    /** Heat building, faint. */
    FaintOverheat,

    /** Heat building, soft. */
    SoftOverheat,

    /** Heat building, firm. */
    FirmOverheat,

    /** Heat building, strong. */
    StrongOverheat,

    /** Heat building, intense. */
    IntenseOverheat,

    /** A signal fading, faint. */
    FaintLowSignal,

    /** A signal fading, soft. */
    SoftLowSignal,

    /** A signal fading, firm. */
    FirmLowSignal,

    /** A signal fading, strong. */
    StrongLowSignal,

    /** A signal fading, intense. */
    IntenseLowSignal,

    /** Storage full, faint. */
    FaintStorageFull,

    /** Storage full, soft. */
    SoftStorageFull,

    /** Storage full, firm. */
    FirmStorageFull,

    /** Storage full, strong. */
    StrongStorageFull,

    /** Storage full, intense. */
    IntenseStorageFull,

    /** Timed out, faint. */
    FaintTimeout,

    /** Timed out, soft. */
    SoftTimeout,

    /** Timed out, firm. */
    FirmTimeout,

    /** Timed out, strong. */
    StrongTimeout,

    /** Timed out, intense. */
    IntenseTimeout,

    /** Blocked, faint. */
    FaintBlocked,

    /** Blocked, soft. */
    SoftBlocked,

    /** Blocked, firm. */
    FirmBlocked,

    /** Blocked, strong. */
    StrongBlocked,

    /** Blocked, intense. */
    IntenseBlocked,

    /** Denied, faint. */
    FaintDenied,

    /** Denied, soft. */
    SoftDenied,

    /** Denied, firm. */
    FirmDenied,

    /** Denied, strong. */
    StrongDenied,

    /** Denied, intense. */
    IntenseDenied,

    /** An error tone, faint. */
    FaintErrorTone,

    /** An error tone, soft. */
    SoftErrorTone,

    /** An error tone, firm. */
    FirmErrorTone,

    /** An error tone, strong. */
    StrongErrorTone,

    /** An error tone, intense. */
    IntenseErrorTone,

    /** A critical alert, faint. */
    FaintCriticalAlert,

    /** A critical alert, soft. */
    SoftCriticalAlert,

    /** A critical alert, firm. */
    FirmCriticalAlert,

    /** A critical alert, strong. */
    StrongCriticalAlert,

    /** A critical alert, intense. */
    IntenseCriticalAlert,

    // Rhythm beats: drum patterns, from slow to rapid

    /** A backbeat, slow. */
    SlowBackbeat,

    /** A backbeat, easy. */
    EasyBackbeat,

    /** A backbeat, steady. */
    SteadyBackbeat,

    /** A backbeat, quick. */
    QuickBackbeat,

    /** A backbeat, rapid. */
    RapidBackbeat,

    /** Offbeat hits, slow. */
    SlowOffbeat,

    /** Offbeat hits, easy. */
    EasyOffbeat,

    /** Offbeat hits, steady. */
    SteadyOffbeat,

    /** Offbeat hits, quick. */
    QuickOffbeat,

    /** Offbeat hits, rapid. */
    RapidOffbeat,

    /** A half-time feel, slow. */
    SlowHalfTime,

    /** A half-time feel, easy. */
    EasyHalfTime,

    /** A half-time feel, steady. */
    SteadyHalfTime,

    /** A half-time feel, quick. */
    QuickHalfTime,

    /** A half-time feel, rapid. */
    RapidHalfTime,

    /** A double-time feel, slow. */
    SlowDoubleTime,

    /** A double-time feel, easy. */
    EasyDoubleTime,

    /** A double-time feel, steady. */
    SteadyDoubleTime,

    /** A double-time feel, quick. */
    QuickDoubleTime,

    /** A double-time feel, rapid. */
    RapidDoubleTime,

    /** Triplets, slow. */
    SlowTriplet,

    /** Triplets, easy. */
    EasyTriplet,

    /** Triplets, steady. */
    SteadyTriplet,

    /** Triplets, quick. */
    QuickTriplet,

    /** Triplets, rapid. */
    RapidTriplet,

    /** A syncopated beat, slow. */
    SlowSyncopated,

    /** A syncopated beat, easy. */
    EasySyncopated,

    /** A syncopated beat, steady. */
    SteadySyncopated,

    /** A syncopated beat, quick. */
    QuickSyncopated,

    /** A syncopated beat, rapid. */
    RapidSyncopated,

    /** A cross rhythm, slow. */
    SlowCrossBeat,

    /** A cross rhythm, easy. */
    EasyCrossBeat,

    /** A cross rhythm, steady. */
    SteadyCrossBeat,

    /** A cross rhythm, quick. */
    QuickCrossBeat,

    /** A cross rhythm, rapid. */
    RapidCrossBeat,

    /** A breakbeat, slow. */
    SlowBreakbeat,

    /** A breakbeat, easy. */
    EasyBreakbeat,

    /** A breakbeat, steady. */
    SteadyBreakbeat,

    /** A breakbeat, quick. */
    QuickBreakbeat,

    /** A breakbeat, rapid. */
    RapidBreakbeat,

    /** A paradiddle, slow. */
    SlowParadiddle,

    /** A paradiddle, easy. */
    EasyParadiddle,

    /** A paradiddle, steady. */
    SteadyParadiddle,

    /** A paradiddle, quick. */
    QuickParadiddle,

    /** A paradiddle, rapid. */
    RapidParadiddle,

    /** Flams, slow. */
    SlowFlam,

    /** Flams, easy. */
    EasyFlam,

    /** Flams, steady. */
    SteadyFlam,

    /** Flams, quick. */
    QuickFlam,

    /** Flams, rapid. */
    RapidFlam,

    // Rhythm pulses: single beats, from once to five times

    /** A thump, once. */
    SingleThump,

    /** A thump, twice. */
    DoubleThump,

    /** A thump, three times. */
    TripleThump,

    /** A thump, four times. */
    QuadrupleThump,

    /** A thump, five times. */
    QuintupleThump,

    /** A pound, once. */
    SinglePound,

    /** A pound, twice. */
    DoublePound,

    /** A pound, three times. */
    TriplePound,

    /** A pound, four times. */
    QuadruplePound,

    /** A pound, five times. */
    QuintuplePound,

    /** A patter, once. */
    SinglePatter,

    /** A patter, twice. */
    DoublePatter,

    /** A patter, three times. */
    TriplePatter,

    /** A patter, four times. */
    QuadruplePatter,

    /** A patter, five times. */
    QuintuplePatter,

    /** A bump, once. */
    SingleBump,

    /** A bump, twice. */
    DoubleBump,

    /** A bump, three times. */
    TripleBump,

    /** A bump, four times. */
    QuadrupleBump,

    /** A bump, five times. */
    QuintupleBump,

    /** A thud, once. */
    SingleThud,

    /** A thud, twice. */
    DoubleThud,

    /** A thud, three times. */
    TripleThud,

    /** A thud, four times. */
    QuadrupleThud,

    /** A thud, five times. */
    QuintupleThud,

    /** A strike, once. */
    SingleStrike,

    /** A strike, twice. */
    DoubleStrike,

    /** A strike, three times. */
    TripleStrike,

    /** A strike, four times. */
    QuadrupleStrike,

    /** A strike, five times. */
    QuintupleStrike,

    /** A rap on a door, once. */
    SingleRap,

    /** A rap on a door, twice. */
    DoubleRap,

    /** A rap on a door, three times. */
    TripleRap,

    /** A rap on a door, four times. */
    QuadrupleRap,

    /** A rap on a door, five times. */
    QuintupleRap,

    /** A pair of taps, once. */
    SingleTapPair,

    /** A pair of taps, twice. */
    DoubleTapPair,

    /** A pair of taps, three times. */
    TripleTapPair,

    /** A pair of taps, four times. */
    QuadrupleTapPair,

    /** A pair of taps, five times. */
    QuintupleTapPair,

    /** A drumbeat, once. */
    SingleDrumbeat,

    /** A drumbeat, twice. */
    DoubleDrumbeat,

    /** A drumbeat, three times. */
    TripleDrumbeat,

    /** A drumbeat, four times. */
    QuadrupleDrumbeat,

    /** A drumbeat, five times. */
    QuintupleDrumbeat,

    /** A heave, once. */
    SingleHeave,

    /** A heave, twice. */
    DoubleHeave,

    /** A heave, three times. */
    TripleHeave,

    /** A heave, four times. */
    QuadrupleHeave,

    /** A heave, five times. */
    QuintupleHeave,

    // Rhythm footwork: steps, from slow to rapid

    /** Walking, slow. */
    SlowWalking,

    /** Walking, easy. */
    EasyWalking,

    /** Walking, steady. */
    SteadyWalking,

    /** Walking, quick. */
    QuickWalking,

    /** Walking, rapid. */
    RapidWalking,

    /** Running, slow. */
    SlowRunning,

    /** Running, easy. */
    EasyRunning,

    /** Running, steady. */
    SteadyRunning,

    /** Running, quick. */
    QuickRunning,

    /** Running, rapid. */
    RapidRunning,

    /** Marching, slow. */
    SlowMarchingFeet,

    /** Marching, easy. */
    EasyMarchingFeet,

    /** Marching, steady. */
    SteadyMarchingFeet,

    /** Marching, quick. */
    QuickMarchingFeet,

    /** Marching, rapid. */
    RapidMarchingFeet,

    /** Tiptoeing, slow. */
    SlowTiptoe,

    /** Tiptoeing, easy. */
    EasyTiptoe,

    /** Tiptoeing, steady. */
    SteadyTiptoe,

    /** Tiptoeing, quick. */
    QuickTiptoe,

    /** Tiptoeing, rapid. */
    RapidTiptoe,

    /** Skipping, slow. */
    SlowSkipping,

    /** Skipping, easy. */
    EasySkipping,

    /** Skipping, steady. */
    SteadySkipping,

    /** Skipping, quick. */
    QuickSkipping,

    /** Skipping, rapid. */
    RapidSkipping,

    /** Stomping, slow. */
    SlowStomping,

    /** Stomping, easy. */
    EasyStomping,

    /** Stomping, steady. */
    SteadyStomping,

    /** Stomping, quick. */
    QuickStomping,

    /** Stomping, rapid. */
    RapidStomping,

    /** Tap dancing, slow. */
    SlowTapDance,

    /** Tap dancing, easy. */
    EasyTapDance,

    /** Tap dancing, steady. */
    SteadyTapDance,

    /** Tap dancing, quick. */
    QuickTapDance,

    /** Tap dancing, rapid. */
    RapidTapDance,

    /** Jogging, slow. */
    SlowJogging,

    /** Jogging, easy. */
    EasyJogging,

    /** Jogging, steady. */
    SteadyJogging,

    /** Jogging, quick. */
    QuickJogging,

    /** Jogging, rapid. */
    RapidJogging,

    /** Climbing stairs, slow. */
    SlowClimbingStairs,

    /** Climbing stairs, easy. */
    EasyClimbingStairs,

    /** Climbing stairs, steady. */
    SteadyClimbingStairs,

    /** Climbing stairs, quick. */
    QuickClimbingStairs,

    /** Climbing stairs, rapid. */
    RapidClimbingStairs,

    /** Shuffling along, slow. */
    SlowShufflingFeet,

    /** Shuffling along, easy. */
    EasyShufflingFeet,

    /** Shuffling along, steady. */
    SteadyShufflingFeet,

    /** Shuffling along, quick. */
    QuickShufflingFeet,

    /** Shuffling along, rapid. */
    RapidShufflingFeet,

    // Texture grains: grainy surfaces, from faint to intense

    /** Fine grit, faint. */
    FaintGrit,

    /** Fine grit, soft. */
    SoftGrit,

    /** Fine grit, firm. */
    FirmGrit,

    /** Fine grit, strong. */
    StrongGrit,

    /** Fine grit, intense. */
    IntenseGrit,

    /** Pebbles, faint. */
    FaintPebbles,

    /** Pebbles, soft. */
    SoftPebbles,

    /** Pebbles, firm. */
    FirmPebbles,

    /** Pebbles, strong. */
    StrongPebbles,

    /** Pebbles, intense. */
    IntensePebbles,

    /** Grains of salt, faint. */
    FaintSalt,

    /** Grains of salt, soft. */
    SoftSalt,

    /** Grains of salt, firm. */
    FirmSalt,

    /** Grains of salt, strong. */
    StrongSalt,

    /** Grains of salt, intense. */
    IntenseSalt,

    /** A gravel path, faint. */
    FaintGravelPath,

    /** A gravel path, soft. */
    SoftGravelPath,

    /** A gravel path, firm. */
    FirmGravelPath,

    /** A gravel path, strong. */
    StrongGravelPath,

    /** A gravel path, intense. */
    IntenseGravelPath,

    /** Crumbs, faint. */
    FaintCrumbs,

    /** Crumbs, soft. */
    SoftCrumbs,

    /** Crumbs, firm. */
    FirmCrumbs,

    /** Crumbs, strong. */
    StrongCrumbs,

    /** Crumbs, intense. */
    IntenseCrumbs,

    /** Velcro pulled apart, faint. */
    FaintVelcro,

    /** Velcro pulled apart, soft. */
    SoftVelcro,

    /** Velcro pulled apart, firm. */
    FirmVelcro,

    /** Velcro pulled apart, strong. */
    StrongVelcro,

    /** Velcro pulled apart, intense. */
    IntenseVelcro,

    /** Bubble wrap popping, faint. */
    FaintBubbleWrap,

    /** Bubble wrap popping, soft. */
    SoftBubbleWrap,

    /** Bubble wrap popping, firm. */
    FirmBubbleWrap,

    /** Bubble wrap popping, strong. */
    StrongBubbleWrap,

    /** Bubble wrap popping, intense. */
    IntenseBubbleWrap,

    /** Corrugated card, faint. */
    FaintCorrugated,

    /** Corrugated card, soft. */
    SoftCorrugated,

    /** Corrugated card, firm. */
    FirmCorrugated,

    /** Corrugated card, strong. */
    StrongCorrugated,

    /** Corrugated card, intense. */
    IntenseCorrugated,

    /** Beads rolling, faint. */
    FaintBeads,

    /** Beads rolling, soft. */
    SoftBeads,

    /** Beads rolling, firm. */
    FirmBeads,

    /** Beads rolling, strong. */
    StrongBeads,

    /** Beads rolling, intense. */
    IntenseBeads,

    /** Sawdust, faint. */
    FaintSawdust,

    /** Sawdust, soft. */
    SoftSawdust,

    /** Sawdust, firm. */
    FirmSawdust,

    /** Sawdust, strong. */
    StrongSawdust,

    /** Sawdust, intense. */
    IntenseSawdust,

    // Texture hums: steady sounds, from tiny to huge

    /** A low drone, tiny. */
    TinyDrone,

    /** A low drone, small. */
    SmallDrone,

    /** A low drone, medium. */
    MediumDrone,

    /** A low drone, large. */
    LargeDrone,

    /** A low drone, huge. */
    HugeDrone,

    /** A whirr, tiny. */
    TinyWhirr,

    /** A whirr, small. */
    SmallWhirr,

    /** A whirr, medium. */
    MediumWhirr,

    /** A whirr, large. */
    LargeWhirr,

    /** A whirr, huge. */
    HugeWhirr,

    /** A murmur, tiny. */
    TinyMurmur,

    /** A murmur, small. */
    SmallMurmur,

    /** A murmur, medium. */
    MediumMurmur,

    /** A murmur, large. */
    LargeMurmur,

    /** A murmur, huge. */
    HugeMurmur,

    /** A vibration, tiny. */
    TinyVibration,

    /** A vibration, small. */
    SmallVibration,

    /** A vibration, medium. */
    MediumVibration,

    /** A vibration, large. */
    LargeVibration,

    /** A vibration, huge. */
    HugeVibration,

    /** A fading resonance, tiny. */
    TinyResonance,

    /** A fading resonance, small. */
    SmallResonance,

    /** A fading resonance, medium. */
    MediumResonance,

    /** A fading resonance, large. */
    LargeResonance,

    /** A fading resonance, huge. */
    HugeResonance,

    /** A thrum, tiny. */
    TinyThrum,

    /** A thrum, small. */
    SmallThrum,

    /** A thrum, medium. */
    MediumThrum,

    /** A thrum, large. */
    LargeThrum,

    /** A thrum, huge. */
    HugeThrum,

    /** A fizz, tiny. */
    TinyFizz,

    /** A fizz, small. */
    SmallFizz,

    /** A fizz, medium. */
    MediumFizz,

    /** A fizz, large. */
    LargeFizz,

    /** A fizz, huge. */
    HugeFizz,

    /** A crackle, tiny. */
    TinyCrackle,

    /** A crackle, small. */
    SmallCrackle,

    /** A crackle, medium. */
    MediumCrackle,

    /** A crackle, large. */
    LargeCrackle,

    /** A crackle, huge. */
    HugeCrackle,

    /** A hiss, tiny. */
    TinyHiss,

    /** A hiss, small. */
    SmallHiss,

    /** A hiss, medium. */
    MediumHiss,

    /** A hiss, large. */
    LargeHiss,

    /** A hiss, huge. */
    HugeHiss,

    /** A warble, tiny. */
    TinyWarble,

    /** A warble, small. */
    SmallWarble,

    /** A warble, medium. */
    MediumWarble,

    /** A warble, large. */
    LargeWarble,

    /** A warble, huge. */
    HugeWarble,

    // Texture swells: rising and falling, from slow to rapid

    /** A crest, slow. */
    SlowCrest,

    /** A crest, easy. */
    EasyCrest,

    /** A crest, steady. */
    SteadyCrest,

    /** A crest, quick. */
    QuickCrest,

    /** A crest, rapid. */
    RapidCrest,

    /** An undulation, slow. */
    SlowUndulation,

    /** An undulation, easy. */
    EasyUndulation,

    /** An undulation, steady. */
    SteadyUndulation,

    /** An undulation, quick. */
    QuickUndulation,

    /** An undulation, rapid. */
    RapidUndulation,

    /** A glide sharpening, slow. */
    SlowGlide,

    /** A glide sharpening, easy. */
    EasyGlide,

    /** A glide sharpening, steady. */
    SteadyGlide,

    /** A glide sharpening, quick. */
    QuickGlide,

    /** A glide sharpening, rapid. */
    RapidGlide,

    /** A billow, slow. */
    SlowBillow,

    /** A billow, easy. */
    EasyBillow,

    /** A billow, steady. */
    SteadyBillow,

    /** A billow, quick. */
    QuickBillow,

    /** A billow, rapid. */
    RapidBillow,

    /** A flare, slow. */
    SlowFlare,

    /** A flare, easy. */
    EasyFlare,

    /** A flare, steady. */
    SteadyFlare,

    /** A flare, quick. */
    QuickFlare,

    /** A flare, rapid. */
    RapidFlare,

    /** Fading in, slow. */
    SlowFadeIn,

    /** Fading in, easy. */
    EasyFadeIn,

    /** Fading in, steady. */
    SteadyFadeIn,

    /** Fading in, quick. */
    QuickFadeIn,

    /** Fading in, rapid. */
    RapidFadeIn,

    /** Fading away, slow. */
    SlowFadeAway,

    /** Fading away, easy. */
    EasyFadeAway,

    /** Fading away, steady. */
    SteadyFadeAway,

    /** Fading away, quick. */
    QuickFadeAway,

    /** Fading away, rapid. */
    RapidFadeAway,

    /** Breathing, slow. */
    SlowBreathing,

    /** Breathing, easy. */
    EasyBreathing,

    /** Breathing, steady. */
    SteadyBreathing,

    /** Breathing, quick. */
    QuickBreathing,

    /** Breathing, rapid. */
    RapidBreathing,

    /** A tremolo, slow. */
    SlowTremolo,

    /** A tremolo, easy. */
    EasyTremolo,

    /** A tremolo, steady. */
    SteadyTremolo,

    /** A tremolo, quick. */
    QuickTremolo,

    /** A tremolo, rapid. */
    RapidTremolo,

    /** A lull, slow. */
    SlowLull,

    /** A lull, easy. */
    EasyLull,

    /** A lull, steady. */
    SteadyLull,

    /** A lull, quick. */
    QuickLull,

    /** A lull, rapid. */
    RapidLull,

    // Nature creatures: wildlife, from tiny to huge

    /** A frog croaking, tiny. */
    TinyFrog,

    /** A frog croaking, small. */
    SmallFrog,

    /** A frog croaking, medium. */
    MediumFrog,

    /** A frog croaking, large. */
    LargeFrog,

    /** A frog croaking, huge. */
    HugeFrog,

    /** An owl hooting, tiny. */
    TinyOwl,

    /** An owl hooting, small. */
    SmallOwl,

    /** An owl hooting, medium. */
    MediumOwl,

    /** An owl hooting, large. */
    LargeOwl,

    /** An owl hooting, huge. */
    HugeOwl,

    /** A hummingbird hovering, tiny. */
    TinyHummingbird,

    /** A hummingbird hovering, small. */
    SmallHummingbird,

    /** A hummingbird hovering, medium. */
    MediumHummingbird,

    /** A hummingbird hovering, large. */
    LargeHummingbird,

    /** A hummingbird hovering, huge. */
    HugeHummingbird,

    /** A squirrel chattering, tiny. */
    TinySquirrel,

    /** A squirrel chattering, small. */
    SmallSquirrel,

    /** A squirrel chattering, medium. */
    MediumSquirrel,

    /** A squirrel chattering, large. */
    LargeSquirrel,

    /** A squirrel chattering, huge. */
    HugeSquirrel,

    /** A rattlesnake, tiny. */
    TinySnakeRattle,

    /** A rattlesnake, small. */
    SmallSnakeRattle,

    /** A rattlesnake, medium. */
    MediumSnakeRattle,

    /** A rattlesnake, large. */
    LargeSnakeRattle,

    /** A rattlesnake, huge. */
    HugeSnakeRattle,

    /** A lion's roar, tiny. */
    TinyLionRoar,

    /** A lion's roar, small. */
    SmallLionRoar,

    /** A lion's roar, medium. */
    MediumLionRoar,

    /** A lion's roar, large. */
    LargeLionRoar,

    /** A lion's roar, huge. */
    HugeLionRoar,

    /** An elephant's stomp, tiny. */
    TinyElephant,

    /** An elephant's stomp, small. */
    SmallElephant,

    /** An elephant's stomp, medium. */
    MediumElephant,

    /** An elephant's stomp, large. */
    LargeElephant,

    /** An elephant's stomp, huge. */
    HugeElephant,

    /** A mosquito, tiny. */
    TinyMosquito,

    /** A mosquito, small. */
    SmallMosquito,

    /** A mosquito, medium. */
    MediumMosquito,

    /** A mosquito, large. */
    LargeMosquito,

    /** A mosquito, huge. */
    HugeMosquito,

    /** Fireflies, tiny. */
    TinyFirefly,

    /** Fireflies, small. */
    SmallFirefly,

    /** Fireflies, medium. */
    MediumFirefly,

    /** Fireflies, large. */
    LargeFirefly,

    /** Fireflies, huge. */
    HugeFirefly,

    /** Bat wings, tiny. */
    TinyBatWings,

    /** Bat wings, small. */
    SmallBatWings,

    /** Bat wings, medium. */
    MediumBatWings,

    /** Bat wings, large. */
    LargeBatWings,

    /** Bat wings, huge. */
    HugeBatWings,

    // Nature water: water in motion, from faint to intense

    /** A slow drip, faint. */
    FaintDrip,

    /** A slow drip, soft. */
    SoftDrip,

    /** A slow drip, firm. */
    FirmDrip,

    /** A slow drip, strong. */
    StrongDrip,

    /** A slow drip, intense. */
    IntenseDrip,

    /** A puddle splash, faint. */
    FaintPuddle,

    /** A puddle splash, soft. */
    SoftPuddle,

    /** A puddle splash, firm. */
    FirmPuddle,

    /** A puddle splash, strong. */
    StrongPuddle,

    /** A puddle splash, intense. */
    IntensePuddle,

    /** A waterfall, faint. */
    FaintWaterfall,

    /** A waterfall, soft. */
    SoftWaterfall,

    /** A waterfall, firm. */
    FirmWaterfall,

    /** A waterfall, strong. */
    StrongWaterfall,

    /** A waterfall, intense. */
    IntenseWaterfall,

    /** A babbling brook, faint. */
    FaintBrook,

    /** A babbling brook, soft. */
    SoftBrook,

    /** A babbling brook, firm. */
    FirmBrook,

    /** A babbling brook, strong. */
    StrongBrook,

    /** A babbling brook, intense. */
    IntenseBrook,

    /** A fountain, faint. */
    FaintFountain,

    /** A fountain, soft. */
    SoftFountain,

    /** A fountain, firm. */
    FirmFountain,

    /** A fountain, strong. */
    StrongFountain,

    /** A fountain, intense. */
    IntenseFountain,

    /** A geyser erupting, faint. */
    FaintGeyser,

    /** A geyser erupting, soft. */
    SoftGeyser,

    /** A geyser erupting, firm. */
    FirmGeyser,

    /** A geyser erupting, strong. */
    StrongGeyser,

    /** A geyser erupting, intense. */
    IntenseGeyser,

    /** Water lapping a shore, faint. */
    FaintLakeLap,

    /** Water lapping a shore, soft. */
    SoftLakeLap,

    /** Water lapping a shore, firm. */
    FirmLakeLap,

    /** Water lapping a shore, strong. */
    StrongLakeLap,

    /** Water lapping a shore, intense. */
    IntenseLakeLap,

    /** Icicles dripping, faint. */
    FaintIcicle,

    /** Icicles dripping, soft. */
    SoftIcicle,

    /** Icicles dripping, firm. */
    FirmIcicle,

    /** Icicles dripping, strong. */
    StrongIcicle,

    /** Icicles dripping, intense. */
    IntenseIcicle,

    /** A hot spring, faint. */
    FaintHotSpring,

    /** A hot spring, soft. */
    SoftHotSpring,

    /** A hot spring, firm. */
    FirmHotSpring,

    /** A hot spring, strong. */
    StrongHotSpring,

    /** A hot spring, intense. */
    IntenseHotSpring,

    /** River rapids, faint. */
    FaintRiverRapids,

    /** River rapids, soft. */
    SoftRiverRapids,

    /** River rapids, firm. */
    FirmRiverRapids,

    /** River rapids, strong. */
    StrongRiverRapids,

    /** River rapids, intense. */
    IntenseRiverRapids,

    // Nature sky: weather overhead, from slow to rapid

    /** A breeze, slow. */
    SlowBreeze,

    /** A breeze, easy. */
    EasyBreeze,

    /** A breeze, steady. */
    SteadyBreeze,

    /** A breeze, quick. */
    QuickBreeze,

    /** A breeze, rapid. */
    RapidBreeze,

    /** A gale, slow. */
    SlowGale,

    /** A gale, easy. */
    EasyGale,

    /** A gale, steady. */
    SteadyGale,

    /** A gale, quick. */
    QuickGale,

    /** A gale, rapid. */
    RapidGale,

    /** A sunrise, slow. */
    SlowSunrise,

    /** A sunrise, easy. */
    EasySunrise,

    /** A sunrise, steady. */
    SteadySunrise,

    /** A sunrise, quick. */
    QuickSunrise,

    /** A sunrise, rapid. */
    RapidSunrise,

    /** A sunset, slow. */
    SlowSunset,

    /** A sunset, easy. */
    EasySunset,

    /** A sunset, steady. */
    SteadySunset,

    /** A sunset, quick. */
    QuickSunset,

    /** A sunset, rapid. */
    RapidSunset,

    /** A rainbow, slow. */
    SlowRainbow,

    /** A rainbow, easy. */
    EasyRainbow,

    /** A rainbow, steady. */
    SteadyRainbow,

    /** A rainbow, quick. */
    QuickRainbow,

    /** A rainbow, rapid. */
    RapidRainbow,

    /** Falling snow, slow. */
    SlowSnowfall,

    /** Falling snow, easy. */
    EasySnowfall,

    /** Falling snow, steady. */
    SteadySnowfall,

    /** Falling snow, quick. */
    QuickSnowfall,

    /** Falling snow, rapid. */
    RapidSnowfall,

    /** Fog rolling in, slow. */
    SlowFogRoll,

    /** Fog rolling in, easy. */
    EasyFogRoll,

    /** Fog rolling in, steady. */
    SteadyFogRoll,

    /** Fog rolling in, quick. */
    QuickFogRoll,

    /** Fog rolling in, rapid. */
    RapidFogRoll,

    /** An aurora, slow. */
    SlowAurora,

    /** An aurora, easy. */
    EasyAurora,

    /** An aurora, steady. */
    SteadyAurora,

    /** An aurora, quick. */
    QuickAurora,

    /** An aurora, rapid. */
    RapidAurora,

    /** Starlight, slow. */
    SlowStarlight,

    /** Starlight, easy. */
    EasyStarlight,

    /** Starlight, steady. */
    SteadyStarlight,

    /** Starlight, quick. */
    QuickStarlight,

    /** Starlight, rapid. */
    RapidStarlight,

    /** An overcast sky, slow. */
    SlowOvercast,

    /** An overcast sky, easy. */
    EasyOvercast,

    /** An overcast sky, steady. */
    SteadyOvercast,

    /** An overcast sky, quick. */
    QuickOvercast,

    /** An overcast sky, rapid. */
    RapidOvercast,

    // Mechanical parts: moving parts, from faint to intense

    /** A cog turning, faint. */
    FaintCog,

    /** A cog turning, soft. */
    SoftCog,

    /** A cog turning, firm. */
    FirmCog,

    /** A cog turning, strong. */
    StrongCog,

    /** A cog turning, intense. */
    IntenseCog,

    /** A spring bouncing, faint. */
    FaintSpringCoil,

    /** A spring bouncing, soft. */
    SoftSpringCoil,

    /** A spring bouncing, firm. */
    FirmSpringCoil,

    /** A spring bouncing, strong. */
    StrongSpringCoil,

    /** A spring bouncing, intense. */
    IntenseSpringCoil,

    /** A piston pumping, faint. */
    FaintPiston,

    /** A piston pumping, soft. */
    SoftPiston,

    /** A piston pumping, firm. */
    FirmPiston,

    /** A piston pumping, strong. */
    StrongPiston,

    /** A piston pumping, intense. */
    IntensePiston,

    /** A valve releasing, faint. */
    FaintValve,

    /** A valve releasing, soft. */
    SoftValve,

    /** A valve releasing, firm. */
    FirmValve,

    /** A valve releasing, strong. */
    StrongValve,

    /** A valve releasing, intense. */
    IntenseValve,

    /** A gear shift, faint. */
    FaintGearShift,

    /** A gear shift, soft. */
    SoftGearShift,

    /** A gear shift, firm. */
    FirmGearShift,

    /** A gear shift, strong. */
    StrongGearShift,

    /** A gear shift, intense. */
    IntenseGearShift,

    /** A bearing spinning, faint. */
    FaintBearing,

    /** A bearing spinning, soft. */
    SoftBearing,

    /** A bearing spinning, firm. */
    FirmBearing,

    /** A bearing spinning, strong. */
    StrongBearing,

    /** A bearing spinning, intense. */
    IntenseBearing,

    /** A hinge swinging, faint. */
    FaintHinge,

    /** A hinge swinging, soft. */
    SoftHinge,

    /** A hinge swinging, firm. */
    FirmHinge,

    /** A hinge swinging, strong. */
    StrongHinge,

    /** A hinge swinging, intense. */
    IntenseHinge,

    /** A bolt sliding home, faint. */
    FaintLatchBolt,

    /** A bolt sliding home, soft. */
    SoftLatchBolt,

    /** A bolt sliding home, firm. */
    FirmLatchBolt,

    /** A bolt sliding home, strong. */
    StrongLatchBolt,

    /** A bolt sliding home, intense. */
    IntenseLatchBolt,

    /** A crank turning, faint. */
    FaintCrank,

    /** A crank turning, soft. */
    SoftCrank,

    /** A crank turning, firm. */
    FirmCrank,

    /** A crank turning, strong. */
    StrongCrank,

    /** A crank turning, intense. */
    IntenseCrank,

    /** A pulley hauling, faint. */
    FaintPulley,

    /** A pulley hauling, soft. */
    SoftPulley,

    /** A pulley hauling, firm. */
    FirmPulley,

    /** A pulley hauling, strong. */
    StrongPulley,

    /** A pulley hauling, intense. */
    IntensePulley,

    // Mechanical devices: machines at home, from slow to rapid

    /** A turntable spinning, slow. */
    SlowTurntable,

    /** A turntable spinning, easy. */
    EasyTurntable,

    /** A turntable spinning, steady. */
    SteadyTurntable,

    /** A turntable spinning, quick. */
    QuickTurntable,

    /** A turntable spinning, rapid. */
    RapidTurntable,

    /** A projector running, slow. */
    SlowProjector,

    /** A projector running, easy. */
    EasyProjector,

    /** A projector running, steady. */
    SteadyProjector,

    /** A projector running, quick. */
    QuickProjector,

    /** A projector running, rapid. */
    RapidProjector,

    /** A cassette playing, slow. */
    SlowCassette,

    /** A cassette playing, easy. */
    EasyCassette,

    /** A cassette playing, steady. */
    SteadyCassette,

    /** A cassette playing, quick. */
    QuickCassette,

    /** A cassette playing, rapid. */
    RapidCassette,

    /** A vending machine, slow. */
    SlowVendingMachine,

    /** A vending machine, easy. */
    EasyVendingMachine,

    /** A vending machine, steady. */
    SteadyVendingMachine,

    /** A vending machine, quick. */
    QuickVendingMachine,

    /** A vending machine, rapid. */
    RapidVendingMachine,

    /** A washing machine, slow. */
    SlowWashingMachine,

    /** A washing machine, easy. */
    EasyWashingMachine,

    /** A washing machine, steady. */
    SteadyWashingMachine,

    /** A washing machine, quick. */
    QuickWashingMachine,

    /** A washing machine, rapid. */
    RapidWashingMachine,

    /** A dishwasher, slow. */
    SlowDishwasher,

    /** A dishwasher, easy. */
    EasyDishwasher,

    /** A dishwasher, steady. */
    SteadyDishwasher,

    /** A dishwasher, quick. */
    QuickDishwasher,

    /** A dishwasher, rapid. */
    RapidDishwasher,

    /** A lawn mower, slow. */
    SlowLawnMower,

    /** A lawn mower, easy. */
    EasyLawnMower,

    /** A lawn mower, steady. */
    SteadyLawnMower,

    /** A lawn mower, quick. */
    QuickLawnMower,

    /** A lawn mower, rapid. */
    RapidLawnMower,

    /** A vacuum cleaner, slow. */
    SlowVacuum,

    /** A vacuum cleaner, easy. */
    EasyVacuum,

    /** A vacuum cleaner, steady. */
    SteadyVacuum,

    /** A vacuum cleaner, quick. */
    QuickVacuum,

    /** A vacuum cleaner, rapid. */
    RapidVacuum,

    /** An air conditioner, slow. */
    SlowAirConditioner,

    /** An air conditioner, easy. */
    EasyAirConditioner,

    /** An air conditioner, steady. */
    SteadyAirConditioner,

    /** An air conditioner, quick. */
    QuickAirConditioner,

    /** An air conditioner, rapid. */
    RapidAirConditioner,

    /** A coffee machine, slow. */
    SlowCoffeeMachine,

    /** A coffee machine, easy. */
    EasyCoffeeMachine,

    /** A coffee machine, steady. */
    SteadyCoffeeMachine,

    /** A coffee machine, quick. */
    QuickCoffeeMachine,

    /** A coffee machine, rapid. */
    RapidCoffeeMachine,

    // Game moves: a character's moves, from tiny to huge

    /** A sprint, tiny. */
    TinySprint,

    /** A sprint, small. */
    SmallSprint,

    /** A sprint, medium. */
    MediumSprint,

    /** A sprint, large. */
    LargeSprint,

    /** A sprint, huge. */
    HugeSprint,

    /** A slide, tiny. */
    TinySlide,

    /** A slide, small. */
    SmallSlide,

    /** A slide, medium. */
    MediumSlide,

    /** A slide, large. */
    LargeSlide,

    /** A slide, huge. */
    HugeSlide,

    /** A roll, tiny. */
    TinyRoll,

    /** A roll, small. */
    SmallRoll,

    /** A roll, medium. */
    MediumRoll,

    /** A roll, large. */
    LargeRoll,

    /** A roll, huge. */
    HugeRoll,

    /** Climbing a ledge, tiny. */
    TinyLedgeClimb,

    /** Climbing a ledge, small. */
    SmallLedgeClimb,

    /** Climbing a ledge, medium. */
    MediumLedgeClimb,

    /** Climbing a ledge, large. */
    LargeLedgeClimb,

    /** Climbing a ledge, huge. */
    HugeLedgeClimb,

    /** A wall jump, tiny. */
    TinyWallJump,

    /** A wall jump, small. */
    SmallWallJump,

    /** A wall jump, medium. */
    MediumWallJump,

    /** A wall jump, large. */
    LargeWallJump,

    /** A wall jump, huge. */
    HugeWallJump,

    /** A dodge, tiny. */
    TinyDodge,

    /** A dodge, small. */
    SmallDodge,

    /** A dodge, medium. */
    MediumDodge,

    /** A dodge, large. */
    LargeDodge,

    /** A dodge, huge. */
    HugeDodge,

    /** A block, tiny. */
    TinyBlock,

    /** A block, small. */
    SmallBlock,

    /** A block, medium. */
    MediumBlock,

    /** A block, large. */
    LargeBlock,

    /** A block, huge. */
    HugeBlock,

    /** A parry, tiny. */
    TinyParry,

    /** A parry, small. */
    SmallParry,

    /** A parry, medium. */
    MediumParry,

    /** A parry, large. */
    LargeParry,

    /** A parry, huge. */
    HugeParry,

    /** A grapple, tiny. */
    TinyGrapple,

    /** A grapple, small. */
    SmallGrapple,

    /** A grapple, medium. */
    MediumGrapple,

    /** A grapple, large. */
    LargeGrapple,

    /** A grapple, huge. */
    HugeGrapple,

    /** A crouch, tiny. */
    TinyCrouch,

    /** A crouch, small. */
    SmallCrouch,

    /** A crouch, medium. */
    MediumCrouch,

    /** A crouch, large. */
    LargeCrouch,

    /** A crouch, huge. */
    HugeCrouch,

    // Game rewards: things collected, from once to five times

    /** A gem collected, once. */
    SingleGem,

    /** A gem collected, twice. */
    DoubleGem,

    /** A gem collected, three times. */
    TripleGem,

    /** A gem collected, four times. */
    QuadrupleGem,

    /** A gem collected, five times. */
    QuintupleGem,

    /** A star collected, once. */
    SingleStar,

    /** A star collected, twice. */
    DoubleStar,

    /** A star collected, three times. */
    TripleStar,

    /** A star collected, four times. */
    QuadrupleStar,

    /** A star collected, five times. */
    QuintupleStar,

    /** A key collected, once. */
    SingleKey,

    /** A key collected, twice. */
    DoubleKey,

    /** A key collected, three times. */
    TripleKey,

    /** A key collected, four times. */
    QuadrupleKey,

    /** A key collected, five times. */
    QuintupleKey,

    /** A chest opened, once. */
    SingleChest,

    /** A chest opened, twice. */
    DoubleChest,

    /** A chest opened, three times. */
    TripleChest,

    /** A chest opened, four times. */
    QuadrupleChest,

    /** A chest opened, five times. */
    QuintupleChest,

    /** A heart collected, once. */
    SingleHeart,

    /** A heart collected, twice. */
    DoubleHeart,

    /** A heart collected, three times. */
    TripleHeart,

    /** A heart collected, four times. */
    QuadrupleHeart,

    /** A heart collected, five times. */
    QuintupleHeart,

    /** A trophy won, once. */
    SingleTrophy,

    /** A trophy won, twice. */
    DoubleTrophy,

    /** A trophy won, three times. */
    TripleTrophy,

    /** A trophy won, four times. */
    QuadrupleTrophy,

    /** A trophy won, five times. */
    QuintupleTrophy,

    /** A medal won, once. */
    SingleMedal,

    /** A medal won, twice. */
    DoubleMedal,

    /** A medal won, three times. */
    TripleMedal,

    /** A medal won, four times. */
    QuadrupleMedal,

    /** A medal won, five times. */
    QuintupleMedal,

    /** A token collected, once. */
    SingleToken,

    /** A token collected, twice. */
    DoubleToken,

    /** A token collected, three times. */
    TripleToken,

    /** A token collected, four times. */
    QuadrupleToken,

    /** A token collected, five times. */
    QuintupleToken,

    /** A crown won, once. */
    SingleCrown,

    /** A crown won, twice. */
    DoubleCrown,

    /** A crown won, three times. */
    TripleCrown,

    /** A crown won, four times. */
    QuadrupleCrown,

    /** A crown won, five times. */
    QuintupleCrown,

    /** A scroll found, once. */
    SingleScroll,

    /** A scroll found, twice. */
    DoubleScroll,

    /** A scroll found, three times. */
    TripleScroll,

    /** A scroll found, four times. */
    QuadrupleScroll,

    /** A scroll found, five times. */
    QuintupleScroll,

    // Random: a thousand drawn at random from a fixed seed, each listed with the built-in group it suits

    /** 4 taps over 217 ms. */
    EmberNebula,

    /** A tap and a hold over 91 ms. */
    MellowRhapsody,

    /** 2 taps and 8 holds over 1.3 s. */
    HollowComet,

    /** A tap and 7 holds over 831 ms. */
    MellowZephyr,

    /** 7 taps and 2 holds over 897 ms. */
    HazyWhisper,

    /** 2 taps and 3 holds over 763 ms. */
    MossyHarbor,

    /** A tap and a hold over 94 ms. */
    RubyBlossom,

    /** 8 taps and 2 holds over 1.2 s. */
    StormyHaven,

    /** A tap and a hold over 88 ms. */
    EmberThistle,

    /** 2 taps and 5 holds over 1.2 s. */
    GoldenQuartz,

    /** 4 taps over 338 ms. */
    CobaltLotus,

    /** 7 taps over 1.2 s. */
    SaffronEmberGlow,

    /** 6 taps and a hold over 1.8 s. */
    CrimsonDelta,

    /** 3 taps and 2 holds over 633 ms. */
    CosmicHaven,

    /** 3 taps and a hold over 190 ms. */
    LunarWren,

    /** 4 taps over 220 ms. */
    CobaltStarling,

    /** 2 taps and 2 holds over 241 ms. */
    IvoryMeadow,

    /** 3 taps and a hold over 182 ms. */
    GlacialBlueCascade,

    /** 4 taps over 219 ms. */
    ZestySaga,

    /** 8 taps over 1.2 s. */
    ZestyVortex,

    /** 2 taps and 2 holds over 238 ms. */
    GlacialBlueVortex,

    /** 3 taps and a hold over 181 ms. */
    VioletKite,

    /** 4 taps and 7 holds over 873 ms. */
    CobaltFjord,

    /** 4 holds over 197 ms. */
    MellowLighthouse,

    /** 2 taps and a hold over 545 ms. */
    PastelOasis,

    /** 3 taps over 253 ms. */
    WovenReef,

    /** 6 holds over 913 ms. */
    ObsidianVale,

    /** 9 taps over 2.2 s. */
    ObsidianFable,

    /** 6 taps over 356 ms. */
    PrismMonsoon,

    /** 5 taps and 2 holds over 826 ms. */
    SolarNimbus,

    /** A tap and 3 holds over 1.0 s. */
    RusticLighthouse,

    /** 4 taps and 4 holds over 1.6 s. */
    MistyVortex,

    /** 3 taps and a hold over 375 ms. */
    AshenStarling,

    /** 6 holds over 731 ms. */
    NeonWillow,

    /** 2 taps and 2 holds over 1.0 s. */
    VelvetJuniper,

    /** 3 taps and 3 holds over 1.4 s. */
    EmeraldThistle,

    /** 4 taps and 2 holds over 605 ms. */
    AzureOasis,

    /** 4 taps and a hold over 349 ms. */
    CopperWhisper,

    /** 5 taps over 547 ms. */
    TwilightJuniper,

    /** 6 taps and 2 holds over 879 ms. */
    SolarQuasar,

    /** A tap and 2 holds over 368 ms. */
    PrismOrchid,

    /** 2 taps over 88 ms. */
    VelvetWhisper,

    /** 8 taps and a hold over 1.5 s. */
    CosmicJuniper,

    /** A tap and 2 holds over 211 ms. */
    HazyMarble,

    /** A tap and a hold over 241 ms. */
    EmberJubilee,

    /** 6 taps over 1.3 s. */
    ObsidianFjord,

    /** 5 taps and 2 holds over 863 ms. */
    OpalLagoon,

    /** 3 taps and 5 holds over 1.4 s. */
    JaggedNimbus,

    /** 3 taps over 102 ms. */
    DappledLantern,

    /** 5 taps over 835 ms. */
    OchreSparrow,

    /** 4 taps over 163 ms. */
    CrimsonTalisman,

    /** 3 taps over 127 ms. */
    WovenDune,

    /** 5 taps and a hold over 489 ms. */
    AmberNebula,

    /** 6 taps and 3 holds over 1.9 s. */
    CosmicThistle,

    /** 3 taps and a hold over 746 ms. */
    MellowAtlas,

    /** 5 taps and 4 holds over 1.1 s. */
    HollowBlossom,

    /** 2 taps and 7 holds over 1.1 s. */
    CobaltOasis,

    /** 4 taps over 588 ms. */
    FeralHarbor,

    /** 2 taps and 3 holds over 1.0 s. */
    PaleUtopia,

    /** 5 taps and a hold over 940 ms. */
    FeralWren,

    /** A tap and 3 holds over 827 ms. */
    ObsidianOrchid,

    /** 4 taps and 3 holds over 810 ms. */
    AzureZephyr,

    /** 3 taps and a hold over 152 ms. */
    IndigoWren,

    /** 2 holds over 122 ms. */
    JadeVale,

    /** A tap and 10 holds over 1.3 s. */
    MistyVale,

    /** 3 taps over 103 ms. */
    SaffronKite,

    /** 4 taps and 2 holds over 632 ms. */
    WovenWren,

    /** 4 taps over 631 ms. */
    BronzeHarbor,

    /** 6 taps and a hold over 908 ms. */
    IndigoOrchid,

    /** 5 taps and 4 holds over 2.0 s. */
    ScarletMarble,

    /** 3 taps and a hold over 654 ms. */
    SilverZephyr,

    /** 3 taps and 6 holds over 1.0 s. */
    GildedOasis,

    /** 6 taps and 3 holds over 1.5 s. */
    TwilightWhisper,

    /** 5 taps and a hold over 942 ms. */
    EmeraldQuartz,

    /** 4 taps over 204 ms. */
    BronzeQuartz,

    /** 3 taps and 3 holds over 886 ms. */
    LuckyMonsoon,

    /** 3 taps and 6 holds over 712 ms. */
    CobaltLighthouse,

    /** A tap and 3 holds over 530 ms. */
    RubyMarble,

    /** 7 taps and a hold over 746 ms. */
    PaleLagoon,

    /** 6 taps and 3 holds over 1.4 s. */
    DappledLotus,

    /** 6 taps over 1.4 s. */
    GoldenQuill,

    /** 4 taps and 2 holds over 1.2 s. */
    SableMirage,

    /** A tap and 2 holds over 521 ms. */
    UmberHorizon,

    /** 2 taps and a hold over 436 ms. */
    PaleDelta,

    /** 6 taps and 2 holds over 1.5 s. */
    ElectricMirage,

    /** 6 taps over 519 ms. */
    JadePinnacle,

    /** 2 taps over 86 ms. */
    JadeNimbus,

    /** 5 taps and 2 holds over 1.1 s. */
    HollowTundra,

    /** A tap and a hold over 331 ms. */
    EmberComet,

    /** 5 taps and a hold over 733 ms. */
    MistyLotus,

    /** 2 taps and 7 holds over 1.1 s. */
    NobleLotus,

    /** 3 taps over 107 ms. */
    RubyHorizon,

    /** 4 taps and 7 holds over 1.1 s. */
    CopperThistle,

    /** 2 taps and 9 holds over 1.4 s. */
    RubyTalisman,

    /** 2 taps over 85 ms. */
    CobaltQuartz,

    /** 6 taps and 2 holds over 598 ms. */
    DappledTundra,

    /** 5 taps and 2 holds over 1.2 s. */
    WovenPrairie,

    /** 7 taps over 1.3 s. */
    RubyWren,

    /** 4 taps and a hold over 401 ms. */
    HazyHorizon,

    /** 2 taps and 3 holds over 511 ms. */
    IndigoUtopia,

    /** 3 taps and a hold over 184 ms. */
    AshenLotus,

    /** A tap and 4 holds over 1.3 s. */
    SilverPinnacle,

    /** 2 taps and 7 holds over 1.1 s. */
    PastelPrairie,

    /** 3 taps and a hold over 181 ms. */
    GoldenPebble,

    /** 2 taps and a hold over 173 ms. */
    VividOrchid,

    /** 3 taps and 2 holds over 561 ms. */
    GildedHarbor,

    /** 2 taps over 90 ms. */
    ZestyMosaic,

    /** 3 holds over 617 ms. */
    AzureQuartz,

    /** 2 taps and 10 holds over 1.6 s. */
    PastelVale,

    /** 9 taps and a hold over 1.1 s. */
    OpalGalaxy,

    /** 4 taps over 212 ms. */
    VividTalisman,

    /** 4 taps and 2 holds over 896 ms. */
    LunarUtopia,

    /** 6 taps over 966 ms. */
    EmeraldLotus,

    /** 6 taps and 2 holds over 1.2 s. */
    VividSonnet,

    /** 2 taps over 83 ms. */
    MistyPebble,

    /** 4 holds over 738 ms. */
    AmberPinnacle,

    /** 12 holds over 1.7 s. */
    SableLagoon,

    /** 3 taps over 124 ms. */
    FrostyMonsoon,

    /** 4 taps and 6 holds over 803 ms. */
    VioletQuill,

    /** 5 taps over 467 ms. */
    ElectricOasis,

    /** 5 taps over 478 ms. */
    OpalFjord,

    /** 7 taps and 3 holds over 1.1 s. */
    FeralNimbus,

    /** A tap and 3 holds over 397 ms. */
    VividIris,

    /** 7 taps and 3 holds over 991 ms. */
    SwiftPinnacle,

    /** 2 taps over 81 ms. */
    RusticLagoon,

    /** 5 taps and 2 holds over 1.4 s. */
    VividReef,

    /** 4 taps and 2 holds over 843 ms. */
    VividSaga,

    /** 3 taps and 6 holds over 1.2 s. */
    VelvetSaga,

    /** 3 taps and a hold over 219 ms. */
    FeralFable,

    /** 4 taps over 645 ms. */
    NobleSpire,

    /** 3 taps and 4 holds over 1.1 s. */
    DappledHarbor,

    /** 7 taps over 1.2 s. */
    StormyOrchid,

    /** 4 taps and 3 holds over 577 ms. */
    TidalFable,

    /** 3 taps over 96 ms. */
    OpalHorizon,

    /** 4 taps and 3 holds over 1.2 s. */
    PaleLantern,

    /** 2 taps and 7 holds over 1.0 s. */
    DuskyMarble,

    /** 3 taps over 200 ms. */
    EmeraldTundra,

    /** 2 taps over 42 ms. */
    SaffronHaven,

    /** 6 taps over 1.5 s. */
    WovenMirage,

    /** 8 taps and 2 holds over 1.4 s. */
    ObsidianQuasar,

    /** 2 taps over 93 ms. */
    WovenLighthouse,

    /** 3 taps and a hold over 204 ms. */
    ElectricLighthouse,

    /** 5 taps and a hold over 1.1 s. */
    SilverAtlas,

    /** A tap and 5 holds over 897 ms. */
    MellowWren,

    /** 5 taps and a hold over 540 ms. */
    DappledMarble,

    /** 6 taps and a hold over 957 ms. */
    UmberFable,

    /** A tap and 11 holds over 1.4 s. */
    StormyTalisman,

    /** 2 taps and a hold over 377 ms. */
    LuckyStarling,

    /** A tap and a hold over 54 ms. */
    SilverAnchor,

    /** 4 taps and 3 holds over 939 ms. */
    BronzeRhapsody,

    /** 4 taps over 415 ms. */
    WildTalisman,

    /** 3 taps and a hold over 173 ms. */
    FeralSparrow,

    /** A tap and 9 holds over 1.3 s. */
    MistyHarbor,

    /** 3 taps and 4 holds over 731 ms. */
    MellowEmberGlow,

    /** 5 taps and a hold over 404 ms. */
    CobaltZenith,

    /** A tap and 7 holds over 886 ms. */
    TwilightMarble,

    /** 6 taps and 2 holds over 1.6 s. */
    DappledYarrow,

    /** 3 taps and 2 holds over 706 ms. */
    HollowQuill,

    /** 3 taps and 5 holds over 706 ms. */
    AshenEmberGlow,

    /** 3 taps and a hold over 442 ms. */
    LuckyWillow,

    /** A tap and 9 holds over 1.3 s. */
    JaggedHaven,

    /** 3 taps and 2 holds over 832 ms. */
    TidalTalisman,

    /** 5 taps and 5 holds over 753 ms. */
    LunarMarble,

    /** 5 taps and 4 holds over 1.6 s. */
    SunlitMonsoon,

    /** 4 holds over 770 ms. */
    ZestyAtlas,

    /** 3 taps and a hold over 287 ms. */
    NeonWren,

    /** 3 taps and a hold over 179 ms. */
    RubyLighthouse,

    /** 7 taps and 3 holds over 588 ms. */
    SolarOasis,

    /** 10 taps over 882 ms. */
    FeralJuniper,

    /** 2 taps over 45 ms. */
    EmeraldGalaxy,

    /** 3 taps and 5 holds over 1.9 s. */
    SolarQuill,

    /** 2 taps and a hold over 570 ms. */
    SaffronPebble,

    /** 5 taps and a hold over 811 ms. */
    CobaltZephyr,

    /** 6 taps and 6 holds over 954 ms. */
    GildedMeadow,

    /** 5 taps and 7 holds over 1.0 s. */
    VioletYarrow,

    /** 3 taps and a hold over 495 ms. */
    VelvetHarbor,

    /** A tap and 2 holds over 658 ms. */
    IvoryKite,

    /** 3 taps and 2 holds over 873 ms. */
    UmberGalaxy,

    /** 6 taps and 4 holds over 871 ms. */
    EmeraldEmberGlow,

    /** 2 taps and a hold over 338 ms. */
    SaffronLantern,

    /** 5 holds over 513 ms. */
    MellowIris,

    /** 3 taps and 8 holds over 1.2 s. */
    EmeraldPrairie,

    /** 3 taps and a hold over 620 ms. */
    TwilightSpire,

    /** 5 taps over 1.0 s. */
    BronzeVortex,

    /** 4 taps and 2 holds over 740 ms. */
    ElectricLagoon,

    /** 2 taps and a hold over 164 ms. */
    NobleMarble,

    /** 4 taps and 2 holds over 551 ms. */
    WildPebble,

    /** A tap and 4 holds over 903 ms. */
    VioletLantern,

    /** 4 taps and 2 holds over 714 ms. */
    HazyLotus,

    /** 6 taps and 2 holds over 1.2 s. */
    SaffronZephyr,

    /** 7 taps and 2 holds over 860 ms. */
    JaggedGalaxy,

    /** 5 taps and 3 holds over 1.1 s. */
    CrimsonIris,

    /** 6 taps and 2 holds over 1.8 s. */
    AshenPebble,

    /** 3 taps over 276 ms. */
    FrostyTalisman,

    /** 3 taps and a hold over 213 ms. */
    CosmicGlacier,

    /** 6 holds over 818 ms. */
    WildIris,

    /** 4 taps and a hold over 861 ms. */
    ArcticThistle,

    /** 4 taps and 2 holds over 804 ms. */
    IvoryTundra,

    /** 5 taps over 549 ms. */
    CobaltQuasar,

    /** A tap and a hold over 135 ms. */
    PastelZenith,

    /** 2 taps and 8 holds over 1.1 s. */
    VelvetFable,

    /** 4 taps and 3 holds over 1.1 s. */
    IndigoKestrel,

    /** 4 taps and 3 holds over 1.1 s. */
    FeralKite,

    /** 2 taps over 58 ms. */
    WildSpire,

    /** 2 taps over 40 ms. */
    OpalJubilee,

    /** 4 taps and 3 holds over 618 ms. */
    AshenWillow,

    /** 2 taps and 10 holds over 1.4 s. */
    MellowCascade,

    /** 2 taps and 3 holds over 607 ms. */
    LunarLagoon,

    /** 3 taps over 448 ms. */
    VividQuartz,

    /** 2 taps and 3 holds over 749 ms. */
    MellowWhisper,

    /** 6 taps over 464 ms. */
    MossySaga,

    /** 2 taps over 77 ms. */
    TealOasis,

    /** 4 taps and a hold over 452 ms. */
    NeonHaven,

    /** A tap and 5 holds over 911 ms. */
    SableZephyr,

    /** 7 taps and 2 holds over 734 ms. */
    CopperNimbus,

    /** 3 taps over 301 ms. */
    SunlitWren,

    /** A tap and a hold over 49 ms. */
    AzureSonnet,

    /** 2 taps and 4 holds over 909 ms. */
    PrismQuasar,

    /** 9 taps over 1.4 s. */
    ElectricYarrow,

    /** 4 taps and a hold over 487 ms. */
    MistyKite,

    /** A tap and 4 holds over 450 ms. */
    MossyLighthouse,

    /** 2 taps over 58 ms. */
    HollowGlacier,

    /** 4 taps over 164 ms. */
    AmberLantern,

    /** 3 taps and 3 holds over 691 ms. */
    IvoryMonsoon,

    /** 2 taps and 10 holds over 1.3 s. */
    ElectricNimbus,

    /** 2 taps and 2 holds over 192 ms. */
    TwilightEmberGlow,

    /** 2 taps and 2 holds over 240 ms. */
    UmberHarbor,

    /** 8 taps and a hold over 1.3 s. */
    CobaltRhapsody,

    /** 5 taps and a hold over 993 ms. */
    PrismNimbus,

    /** 2 taps and 2 holds over 676 ms. */
    WildAnchor,

    /** 4 taps and a hold over 826 ms. */
    AzureTundra,

    /** 2 taps and a hold over 384 ms. */
    NeonGlacier,

    /** A tap and 7 holds over 1.0 s. */
    UmberMeadow,

    /** 9 taps and a hold over 984 ms. */
    OpalVortex,

    /** 4 taps and a hold over 566 ms. */
    ScarletCanyon,

    /** 5 taps and 2 holds over 1.1 s. */
    ArcticTundra,

    /** 2 taps and 3 holds over 876 ms. */
    JaggedFjord,

    /** 4 taps and a hold over 456 ms. */
    AmberWhisper,

    /** 3 taps and a hold over 545 ms. */
    PaleThistle,

    /** 6 taps and 2 holds over 913 ms. */
    HazyTundra,

    /** A tap and 5 holds over 971 ms. */
    GlacialBlueQuill,

    /** 3 taps and a hold over 388 ms. */
    DuskyYarrow,

    /** A tap and 7 holds over 922 ms. */
    DuskyMeadow,

    /** 5 taps and 4 holds over 810 ms. */
    CoralNebula,

    /** 4 taps and 5 holds over 1.8 s. */
    CopperSparrow,

    /** 8 taps over 856 ms. */
    GlacialBlueMosaic,

    /** 5 taps and 4 holds over 573 ms. */
    ElectricMonsoon,

    /** 3 taps and a hold over 282 ms. */
    PaleMirage,

    /** 9 taps and a hold over 1.4 s. */
    CoralDriftwood,

    /** 4 taps over 352 ms. */
    IndigoLighthouse,

    /** 4 taps over 579 ms. */
    SableAtlas,

    /** 6 taps and 2 holds over 815 ms. */
    WistfulLantern,

    /** 5 taps and 2 holds over 667 ms. */
    AmberOrchid,

    /** 4 taps over 880 ms. */
    MistyKestrel,

    /** A tap and 2 holds over 498 ms. */
    DappledWren,

    /** 3 taps and a hold over 260 ms. */
    GlacialBlueLantern,

    /** 2 taps and 9 holds over 1.6 s. */
    SolarThistle,

    /** 3 taps and 3 holds over 1.2 s. */
    AmberZephyr,

    /** 3 taps and 9 holds over 1.3 s. */
    SolarDriftwood,

    /** 4 taps over 278 ms. */
    HollowQuartz,

    /** 5 taps and a hold over 564 ms. */
    IvoryNebula,

    /** A tap and 3 holds over 409 ms. */
    EmeraldKite,

    /** 2 taps and 7 holds over 1.2 s. */
    FrostyLighthouse,

    /** 5 taps and a hold over 994 ms. */
    JadeGalaxy,

    /** 3 taps over 108 ms. */
    RusticReef,

    /** 2 taps over 128 ms. */
    SwiftUtopia,

    /** 3 taps over 163 ms. */
    VioletHaven,

    /** 3 taps and a hold over 614 ms. */
    MistyQuasar,

    /** 7 taps and 3 holds over 1.3 s. */
    ScarletSparrow,

    /** 2 taps and 3 holds over 375 ms. */
    WistfulComet,

    /** A tap and 8 holds over 1.1 s. */
    ScarletBlossom,

    /** 7 taps and 2 holds over 2.1 s. */
    SaffronComet,

    /** A tap and 2 holds over 233 ms. */
    TidalPrairie,

    /** 2 taps and 2 holds over 643 ms. */
    CoralStarling,

    /** 6 taps over 1.5 s. */
    JaggedDune,

    /** 4 taps and 2 holds over 946 ms. */
    CopperRhapsody,

    /** 5 taps and 5 holds over 947 ms. */
    RusticHorizon,

    /** 5 taps over 538 ms. */
    CrimsonDriftwood,

    /** 2 taps and a hold over 143 ms. */
    PrismTalisman,

    /** 3 taps and 5 holds over 634 ms. */
    NeonReef,

    /** 2 taps and a hold over 547 ms. */
    RusticUtopia,

    /** 8 taps over 1.4 s. */
    NobleQuartz,

    /** A tap and 2 holds over 205 ms. */
    ElectricFable,

    /** 2 taps and 5 holds over 729 ms. */
    StormyCanyon,

    /** 2 taps and a hold over 183 ms. */
    FrostyLotus,

    /** 3 taps and 4 holds over 1.1 s. */
    GildedQuartz,

    /** 4 taps over 159 ms. */
    BronzeWren,

    /** 4 taps over 882 ms. */
    GildedQuill,

    /** A tap and 3 holds over 749 ms. */
    PastelGlacier,

    /** 5 taps over 472 ms. */
    NobleFjord,

    /** 2 taps and 2 holds over 503 ms. */
    ArcticJuniper,

    /** 5 taps and 2 holds over 1.2 s. */
    TwilightPinnacle,

    /** 2 taps and 2 holds over 249 ms. */
    SableJuniper,

    /** 4 taps and 2 holds over 929 ms. */
    JadeCascade,

    /** 2 taps and 2 holds over 234 ms. */
    ScarletQuartz,

    /** 4 taps and a hold over 428 ms. */
    ArcticIris,

    /** 2 taps over 65 ms. */
    MellowZenith,

    /** 3 taps and 2 holds over 1.2 s. */
    MellowAnchor,

    /** 3 taps and 3 holds over 603 ms. */
    FeralIris,

    /** A tap and a hold over 149 ms. */
    PrismLighthouse,

    /** 4 taps and 3 holds over 531 ms. */
    PrismOasis,

    /** 4 taps and 2 holds over 1.0 s. */
    TidalEmberGlow,

    /** 4 taps over 294 ms. */
    GoldenIris,

    /** A tap and 2 holds over 326 ms. */
    IvoryDune,

    /** A tap and 9 holds over 1.5 s. */
    JaggedSaga,

    /** 3 taps and a hold over 621 ms. */
    WistfulFable,

    /** 8 taps over 1.3 s. */
    EmberVale,

    /** 7 taps over 904 ms. */
    DuskyLotus,

    /** 5 taps and a hold over 785 ms. */
    GlacialBlueGalaxy,

    /** A tap and 3 holds over 898 ms. */
    SableHaven,

    /** 3 taps and 2 holds over 712 ms. */
    SablePrairie,

    /** 3 taps and a hold over 182 ms. */
    UmberThistle,

    /** A tap and 9 holds over 1.3 s. */
    WovenKestrel,

    /** 5 taps and 5 holds over 774 ms. */
    TidalDelta,

    /** 5 taps and 3 holds over 1.4 s. */
    SunlitHaven,

    /** 3 taps and a hold over 179 ms. */
    EmberFable,

    /** 2 taps over 38 ms. */
    BronzeMeadow,

    /** 3 taps over 110 ms. */
    NobleAnchor,

    /** 2 taps and 2 holds over 694 ms. */
    SableReef,

    /** 6 taps over 729 ms. */
    PastelRhapsody,

    /** 2 taps and a hold over 437 ms. */
    FeralVortex,

    /** 3 taps over 223 ms. */
    CosmicFjord,

    /** 2 taps and a hold over 403 ms. */
    TwilightQuasar,

    /** 3 taps over 124 ms. */
    JadeSaga,

    /** 6 taps and a hold over 961 ms. */
    VividWillow,

    /** 3 taps over 80 ms. */
    OpalOasis,

    /** 3 taps and 7 holds over 903 ms. */
    SwiftNebula,

    /** 9 holds over 1.1 s. */
    CopperMeadow,

    /** 2 taps and 4 holds over 433 ms. */
    DuskyGalaxy,

    /** A tap and 2 holds over 322 ms. */
    PrismMosaic,

    /** A tap and 3 holds over 431 ms. */
    EmberSparrow,

    /** 5 taps and 5 holds over 1.0 s. */
    CopperJubilee,

    /** 3 taps and 2 holds over 486 ms. */
    WistfulTalisman,

    /** 4 taps and a hold over 243 ms. */
    RusticHarbor,

    /** 2 taps and 2 holds over 392 ms. */
    AzurePebble,

    /** 2 holds over 319 ms. */
    ObsidianSparrow,

    /** A tap and 10 holds over 1.5 s. */
    TealMosaic,

    /** 5 taps and 4 holds over 1.7 s. */
    MossyJuniper,

    /** 8 taps and 2 holds over 1.0 s. */
    SunlitZephyr,

    /** 4 taps and 4 holds over 2.0 s. */
    VelvetSparrow,

    /** 3 taps and a hold over 262 ms. */
    VioletCascade,

    /** 9 taps and a hold over 1.3 s. */
    VioletWren,

    /** A tap and 3 holds over 525 ms. */
    CosmicWren,

    /** 2 holds over 127 ms. */
    SunlitWhisper,

    /** 2 taps and a hold over 142 ms. */
    VioletPebble,

    /** 5 taps over 634 ms. */
    LunarOasis,

    /** 3 holds over 241 ms. */
    NobleEmberGlow,

    /** 6 taps and 3 holds over 1.8 s. */
    AshenVortex,

    /** A tap and a hold over 157 ms. */
    ElectricZenith,

    /** 5 taps and 2 holds over 1.0 s. */
    LunarFable,

    /** 5 taps and 5 holds over 923 ms. */
    AshenJubilee,

    /** 5 taps and 2 holds over 468 ms. */
    NeonZenith,

    /** 7 taps and 2 holds over 1.2 s. */
    RubyPebble,

    /** A tap and 4 holds over 562 ms. */
    AshenHarbor,

    /** 4 taps and 5 holds over 796 ms. */
    GlacialBlueThistle,

    /** 3 taps over 89 ms. */
    SunlitFable,

    /** 2 taps and 10 holds over 1.5 s. */
    OchrePrairie,

    /** 3 taps and a hold over 191 ms. */
    ElectricAnchor,

    /** 2 taps and a hold over 362 ms. */
    GoldenSparrow,

    /** A tap and a hold over 141 ms. */
    SaffronWhisper,

    /** 2 taps and 3 holds over 1.2 s. */
    TwilightNebula,

    /** 5 taps and a hold over 635 ms. */
    GildedKestrel,

    /** 2 taps and a hold over 129 ms. */
    MellowFable,

    /** A tap and a hold over 114 ms. */
    WistfulCanyon,

    /** 2 taps and 3 holds over 1.2 s. */
    SunlitLighthouse,

    /** 4 taps and 3 holds over 1.2 s. */
    EmberDelta,

    /** A tap and 3 holds over 502 ms. */
    FeralDriftwood,

    /** 3 taps and 6 holds over 2.1 s. */
    VividKite,

    /** 4 taps over 537 ms. */
    VividTundra,

    /** A tap and 9 holds over 1.4 s. */
    AzureMarble,

    /** A tap and 2 holds over 163 ms. */
    JadeZenith,

    /** 2 holds over 112 ms. */
    IvorySparrow,

    /** 3 taps over 220 ms. */
    VelvetQuasar,

    /** 2 taps and 4 holds over 704 ms. */
    BronzeEmberGlow,

    /** 4 taps and 3 holds over 1.2 s. */
    BronzeLantern,

    /** 7 taps and 2 holds over 1.3 s. */
    GildedDriftwood,

    /** 7 taps and a hold over 1.8 s. */
    JaggedStarling,

    /** 3 taps over 86 ms. */
    IndigoMonsoon,

    /** 3 taps and a hold over 697 ms. */
    GildedJuniper,

    /** 2 taps and 4 holds over 655 ms. */
    AmberCanyon,

    /** 3 taps and 2 holds over 710 ms. */
    HazyPrairie,

    /** 4 taps over 557 ms. */
    AshenWhisper,

    /** 4 taps and 2 holds over 959 ms. */
    ElectricHaven,

    /** 7 taps over 1.4 s. */
    WovenQuill,

    /** A tap and 4 holds over 861 ms. */
    LuckyLantern,

    /** 4 taps and a hold over 384 ms. */
    StormySonnet,

    /** 2 taps and 3 holds over 848 ms. */
    LunarSpire,

    /** A tap and 4 holds over 600 ms. */
    HazyQuasar,

    /** 8 taps and a hold over 619 ms. */
    PrismZephyr,

    /** 5 taps and 2 holds over 1.1 s. */
    WistfulMosaic,

    /** 8 taps over 789 ms. */
    BronzeHorizon,

    /** 4 taps and a hold over 467 ms. */
    TidalWhisper,

    /** 2 taps and 2 holds over 547 ms. */
    VividMarble,

    /** 3 taps and 3 holds over 1.1 s. */
    NeonAtlas,

    /** 2 taps and 4 holds over 1.0 s. */
    TidalNimbus,

    /** 5 taps over 657 ms. */
    WovenCanyon,

    /** 3 taps over 130 ms. */
    PastelSaga,

    /** A tap and a hold over 119 ms. */
    FeralNebula,

    /** 2 taps and a hold over 375 ms. */
    WildWhisper,

    /** 2 taps and 10 holds over 1.3 s. */
    SaffronOasis,

    /** 8 taps over 1.2 s. */
    WistfulVortex,

    /** 6 taps and a hold over 398 ms. */
    MossyCanyon,

    /** 2 taps and a hold over 217 ms. */
    HazyEmberGlow,

    /** 2 taps and 7 holds over 713 ms. */
    HazyMirage,

    /** 3 taps and 4 holds over 1.1 s. */
    EmberWhisper,

    /** 2 taps and a hold over 410 ms. */
    PrismRhapsody,

    /** 7 taps over 1.1 s. */
    ScarletSpire,

    /** 7 taps over 475 ms. */
    SableOasis,

    /** 2 taps and a hold over 458 ms. */
    IvoryGlacier,

    /** 3 taps over 85 ms. */
    SwiftSpire,

    /** 7 taps and a hold over 845 ms. */
    SilverBlossom,

    /** 3 taps and 2 holds over 275 ms. */
    SableTalisman,

    /** 2 taps and 10 holds over 1.6 s. */
    IvoryPrairie,

    /** 6 taps and a hold over 858 ms. */
    GoldenLantern,

    /** 5 taps and a hold over 568 ms. */
    EmberLantern,

    /** 4 taps and 2 holds over 583 ms. */
    CrimsonAnchor,

    /** 3 taps and a hold over 879 ms. */
    WildMonsoon,

    /** 2 taps and 2 holds over 770 ms. */
    StormyQuartz,

    /** 4 taps and a hold over 542 ms. */
    GildedIris,

    /** 2 taps and 5 holds over 993 ms. */
    FrostyMosaic,

    /** 4 taps and 2 holds over 1.2 s. */
    JaggedKestrel,

    /** A tap and 6 holds over 743 ms. */
    RusticSpire,

    /** 3 taps and a hold over 318 ms. */
    ObsidianUtopia,

    /** 4 taps and 5 holds over 1.9 s. */
    SunlitTundra,

    /** 4 taps and a hold over 496 ms. */
    CoralCanyon,

    /** 11 holds over 1.5 s. */
    CopperGalaxy,

    /** 4 taps and 4 holds over 781 ms. */
    MistyYarrow,

    /** 5 taps and a hold over 839 ms. */
    VividHaven,

    /** 3 taps and 4 holds over 706 ms. */
    MossyHaven,

    /** 5 taps and 4 holds over 737 ms. */
    SilverUtopia,

    /** 4 taps over 723 ms. */
    PrismUtopia,

    /** 5 taps and 3 holds over 1.4 s. */
    ScarletNimbus,

    /** A tap and 2 holds over 218 ms. */
    PastelComet,

    /** 2 taps and 2 holds over 228 ms. */
    UmberIris,

    /** 2 taps over 89 ms. */
    FrostyNimbus,

    /** 3 taps and a hold over 599 ms. */
    PastelSparrow,

    /** 3 taps over 157 ms. */
    UmberHaven,

    /** 3 taps over 106 ms. */
    IvoryLotus,

    /** 4 taps and a hold over 631 ms. */
    CobaltWhisper,

    /** 2 taps over 65 ms. */
    NeonVale,

    /** 3 taps and a hold over 570 ms. */
    OpalTundra,

    /** 7 taps and 2 holds over 634 ms. */
    SolarIris,

    /** 2 taps and 7 holds over 1.2 s. */
    AzureUtopia,

    /** 11 holds over 1.6 s. */
    DuskyVale,

    /** 5 taps and a hold over 955 ms. */
    JadeAtlas,

    /** A tap and 3 holds over 219 ms. */
    PrismPinnacle,

    /** 8 taps and 2 holds over 1.2 s. */
    NobleYarrow,

    /** A tap and 2 holds over 364 ms. */
    VelvetYarrow,

    /** 3 taps and a hold over 654 ms. */
    HazyFable,

    /** 5 taps and a hold over 916 ms. */
    TidalHaven,

    /** 3 taps over 288 ms. */
    MistyUtopia,

    /** 2 taps and 2 holds over 270 ms. */
    RusticPinnacle,

    /** 6 taps over 457 ms. */
    OchreNimbus,

    /** 5 taps and 2 holds over 873 ms. */
    TwilightZephyr,

    /** A tap and 2 holds over 208 ms. */
    MistySaga,

    /** 2 taps and 7 holds over 921 ms. */
    HollowLantern,

    /** 2 taps and a hold over 113 ms. */
    SableIris,

    /** 4 taps over 697 ms. */
    LunarHarbor,

    /** 2 taps over 118 ms. */
    LuckyDriftwood,

    /** 3 taps and 2 holds over 941 ms. */
    WistfulLagoon,

    /** 4 taps and a hold over 475 ms. */
    CopperOrchid,

    /** 2 taps over 88 ms. */
    NeonLotus,

    /** 2 taps over 41 ms. */
    ScarletGalaxy,

    /** 5 holds over 712 ms. */
    VividJubilee,

    /** 2 taps over 37 ms. */
    WildLantern,

    /** 5 taps and 3 holds over 676 ms. */
    OpalBlossom,

    /** A tap and 9 holds over 1.3 s. */
    SaffronOrchid,

    /** 4 taps and 3 holds over 1.3 s. */
    VelvetLantern,

    /** 3 taps and 3 holds over 431 ms. */
    BronzeQuill,

    /** 5 taps and 3 holds over 672 ms. */
    SolarSparrow,

    /** 4 taps over 206 ms. */
    MellowJubilee,

    /** 2 taps and 3 holds over 428 ms. */
    FrostyPebble,

    /** 4 taps and a hold over 632 ms. */
    ZestyHarbor,

    /** 8 taps over 1.3 s. */
    SaffronGalaxy,

    /** 2 taps and a hold over 110 ms. */
    ZestyLantern,

    /** A tap and 3 holds over 665 ms. */
    DuskyJubilee,

    /** 4 taps and 2 holds over 814 ms. */
    GildedTalisman,

    /** 7 taps and 2 holds over 1.3 s. */
    RubyFjord,

    /** 2 taps and 4 holds over 1.4 s. */
    SunlitRhapsody,

    /** 3 taps and 4 holds over 1.4 s. */
    TidalYarrow,

    /** 4 taps and 2 holds over 844 ms. */
    TwilightDelta,

    /** 2 taps over 54 ms. */
    SableZenith,

    /** 5 taps and a hold over 508 ms. */
    JaggedQuasar,

    /** A tap and 4 holds over 574 ms. */
    JadeUtopia,

    /** 4 holds over 597 ms. */
    NeonDriftwood,

    /** 8 taps and 2 holds over 1.1 s. */
    IndigoThistle,

    /** 5 taps and a hold over 625 ms. */
    GildedEmberGlow,

    /** 2 taps and 2 holds over 546 ms. */
    VioletRhapsody,

    /** 4 taps and 2 holds over 911 ms. */
    SableJubilee,

    /** 5 taps and 4 holds over 1.5 s. */
    HollowSparrow,

    /** 2 taps and 5 holds over 1.4 s. */
    AshenCanyon,

    /** 3 taps and 2 holds over 687 ms. */
    ZestyJuniper,

    /** 6 taps and a hold over 1.2 s. */
    NeonGalaxy,

    /** 3 taps over 261 ms. */
    NobleOrchid,

    /** 3 taps and 2 holds over 626 ms. */
    CosmicQuasar,

    /** 2 taps and a hold over 141 ms. */
    UmberTundra,

    /** 3 taps and a hold over 299 ms. */
    RusticFjord,

    /** 2 taps and 2 holds over 866 ms. */
    ObsidianLantern,

    /** A tap and a hold over 105 ms. */
    WovenFable,

    /** 3 taps and 2 holds over 807 ms. */
    MossyQuasar,

    /** 6 taps and 3 holds over 696 ms. */
    WovenAtlas,

    /** 2 taps over 68 ms. */
    CobaltHorizon,

    /** 9 taps over 1.2 s. */
    EmberQuartz,

    /** 3 taps and a hold over 554 ms. */
    SableDune,

    /** 4 taps over 371 ms. */
    LunarHorizon,

    /** 6 taps and 3 holds over 1.4 s. */
    JadeJubilee,

    /** 8 taps and a hold over 1.2 s. */
    TealNimbus,

    /** 9 taps over 1.4 s. */
    SunlitComet,

    /** 3 taps over 276 ms. */
    SilverOasis,

    /** 2 taps and 4 holds over 1.1 s. */
    CopperYarrow,

    /** 2 taps and a hold over 303 ms. */
    ObsidianLagoon,

    /** 4 taps and a hold over 618 ms. */
    OchreMosaic,

    /** 4 taps and a hold over 968 ms. */
    CosmicPebble,

    /** A tap and 5 holds over 557 ms. */
    DappledTalisman,

    /** 6 taps and a hold over 1.4 s. */
    MistyWillow,

    /** 8 taps and a hold over 2.1 s. */
    MossyFjord,

    /** 5 taps and 4 holds over 1.6 s. */
    NobleLagoon,

    /** 2 taps and a hold over 390 ms. */
    StormyDelta,

    /** 5 taps and a hold over 445 ms. */
    MossyDune,

    /** 5 taps and a hold over 805 ms. */
    UmberNimbus,

    /** A tap and 8 holds over 1.1 s. */
    CopperSpire,

    /** 5 taps and a hold over 708 ms. */
    FeralSaga,

    /** 2 taps and 9 holds over 1.2 s. */
    LuckyIris,

    /** 5 taps and 6 holds over 1.2 s. */
    UmberSonnet,

    /** 4 taps and 2 holds over 778 ms. */
    WovenPebble,

    /** 4 taps and 3 holds over 1.0 s. */
    SolarSaga,

    /** 8 taps and a hold over 713 ms. */
    ScarletMonsoon,

    /** 4 taps and a hold over 742 ms. */
    ObsidianHorizon,

    /** 3 taps and 3 holds over 1.3 s. */
    CosmicHarbor,

    /** A tap and 2 holds over 498 ms. */
    EmeraldHorizon,

    /** 2 taps and 2 holds over 540 ms. */
    LunarAnchor,

    /** 3 taps and 2 holds over 607 ms. */
    FrostyNebula,

    /** 2 taps and a hold over 150 ms. */
    AshenTalisman,

    /** A tap and a hold over 138 ms. */
    RusticTundra,

    /** 2 taps over 78 ms. */
    ZestyHaven,

    /** 3 taps over 200 ms. */
    NobleQuasar,

    /** 3 taps and 2 holds over 570 ms. */
    SilverMeadow,

    /** 3 taps and a hold over 622 ms. */
    SableRhapsody,

    /** 2 taps and 2 holds over 569 ms. */
    GoldenMeadow,

    /** 4 taps and a hold over 427 ms. */
    RubyMirage,

    /** 3 holds over 240 ms. */
    EmeraldFable,

    /** A tap and 5 holds over 1.5 s. */
    TwilightZenith,

    /** 4 taps and 2 holds over 1.0 s. */
    OpalMarble,

    /** 5 taps over 509 ms. */
    MossyYarrow,

    /** 3 taps and 9 holds over 1.5 s. */
    BronzeTalisman,

    /** 7 taps over 945 ms. */
    MistyAnchor,

    /** 8 taps over 1.2 s. */
    OpalCanyon,

    /** 7 taps over 1.8 s. */
    SunlitSparrow,

    /** 7 taps over 1.2 s. */
    PastelWhisper,

    /** 4 taps and 4 holds over 1.5 s. */
    TealComet,

    /** 2 taps over 104 ms. */
    EmeraldAtlas,

    /** 5 taps and a hold over 904 ms. */
    MellowThistle,

    /** 3 taps and 9 holds over 1.4 s. */
    OpalDelta,

    /** 7 taps over 1.6 s. */
    CopperComet,

    /** 7 taps and 3 holds over 1.1 s. */
    JadePebble,

    /** 3 taps and 7 holds over 1.1 s. */
    WovenGalaxy,

    /** 4 taps and 3 holds over 1.2 s. */
    LuckyMosaic,

    /** A tap and 2 holds over 188 ms. */
    ZestyNebula,

    /** 3 holds over 555 ms. */
    PastelWren,

    /** 8 taps and a hold over 1.2 s. */
    MellowHaven,

    /** 3 taps and a hold over 464 ms. */
    LuckyUtopia,

    /** 3 taps over 162 ms. */
    GlacialBlueKite,

    /** 4 holds over 1.0 s. */
    NeonNimbus,

    /** 4 taps and a hold over 522 ms. */
    OchreTalisman,

    /** A tap and 8 holds over 1.3 s. */
    IndigoYarrow,

    /** 3 taps and 2 holds over 887 ms. */
    AshenReef,

    /** 2 taps and 5 holds over 845 ms. */
    EmberRhapsody,

    /** 6 holds over 788 ms. */
    EmberOasis,

    /** 4 taps and a hold over 440 ms. */
    EmberMonsoon,

    /** 3 taps over 173 ms. */
    PastelKestrel,

    /** 3 taps and a hold over 353 ms. */
    VividComet,

    /** 9 taps and a hold over 1.4 s. */
    NobleDriftwood,

    /** 4 taps and 3 holds over 673 ms. */
    WildHarbor,

    /** 2 taps and 10 holds over 1.5 s. */
    CosmicDune,

    /** A tap and 4 holds over 581 ms. */
    StormyStarling,

    /** 3 taps and a hold over 501 ms. */
    SilverMarble,

    /** 5 taps and a hold over 1.1 s. */
    GildedFjord,

    /** 2 taps and a hold over 456 ms. */
    GildedGalaxy,

    /** 9 taps and a hold over 494 ms. */
    CopperMirage,

    /** 8 taps over 1.9 s. */
    SableQuartz,

    /** 9 taps and a hold over 1.2 s. */
    LunarNimbus,

    /** 4 taps and a hold over 311 ms. */
    FrostyKestrel,

    /** 5 taps and 2 holds over 1.4 s. */
    HollowDelta,

    /** 8 taps over 925 ms. */
    JaggedDriftwood,

    /** A tap and a hold over 107 ms. */
    TealDriftwood,

    /** 2 taps and a hold over 153 ms. */
    AshenVale,

    /** A tap and 8 holds over 1.0 s. */
    ArcticHarbor,

    /** 3 taps over 154 ms. */
    GoldenJuniper,

    /** 2 taps and 2 holds over 701 ms. */
    LunarJuniper,

    /** 6 taps and 3 holds over 1.6 s. */
    LuckyNebula,

    /** 3 taps over 158 ms. */
    MellowGlacier,

    /** 5 taps and a hold over 751 ms. */
    AshenPinnacle,

    /** 2 taps and a hold over 597 ms. */
    IndigoVortex,

    /** A tap and 5 holds over 807 ms. */
    MistyDelta,

    /** 2 taps and 2 holds over 647 ms. */
    OchreDelta,

    /** 3 taps and a hold over 492 ms. */
    PaleHarbor,

    /** 3 taps and 5 holds over 1.0 s. */
    PaleJuniper,

    /** 4 taps over 776 ms. */
    SwiftReef,

    /** 5 taps and 4 holds over 1.6 s. */
    PastelPinnacle,

    /** 2 taps over 78 ms. */
    RubyLotus,

    /** 3 taps and 6 holds over 942 ms. */
    PaleVortex,

    /** 4 taps and 4 holds over 1.1 s. */
    ZestySparrow,

    /** 7 taps over 1.1 s. */
    AzureLotus,

    /** 2 taps and a hold over 149 ms. */
    SilverGalaxy,

    /** A tap and 3 holds over 267 ms. */
    CosmicKite,

    /** 7 taps over 1.3 s. */
    SableHorizon,

    /** 9 holds over 1.2 s. */
    AmberMirage,

    /** 5 taps and 2 holds over 1.0 s. */
    GildedSpire,

    /** A tap and 7 holds over 910 ms. */
    ZestyOrchid,

    /** 6 holds over 815 ms. */
    CosmicFable,

    /** 2 taps over 89 ms. */
    OpalHarbor,

    /** A tap and 6 holds over 883 ms. */
    ArcticQuasar,

    /** 9 taps over 2.3 s. */
    CrimsonBlossom,

    /** 5 taps and 3 holds over 1.6 s. */
    IndigoPinnacle,

    /** 2 taps over 36 ms. */
    EmberStarling,

    /** 7 taps over 1.6 s. */
    AmberTundra,

    /** 3 taps and a hold over 391 ms. */
    CrimsonLagoon,

    /** 2 taps and a hold over 149 ms. */
    DuskyReef,

    /** A tap and 9 holds over 1.0 s. */
    WistfulSaga,

    /** 7 taps and 2 holds over 1.2 s. */
    ScarletVortex,

    /** 4 taps and 2 holds over 609 ms. */
    SolarWillow,

    /** 2 taps and a hold over 396 ms. */
    CosmicLighthouse,

    /** 2 taps and 2 holds over 593 ms. */
    StormyComet,

    /** 2 taps and 6 holds over 1.0 s. */
    GlacialBlueJubilee,

    /** 3 taps over 197 ms. */
    TwilightReef,

    /** 2 taps and a hold over 372 ms. */
    VioletTalisman,

    /** 3 taps and 2 holds over 670 ms. */
    StormyDriftwood,

    /** 2 taps and 3 holds over 434 ms. */
    GoldenCascade,

    /** 2 taps over 42 ms. */
    BronzeFjord,

    /** 5 taps over 1.1 s. */
    UmberLotus,

    /** 2 taps and a hold over 399 ms. */
    AzureJuniper,

    /** 5 taps and 2 holds over 1.1 s. */
    EmberZenith,

    /** 5 taps over 1.2 s. */
    FeralOasis,

    /** 2 holds over 116 ms. */
    HollowDriftwood,

    /** 4 taps and a hold over 695 ms. */
    ArcticTalisman,

    /** 6 taps over 766 ms. */
    NobleOasis,

    /** 4 taps over 340 ms. */
    AzureCanyon,

    /** 4 taps and 4 holds over 1.3 s. */
    IndigoSparrow,

    /** 3 taps and 2 holds over 402 ms. */
    NeonComet,

    /** 2 taps and a hold over 117 ms. */
    FrostyHarbor,

    /** A tap and 5 holds over 699 ms. */
    SilverMonsoon,

    /** 3 taps and 9 holds over 1.6 s. */
    PastelSonnet,

    /** 4 taps and a hold over 827 ms. */
    ScarletKestrel,

    /** 2 holds over 247 ms. */
    MistyOasis,

    /** 2 taps and 2 holds over 188 ms. */
    VioletGlacier,

    /** 3 taps and a hold over 119 ms. */
    UmberSparrow,

    /** A tap and 11 holds over 1.5 s. */
    GildedGlacier,

    /** 3 taps over 115 ms. */
    ArcticDriftwood,

    /** 5 taps and 4 holds over 2.2 s. */
    BronzeLighthouse,

    /** 2 taps over 89 ms. */
    VioletOrchid,

    /** 3 taps and a hold over 173 ms. */
    CobaltDriftwood,

    /** 6 taps over 644 ms. */
    AshenMosaic,

    /** A tap and 7 holds over 1.1 s. */
    TealThistle,

    /** 4 taps and 3 holds over 1.1 s. */
    TealDune,

    /** 3 taps and 9 holds over 1.4 s. */
    CoralMarble,

    /** 7 taps and 2 holds over 1.0 s. */
    JaggedOrchid,

    /** A tap and 11 holds over 1.6 s. */
    LuckyRhapsody,

    /** 9 taps and a hold over 1.1 s. */
    PrismMirage,

    /** 5 taps and a hold over 968 ms. */
    GlacialBlueBlossom,

    /** 3 taps and a hold over 663 ms. */
    GildedMirage,

    /** 8 holds over 1.2 s. */
    MellowNimbus,

    /** 4 taps over 205 ms. */
    LunarWhisper,

    /** 3 taps and 3 holds over 1.1 s. */
    WovenKite,

    /** 3 taps and 3 holds over 1.1 s. */
    SaffronSparrow,

    /** 3 taps and 7 holds over 1.1 s. */
    IndigoDriftwood,

    /** A tap and 2 holds over 757 ms. */
    ObsidianIris,

    /** 3 taps and a hold over 429 ms. */
    FeralDune,

    /** 2 taps over 41 ms. */
    PastelMeadow,

    /** 3 taps and 3 holds over 1.0 s. */
    OpalSpire,

    /** 6 taps and a hold over 1.6 s. */
    WovenWhisper,

    /** 3 taps over 120 ms. */
    VividMeadow,

    /** 3 taps and 2 holds over 1.0 s. */
    CosmicZenith,

    /** 2 taps and 10 holds over 1.6 s. */
    TealFjord,

    /** 5 holds over 849 ms. */
    WovenQuasar,

    /** 11 holds over 1.3 s. */
    IndigoNebula,

    /** 2 taps and 8 holds over 1.1 s. */
    VelvetRhapsody,

    /** 2 taps over 81 ms. */
    MossyTalisman,

    /** 2 taps and a hold over 389 ms. */
    ScarletPinnacle,

    /** 2 taps over 87 ms. */
    RubyMonsoon,

    /** 9 taps and a hold over 1.6 s. */
    ObsidianHarbor,

    /** 3 taps and 6 holds over 840 ms. */
    StormyNimbus,

    /** A tap and 6 holds over 791 ms. */
    SwiftStarling,

    /** 2 taps and 2 holds over 416 ms. */
    ScarletKite,

    /** 6 taps and a hold over 492 ms. */
    EmberTundra,

    /** 4 taps and 3 holds over 402 ms. */
    ZestyOasis,

    /** A tap and a hold over 82 ms. */
    PrismSaga,

    /** 3 taps and 3 holds over 1.3 s. */
    RubySparrow,

    /** 4 taps and a hold over 1.3 s. */
    JadeQuasar,

    /** 3 taps and a hold over 490 ms. */
    SwiftFjord,

    /** 2 taps and 5 holds over 846 ms. */
    PastelTalisman,

    /** 7 taps and a hold over 779 ms. */
    CobaltLantern,

    /** 3 taps and 3 holds over 1.3 s. */
    VelvetVortex,

    /** 5 taps and 2 holds over 1.0 s. */
    CobaltNebula,

    /** A tap and 5 holds over 721 ms. */
    AzureGlacier,

    /** 5 taps and a hold over 1.3 s. */
    WovenComet,

    /** 6 taps and a hold over 1.1 s. */
    PrismSparrow,

    /** 2 taps over 42 ms. */
    RusticTalisman,

    /** 4 taps over 430 ms. */
    NeonStarling,

    /** 3 taps and 2 holds over 645 ms. */
    RubyGlacier,

    /** 6 taps over 884 ms. */
    IndigoPebble,

    /** 3 taps and 4 holds over 1.2 s. */
    HollowReef,

    /** 6 taps over 451 ms. */
    DappledAtlas,

    /** 2 taps and a hold over 469 ms. */
    TidalHarbor,

    /** 4 taps over 678 ms. */
    JadeIris,

    /** A tap and 8 holds over 1.2 s. */
    SolarWhisper,

    /** 2 taps and 2 holds over 538 ms. */
    CobaltQuill,

    /** 3 taps and 3 holds over 806 ms. */
    IndigoWhisper,

    /** 2 taps and 5 holds over 1.3 s. */
    UmberNebula,

    /** 2 taps and 2 holds over 554 ms. */
    DuskyStarling,

    /** 3 taps over 153 ms. */
    GoldenDelta,

    /** 5 taps and a hold over 471 ms. */
    ObsidianThistle,

    /** 8 taps and a hold over 1.3 s. */
    JadePrairie,

    /** 2 taps and a hold over 248 ms. */
    WildOasis,

    /** A tap and 4 holds over 1.0 s. */
    CoralJuniper,

    /** 7 taps and 3 holds over 827 ms. */
    SaffronMosaic,

    /** A tap and a hold over 226 ms. */
    IndigoLotus,

    /** 2 taps and 2 holds over 225 ms. */
    NobleHaven,

    /** 7 taps over 971 ms. */
    LuckyVortex,

    /** 3 taps and 3 holds over 968 ms. */
    NobleFable,

    /** 2 taps and 3 holds over 839 ms. */
    CopperQuasar,

    /** 6 taps over 464 ms. */
    SunlitQuartz,

    /** 4 taps and a hold over 1.1 s. */
    HollowEmberGlow,

    /** A tap and 3 holds over 387 ms. */
    EmeraldHaven,

    /** 3 taps and a hold over 611 ms. */
    LunarMosaic,

    /** 3 taps and a hold over 467 ms. */
    GlacialBlueReef,

    /** 2 taps and 2 holds over 1.1 s. */
    ZestyCanyon,

    /** 3 taps over 149 ms. */
    LunarSparrow,

    /** 3 taps and 2 holds over 617 ms. */
    SilverTundra,

    /** 2 taps and 7 holds over 1.1 s. */
    UmberLagoon,

    /** 9 taps over 1.9 s. */
    SolarAnchor,

    /** 6 taps over 1.2 s. */
    IndigoMarble,

    /** 2 taps and a hold over 347 ms. */
    GildedCanyon,

    /** A tap and 8 holds over 1.2 s. */
    OchreFjord,

    /** 10 taps over 1.6 s. */
    OchreJuniper,

    /** 3 taps and a hold over 469 ms. */
    OchreMarble,

    /** 2 taps and 2 holds over 296 ms. */
    StormyVale,

    /** 4 taps and 3 holds over 568 ms. */
    OchreKestrel,

    /** 2 taps over 37 ms. */
    CoralOrchid,

    /** 2 taps and a hold over 326 ms. */
    IndigoIris,

    /** 6 holds over 788 ms. */
    StormyMonsoon,

    /** 5 taps and 4 holds over 1.5 s. */
    SilverYarrow,

    /** 3 taps and a hold over 370 ms. */
    VioletZenith,

    /** 2 taps and 6 holds over 861 ms. */
    SaffronUtopia,

    /** A tap and 3 holds over 259 ms. */
    LuckyBlossom,

    /** 2 taps and a hold over 86 ms. */
    MistyFable,

    /** 3 taps and 2 holds over 559 ms. */
    GildedHaven,

    /** 4 taps and 2 holds over 432 ms. */
    ElectricHorizon,

    /** A tap and a hold over 115 ms. */
    BronzeSpire,

    /** A tap and 3 holds over 855 ms. */
    CobaltPinnacle,

    /** 2 taps and 10 holds over 1.6 s. */
    RubyWillow,

    /** 6 taps over 824 ms. */
    BronzeWhisper,

    /** 7 taps and a hold over 638 ms. */
    SwiftGlacier,

    /** 4 taps and a hold over 603 ms. */
    OpalSparrow,

    /** 6 taps and a hold over 328 ms. */
    TwilightCanyon,

    /** A tap and 2 holds over 368 ms. */
    GildedHorizon,

    /** 3 taps over 132 ms. */
    AzureQuasar,

    /** 4 holds over 1.2 s. */
    PastelDune,

    /** 2 taps and 2 holds over 777 ms. */
    PrismDelta,

    /** 2 taps and a hold over 118 ms. */
    StormyFable,

    /** 2 taps over 85 ms. */
    SunlitPebble,

    /** 3 taps and 8 holds over 1.1 s. */
    EmeraldZenith,

    /** 3 taps and 2 holds over 807 ms. */
    PaleWren,

    /** 4 taps and 3 holds over 1.4 s. */
    SableHarbor,

    /** A tap and 6 holds over 1.4 s. */
    VioletIris,

    /** 3 taps and a hold over 621 ms. */
    PastelNebula,

    /** A tap and 7 holds over 1.1 s. */
    MistyLighthouse,

    /** 3 taps over 210 ms. */
    AmberQuartz,

    /** 4 holds over 572 ms. */
    SunlitAtlas,

    /** 5 taps over 742 ms. */
    WildDriftwood,

    /** 3 taps and a hold over 438 ms. */
    RubyNimbus,

    /** 5 taps over 629 ms. */
    WistfulUtopia,

    /** 4 taps over 380 ms. */
    OchreHarbor,

    /** 9 taps over 1.6 s. */
    MistyAtlas,

    /** 3 taps over 128 ms. */
    SolarPinnacle,

    /** 7 taps over 1.2 s. */
    SilverJubilee,

    /** 6 taps over 1.4 s. */
    AmberFjord,

    /** 3 taps over 156 ms. */
    JaggedMarble,

    /** 2 taps and 5 holds over 829 ms. */
    SwiftGalaxy,

    /** 2 taps and 2 holds over 763 ms. */
    ScarletGlacier,

    /** 2 taps over 63 ms. */
    WistfulThistle,

    /** A tap and 2 holds over 459 ms. */
    UmberLighthouse,

    /** 7 taps and a hold over 1.5 s. */
    LunarPinnacle,

    /** 6 taps over 1.2 s. */
    CopperKestrel,

    /** 4 taps and a hold over 679 ms. */
    ScarletAnchor,

    /** 4 taps over 429 ms. */
    NobleLighthouse,

    /** 3 taps over 347 ms. */
    BronzeGalaxy,

    /** 3 taps and 3 holds over 942 ms. */
    CopperHorizon,

    /** 4 taps and 3 holds over 1.2 s. */
    HollowMarble,

    /** 7 taps and a hold over 644 ms. */
    EmberKite,

    /** 4 taps over 487 ms. */
    SunlitWillow,

    /** A tap and 7 holds over 1.2 s. */
    SableMarble,

    /** A tap and 11 holds over 1.7 s. */
    DappledAnchor,

    /** 2 taps and a hold over 129 ms. */
    PaleLotus,

    /** 2 taps over 47 ms. */
    JadeMeadow,

    /** 2 taps and 4 holds over 657 ms. */
    PastelQuasar,

    /** 2 taps over 84 ms. */
    SaffronQuasar,

    /** 2 taps and 3 holds over 961 ms. */
    CoralMonsoon,

    /** 3 taps and a hold over 467 ms. */
    VelvetPinnacle,

    /** 5 taps and 2 holds over 1.0 s. */
    SunlitIris,

    /** 4 taps and 2 holds over 830 ms. */
    WildVortex,

    /** 8 taps over 2.2 s. */
    SilverKestrel,

    /** 4 taps and a hold over 881 ms. */
    SilverDelta,

    /** 6 taps and 2 holds over 1.2 s. */
    LuckyCascade,

    /** 2 taps and a hold over 472 ms. */
    TidalLighthouse,

    /** 5 taps and 2 holds over 954 ms. */
    GlacialBlueFable,

    /** A tap and 3 holds over 428 ms. */
    GlacialBlueDriftwood,

    /** 5 taps and a hold over 983 ms. */
    GildedCascade,

    /** 4 taps over 305 ms. */
    SunlitReef,

    /** 2 taps and 3 holds over 770 ms. */
    HazyWillow,

    /** 4 taps and 5 holds over 818 ms. */
    SilverNebula,

    /** 3 taps and 2 holds over 964 ms. */
    JadeMonsoon,

    /** 4 taps and 2 holds over 553 ms. */
    SwiftWhisper,

    /** 4 taps and 7 holds over 1.1 s. */
    HollowSpire,

    /** 6 taps over 737 ms. */
    VelvetZenith,

    /** A tap and 9 holds over 1.1 s. */
    HazyReef,

    /** 6 taps over 648 ms. */
    JaggedQuartz,

    /** 7 taps and a hold over 1.6 s. */
    JaggedSparrow,

    /** A tap and 4 holds over 1.1 s. */
    TwilightKite,

    /** 5 taps over 730 ms. */
    WovenHorizon,

    /** A tap and 5 holds over 1.3 s. */
    FrostyLagoon,

    /** 4 taps and 3 holds over 1.1 s. */
    WildMarble,

    /** 8 taps over 1.4 s. */
    VividPinnacle,

    /** 4 taps and 2 holds over 600 ms. */
    HazyHarbor,

    /** 5 taps and 4 holds over 1.0 s. */
    DappledQuartz,

    /** 4 taps and a hold over 719 ms. */
    RubyThistle,

    /** 6 taps over 1.4 s. */
    VelvetAnchor,

    /** 5 taps over 759 ms. */
    MistySpire,

    /** A tap and 7 holds over 913 ms. */
    BronzeCanyon,

    /** 3 taps and a hold over 265 ms. */
    AmberKestrel,

    /** 5 taps over 364 ms. */
    EmeraldSonnet,

    /** 2 taps and 5 holds over 1.0 s. */
    CrimsonLighthouse,

    /** 3 taps over 262 ms. */
    SunlitHorizon,

    /** 4 taps and 3 holds over 1.4 s. */
    CoralTalisman,

    /** 4 taps over 624 ms. */
    ElectricTalisman,

    /** 3 taps and a hold over 431 ms. */
    ArcticFjord,

    /** A tap and a hold over 265 ms. */
    TealZenith,

    /** 2 taps over 84 ms. */
    LunarCascade,

    /** 4 taps and a hold over 511 ms. */
    PaleJubilee,

    /** 4 taps over 141 ms. */
    EmeraldMonsoon,

    /** 6 taps and 2 holds over 795 ms. */
    VelvetWillow,

    /** 4 holds over 614 ms. */
    BronzeJuniper,

    /** 2 taps and a hold over 679 ms. */
    SwiftZephyr,

    /** 2 taps and 3 holds over 574 ms. */
    CobaltMeadow,

    /** 6 taps over 670 ms. */
    UmberVortex,

    /** 3 taps over 130 ms. */
    OpalYarrow,

    /** 4 taps and a hold over 674 ms. */
    JadeNebula,

    /** 5 taps and a hold over 334 ms. */
    TidalMonsoon,

    /** A tap and 11 holds over 1.8 s. */
    SableEmberGlow,

    /** 3 taps and a hold over 168 ms. */
    SilverQuill,

    /** 2 taps and 3 holds over 469 ms. */
    ZestyLagoon,

    /** 4 taps over 608 ms. */
    OpalMosaic,

    /** 2 taps and 9 holds over 1.1 s. */
    SableCascade,

    /** 5 taps and 2 holds over 1.2 s. */
    NeonMonsoon,

    /** A tap and 4 holds over 934 ms. */
    CobaltComet,

    /** A tap and 3 holds over 233 ms. */
    OchreSonnet,

    /** 5 taps over 896 ms. */
    ElectricDelta,

    /** 5 taps and 4 holds over 1.7 s. */
    VividQuasar,

    /** 3 taps and 4 holds over 1.5 s. */
    RusticKite,

    /** 4 taps over 231 ms. */
    LunarIris,

    /** A tap and a hold over 117 ms. */
    DuskyOrchid,

    /** A tap and 7 holds over 1.9 s. */
    DuskyComet,

    /** 5 taps and 2 holds over 657 ms. */
    FeralZenith,

    /** A tap and 2 holds over 159 ms. */
    DappledDune,

    /** 4 taps and 3 holds over 1.0 s. */
    ZestyMarble,

    /** 4 taps and a hold over 418 ms. */
    SunlitTalisman,

    /** 2 taps and 2 holds over 578 ms. */
    PastelCanyon,

    /** 3 taps and 6 holds over 995 ms. */
    SaffronBlossom,

    /** A tap and 5 holds over 602 ms. */
    FeralHaven,

    /** 2 taps over 63 ms. */
    DappledLighthouse,

    /** 3 taps and a hold over 708 ms. */
    CosmicWhisper,

    /** 7 taps over 794 ms. */
    VelvetKite,

    /** 4 taps and a hold over 488 ms. */
    AshenNimbus,

    /** 4 taps and 4 holds over 1.3 s. */
    CrimsonZephyr,

    /** 3 taps over 190 ms. */
    CopperQuartz,

    /** 6 taps and 2 holds over 1.5 s. */
    LuckyGlacier,

    /** 5 taps over 1.1 s. */
    WistfulZenith,

    /** 4 taps and a hold over 413 ms. */
    CopperDune,

    /** 3 taps and a hold over 433 ms. */
    IndigoOasis,

    /** 3 taps and 6 holds over 782 ms. */
    PrismMarble,

    /** 3 taps and 2 holds over 656 ms. */
    GlacialBlueSpire,

    /** A tap and 10 holds over 1.7 s. */
    IndigoComet,

    /** 8 taps over 2.0 s. */
    AzureMeadow,

    /** 3 taps and a hold over 636 ms. */
    AzureYarrow,

    /** 8 taps over 1.4 s. */
    CrimsonLantern,

    /** 3 taps over 112 ms. */
    NobleCascade,

    /** 2 taps and 10 holds over 1.4 s. */
    ElectricSpire,

    /** A tap and 3 holds over 353 ms. */
    PaleCascade,

    /** 7 taps over 1.1 s. */
    SaffronPinnacle,

    /** 2 taps and 3 holds over 933 ms. */
    ZestyLotus,

    /** 7 taps and a hold over 1.4 s. */
    DuskyZenith,

    /** 4 taps and 3 holds over 1.0 s. */
    SolarMonsoon,

    /** A tap and a hold over 41 ms. */
    WistfulPrairie,

    /** 2 taps and 2 holds over 191 ms. */
    SwiftMosaic,

    /** 2 taps and a hold over 293 ms. */
    HollowHarbor,

    /** 5 taps and a hold over 718 ms. */
    SunlitMeadow,

    /** A tap and 3 holds over 663 ms. */
    LuckyNimbus,

    /** 3 taps over 163 ms. */
    CoralFjord,

    /** 8 taps and a hold over 946 ms. */
    CosmicLotus,

    /** 2 taps and 2 holds over 337 ms. */
    BronzeMarble,

    /** 2 taps and 7 holds over 1.0 s. */
    MossyMosaic,

    /** 2 taps and 3 holds over 312 ms. */
    CoralJubilee,

    /** 2 taps and a hold over 117 ms. */
    IvoryNimbus,

    /** 6 taps and 6 holds over 864 ms. */
    CoralLotus,

    /** 2 taps and 10 holds over 1.4 s. */
    TwilightTundra,

    /** 8 taps over 1.2 s. */
    NobleCanyon,

    /** 2 taps and 3 holds over 513 ms. */
    EmberGalaxy,

    /** 3 taps and 2 holds over 697 ms. */
    LunarMonsoon,

    /** 4 taps over 191 ms. */
    WildZephyr,

    /** 2 holds over 293 ms. */
    RubyVale,

    /** 3 taps and 2 holds over 650 ms. */
    EmeraldJubilee,

    /** A tap and a hold over 142 ms. */
    SableDriftwood,

    /** 4 taps and a hold over 528 ms. */
    SwiftHorizon,

    /** 3 taps over 275 ms. */
    VioletWillow,

    /** 4 taps and 2 holds over 717 ms. */
    TealHarbor,

    /** 4 taps and a hold over 481 ms. */
    AmberEmberGlow,

    /** 2 taps and 2 holds over 279 ms. */
    HazyGalaxy,

    /** 3 taps and a hold over 660 ms. */
    PrismLotus,

    /** 2 taps and 3 holds over 1.0 s. */
    GildedOrchid,

    /** 2 taps and 8 holds over 1.2 s. */
    VelvetLagoon,

    /** 2 taps over 33 ms. */
    GildedZenith,

    /** 6 taps over 457 ms. */
    WistfulAtlas,

    /** 3 taps and 2 holds over 557 ms. */
    ScarletWren,

    /** 3 taps and 2 holds over 323 ms. */
    GildedFable,

    /** 8 taps and a hold over 1.7 s. */
    NeonRhapsody,

    /** 3 taps over 251 ms. */
    ScarletMirage,

    /** 3 taps and 2 holds over 476 ms. */
    LuckyMeadow,

    /** 4 taps and a hold over 427 ms. */
    MistyQuartz,

    /** 2 taps and a hold over 181 ms. */
    WovenThistle,

    /** 7 taps over 1.6 s. */
    CrimsonGalaxy,

    /** 6 taps over 453 ms. */
    PastelOrchid,

    /** 5 taps over 645 ms. */
    SunlitCanyon,

    /** 3 taps and 4 holds over 481 ms. */
    UmberKestrel,

    /** A tap and 2 holds over 135 ms. */
    IvoryCanyon,

    /** 6 taps and 4 holds over 1.1 s. */
    IndigoJuniper,

    /** 4 taps over 357 ms. */
    WistfulCascade,

    /** 8 taps and a hold over 1.6 s. */
    CrimsonReef,

    /** 3 taps and 5 holds over 583 ms. */
    RusticZenith,

    /** 5 taps and 2 holds over 1.4 s. */
    MellowTundra,

    /** 3 taps and a hold over 507 ms. */
    CopperLighthouse,

    /** A tap and 2 holds over 547 ms. */
    FeralPinnacle,

    /** 2 taps and a hold over 92 ms. */
    MossyJubilee,

    /** 2 taps and a hold over 136 ms. */
    WovenTalisman,

    /** 2 taps over 36 ms. */
    JadeComet,

    /** 8 taps and a hold over 1.3 s. */
    GoldenHarbor,

    /** A tap and 2 holds over 552 ms. */
    VioletFjord,

    /** 2 taps and a hold over 174 ms. */
    CrimsonQuill,

    /** 2 taps over 86 ms. */
    VelvetComet,

    /** 4 taps and 2 holds over 315 ms. */
    VelvetNebula,

    /** 2 taps and a hold over 102 ms. */
    ScarletZenith,

    /** 2 taps and 2 holds over 227 ms. */
    EmberZephyr,

    /** 2 taps and 2 holds over 681 ms. */
    CopperAtlas,

    /** 11 holds over 1.7 s. */
    MossyOasis,

    /** 3 taps and 3 holds over 436 ms. */
    NoblePebble,

    /** A tap and a hold over 77 ms. */
    ScarletDune,

    /** A tap and 5 holds over 1.5 s. */
    SaffronCascade,

    /** 11 holds over 1.6 s. */
    VioletTundra,

    /** 6 taps and a hold over 1.3 s. */
    CopperWillow,

    /** 3 taps and 4 holds over 728 ms. */
    HollowOrchid,

    /** 3 taps and 7 holds over 952 ms. */
    StormyZephyr,

    /** 3 taps and a hold over 723 ms. */
    AshenFjord,

    /** 3 taps and a hold over 174 ms. */
    ZestyKestrel,

    /** 9 taps and a hold over 1.5 s. */
    FeralEmberGlow,

    /** 3 taps and 4 holds over 642 ms. */
    VividPebble,

    /** A tap and 5 holds over 605 ms. */
    CosmicQuartz,

    /** 3 taps over 229 ms. */
    ObsidianLighthouse,

    /** 2 taps and a hold over 479 ms. */
    CosmicSparrow,

    /** 4 taps over 388 ms. */
    MistyHaven,

    /** 3 taps and a hold over 294 ms. */
    TwilightWren,

    /** 2 taps and 2 holds over 317 ms. */
    CoralMirage,

    /** 2 taps over 61 ms. */
    ArcticHaven,

    /** 3 taps and 4 holds over 1.6 s. */
    DuskyMirage,

    /** 6 taps and 3 holds over 1.0 s. */
    RusticBlossom,

    /** 4 taps and 3 holds over 872 ms. */
    GildedKite,

    /** 5 taps and 4 holds over 1.9 s. */
    ArcticVale,

    /** A tap and 7 holds over 923 ms. */
    NeonMirage,

    /** 4 taps and 3 holds over 909 ms. */
    OchreWren,

    /** A tap and a hold over 149 ms. */
    SilverKite,

    /** 4 taps and a hold over 674 ms. */
    AshenDriftwood,

    /** 3 holds over 681 ms. */
    BronzeDune,

    /** 2 taps and 7 holds over 1.1 s. */
    HollowWhisper,

    /** 6 taps over 754 ms. */
    MossyGlacier,

    /** 5 taps and 3 holds over 1.7 s. */
    ElectricDune,

    /** 2 taps and 5 holds over 604 ms. */
    DappledQuasar,

    /** 5 taps and a hold over 951 ms. */
    SaffronThistle,

    /** 7 taps and 2 holds over 734 ms. */
    HollowCascade,

    /** 3 taps and 3 holds over 897 ms. */
    JadeHorizon,

    /** 2 taps and 2 holds over 142 ms. */
    SolarCanyon,

    /** 7 taps over 1.6 s. */
    GlacialBlueOrchid,

    /** 3 taps over 243 ms. */
    MossyNebula,

    /** 7 taps over 1.3 s. */
    DuskySpire,

    /** 5 taps and 4 holds over 549 ms. */
    NeonHarbor,

    /** 7 taps over 1.2 s. */
    ScarletLighthouse,

    /** 3 taps over 137 ms. */
    ArcticCanyon,

    /** 2 taps and 3 holds over 582 ms. */
    MistyBlossom,

    /** 3 taps and 6 holds over 847 ms. */
    IndigoDelta,

    /** 3 taps and a hold over 191 ms. */
    EmberCascade,

    /** 4 taps and 2 holds over 471 ms. */
    PastelCascade,

    /** 2 taps over 67 ms. */
    NeonKite,

    /** 3 taps over 289 ms. */
    DuskyLantern,

    /** 2 taps over 62 ms. */
    GlacialBlueWren;
    // END GENERATED PATTERNS

    /**
     * How long the pattern plays, in milliseconds: from its first event to the end of its last. A single tap,
     * like [Tick], is 0.
     *
     * The engine doesn't report when a pattern ends, so use this to time UI to it.
     */
    public val durationMs: Long get() = HapticPatterns.durationMs(this)

    /**
     * The taps and holds that make up the pattern, in time order: for showing or inspecting it, such as
     * drawing its timeline. Playing a pattern doesn't need these; use [HapticEngine.play].
     */
    public val events: List<HapticPatternEvent> get() = HapticPatterns.events(this)
}
