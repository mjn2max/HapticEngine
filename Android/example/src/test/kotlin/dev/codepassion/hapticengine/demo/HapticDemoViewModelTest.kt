package dev.codepassion.hapticengine.demo

import dev.codepassion.hapticengine.HapticEngine
import dev.codepassion.hapticengine.HapticPattern
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.runTest
import kotlinx.coroutines.test.setMain
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneOffset

/** Mirrors `HapticDemoModelTests.swift`. */
@OptIn(ExperimentalCoroutinesApi::class)
class HapticDemoViewModelTest {
    private val dispatcher = StandardTestDispatcher()

    private class SpyEngine(override val isHapticsSupported: Boolean = true) : HapticEngine {
        val played = mutableListOf<HapticPattern>()
        override fun play(pattern: HapticPattern) {
            played += pattern
        }
    }

    private val engine = SpyEngine()
    private val store = InMemoryActivityStore()

    /** Runs work handed to other threads at once, so tests see it. */
    private fun model(activity: ActivityStore = store) =
        HapticDemoViewModel(engine, activity = activity, playbackExecutor = { it.run() }, storageExecutor = { it.run() }, zone = { ZoneOffset.UTC })

    @Before
    fun setUp() = Dispatchers.setMain(dispatcher)

    @After
    fun tearDown() = Dispatchers.resetMain()

    @Test
    fun playingPlaysAndLogs() {
        val model = model()
        model.play(HapticPattern.Success)
        assertEquals(listOf(HapticPattern.Success), engine.played)
        assertEquals(listOf(HapticPattern.Success), model.log.map { it.pattern })
        assertEquals(HapticPattern.Success, model.lastPlayed)
        assertEquals(model.log.first().id, model.nowPlaying?.entryId)
        // Saved as it's played.
        assertEquals(model.log, store.load())
    }

    @Test
    fun replayingTheSamePatternAddsNoEntry() {
        val model = model()
        model.play(HapticPattern.Tick)
        model.play(HapticPattern.Tick)
        model.play(HapticPattern.Knock)
        assertEquals(listOf(HapticPattern.Knock, HapticPattern.Tick), model.log.map { it.pattern })
        assertEquals(3, engine.played.size)
    }

    @Test
    fun replayFromHistoryLeavesTheLogAlone() {
        val model = model()
        model.play(HapticPattern.Tick)
        model.play(HapticPattern.Knock)
        val tick = model.log.last()
        model.replay(tick)
        assertEquals(listOf(HapticPattern.Knock, HapticPattern.Tick), model.log.map { it.pattern })
        assertEquals(tick.id, model.nowPlaying?.entryId)
    }

    @Test
    fun theLogKeepsTheNewestThousand() {
        val model = model()
        repeat(ActivityStore.LIMIT + 5) { model.play(if (it % 2 == 0) HapticPattern.Tick else HapticPattern.Knock) }
        assertEquals(ActivityStore.LIMIT, model.log.size)
    }

    @Test
    fun nowPlayingClearsOnceThePatternEnds() = runTest(dispatcher) {
        val model = model()
        model.play(HapticPattern.Heartbeat)
        assertNotNull(model.nowPlaying)
        advanceTimeBy(HapticPattern.Heartbeat.durationMs + 1)
        assertNull(model.nowPlaying)
        // Still shown, so it can be starred or replayed.
        assertEquals(HapticPattern.Heartbeat, model.lastPlayed)
    }

    @Test
    fun aTickStaysLongEnoughToNotice() = runTest(dispatcher) {
        val model = model()
        model.play(HapticPattern.Tick)
        advanceTimeBy(HapticDemoViewModel.MINIMUM_DISPLAY_MS - 1)
        assertNotNull(model.nowPlaying)
        advanceTimeBy(2)
        assertNull(model.nowPlaying)
    }

    @Test
    fun favoritesToggleInTheOrderStarred() {
        val model = model()
        model.toggleFavorite(HapticPattern.Rumble)
        model.toggleFavorite(HapticPattern.Tick)
        assertEquals(listOf(HapticPattern.Rumble, HapticPattern.Tick), model.favorites)
        model.toggleFavorite(HapticPattern.Rumble)
        assertEquals(listOf(HapticPattern.Tick), model.favorites)
        assertFalse(model.isFavorite(HapticPattern.Rumble))
    }

    @Test
    fun recentHoldsStillWhileShowing() {
        val model = model()
        model.play(HapticPattern.Tick)
        model.play(HapticPattern.Knock)
        model.selectFilter(PatternFilter.Recent)
        assertEquals(listOf(HapticPattern.Knock, HapticPattern.Tick), model.recentPatterns)
        // Played from Recent: it stays where it was, under the finger.
        model.play(HapticPattern.Tick)
        assertEquals(listOf(HapticPattern.Knock, HapticPattern.Tick), model.recentPatterns)
        // Chosen again, it catches up.
        model.selectFilter(PatternFilter.Recent)
        assertEquals(listOf(HapticPattern.Tick, HapticPattern.Knock), model.recentPatterns)
    }

    @Test
    fun deletingAndClearingSave() {
        val model = model()
        model.play(HapticPattern.Tick)
        model.play(HapticPattern.Knock)
        model.deleteEntry(model.log.first())
        assertEquals(listOf(HapticPattern.Tick), model.log.map { it.pattern })
        assertEquals(listOf(HapticPattern.Tick), model.recentPatterns)
        model.clearLog()
        assertTrue(model.log.isEmpty())
        assertTrue(store.load().isEmpty())
    }

    @Test
    fun loadsTheSavedLog() {
        store.add(LogEntry(1, Instant.parse("2026-10-01T10:00:00Z"), HapticPattern.Pulse))
        store.add(LogEntry(2, Instant.parse("2026-10-02T10:00:00Z"), HapticPattern.Tick))
        val model = model()
        assertEquals(listOf(HapticPattern.Tick, HapticPattern.Pulse), model.log.map { it.pattern })
        assertEquals(listOf(HapticPattern.Tick, HapticPattern.Pulse), model.recentPatterns)
        assertEquals(2, model.logDays.size)
    }

    @Test
    fun theLaunchRippleNeedsSavedPreferences() {
        // Without them, as in previews, it never plays.
        assertFalse(model().claimLaunchRipple())
    }
}

class ActivityDayTest {
    private fun entry(id: Long, time: String) = LogEntry(id, Instant.parse(time), HapticPattern.Tick)

    @Test
    fun groupsRunsOfOneDay() {
        val log = listOf(entry(3, "2026-10-08T20:00:00Z"), entry(2, "2026-10-08T08:00:00Z"), entry(1, "2026-10-06T12:00:00Z"))
        val days = ActivityDay.group(log, ZoneOffset.UTC)
        assertEquals(listOf(LocalDate.parse("2026-10-08"), LocalDate.parse("2026-10-06")), days.map { it.day })
        assertEquals(listOf(3L, 2L), days.first().entries.map { it.id })
    }

    @Test
    fun namesRecentDaysAndDatesBeyond() {
        val today = LocalDate.parse("2026-10-08")
        assertEquals("Today", dayTitle(today, today, java.util.Locale.US))
        assertEquals("Yesterday", dayTitle(today.minusDays(1), today, java.util.Locale.US))
        assertEquals("Friday", dayTitle(LocalDate.parse("2026-10-02"), today, java.util.Locale.US))
        assertEquals("Wed, Sep 30", dayTitle(LocalDate.parse("2026-09-30"), today, java.util.Locale.US))
        assertEquals("Dec 31, 2025", dayTitle(LocalDate.parse("2025-12-31"), today, java.util.Locale.US))
    }
}
