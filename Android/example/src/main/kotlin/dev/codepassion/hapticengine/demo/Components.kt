package dev.codepassion.hapticengine.demo

import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.GraphicEq
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import dev.codepassion.hapticengine.HapticPattern

/** Springs used across the demo, matching SwiftUI's `.snappy`. */
fun <T> snappy() = spring<T>(dampingRatio = 0.85f, stiffness = 500f)

/**
 * A pattern's icon on a light rounded square in its color, a shade deeper while playing.
 * Shared by every layout so a pattern looks the same wherever it appears.
 */
@Composable
fun PatternIcon(pattern: HapticPattern, isPlaying: Boolean, modifier: Modifier = Modifier, size: Dp = 44.dp) {
    val tint = pattern.tint
    val background by animateColorAsState(tint.copy(alpha = if (isPlaying) 0.25f else 0.15f), snappy(), label = "icon")
    Box(
        modifier
            .size(size)
            .background(background, RoundedCornerShape(size * 0.27f)),
        contentAlignment = Alignment.Center,
    ) {
        Icon(pattern.icon, contentDescription = null, tint = tint, modifier = Modifier.size(size * 0.5f))
    }
}

/** A waveform that pulses while a pattern plays, like SF Symbols' variable color effect on iOS. */
@Composable
fun PlayingIndicator(tint: Color, modifier: Modifier = Modifier) {
    val alpha by rememberInfiniteTransition(label = "playing").animateFloat(
        initialValue = 1f,
        targetValue = 0.35f,
        animationSpec = infiniteRepeatable(tween(450), RepeatMode.Reverse),
        label = "alpha",
    )
    Icon(
        Icons.Rounded.GraphicEq,
        contentDescription = null,
        tint = tint,
        modifier = modifier.size(22.dp).graphicsLayer { this.alpha = alpha },
    )
}

/** Shrinks slightly while pressed, so a tap feels physical even without haptics. Like `PressableStyle` on iOS. */
fun Modifier.pressScale(interactionSource: MutableInteractionSource): Modifier = composed {
    val pressed by interactionSource.collectIsPressedAsState()
    val scale by animateFloatAsState(if (pressed) 0.96f else 1f, snappy(), label = "press")
    graphicsLayer { scaleX = scale; scaleY = scale }
}
