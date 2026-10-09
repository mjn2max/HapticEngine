package dev.codepassion.hapticengine

import org.junit.Assert.assertEquals
import org.junit.Test

class HapticEngineTest {
    private class SpyEngine : HapticEngine {
        override val isHapticsSupported = true
        val played = mutableListOf<HapticPattern>()

        override fun play(pattern: HapticPattern) {
            played += pattern
        }
    }

    @Test
    fun shorthandsPlayTheirPattern() {
        val spy = SpyEngine()
        spy.startSimpleHaptic()
        spy.startComplexHaptic()
        spy.startTickHaptic()
        spy.startSuccessHaptic()
        spy.startWarningHaptic()
        spy.startErrorHaptic()
        spy.startHeartbeatHaptic()
        spy.startKnockHaptic()
        spy.startRumbleHaptic()
        spy.startPulseHaptic()
        assertEquals(HapticPattern.entries.take(10), spy.played)
    }

    @Test
    fun stopDefaultsToDoingNothing() {
        // Implementations written before `stop()` existed still compile, and calling it is safe.
        val spy = SpyEngine()
        spy.play(HapticPattern.Tick)
        spy.stop()
        assertEquals(listOf(HapticPattern.Tick), spy.played)
    }
}

class HapticUsageTest {
    @Test
    fun touchUsesTheTouchFeedbackSetting() {
        assertEquals(android.os.VibrationAttributes.USAGE_TOUCH, HapticUsage.Touch.vibrationUsage)
        assertEquals(android.media.AudioAttributes.USAGE_ASSISTANCE_SONIFICATION, HapticUsage.Touch.audioUsage)
    }

    @Test
    fun everyUsageMapsToADistinctSetting() {
        assertEquals(HapticUsage.entries.size, HapticUsage.entries.map { it.vibrationUsage }.toSet().size)
        assertEquals(HapticUsage.entries.size, HapticUsage.entries.map { it.audioUsage }.toSet().size)
    }
}
