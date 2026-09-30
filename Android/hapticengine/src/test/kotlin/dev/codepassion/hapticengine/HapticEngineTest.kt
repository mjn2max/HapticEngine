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
        assertEquals(HapticPattern.entries, spy.played)
    }
}
