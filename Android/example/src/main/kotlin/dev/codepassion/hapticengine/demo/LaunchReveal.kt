package dev.codepassion.hapticengine.demo

import android.content.Context
import android.os.Build
import android.os.SystemClock
import android.os.VibrationAttributes
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.Settings
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.graphics.BlurEffect
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay

/**
 * How the home screen first appears: a ripple. The patterns come into focus in a wave spreading diagonally
 * from the top-start corner, then the now-playing bar docks below them. On the first launch the wave can be
 * felt too: see [LaunchRipple]. Once per launch; afterwards everything shows at once. Mirrors
 * `LaunchReveal.swift`.
 *
 * Timed from when the wave starts, rather than switched on for everything at once, because the patterns
 * are built lazily: some are only built once the wave is under way. Each takes its turn whenever it's built,
 * and one built after its turn shows at once.
 */
object LaunchReveal {
    /** A beat after the wave starts. */
    const val START_MS = 30L

    /** From the first pattern's turn to the last's. */
    const val SPREAD_MS = 320L

    /** About a screenful, in rows and columns from the corner. Patterns further out join the last of them. */
    private const val REACH = 10.0

    /** The bar docks as the wave's tail lands. */
    val BAR_DELAY_MS = START_MS + (SPREAD_MS * 0.85).toLong()

    /** Each pattern coming into focus: quick, with a hint of settle. */
    const val DURATION_MS = 450L

    /** When the pattern [row] rows down and [column] columns across takes its turn. A title takes half a row. */
    fun delayMs(row: Double, column: Int = 0): Long {
        val progress = ((row + column) / REACH).coerceIn(0.0, 1.0)
        // Eased out: long gaps near the corner, short ones further out.
        return START_MS + (SPREAD_MS * (1 - (1 - progress) * (1 - progress))).toLong()
    }
}

/**
 * When the home screen's wave started, in [SystemClock.uptimeMillis], or `null` until it does. Long ago by
 * default, so other screens and previews show at once.
 */
val LocalLaunchRevealStart = compositionLocalOf<Long?> { Long.MIN_VALUE / 2 }

/** Whether the system's animations are off, Android's closest setting to iOS's Reduce Motion. */
fun Context.prefersReducedMotion(): Boolean =
    Settings.Global.getFloat(contentResolver, Settings.Global.ANIMATOR_DURATION_SCALE, 1f) == 0f

/** Comes into focus where it sits as the home screen first appears, [row] rows down and [column] across. */
fun Modifier.launchReveal(row: Double, column: Int = 0): Modifier =
    launchReveal(LaunchReveal.delayMs(row, column), offset = 4.dp, scale = 0.94f, blur = 6.dp)

/** Rises [distance] and fades in as the home screen first appears, [delayMs] after the wave starts. */
fun Modifier.launchRise(delayMs: Long, distance: Dp): Modifier =
    launchReveal(delayMs, offset = distance, scale = 1f, blur = 0.dp)

private fun Modifier.launchReveal(delayMs: Long, offset: Dp, scale: Float, blur: Dp): Modifier = composed {
    val start = LocalLaunchRevealStart.current
    val reduceMotion = LocalContext.current.prefersReducedMotion()
    val offsetPx = with(LocalDensity.current) { offset.toPx() }
    val blurPx = with(LocalDensity.current) { blur.toPx() }
    // Built after its turn was over, such as a pattern scrolled to later: no animation then.
    val progress = remember {
        val isLate = start != null && SystemClock.uptimeMillis() - start >= delayMs + LaunchReveal.DURATION_MS
        Animatable(if (isLate) 1f else 0f)
    }
    LaunchedEffect(start) {
        if (start == null || progress.value == 1f) return@LaunchedEffect
        // What's left of the wait for its turn: all of it if built early, none if built late.
        delay((delayMs - (SystemClock.uptimeMillis() - start)).coerceAtLeast(0))
        progress.animateTo(1f, if (reduceMotion) tween(200) else spring(dampingRatio = 0.8f, stiffness = 300f))
    }
    val moved = { if (reduceMotion) 0f else 1f - progress.value }
    this
        .graphicsLayer {
            alpha = progress.value.coerceIn(0f, 1f)
            val s = 1f - (1f - scale) * moved()
            scaleX = s
            scaleY = s
            translationY = offsetPx * moved()
            // Only for a pattern: it sharpens as it lands. Drawn by the layer, so it costs no recomposition.
            val radius = blurPx * moved()
            renderEffect = if (radius > 0.5f) BlurEffect(radius, radius) else null
        }
}

/**
 * A tap at the patterns' first turns, fading as the wave spreads, like a pebble dropped in water: what the
 * haptic engine is for, felt before anything's read. Only on the first launch, and soft: a hint, not a buzz.
 *
 * Played with the system vibrator rather than the library: the library plays its own patterns, and this
 * one belongs to the demo. Mirrors `LaunchRipple` on iOS.
 */
object LaunchRipple {
    /** Where the wave is when each tap lands, in rows from the corner, and the tap's strength. */
    private val taps = listOf(0.0 to 0.45f, 2.0 to 0.32f, 4.5 to 0.22f, 8.0 to 0.14f)

    /** Taps land as their patterns are partway into focus rather than as they start. */
    private const val LAG_MS = 60L

    fun play(context: Context) {
        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Vibrator::class.java)
        }
        if (!vibrator.hasVibrator()) return
        val times = taps.map { (row, _) -> LaunchReveal.delayMs(row) + LAG_MS }
        val effect = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
            vibrator.areAllPrimitivesSupported(VibrationEffect.Composition.PRIMITIVE_LOW_TICK)
        ) {
            val composition = VibrationEffect.startComposition()
            var previous = 0L
            taps.zip(times) { (_, strength), time ->
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, strength * 2f, (time - previous).toInt())
                previous = time
            }
            composition.compose()
        } else {
            // Short, faint pulses where the vibrator has no primitives.
            val timings = mutableListOf<Long>()
            val amplitudes = mutableListOf<Int>()
            var cursor = 0L
            taps.zip(times) { (_, strength), time ->
                timings += time - cursor
                amplitudes += 0
                timings += TAP_MS
                amplitudes += (strength * 255).toInt().coerceAtLeast(1)
                cursor = time + TAP_MS
            }
            VibrationEffect.createWaveform(timings.toLongArray(), amplitudes.toIntArray(), -1)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            vibrator.vibrate(effect, VibrationAttributes.createForUsage(VibrationAttributes.USAGE_TOUCH))
        } else {
            vibrator.vibrate(effect)
        }
    }

    private const val TAP_MS = 10L
}
