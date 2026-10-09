package dev.codepassion.hapticengine.demo

import android.os.SystemClock
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.codepassion.hapticengine.HapticEngine
import dev.codepassion.hapticengine.HapticPattern
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.util.UUID
import java.util.concurrent.Executor
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicLong

/**
 * The demo's state: favorites, the filter and layout, the activity log, and what's playing. Mirrors
 * `HapticDemoModel` on iOS.
 *
 * @param playbackExecutor where patterns are handed to the engine. Off the main thread: the first play of a
 *   pattern builds its vibration, and the call into the system can take long enough to drop a frame just as
 *   a tapped pattern starts animating. One thread, so patterns still play in the order they were tapped.
 * @param storageExecutor where the activity log is written, for the same reason.
 */
class HapticDemoViewModel(
    private val engine: HapticEngine,
    private val preferences: Preferences? = null,
    private val activity: ActivityStore = InMemoryActivityStore(),
    private val playbackExecutor: Executor = backgroundThread("playback"),
    private val storageExecutor: Executor = backgroundThread("storage"),
    private val zone: () -> ZoneId = ZoneId::systemDefault,
) : ViewModel() {
    /** The pattern most recently played, while it's still playing. */
    data class Playback(
        val pattern: HapticPattern,
        /** The log entry this playback belongs to, so the history screen highlights the right row. */
        val entryId: Long?,
        val startMs: Long = SystemClock.uptimeMillis(),
        val id: Long = nextPlaybackId.incrementAndGet(),
    ) {
        /** Keeps very short patterns, like Tick, on screen long enough to notice. */
        val displayMs: Long get() = maxOf(pattern.durationMs, MINIMUM_DISPLAY_MS)
    }

    val isHapticsSupported: Boolean get() = engine.isHapticsSupported

    /** Patterns the user starred, in the order they were starred. Saved between launches. */
    var favorites by mutableStateOf(preferences?.favorites.orEmpty())
        private set

    /** What the browser shows. Saved between launches. */
    var filter by mutableStateOf(preferences?.filter ?: PatternFilter.All)
        private set

    /** How the browser lays out the patterns. Saved between launches. */
    var layout by mutableStateOf(preferences?.layout ?: PatternLayout.Grid)
        private set

    /**
     * Newest first. Only records a pattern when it differs from the one before, so replays don't add
     * entries. Saved between launches.
     */
    var log by mutableStateOf(activity.load())
        private set

    /** The log split into days, for the history screen. Grouped when the log changes, not on every frame. */
    var logDays by mutableStateOf(ActivityDay.group(log, zone()))
        private set

    /**
     * The patterns in the log, newest first, each once: what the Recent filter shows.
     *
     * Held still while Recent is showing: kept live, playing a pattern there moved it to the top, out from
     * under the finger that tapped it. It catches up when Recent is chosen again, and whenever entries are
     * removed, which happens on the history screen, out of sight.
     */
    var recentPatterns by mutableStateOf(emptyList<HapticPattern>())
        private set

    var nowPlaying by mutableStateOf<Playback?>(null)
        private set

    /** Stays set after the pattern finishes, so its description can still be read. */
    var lastPlayed by mutableStateOf<HapticPattern?>(null)
        private set

    private var playbackEnd: Job? = null

    init {
        refreshRecentPatterns()
    }

    fun selectFilter(filter: PatternFilter) {
        this.filter = filter
        preferences?.filter = filter
        // Choosing Recent, even again, brings it up to date: see `recentPatterns`.
        if (filter == PatternFilter.Recent) refreshRecentPatterns()
    }

    fun selectLayout(layout: PatternLayout) {
        this.layout = layout
        preferences?.layout = layout
    }

    /** Whether the launch reveal's haptic ripple should play: once, on the first launch, where haptics play. */
    fun claimLaunchRipple(): Boolean {
        val preferences = preferences ?: return false
        if (!isHapticsSupported || preferences.hasFeltLaunchRipple) return false
        preferences.hasFeltLaunchRipple = true
        return true
    }

    fun isFavorite(pattern: HapticPattern): Boolean = pattern in favorites

    fun toggleFavorite(pattern: HapticPattern) {
        favorites = if (pattern in favorites) favorites - pattern else favorites + pattern
        preferences?.favorites = favorites
    }

    /** Plays a pattern chosen on the home screen, logging it if it differs from the last one logged. */
    fun play(pattern: HapticPattern) {
        if (log.firstOrNull()?.pattern != pattern) {
            val entry = LogEntry(UUID.randomUUID().mostSignificantBits, Instant.now(), pattern)
            updateLog((listOf(entry) + log).take(ActivityStore.LIMIT))
            storageExecutor.execute { activity.add(entry) }
            if (filter != PatternFilter.Recent) refreshRecentPatterns()
        }
        startPlayback(pattern, log.firstOrNull()?.id)
    }

    /** Plays a pattern from the history without logging it again, so the list doesn't change under the finger. */
    fun replay(entry: LogEntry) = startPlayback(entry.pattern, entry.id)

    fun deleteEntry(entry: LogEntry) {
        updateLog(log.filter { it.id != entry.id })
        storageExecutor.execute { activity.delete(entry.id) }
        refreshRecentPatterns()
    }

    fun clearLog() {
        updateLog(emptyList())
        storageExecutor.execute { activity.deleteAll() }
        refreshRecentPatterns()
    }

    private fun updateLog(log: List<LogEntry>) {
        this.log = log
        logDays = ActivityDay.group(log, zone())
    }

    private fun refreshRecentPatterns() {
        recentPatterns = log.map { it.pattern }.distinct()
    }

    private fun startPlayback(pattern: HapticPattern, entryId: Long?) {
        playbackExecutor.execute { engine.play(pattern) }

        // The engine doesn't report when a pattern finishes, so clear it once its duration has passed.
        // A new tap replaces the one before it.
        val playback = Playback(pattern, entryId)
        nowPlaying = playback
        lastPlayed = pattern
        playbackEnd?.cancel()
        playbackEnd = viewModelScope.launch {
            delay(playback.displayMs)
            nowPlaying = null
        }
    }

    override fun onCleared() {
        engine.stop()
    }

    companion object {
        const val MINIMUM_DISPLAY_MS = 600L
        private val nextPlaybackId = AtomicLong()

        /** One thread that never keeps the process alive. */
        private fun backgroundThread(name: String): Executor =
            Executors.newSingleThreadExecutor { runnable -> Thread(runnable, "HapticDemo-$name").apply { isDaemon = true } }
    }
}

/** The entries played on one day, newest first, under a header naming the day. Mirrors `ActivityDay` on iOS. */
data class ActivityDay(val day: LocalDate, val entries: List<LogEntry>) {
    companion object {
        /** Splits a log, newest first, into days, newest first. The log is in order, so each day is a run. */
        fun group(log: List<LogEntry>, zone: ZoneId): List<ActivityDay> {
            val days = mutableListOf<Pair<LocalDate, MutableList<LogEntry>>>()
            for (entry in log) {
                val day = entry.time.atZone(zone).toLocalDate()
                if (days.lastOrNull()?.first == day) days.last().second += entry else days += day to mutableListOf(entry)
            }
            return days.map { (day, entries) -> ActivityDay(day, entries) }
        }
    }
}

/** For previews and tests, where there's no vibrator to drive. */
class PreviewHapticEngine(override val isHapticsSupported: Boolean = true) : HapticEngine {
    override fun play(pattern: HapticPattern) = Unit
}
