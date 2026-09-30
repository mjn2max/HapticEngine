package dev.codepassion.hapticengine.demo

import android.os.SystemClock
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.codepassion.hapticengine.HapticEngine
import dev.codepassion.hapticengine.HapticPattern
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.time.LocalTime
import java.util.concurrent.atomic.AtomicLong

/** Mirrors `HapticDemoModel` on iOS. */
class HapticDemoViewModel(private val engine: HapticEngine) : ViewModel() {
    /** A pattern the user switched to. */
    data class LogEntry(
        val pattern: HapticPattern,
        val time: LocalTime = LocalTime.now(),
        val id: Long = nextId.incrementAndGet(),
    )

    /** The pattern most recently played, while it's still playing. */
    data class Playback(
        val pattern: HapticPattern,
        /** The log entry this playback belongs to, so the activity screen highlights the right row. */
        val entryId: Long?,
        val startMs: Long = SystemClock.elapsedRealtime(),
        val id: Long = nextId.incrementAndGet(),
    ) {
        /** Keeps very short patterns, like Tick, on screen long enough to notice. */
        val displayMs: Long get() = maxOf(pattern.durationMs, MINIMUM_DISPLAY_MS)
    }

    val isHapticsSupported: Boolean get() = engine.isHapticsSupported

    private val _log = mutableStateListOf<LogEntry>()

    /** Newest first. Only records a pattern when it differs from the one before, so replays don't add entries. */
    val log: List<LogEntry> get() = _log

    var nowPlaying by mutableStateOf<Playback?>(null)
        private set

    /** Stays set after the pattern finishes, so its description can still be read. */
    var lastPlayed by mutableStateOf<HapticPattern?>(null)
        private set

    private var playbackEnd: Job? = null

    /** Plays a pattern chosen on the home screen, logging it if it differs from the last one logged. */
    fun play(pattern: HapticPattern) {
        if (_log.firstOrNull()?.pattern != pattern) {
            _log.add(0, LogEntry(pattern))
            if (_log.size > MAX_ENTRIES) _log.removeAt(_log.lastIndex)
        }
        startPlayback(pattern, _log.firstOrNull()?.id)
    }

    /** Plays a pattern from the activity log without logging it again, so the list doesn't change under the finger. */
    fun replay(entry: LogEntry) = startPlayback(entry.pattern, entry.id)

    fun deleteEntry(entry: LogEntry) {
        _log.removeAll { it.id == entry.id }
    }

    fun clearLog() = _log.clear()

    private fun startPlayback(pattern: HapticPattern, entryId: Long?) {
        engine.play(pattern)

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

    private companion object {
        const val MAX_ENTRIES = 50
        const val MINIMUM_DISPLAY_MS = 600L
        val nextId = AtomicLong()
    }
}

/** For previews, where there's no vibrator to drive. */
class PreviewHapticEngine(override val isHapticsSupported: Boolean = true) : HapticEngine {
    override fun play(pattern: HapticPattern) = Unit
}
