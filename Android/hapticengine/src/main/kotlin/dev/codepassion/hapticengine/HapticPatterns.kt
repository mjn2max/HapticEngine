package dev.codepassion.hapticengine

import java.util.concurrent.atomic.AtomicReferenceArray
import kotlin.math.roundToLong

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
 * The events come from the iOS library, through `HapticPatternData`, so both platforms play the same
 * patterns: see `Android/scripts/export-patterns.sh`. Kept free of Android types so they can be unit tested
 * on the JVM.
 */
internal object HapticPatterns {
    /** How long a tap vibrates in a waveform: short for a sharp tap, longer for a dull one. */
    private const val SHARP_TAP_MS = 12L
    private const val DULL_TAP_MS = 36L

    /** Taps at least this sharp play as [Primitive.Click], softer ones as [Primitive.Thud]. */
    private const val CLICK_SHARPNESS = 0.5f

    /**
     * Each pattern's events, decoded the first time they're asked for, then kept: decoding all four
     * thousand up front would cost an app that plays a few. Decoding is pure, so two threads racing to
     * decode one only do the work twice.
     */
    private val cache = AtomicReferenceArray<List<HapticPatternEvent>>(HapticPatternData.COUNT)

    /** The only way in, so playback, [HapticPattern.events] and tests always see the same events. */
    fun events(pattern: HapticPattern): List<HapticPatternEvent> {
        cache.get(pattern.ordinal)?.let { return it }
        val events = decode(HapticPatternData.encoded(pattern.ordinal))
        cache.set(pattern.ordinal, events)
        return events
    }

    fun durationMs(pattern: HapticPattern): Long = events(pattern).maxOf { it.endMs }

    /** Reads one pattern's events: see `HapticPatternData`. */
    fun decode(encoded: String): List<HapticPatternEvent> =
        encoded.split(';').map { event ->
            val fields = event.split(',')
            fun level(index: Int) = fields[index].toInt() / 1000f
            when (fields[0]) {
                "t" -> HapticPatternEvent(HapticPatternEvent.Kind.Tap, fields[1].toLong(), 0, level(2), level(3))
                "h" -> HapticPatternEvent(HapticPatternEvent.Kind.Hold, fields[1].toLong(), fields[2].toLong(), level(3), level(4))
                else -> error("Unknown event $event")
            }
        }

    /**
     * The pattern as haptic primitives, which feel much closer to iOS taps than a raw vibration.
     * `null` for patterns with holds, which primitives can't express.
     */
    fun primitives(pattern: HapticPattern): List<PrimitiveStep>? {
        val events = events(pattern)
        if (events.any { it.kind == HapticPatternEvent.Kind.Hold }) return null
        return events.map { tap ->
            val primitive = if (tap.sharpness >= CLICK_SHARPNESS) Primitive.Click else Primitive.Thud
            PrimitiveStep(primitive, tap.intensity, tap.timeMs)
        }
    }

    /**
     * The delay before each step, each counted from the end of the primitive before, as
     * `VibrationEffect.Composition.addPrimitive` takes them. `null` if a primitive lasts past the next
     * step's start on this vibrator: the taps would then drift later than the spec and
     * [HapticPattern.durationMs], so the pattern should play as a waveform instead.
     *
     * @param durationMs how long the vibrator plays each primitive.
     */
    fun primitiveDelays(steps: List<PrimitiveStep>, durationMs: (Primitive) -> Int): List<Int>? {
        var previousEndMs = 0L
        return steps.map { step ->
            val delayMs = step.atMs - previousEndMs
            if (delayMs < 0) return null
            previousEndMs = step.atMs + durationMs(step.primitive)
            delayMs.toInt()
        }
    }

    /**
     * The pattern as a plain waveform, which every vibrator can play.
     *
     * Events can overlap, as they do on iOS: a tap can land on a hold, as in a doorbell's "ding" over its
     * ring. Core Haptics mixes them, so here a tap over a hold adds its strength to the hold's for as long
     * as the tap lasts, and the tap still stands out from it. Holds never overlap each other, and taps are
     * cut short where the next tap starts, so neither runs into the next of its kind.
     */
    fun waveform(pattern: HapticPattern): Waveform = waveform(events(pattern))

    fun waveform(events: List<HapticPatternEvent>): Waveform {
        val taps = events.filter { it.kind == HapticPatternEvent.Kind.Tap }.sortedBy { it.timeMs }
        val tapSpans = taps.mapIndexed { index, tap ->
            val next = taps.getOrNull(index + 1)?.timeMs
            val length = if (next == null) tapMs(tap.sharpness) else minOf(tapMs(tap.sharpness), next - tap.timeMs)
            Span(tap.timeMs, tap.timeMs + length, tap.intensity)
        }
        val holdSpans = events.filter { it.kind == HapticPatternEvent.Kind.Hold }.map { Span(it.timeMs, it.endMs, it.intensity) }

        // Every moment the strength can change, then the strength between each and the next.
        val edges = (tapSpans + holdSpans).flatMap { listOf(it.startMs, it.endMs) }.toSortedSet().toList()
        val timings = mutableListOf<Long>()
        val amplitudes = mutableListOf<Int>()
        // Silence before the first event, should a pattern ever start late.
        if (edges.first() > 0) {
            timings += edges.first()
            amplitudes += 0
        }
        for ((start, end) in edges.zipWithNext()) {
            val hold = holdSpans.filter { it.covers(start) }.maxOfOrNull { it.intensity } ?: 0f
            val tap = tapSpans.filter { it.covers(start) }.maxOfOrNull { it.intensity } ?: 0f
            val amplitude = if (hold == 0f && tap == 0f) 0 else amplitude(minOf(hold + tap, 1f))
            // Runs of one strength play as one segment.
            if (amplitudes.isNotEmpty() && amplitudes.last() == amplitude) {
                timings[timings.lastIndex] += end - start
            } else {
                timings += end - start
                amplitudes += amplitude
            }
        }
        return Waveform(timings, amplitudes)
    }

    /** One event's place in a waveform, from [startMs] up to [endMs]. */
    private data class Span(val startMs: Long, val endMs: Long, val intensity: Float) {
        fun covers(timeMs: Long) = timeMs in startMs until endMs
    }

    /** How long a tap of [sharpness] vibrates in a waveform. */
    fun tapMs(sharpness: Float): Long =
        (DULL_TAP_MS - (DULL_TAP_MS - SHARP_TAP_MS) * sharpness.coerceIn(0f, 1f)).roundToLong()

    /** Converts an iOS-style intensity (0..1) to an Android amplitude (1..255). */
    fun amplitude(intensity: Float): Int =
        (intensity.coerceIn(0f, 1f) * Waveform.MAX_AMPLITUDE).toInt().coerceAtLeast(1)
}
