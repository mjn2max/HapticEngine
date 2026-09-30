package dev.codepassion.hapticengine

import android.content.Context

/**
 * Plays the library's haptic patterns. Mirrors `HapticEngineProtocol` on iOS.
 *
 * Depend on this interface rather than the default engine so you can substitute a fake in tests and
 * Compose previews. An implementation only needs [isHapticsSupported] and [play]; the
 * `start…Haptic()` shorthands are provided for you.
 */
public interface HapticEngine {
    /** Whether the device has a vibrator that can play haptics. */
    public val isHapticsSupported: Boolean

    /**
     * Plays a built-in pattern, stopping any pattern that is still playing.
     * Does nothing when [isHapticsSupported] is `false`.
     */
    public fun play(pattern: HapticPattern)

    /** Plays [HapticPattern.Simple]. */
    public fun startSimpleHaptic(): Unit = play(HapticPattern.Simple)

    /** Plays [HapticPattern.Complex]. */
    public fun startComplexHaptic(): Unit = play(HapticPattern.Complex)

    /** Plays [HapticPattern.Tick]. */
    public fun startTickHaptic(): Unit = play(HapticPattern.Tick)

    /** Plays [HapticPattern.Success]. */
    public fun startSuccessHaptic(): Unit = play(HapticPattern.Success)

    /** Plays [HapticPattern.Warning]. */
    public fun startWarningHaptic(): Unit = play(HapticPattern.Warning)

    /** Plays [HapticPattern.Error]. */
    public fun startErrorHaptic(): Unit = play(HapticPattern.Error)

    /** Plays [HapticPattern.Heartbeat]. */
    public fun startHeartbeatHaptic(): Unit = play(HapticPattern.Heartbeat)

    /** Plays [HapticPattern.Knock]. */
    public fun startKnockHaptic(): Unit = play(HapticPattern.Knock)

    /** Plays [HapticPattern.Rumble]. */
    public fun startRumbleHaptic(): Unit = play(HapticPattern.Rumble)

    /** Plays [HapticPattern.Pulse]. */
    public fun startPulseHaptic(): Unit = play(HapticPattern.Pulse)
}

/**
 * Creates the default [HapticEngine], backed by the system vibrator.
 *
 * @param usage what the haptics are for, which decides which of the user's vibration settings apply.
 *   Defaults to [HapticUsage.Touch], for feedback on something the user touched.
 */
@JvmOverloads
public fun HapticEngine(context: Context, usage: HapticUsage = HapticUsage.Touch): HapticEngine =
    VibratorHapticEngine(context.applicationContext, usage)
