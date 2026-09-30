package dev.codepassion.hapticengine.demo

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AdsClick
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.Dangerous
import androidx.compose.material.icons.outlined.DoorFront
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material.icons.outlined.GraphicEq
import androidx.compose.material.icons.outlined.Sensors
import androidx.compose.material.icons.outlined.TouchApp
import androidx.compose.material.icons.outlined.WarningAmber
import androidx.compose.material.icons.outlined.Waves
import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import dev.codepassion.hapticengine.HapticPattern
import java.util.Locale

/** Display text, icons and colors for the library's built-in patterns. Mirrors `HapticPattern+Display.swift`. */
val HapticPattern.title: String
    get() = when (this) {
        HapticPattern.Simple -> "Simple"
        HapticPattern.Complex -> "Complex"
        HapticPattern.Tick -> "Tick"
        HapticPattern.Success -> "Success"
        HapticPattern.Warning -> "Warning"
        HapticPattern.Error -> "Error"
        HapticPattern.Heartbeat -> "Heartbeat"
        HapticPattern.Knock -> "Knock"
        HapticPattern.Rumble -> "Rumble"
        HapticPattern.Pulse -> "Pulse"
    }

/** Written to fit two lines of the status card on a small phone. */
val HapticPattern.subtitle: String
    get() = when (this) {
        HapticPattern.Simple -> "Sharp tap, then a rising ramp of taps"
        HapticPattern.Complex -> "Medium, hard, soft, hard over 6 seconds"
        HapticPattern.Tick -> "One light, crisp tap"
        HapticPattern.Success -> "Soft tap, then a strong tap"
        HapticPattern.Warning -> "Strong tap, then a weaker tap"
        HapticPattern.Error -> "Three strong taps in quick succession"
        HapticPattern.Heartbeat -> "Two lub-dub beats, like a pulse"
        HapticPattern.Knock -> "Three firm, dull taps, like a door knock"
        HapticPattern.Rumble -> "Low, strong vibration for 0.8 seconds"
        HapticPattern.Pulse -> "Five short bursts over one second"
    }

val HapticPattern.icon: ImageVector
    get() = when (this) {
        HapticPattern.Simple -> Icons.Outlined.TouchApp
        HapticPattern.Complex -> Icons.Outlined.GraphicEq
        HapticPattern.Tick -> Icons.Outlined.AdsClick
        HapticPattern.Success -> Icons.Outlined.CheckCircle
        HapticPattern.Warning -> Icons.Outlined.WarningAmber
        HapticPattern.Error -> Icons.Outlined.Dangerous
        HapticPattern.Heartbeat -> Icons.Outlined.FavoriteBorder
        HapticPattern.Knock -> Icons.Outlined.DoorFront
        HapticPattern.Rumble -> Icons.Outlined.Waves
        HapticPattern.Pulse -> Icons.Outlined.Sensors
    }

/**
 * Roughly how long the pattern plays, from its first event to the end of its last.
 * Keep in step with the timings in the library's `HapticPatterns.kt`.
 */
val HapticPattern.durationMs: Long
    get() = when (this) {
        HapticPattern.Simple -> 900
        HapticPattern.Complex -> 6_000
        HapticPattern.Tick -> 0
        HapticPattern.Success -> 150
        HapticPattern.Warning -> 250
        HapticPattern.Error -> 200
        HapticPattern.Heartbeat -> 950
        HapticPattern.Knock -> 500
        HapticPattern.Rumble -> 800
        HapticPattern.Pulse -> 900
    }

/** [durationMs] for display, such as "Instant", "250 ms" or "6 s". */
val HapticPattern.durationText: String
    get() = when {
        durationMs < 50 -> "Instant"
        durationMs < 1_000 -> "$durationMs ms"
        durationMs % 1_000 == 0L -> "${durationMs / 1_000} s"
        else -> String.format(Locale.getDefault(), "%.1f s", durationMs / 1_000f)
    }

/**
 * Groups related patterns by color: feedback in traffic-light colors, rhythms in warm tones. The same
 * colors as iOS, in their light and dark variants, so a pattern looks the same on both platforms.
 */
val HapticPattern.tint: Color
    @Composable @ReadOnlyComposable
    get() {
        val (light, dark) = when (this) {
            HapticPattern.Simple -> 0xFF007AFF to 0xFF0A84FF
            HapticPattern.Complex -> 0xFF5856D6 to 0xFF5E5CE6
            HapticPattern.Tick -> 0xFF30B0C7 to 0xFF40C8E0
            HapticPattern.Success -> 0xFF34C759 to 0xFF30D158
            HapticPattern.Warning -> 0xFFFF9500 to 0xFFFF9F0A
            HapticPattern.Error -> 0xFFFF3B30 to 0xFFFF453A
            HapticPattern.Heartbeat -> 0xFFFF2D55 to 0xFFFF375F
            HapticPattern.Knock -> 0xFFA2845E to 0xFFAC8E68
            HapticPattern.Rumble -> 0xFFAF52DE to 0xFFBF5AF2
            HapticPattern.Pulse -> 0xFF32ADE6 to 0xFF64D2FF
        }
        return Color(if (LocalDemoColors.current.isDark) dark else light)
    }

/** The section the demo lists the pattern under. */
val HapticPattern.category: PatternCategory
    get() = when (this) {
        HapticPattern.Tick, HapticPattern.Success, HapticPattern.Warning, HapticPattern.Error -> PatternCategory.Feedback
        HapticPattern.Heartbeat, HapticPattern.Knock, HapticPattern.Pulse -> PatternCategory.Rhythm
        HapticPattern.Simple, HapticPattern.Complex, HapticPattern.Rumble -> PatternCategory.Texture
    }

/** Groups the patterns on the home screen, so the list stays easy to scan as more are added. */
enum class PatternCategory(val title: String) {
    /** Short responses to something the user did. */
    Feedback("Feedback"),

    /** Repeating beats. */
    Rhythm("Rhythm"),

    /** Longer vibrations that build or sustain. */
    Texture("Texture");

    val patterns: List<HapticPattern> get() = HapticPattern.entries.filter { it.category == this }
}
