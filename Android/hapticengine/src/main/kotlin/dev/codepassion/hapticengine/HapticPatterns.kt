package dev.codepassion.hapticengine

import kotlin.math.roundToLong

/**
 * One event in a pattern, as on iOS: [intensity] is strength and [sharpness] is how crisp it feels,
 * both 0..1. Kept free of Android types so patterns can be unit tested on the JVM.
 */
internal sealed interface HapticEvent {
    val atMs: Long
    val intensity: Float
    val sharpness: Float

    /** A momentary tap, like Core Haptics' transient event. */
    data class Tap(override val intensity: Float, override val sharpness: Float, override val atMs: Long) : HapticEvent

    /** A sustained vibration, like Core Haptics' continuous event. */
    data class Hold(
        override val intensity: Float,
        override val sharpness: Float,
        override val atMs: Long,
        val durationMs: Long,
    ) : HapticEvent
}

/**
 * A vibration waveform as alternating segments: each entry in [timingsMs] lasts that long
 * at the matching entry in [amplitudes] (0 = off, 1..255 = strength).
 */
internal data class Waveform(
    val timingsMs: List<Long>,
    val amplitudes: List<Int>,
) {
    init {
        require(timingsMs.size == amplitudes.size) { "timings and amplitudes must be the same length" }
        require(amplitudes.all { it in 0..MAX_AMPLITUDE }) { "amplitudes must be in 0..$MAX_AMPLITUDE" }
    }

    val durationMs: Long get() = timingsMs.sum()

    companion object {
        const val MAX_AMPLITUDE = 255
    }
}

/** A haptic primitive the pattern's taps map to, where the vibrator supports them. */
internal enum class Primitive {
    /** Crisp, for sharp taps. */
    Click,

    /** Deep and dull, for soft taps. */
    Thud,
}

/** One primitive in a composition, played [atMs] after the pattern starts at [scale] strength. */
internal data class PrimitiveStep(val primitive: Primitive, val scale: Float, val atMs: Long)

/**
 * The events that make up each [HapticPattern], and how they're played on Android.
 *
 * Keep the events in step with `HapticPatterns.swift` in the iOS library; the tests hold both sides to
 * the same spec.
 */
internal object HapticPatterns {
    // Timings in milliseconds. Each pattern has its own, so tuning one can't change another.
    private const val SIMPLE_TAP_INTERVAL_MS = 100L
    private const val COMPLEX_SEGMENT_MS = 1_500L
    private const val SUCCESS_GAP_MS = 150L
    private const val WARNING_GAP_MS = 250L
    private const val ERROR_TAP_INTERVAL_MS = 100L
    private const val HEARTBEAT_INTERVAL_MS = 800L
    private const val HEARTBEAT_DUB_DELAY_MS = 150L
    private const val KNOCK_INTERVAL_MS = 250L
    private const val RUMBLE_MS = 800L
    private const val PULSE_BURST_MS = 100L

    /** How long a tap vibrates in a waveform: short for a sharp tap, longer for a dull one. */
    private const val SHARP_TAP_MS = 12L
    private const val DULL_TAP_MS = 36L

    /** Taps at least this sharp play as [Primitive.Click], softer ones as [Primitive.Thud]. */
    private const val CLICK_SHARPNESS = 0.5f

    /** The only way in, so playback and tests always build patterns the same way. */
    fun events(pattern: HapticPattern): List<HapticEvent> = when (pattern) {
        HapticPattern.Simple -> simple()
        HapticPattern.Complex -> complex()
        HapticPattern.Tick -> listOf(tap(0.5f, 1f, 0))
        HapticPattern.Success -> listOf(tap(0.6f, 0.5f, 0), tap(1f, 1f, SUCCESS_GAP_MS))
        HapticPattern.Warning -> listOf(tap(1f, 0.6f, 0), tap(0.6f, 0.6f, WARNING_GAP_MS))
        HapticPattern.Error -> (0L until 3L).map { tap(1f, 1f, it * ERROR_TAP_INTERVAL_MS) }
        HapticPattern.Heartbeat -> heartbeat()
        HapticPattern.Knock -> (0L until 3L).map { tap(0.8f, 0.2f, it * KNOCK_INTERVAL_MS) }
        HapticPattern.Rumble -> listOf(HapticEvent.Hold(0.8f, 0.1f, 0, RUMBLE_MS))
        // Each gap is as long as a burst.
        HapticPattern.Pulse -> (0L until 5L).map { HapticEvent.Hold(1f, 0.5f, it * 2 * PULSE_BURST_MS, PULSE_BURST_MS) }
    }

    /** A full-strength tap, then taps every 100 ms rising from 10% to 90% strength. */
    private fun simple(): List<HapticEvent> =
        listOf(tap(1f, 1f, 0)) + (1..9).map { step ->
            val level = step / 10f
            tap(level, level, step * SIMPLE_TAP_INTERVAL_MS)
        }

    /** Medium (0.5), hard (1.0), soft (0.2), hard (1.0); 1.5 seconds each. */
    private fun complex(): List<HapticEvent> =
        listOf(0.5f, 1f, 0.2f, 1f).mapIndexed { index, level ->
            HapticEvent.Hold(level, level, index * COMPLEX_SEGMENT_MS, COMPLEX_SEGMENT_MS)
        }

    /** Two "lub-dub" beats 800 ms apart: a strong dull tap, then a softer one 150 ms later. */
    private fun heartbeat(): List<HapticEvent> =
        (0L until 2L).flatMap { beat ->
            val start = beat * HEARTBEAT_INTERVAL_MS
            listOf(tap(1f, 0.3f, start), tap(0.6f, 0.3f, start + HEARTBEAT_DUB_DELAY_MS))
        }

    private fun tap(intensity: Float, sharpness: Float, atMs: Long) = HapticEvent.Tap(intensity, sharpness, atMs)

    /**
     * The pattern as haptic primitives, which feel much closer to iOS taps than a raw vibration.
     * `null` for patterns with holds, which primitives can't express.
     */
    fun primitives(pattern: HapticPattern): List<PrimitiveStep>? {
        val events = events(pattern)
        if (events.any { it is HapticEvent.Hold }) return null
        return events.map { tap ->
            val primitive = if (tap.sharpness >= CLICK_SHARPNESS) Primitive.Click else Primitive.Thud
            PrimitiveStep(primitive, tap.intensity, tap.atMs)
        }
    }

    /** The pattern as a plain waveform, which every vibrator can play. */
    fun waveform(pattern: HapticPattern): Waveform {
        val events = events(pattern)
        val timings = mutableListOf<Long>()
        val amplitudes = mutableListOf<Int>()
        var cursor = 0L
        events.forEachIndexed { index, event ->
            if (event.atMs > cursor) {
                timings += event.atMs - cursor
                amplitudes += 0
            }
            val length = when (event) {
                is HapticEvent.Hold -> event.durationMs
                // A tap never runs into the next event.
                is HapticEvent.Tap -> {
                    val next = events.getOrNull(index + 1)?.atMs
                    val tapMs = tapMs(event.sharpness)
                    if (next == null) tapMs else minOf(tapMs, next - event.atMs)
                }
            }
            timings += length
            amplitudes += amplitude(event.intensity)
            cursor = event.atMs + length
        }
        return Waveform(timings, amplitudes)
    }

    /** How long a tap of [sharpness] vibrates in a waveform. */
    fun tapMs(sharpness: Float): Long =
        (DULL_TAP_MS - (DULL_TAP_MS - SHARP_TAP_MS) * sharpness.coerceIn(0f, 1f)).roundToLong()

    /** Converts an iOS-style intensity (0..1) to an Android amplitude (1..255). */
    fun amplitude(intensity: Float): Int =
        (intensity.coerceIn(0f, 1f) * Waveform.MAX_AMPLITUDE).toInt().coerceAtLeast(1)
}
