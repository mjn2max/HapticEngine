package dev.codepassion.hapticengine

import dev.codepassion.hapticengine.HapticEvent.Hold
import dev.codepassion.hapticengine.HapticEvent.Tap
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/** The exact events of every pattern. Keep in step with `HapticPatternSpecTests` on iOS. */
private val specs: Map<HapticPattern, List<HapticEvent>> = mapOf(
    HapticPattern.Simple to listOf(Tap(1f, 1f, 0)) + (1..9).map { Tap(it / 10f, it / 10f, it * 100L) },
    HapticPattern.Complex to listOf(
        Hold(0.5f, 0.5f, 0, 1_500),
        Hold(1f, 1f, 1_500, 1_500),
        Hold(0.2f, 0.2f, 3_000, 1_500),
        Hold(1f, 1f, 4_500, 1_500),
    ),
    HapticPattern.Tick to listOf(Tap(0.5f, 1f, 0)),
    HapticPattern.Success to listOf(Tap(0.6f, 0.5f, 0), Tap(1f, 1f, 150)),
    HapticPattern.Warning to listOf(Tap(1f, 0.6f, 0), Tap(0.6f, 0.6f, 250)),
    HapticPattern.Error to listOf(Tap(1f, 1f, 0), Tap(1f, 1f, 100), Tap(1f, 1f, 200)),
    HapticPattern.Heartbeat to listOf(
        Tap(1f, 0.3f, 0), Tap(0.6f, 0.3f, 150),
        Tap(1f, 0.3f, 800), Tap(0.6f, 0.3f, 950),
    ),
    HapticPattern.Knock to listOf(Tap(0.8f, 0.2f, 0), Tap(0.8f, 0.2f, 250), Tap(0.8f, 0.2f, 500)),
    HapticPattern.Rumble to listOf(Hold(0.8f, 0.1f, 0, 800)),
    HapticPattern.Pulse to (0 until 5).map { Hold(1f, 0.5f, it * 200L, 100) },
)

/** From the first event to the end of the last, as iOS measures it; a tap has no length there. */
private val durationsMs: Map<HapticPattern, Long> = mapOf(
    HapticPattern.Simple to 900, HapticPattern.Complex to 6_000, HapticPattern.Tick to 0,
    HapticPattern.Success to 150, HapticPattern.Warning to 250, HapticPattern.Error to 200,
    HapticPattern.Heartbeat to 950, HapticPattern.Knock to 500, HapticPattern.Rumble to 800,
    HapticPattern.Pulse to 900,
)

/** Equal within a small tolerance, since levels are computed in floating point. */
private fun assertSameEvents(expected: List<HapticEvent>, actual: List<HapticEvent>, pattern: HapticPattern) {
    assertEquals("$pattern event count", expected.size, actual.size)
    expected.zip(actual).forEach { (e, a) ->
        assertEquals("$pattern type", e::class, a::class)
        assertEquals("$pattern time", e.atMs, a.atMs)
        assertEquals("$pattern intensity", e.intensity, a.intensity, 0.0001f)
        assertEquals("$pattern sharpness", e.sharpness, a.sharpness, 0.0001f)
        assertEquals("$pattern length", e.endMs - e.atMs, a.endMs - a.atMs)
    }
}

class HapticPatternSpecTest {
    @Test
    fun everyPatternHasASpec() {
        assertEquals(HapticPattern.entries.toSet(), specs.keys)
        assertEquals(HapticPattern.entries.toSet(), durationsMs.keys)
    }

    @Test
    fun eventsMatchSpec() {
        HapticPattern.entries.forEach { assertSameEvents(specs.getValue(it), HapticPatterns.events(it), it) }
    }

    @Test
    fun durationMatchesSpec() {
        HapticPattern.entries.forEach {
            assertEquals("$it", durationsMs.getValue(it), it.durationMs)
        }
    }

    @Test
    fun patternNamesAreStable() {
        // Names appear in logs and may be persisted by apps, so renaming an entry must be deliberate.
        assertEquals(
            listOf("Simple", "Complex", "Tick", "Success", "Warning", "Error", "Heartbeat", "Knock", "Rumble", "Pulse"),
            HapticPattern.entries.map { it.name },
        )
    }
}

class HapticPatternRuleTest {
    @Test
    fun startsImmediatelyAndStaysInTimeOrder() {
        HapticPattern.entries.forEach {
            val times = HapticPatterns.events(it).map(HapticEvent::atMs)
            assertEquals("$it", 0L, times.first())
            assertEquals("$it", times.sorted(), times)
        }
    }

    @Test
    fun levelsAreInRange() {
        HapticPattern.entries.flatMap(HapticPatterns::events).forEach {
            // Zero strength is silent, so it would only add latency. Zero sharpness is a valid, rounded feel.
            assertTrue(it.intensity > 0f && it.intensity <= 1f)
            assertTrue(it.sharpness in 0f..1f)
        }
    }

    @Test
    fun holdsDoNotOverlap() {
        HapticPattern.entries.forEach { pattern ->
            val holds = HapticPatterns.events(pattern).filterIsInstance<Hold>()
            holds.zipWithNext().forEach { (hold, next) ->
                assertTrue("$pattern", hold.durationMs > 0 && hold.endMs <= next.atMs)
            }
        }
    }

    @Test
    fun patternsAreDistinct() {
        assertEquals(HapticPattern.entries.size, HapticPattern.entries.map(HapticPatterns::events).toSet().size)
    }
}

class WaveformTest {
    @Test
    fun everySegmentHasALengthAndStartsOn() {
        HapticPattern.entries.forEach {
            val waveform = HapticPatterns.waveform(it)
            assertTrue("$it", waveform.timingsMs.all { t -> t > 0 })
            // No silent lead-in: the first segment already vibrates.
            assertTrue("$it", waveform.amplitudes.first() > 0)
        }
    }

    @Test
    fun endsWhenTheLastEventEnds() {
        HapticPattern.entries.forEach {
            val last = HapticPatterns.events(it).last()
            // A tap has no length in the spec, but vibrates for a moment in a waveform.
            val tapLength = if (last is Tap) HapticPatterns.tapMs(last.sharpness) else 0
            assertEquals("$it", durationsMs.getValue(it) + tapLength, HapticPatterns.waveform(it).durationMs)
        }
    }

    @Test
    fun playsOneSegmentPerEventAtItsStrength() {
        HapticPattern.entries.forEach { pattern ->
            val on = HapticPatterns.waveform(pattern).amplitudes.filter { it > 0 }
            assertEquals("$pattern", HapticPatterns.events(pattern).map { HapticPatterns.amplitude(it.intensity) }, on)
        }
    }

    @Test
    fun matchesTheComplexSegments() {
        val complex = HapticPatterns.waveform(HapticPattern.Complex)
        assertEquals(listOf(127, 255, 51, 255), complex.amplitudes)
        assertEquals(List(4) { 1_500L }, complex.timingsMs)
    }

    @Test
    fun sharpTapsAreShorterThanDullOnes() {
        assertEquals(12L, HapticPatterns.tapMs(1f))
        assertEquals(36L, HapticPatterns.tapMs(0f))
        assertTrue(HapticPatterns.tapMs(0.8f) < HapticPatterns.tapMs(0.3f))
    }

    @Test
    fun amplitudeClampsIntensity() {
        assertEquals(255, HapticPatterns.amplitude(2f))
        assertEquals(1, HapticPatterns.amplitude(-1f))
    }

    @Test(expected = IllegalArgumentException::class)
    fun rejectsMismatchedLengths() {
        Waveform(timingsMs = listOf(100L), amplitudes = emptyList())
    }
}

class PrimitivesTest {
    @Test
    fun patternsWithHoldsHaveNoPrimitives() {
        listOf(HapticPattern.Complex, HapticPattern.Rumble, HapticPattern.Pulse).forEach {
            assertNull("$it", HapticPatterns.primitives(it))
        }
    }

    @Test
    fun tapsKeepTheirTimeAndStrength() {
        HapticPattern.entries.forEach { pattern ->
            val steps = HapticPatterns.primitives(pattern) ?: return@forEach
            val taps = HapticPatterns.events(pattern)
            assertEquals("$pattern", taps.map { it.atMs to it.intensity }, steps.map { it.atMs to it.scale })
        }
    }

    @Test
    fun sharpTapsClickAndDullTapsThud() {
        assertEquals(listOf(Primitive.Click), HapticPatterns.primitives(HapticPattern.Tick)?.map { it.primitive })
        assertEquals(List(3) { Primitive.Thud }, HapticPatterns.primitives(HapticPattern.Knock)?.map { it.primitive })
        assertEquals(
            listOf(Primitive.Click, Primitive.Click),
            HapticPatterns.primitives(HapticPattern.Success)?.map { it.primitive },
        )
    }
}

class PrimitiveDelaysTest {
    private fun step(atMs: Long, primitive: Primitive = Primitive.Click) = PrimitiveStep(primitive, 1f, atMs)

    @Test
    fun delaysCountFromTheEndOfThePrimitiveBefore() {
        val steps = listOf(step(0), step(100), step(250))
        // Each click lasts 20 ms: 0, then 100 - 20, then 250 - 120.
        assertEquals(listOf(0, 80, 130), HapticPatterns.primitiveDelays(steps) { 20 })
    }

    @Test
    fun aPrimitiveEndingRightAtTheNextStepNeedsNoDelay() {
        assertEquals(listOf(0, 0), HapticPatterns.primitiveDelays(listOf(step(0), step(100))) { 100 })
    }

    @Test
    fun aPrimitiveLastingPastTheNextStepFallsBack() {
        // A thud longer than the 100 ms between Simple's taps would push every later tap late.
        val simple = HapticPatterns.primitives(HapticPattern.Simple)!!
        assertNull(HapticPatterns.primitiveDelays(simple) { if (it == Primitive.Thud) 120 else 20 })
    }

    @Test
    fun everyPatternKeepsItsTimingWithShortPrimitives() {
        for (pattern in HapticPattern.entries) {
            val steps = HapticPatterns.primitives(pattern) ?: continue
            val delays = HapticPatterns.primitiveDelays(steps) { 20 }
            assertTrue("$pattern fits 20 ms primitives", delays != null)
            // Played back, each step starts exactly when the spec says.
            var endMs = 0L
            val starts = steps.zip(delays!!) { s, delay -> (endMs + delay).also { endMs = it + 20 } }
            assertEquals("$pattern", steps.map { it.atMs }, starts)
        }
    }
}
