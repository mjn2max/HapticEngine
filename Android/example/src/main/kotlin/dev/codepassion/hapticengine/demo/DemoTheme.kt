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
    /** Warnings, such as the missing-vibrator card, like iOS's orange. */
    val caution: Color,
)

val LocalDemoColors = staticCompositionLocalOf {
    DemoColors(isDark = false, background = Color.Unspecified, card = Color.Unspecified, caution = Color.Unspecified)
}

/** Corner radius of every card, tile and row group, as on iOS. */
val CardRadius = 20.dp

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
        caution = Color(if (dark) 0xFFFF9F0A else 0xFFFF9500),
    )
    CompositionLocalProvider(LocalDemoColors provides demoColors) {
        MaterialTheme(colorScheme = colorScheme) {
            // Screens draw their own background rather than sitting in a Surface, so set the text color here;
            // otherwise it falls back to black, which disappears in dark mode.
            CompositionLocalProvider(LocalContentColor provides colorScheme.onSurface, content = content)
        }
    }
}
