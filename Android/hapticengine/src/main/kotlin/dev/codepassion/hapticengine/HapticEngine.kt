package dev.codepassion.hapticengine

import android.content.Context

/**
 * Plays the library's haptic patterns. Mirrors `HapticEngineProtocol` on iOS.
 */
public interface HapticEngine {
    /** Whether the device has a vibrator that can play haptics. */
    public val isHapticsSupported: Boolean

    /** One sharp tap followed by taps of rising strength over about one second. */
    public fun startSimpleHaptic()

    /** Medium, hard, soft, hard: four 1.5 second segments. */
    public fun startComplexHaptic()
}

/** Creates the default [HapticEngine], backed by the system vibrator. */
public fun HapticEngine(context: Context): HapticEngine =
    VibratorHapticEngine(context.applicationContext)
