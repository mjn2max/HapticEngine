package dev.codepassion.hapticengine

/**
 * One event in a [HapticPattern]: a tap or a held vibration, with its timing, strength and feel. Mirrors
 * `HapticPatternEvent` on iOS, with times in milliseconds.
 *
 * For showing or inspecting a pattern, such as drawing its timeline. Playing a pattern doesn't need
 * these; use [HapticEngine.play].
 *
 * ```kotlin
 * for (event in HapticPattern.Heartbeat.events) {
 *     println("${event.kind} ${event.timeMs} ${event.intensity}")
 * }
 * ```
 */
public class HapticPatternEvent(
    public val kind: Kind,
    /** When the event starts, in milliseconds from the start of the pattern. */
    public val timeMs: Long,
    /** How long the event lasts, in milliseconds. 0 for a tap. */
    public val durationMs: Long,
    /** How strong the event is, from 0 to 1. */
    public val intensity: Float,
    /** How crisp the event feels, from 0 (round and dull) to 1 (sharp). */
    public val sharpness: Float,
) {
    public enum class Kind {
        /** A momentary tap. */
        Tap,

        /** A vibration held for [durationMs]. */
        Hold,
    }

    /** When the event stops, in milliseconds from the start of the pattern. A tap's is its start. */
    public val endMs: Long get() = timeMs + durationMs

    override fun equals(other: Any?): Boolean =
        other is HapticPatternEvent && kind == other.kind && timeMs == other.timeMs && durationMs == other.durationMs &&
            intensity == other.intensity && sharpness == other.sharpness

    override fun hashCode(): Int {
        var result = kind.hashCode()
        result = 31 * result + timeMs.hashCode()
        result = 31 * result + durationMs.hashCode()
        result = 31 * result + intensity.hashCode()
        result = 31 * result + sharpness.hashCode()
        return result
    }

    override fun toString(): String =
        "HapticPatternEvent(kind=$kind, timeMs=$timeMs, durationMs=$durationMs, intensity=$intensity, sharpness=$sharpness)"
}
