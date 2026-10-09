package dev.codepassion.hapticengine

import dev.codepassion.hapticengine.HapticPatternEvent.Kind
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

private fun tap(intensity: Float, sharpness: Float, atMs: Long) = HapticPatternEvent(Kind.Tap, atMs, 0, intensity, sharpness)

private fun hold(intensity: Float, sharpness: Float, atMs: Long, durationMs: Long) =
    HapticPatternEvent(Kind.Hold, atMs, durationMs, intensity, sharpness)

/** The exact events of the first ten patterns. Keep in step with `HapticPatternSpecTests` on iOS. */
private val specs: Map<HapticPattern, List<HapticPatternEvent>> = mapOf(
    HapticPattern.Simple to listOf(tap(1f, 1f, 0)) + (1..9).map { tap(it / 10f, it / 10f, it * 100L) },
    HapticPattern.Complex to listOf(
        hold(0.5f, 0.5f, 0, 1_500),
        hold(1f, 1f, 1_500, 1_500),
        hold(0.2f, 0.2f, 3_000, 1_500),
        hold(1f, 1f, 4_500, 1_500),
    ),
    HapticPattern.Tick to listOf(tap(0.5f, 1f, 0)),
    HapticPattern.Success to listOf(tap(0.6f, 0.5f, 0), tap(1f, 1f, 150)),
    HapticPattern.Warning to listOf(tap(1f, 0.6f, 0), tap(0.6f, 0.6f, 250)),
    HapticPattern.Error to listOf(tap(1f, 1f, 0), tap(1f, 1f, 100), tap(1f, 1f, 200)),
    HapticPattern.Heartbeat to listOf(
        tap(1f, 0.3f, 0), tap(0.6f, 0.3f, 150),
        tap(1f, 0.3f, 800), tap(0.6f, 0.3f, 950),
    ),
    HapticPattern.Knock to listOf(tap(0.8f, 0.2f, 0), tap(0.8f, 0.2f, 250), tap(0.8f, 0.2f, 500)),
    HapticPattern.Rumble to listOf(hold(0.8f, 0.1f, 0, 800)),
    HapticPattern.Pulse to (0 until 5).map { hold(1f, 0.5f, it * 200L, 100) },
)

/** From the first event to the end of the last, as iOS measures it; a tap has no length there. */
private val durationsMs: Map<HapticPattern, Long> = mapOf(
    HapticPattern.Simple to 900, HapticPattern.Complex to 6_000, HapticPattern.Tick to 0,
    HapticPattern.Success to 150, HapticPattern.Warning to 250, HapticPattern.Error to 200,
    HapticPattern.Heartbeat to 950, HapticPattern.Knock to 500, HapticPattern.Rumble to 800,
    HapticPattern.Pulse to 900,
)

/** Equal within a small tolerance, since levels are computed in floating point. */
private fun assertSameEvents(expected: List<HapticPatternEvent>, actual: List<HapticPatternEvent>, pattern: HapticPattern) {
    assertEquals("$pattern event count", expected.size, actual.size)
    expected.zip(actual).forEach { (e, a) ->
        assertEquals("$pattern kind", e.kind, a.kind)
        assertEquals("$pattern time", e.timeMs, a.timeMs)
        assertEquals("$pattern intensity", e.intensity, a.intensity, 0.0001f)
        assertEquals("$pattern sharpness", e.sharpness, a.sharpness, 0.0001f)
        assertEquals("$pattern length", e.durationMs, a.durationMs)
    }
}

class HapticPatternSpecTest {
    @Test
    fun eventsMatchSpec() {
        specs.forEach { (pattern, spec) -> assertSameEvents(spec, pattern.events, pattern) }
    }

    @Test
    fun durationMatchesSpec() {
        durationsMs.forEach { (pattern, duration) -> assertEquals("$pattern", duration, pattern.durationMs) }
    }

    @Test
    fun patternNamesAreStable() {
        // Names appear in logs and may be persisted by apps, so renaming an entry must be deliberate. The
        // rest are checked against iOS by `AndroidParityTests` there, and against the public API dump here.
        assertEquals(
            listOf("Simple", "Complex", "Tick", "Success", "Warning", "Error", "Heartbeat", "Knock", "Rumble", "Pulse"),
            HapticPattern.entries.take(10).map { it.name },
        )
    }

    @Test
    fun hasEveryPatternFromIOS() {
        assertEquals(4_000, HapticPattern.entries.size)
        assertEquals(HapticPatternData.COUNT, HapticPattern.entries.size)
        // A few from each kind of generated pattern, named as on iOS with a capital first letter.
        listOf("Selection", "Victory", "HeavyMetalHit", "WaltzAllegro", "HugeBark", "OkInMorseSlow", "FirmButton", "TripleGem", "EmberNebula")
            .forEach { assertNotNull(it, HapticPattern.valueOf(it)) }
    }

    @Test
    fun handBuiltPatternsKeepTheirShape() {
        // Spot checks that the copy from iOS lines up entry by entry: each pattern's events are its own.
        assertSameEvents(listOf(tap(0.4f, 0.8f, 0)), HapticPattern.Selection.events, HapticPattern.Selection)
        assertSameEvents(
            listOf(tap(0.5f, 0.6f, 0), tap(0.9f, 0.9f, 60)),
            HapticPattern.ToggleOn.events,
            HapticPattern.ToggleOn,
        )
        assertSameEvents(
            listOf(tap(1f, 0.9f, 0), hold(0.5f, 0.6f, 0, 300), tap(0.8f, 0.4f, 400), hold(0.4f, 0.3f, 400, 400)),
            HapticPattern.Doorbell.events,
            HapticPattern.Doorbell,
        )
    }
}

class HapticPatternDataTest {
    @Test
    fun decodesTapsAndHolds() {
        assertEquals(
            listOf(tap(0.5f, 1f, 0), hold(0.25f, 0.125f, 40, 160)),
            HapticPatterns.decode("t,0,500,1000;h,40,160,250,125"),
        )
    }

    @Test
    fun publicEventsAreTheOnesPlayed() {
        HapticPattern.entries.forEach { assertEquals("$it", HapticPatterns.events(it), it.events) }
    }

    @Test
    fun eventsAreDecodedOnceAndKept() {
        // The same list each time, so reading them while drawing a timeline costs nothing after the first.
        assertTrue(HapticPattern.Thunder.events === HapticPattern.Thunder.events)
    }
}

/** The rules every pattern follows, as on iOS: see `HapticPatternsTests` there. */
class HapticPatternRuleTest {
    @Test
    fun startsImmediatelyAndStaysInTimeOrder() {
        HapticPattern.entries.forEach {
            val times = it.events.map(HapticPatternEvent::timeMs)
            assertEquals("$it", 0L, times.first())
            assertEquals("$it", times.sorted(), times)
        }
    }

    @Test
    fun levelsAreInRange() {
        HapticPattern.entries.forEach { pattern ->
            pattern.events.forEach {
                // Zero strength is silent, so it would only add latency. Zero sharpness is a valid, rounded feel.
                assertTrue("$pattern", it.intensity > 0f && it.intensity <= 1f)
                assertTrue("$pattern", it.sharpness in 0f..1f)
            }
        }
    }

    @Test
    fun holdsDoNotOverlap() {
        HapticPattern.entries.forEach { pattern ->
            val holds = pattern.events.filter { it.kind == Kind.Hold }
            holds.forEach { assertTrue("$pattern", it.durationMs > 0) }
            holds.zipWithNext().forEach { (hold, next) -> assertTrue("$pattern", hold.endMs <= next.timeMs) }
        }
    }

    @Test
    fun tapsAreFeltApart() {
        // Taps closer than about 10 ms are felt as one, so a pattern with them plays fewer than it says.
        HapticPattern.entries.forEach { pattern ->
            pattern.events.filter { it.kind == Kind.Tap }.map { it.timeMs }.zipWithNext().forEach { (tap, next) ->
                assertTrue("$pattern taps at $tap and $next ms", next - tap >= 10)
            }
        }
    }

    @Test
    fun isShortEnoughForFeedback() {
        // The longest, Complex, is 6 seconds.
        HapticPattern.entries.forEach { assertTrue("$it", it.durationMs <= 6_000) }
    }

    @Test
    fun isStrongEnoughToFeel() {
        HapticPattern.entries.forEach { pattern -> assertTrue("$pattern", pattern.events.maxOf { it.intensity } >= 0.3f) }
    }

    @Test
    fun durationIsTheEndOfTheLastEvent() {
        HapticPattern.entries.forEach { assertEquals("$it", it.events.maxOf(HapticPatternEvent::endMs), it.durationMs) }
    }

    @Test
    fun patternsAreDistinct() {
        assertEquals(HapticPattern.entries.size, HapticPattern.entries.map { it.events }.toSet().size)
    }
}

class WaveformTest {
    /** The waveform's amplitude [atMs] after it starts. */
    private fun Waveform.amplitudeAt(atMs: Long): Int {
        var start = 0L
        timingsMs.forEachIndexed { index, length ->
            if (atMs < start + length) return amplitudes[index]
            start += length
        }
        return 0
    }

    @Test
    fun everySegmentHasALengthAndStartsOn() {
        HapticPattern.entries.forEach {
            val waveform = HapticPatterns.waveform(it)
            assertTrue("$it", waveform.timingsMs.all { t -> t > 0 })
            // No silent lead-in: the first segment already vibrates.
            assertTrue("$it", waveform.amplitudes.first() > 0)
            // Neighbors differ, or they'd be one segment.
            assertTrue("$it", waveform.amplitudes.zipWithNext().none { (a, b) -> a == b })
        }
    }

    @Test
    fun endsWhenTheLastEventEnds() {
        HapticPattern.entries.forEach { pattern ->
            // A tap has no length in the spec, but vibrates for a moment in a waveform.
            val tapEnds = pattern.events.filter { it.kind == Kind.Tap }.map { it.timeMs + HapticPatterns.tapMs(it.sharpness) }
            val expected = maxOf(pattern.durationMs, tapEnds.maxOrNull() ?: 0)
            assertEquals("$pattern", expected, HapticPatterns.waveform(pattern).durationMs)
        }
    }

    @Test
    fun everyEventIsFeltWhenItStarts() {
        // Overlapping events used to push later ones back, stretching the pattern: each starts on time now,
        // at least as strong as it is.
        HapticPattern.entries.forEach { pattern ->
            val waveform = HapticPatterns.waveform(pattern)
            pattern.events.forEach {
                assertTrue("$pattern at ${it.timeMs} ms", waveform.amplitudeAt(it.timeMs) >= HapticPatterns.amplitude(it.intensity))
            }
        }
    }

    @Test
    fun playsOneSegmentPerEventWhenNothingOverlaps() {
        specs.keys.forEach { pattern ->
            val on = HapticPatterns.waveform(pattern).amplitudes.filter { it > 0 }
            assertEquals("$pattern", pattern.events.map { HapticPatterns.amplitude(it.intensity) }, on)
        }
    }

    @Test
    fun matchesTheComplexSegments() {
        val complex = HapticPatterns.waveform(HapticPattern.Complex)
        assertEquals(listOf(127, 255, 51, 255), complex.amplitudes)
        assertEquals(List(4) { 1_500L }, complex.timingsMs)
    }

    @Test
    fun aTapOverAHoldStandsOutAndKeepsTheHoldOnTime() {
        // A bright "ding" over a ring, then a lower "dong" over a fainter one at 400 ms.
        val doorbell = HapticPatterns.waveform(HapticPattern.Doorbell)
        assertEquals(listOf(255, 127, 0, 255, 102), doorbell.amplitudes)
        assertEquals(listOf(HapticPatterns.tapMs(0.9f), 300 - HapticPatterns.tapMs(0.9f), 100, HapticPatterns.tapMs(0.4f), 400 - HapticPatterns.tapMs(0.4f)), doorbell.timingsMs)
    }

    @Test
    fun tapsOverALongHoldDoNotStretchIt() {
        // Crackles over a one-second glow: still one second.
        assertEquals(1_000L, HapticPatterns.waveform(HapticPattern.Campfire).durationMs)
    }

    @Test
    fun aTapStopsWhereTheNextBegins() {
        val waveform = HapticPatterns.waveform(listOf(tap(1f, 0f, 0), tap(0.5f, 0f, 20)))
        assertEquals(listOf(20L, 36L), waveform.timingsMs)
        assertEquals(listOf(255, 127), waveform.amplitudes)
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
        HapticPattern.entries.filter { pattern -> pattern.events.any { it.kind == Kind.Hold } }.forEach {
            assertNull("$it", HapticPatterns.primitives(it))
        }
    }

    @Test
    fun tapsKeepTheirTimeAndStrength() {
        HapticPattern.entries.forEach { pattern ->
            val steps = HapticPatterns.primitives(pattern) ?: return@forEach
            assertEquals("$pattern", pattern.events.map { it.timeMs to it.intensity }, steps.map { it.atMs to it.scale })
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
    fun everyPatternKeepsItsTimingOrFallsBack() {
        for (pattern in HapticPattern.entries) {
            val steps = HapticPatterns.primitives(pattern) ?: continue
            val delays = HapticPatterns.primitiveDelays(steps) { 20 }
            val closest = steps.zipWithNext { a, b -> b.atMs - a.atMs }.minOrNull() ?: Long.MAX_VALUE
            // Taps far enough apart for 20 ms primitives play as primitives; closer ones play as a waveform.
            assertEquals("$pattern fits 20 ms primitives", closest >= 20, delays != null)
            if (delays == null) continue
            // Played back, each step starts exactly when the spec says.
            var endMs = 0L
            val starts = steps.zip(delays) { _, delay -> (endMs + delay).also { endMs = it + 20 } }
            assertEquals("$pattern", steps.map { it.atMs }, starts)
        }
    }
}
