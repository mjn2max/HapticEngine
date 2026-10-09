package dev.codepassion.hapticengine.demo

import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.graphics.Color
import dev.codepassion.hapticengine.HapticPattern
import java.util.Locale

/**
 * Display text, symbols and colors for the library's built-in patterns. Mirrors `HapticPattern+Display.swift`:
 * the names and descriptions are the iOS demo's, copied into `PatternDetailsData.kt` by
 * `Android/scripts/export-patterns.sh`.
 */
val HapticPattern.title: String get() = details.title

/** Written to fit two lines of the now-playing bar on a small phone. */
val HapticPattern.subtitle: String get() = details.subtitle

/** The SF Symbols name iOS draws it with; [PatternSymbol] draws the Material icon for it. */
val HapticPattern.symbol: String get() = details.symbol

/** The section the demo lists the pattern under. */
val HapticPattern.category: PatternCategory get() = details.category

/** [HapticPattern.durationMs] for display, such as "Instant", "250 ms" or "1.5 s", as on iOS. */
val HapticPattern.durationText: String
    get() = formatDuration(durationMs)

fun formatDuration(durationMs: Long): String {
    if (durationMs < 50) return "Instant"
    if (durationMs < 1_000) return "$durationMs ms"
    // Tenths of a second from whole milliseconds, rounding half up, as on iOS: 1.45 s shows as 1.5 s, and
    // 1.04 s as 1 s. Rounded in floating point, x.x5 went either way.
    val tenths = (durationMs + 50) / 100
    return if (tenths % 10 == 0L) "${tenths / 10} s" else String.format(Locale.getDefault(), "%d%s%d s", tenths / 10, decimalSeparator(), tenths % 10)
}

private fun decimalSeparator(): Char = java.text.DecimalFormatSymbols.getInstance().decimalSeparator

/**
 * The original ten keep their own colors, with feedback in traffic-light colors. The rest take their
 * category's color, so related patterns read as a group.
 */
val HapticPattern.demoTint: DemoTint
    get() = when (this) {
        HapticPattern.Simple -> DemoTint.Blue
        HapticPattern.Complex -> DemoTint.Indigo
        HapticPattern.Tick -> DemoTint.Teal
        HapticPattern.Success -> DemoTint.Green
        HapticPattern.Warning -> DemoTint.Orange
        HapticPattern.Error -> DemoTint.Red
        HapticPattern.Heartbeat -> DemoTint.Pink
        HapticPattern.Knock -> DemoTint.Brown
        HapticPattern.Rumble -> DemoTint.Purple
        HapticPattern.Pulse -> DemoTint.Cyan
        else -> category.tint
    }

val HapticPattern.tint: Color
    @Composable @ReadOnlyComposable
    get() = demoTint.color

/** The two groups the filter panel shows categories in. */
enum class CategoryGroup(val title: String) {
    /** The seven groups of patterns built by hand. */
    BuiltIn("Built In"),

    /** The generated families, each a motif at several levels. */
    Families("Families"),
}

/** In the order the library declares them. Grouped once: screens ask on every recomposition. */
val PatternCategory.patterns: List<HapticPattern>
    get() = patternsByCategory.getValue(this)

private val patternsByCategory: Map<PatternCategory, List<HapticPattern>> by lazy {
    val grouped = HapticPattern.entries.groupBy { it.category }
    PatternCategory.entries.associateWith { grouped[it].orEmpty() }
}

private class PatternDetails(val title: String, val subtitle: String, val symbol: String, val category: PatternCategory)

/** Every pattern's details, read from their rows once, the first time any is asked for. */
private val allDetails: Array<PatternDetails> by lazy {
    Array(HapticPattern.entries.size) { ordinal ->
        val (title, subtitle, symbol, category) = PatternDetailsData.row(ordinal).split('|')
        PatternDetails(title, subtitle, symbol, PatternCategory.entries[category.toInt()])
    }
}

private val HapticPattern.details: PatternDetails get() = allDetails[ordinal]
