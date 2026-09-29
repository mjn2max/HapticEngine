package dev.codepassion.hapticengine.demo

import android.app.Application
import androidx.compose.runtime.mutableStateListOf
import androidx.lifecycle.AndroidViewModel
import dev.codepassion.hapticengine.HapticEngine
import java.time.LocalTime

class HapticDemoViewModel(application: Application) : AndroidViewModel(application) {
    data class LogEntry(val message: String, val time: LocalTime = LocalTime.now())

    private val engine = HapticEngine(application)

    val isHapticsSupported: Boolean get() = engine.isHapticsSupported

    private val _log = mutableStateListOf<LogEntry>()
    val log: List<LogEntry> get() = _log

    fun play(preset: HapticPreset) {
        preset.play(engine)
        record("Played ${preset.title}" + if (isHapticsSupported) "" else " (no vibrator)")
    }

    /** Records lifecycle changes, useful for checking playback still works after backgrounding. */
    fun record(message: String) {
        _log.add(0, LogEntry(message))
        if (_log.size > MAX_ENTRIES) _log.removeAt(_log.lastIndex)
    }

    fun clearLog() = _log.clear()

    private companion object {
        const val MAX_ENTRIES = 50
    }
}
