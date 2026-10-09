package dev.codepassion.hapticengine.demo

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp

/**
 * The grouped look of the iOS demo, built from the Material color scheme: cards on a slightly darker
 * background in light mode, and lighter cards on a near-black background in dark mode.
 */
@Immutable
data class DemoColors(
    val isDark: Boolean,
    val background: Color,
    val card: Color,
    /** A row's pressed highlight, and quiet fills such as a meter's track. */
    val fill: Color,
    /** Hairlines between rows. */
    val separator: Color,
)

val LocalDemoColors = staticCompositionLocalOf {
    DemoColors(isDark = false, background = Color.Unspecified, card = Color.Unspecified, fill = Color.Unspecified, separator = Color.Unspecified)
}

/** Corner radius of every card, tile and row group, as on iOS. */
val CardRadius = 20.dp

/**
 * The iOS system colors the demo tints patterns, categories and rows with, in their light and dark
 * variants, so a pattern looks the same on both platforms.
 */
enum class DemoTint(private val light: Long, private val dark: Long) {
    Blue(0xFF007AFF, 0xFF0A84FF),
    Indigo(0xFF5856D6, 0xFF5E5CE6),
    Teal(0xFF30B0C7, 0xFF40C8E0),
    Green(0xFF34C759, 0xFF30D158),
    Orange(0xFFFF9500, 0xFFFF9F0A),
    Red(0xFFFF3B30, 0xFFFF453A),
    Pink(0xFFFF2D55, 0xFFFF375F),
    Brown(0xFFA2845E, 0xFFAC8E68),
    Purple(0xFFAF52DE, 0xFFBF5AF2),
    Cyan(0xFF32ADE6, 0xFF64D2FF),
    Mint(0xFF00C7BE, 0xFF63E6E2),
    Gray(0xFF8E8E93, 0xFF98989D),
    Yellow(0xFFFFCC00, 0xFFFFD60A);

    val color: Color
        @Composable @ReadOnlyComposable
        get() = Color(if (LocalDemoColors.current.isDark) dark else light)
}

@Composable
fun DemoTheme(dark: Boolean = isSystemInDarkTheme(), content: @Composable () -> Unit) {
    val colorScheme = when {
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (dark) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        dark -> darkColorScheme()
        else -> lightColorScheme()
    }
    val demoColors = DemoColors(
        isDark = dark,
        background = if (dark) colorScheme.surface else colorScheme.surfaceContainer,
        card = if (dark) colorScheme.surfaceContainerHigh else colorScheme.surfaceContainerLowest,
        fill = colorScheme.onSurface.copy(alpha = 0.08f),
        separator = colorScheme.outlineVariant.copy(alpha = 0.6f),
    )
    CompositionLocalProvider(LocalDemoColors provides demoColors) {
        MaterialTheme(colorScheme = colorScheme) {
            // Screens draw their own background rather than sitting in a Surface, so set the text color here;
            // otherwise it falls back to black, which disappears in dark mode.
            CompositionLocalProvider(LocalContentColor provides colorScheme.onSurface, content = content)
        }
    }
}
