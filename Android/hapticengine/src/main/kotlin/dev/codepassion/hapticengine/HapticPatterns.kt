package dev.codepassion.hapticengine

/**
 * A vibration waveform as alternating segments: each entry in [timingsMs] lasts that long
 * at the matching entry in [amplitudes] (0 = off, 1..255 = strength).
 *
 * Kept free of Android types so patterns can be unit tested on the JVM.
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

/** Android equivalents of the iOS patterns in `HapticEngine.swift`. */
internal object HapticPatterns {
    private const val TAP_MS = 20L
    private const val TAP_INTERVAL_MS = 100L
    private const val SEGMENT_MS = 1_500L

    /** A full-strength tap, then taps every 100 ms rising from 10% to 90% strength. */
    val simple: Waveform = run {
        val timings = mutableListOf(0L, TAP_MS)
        val amplitudes = mutableListOf(0, Waveform.MAX_AMPLITUDE)
        for (step in 1..9) {
            timings += listOf(TAP_INTERVAL_MS - TAP_MS, TAP_MS)
            amplitudes += listOf(0, amplitude(step / 10f))
        }
        Waveform(timings, amplitudes)
    }

    /** Medium (0.5), hard (1.0), soft (0.2), hard (1.0); 1.5 seconds each. */
    val complex: Waveform = listOf(0.5f, 1.0f, 0.2f, 1.0f).let { intensities ->
        Waveform(
            timingsMs = intensities.map { SEGMENT_MS },
            amplitudes = intensities.map(::amplitude),
        )
    }

    /** Converts an iOS-style intensity (0..1) to an Android amplitude (0..255). */
    fun amplitude(intensity: Float): Int =
        (intensity.coerceIn(0f, 1f) * Waveform.MAX_AMPLITUDE).toInt().coerceAtLeast(1)
}
