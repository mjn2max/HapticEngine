package dev.codepassion.hapticengine

/**
 * A built-in haptic pattern. Pass one to [HapticEngine.play]. Mirrors `HapticPattern` on iOS, in the
 * same order.
 *
 * ```kotlin
 * haptics.play(HapticPattern.Success)
 * ```
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
}
