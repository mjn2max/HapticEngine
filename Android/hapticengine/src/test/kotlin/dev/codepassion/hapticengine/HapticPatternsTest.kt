package dev.codepassion.hapticengine

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class HapticPatternsTest {
    @Test
    fun simpleStartsWithFullStrengthTap() {
        val amplitudes = HapticPatterns.simple.amplitudes
        assertEquals(Waveform.MAX_AMPLITUDE, amplitudes.first { it > 0 })
    }

    @Test
    fun simplePlaysTenTapsWithRisingStrengthAfterTheFirst() {
        val taps = HapticPatterns.simple.amplitudes.filter { it > 0 }
        assertEquals(10, taps.size)
        val ramp = taps.drop(1)
        assertEquals(ramp.sorted(), ramp)
    }

    @Test
    fun simpleLastsUnderOneSecond() {
        assertEquals(920L, HapticPatterns.simple.durationMs)
    }

    @Test
    fun complexMatchesTheIosSegments() {
        val complex = HapticPatterns.complex
        assertEquals(listOf(127, 255, 51, 255), complex.amplitudes)
        assertEquals(6_000L, complex.durationMs)
    }

    @Test
    fun amplitudeClampsIntensity() {
        assertEquals(255, HapticPatterns.amplitude(2f))
        assertEquals(1, HapticPatterns.amplitude(-1f))
    }

    @Test(expected = IllegalArgumentException::class)
    fun waveformRejectsMismatchedLengths() {
        Waveform(timingsMs = listOf(100L), amplitudes = emptyList())
    }

    @Test
    fun allPatternsHaveMatchingLengths() {
        listOf(HapticPatterns.simple, HapticPatterns.complex).forEach {
            assertTrue(it.timingsMs.size == it.amplitudes.size)
        }
    }
}
