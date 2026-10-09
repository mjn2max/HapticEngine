package dev.codepassion.hapticengine.demo

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.foundation.background
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.GraphicEq
import androidx.compose.material.icons.rounded.Star
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import dev.codepassion.hapticengine.HapticPattern

/** The springs used across the demo, matching SwiftUI's `.snappy`. */
fun <T> snappy() = spring<T>(dampingRatio = 0.85f, stiffness = 500f)

/**
 * A pattern's symbol on a light rounded square in its color, a shade deeper while playing, with a star when
 * it's a favorite. Shared by every layout so a pattern looks the same wherever it appears. Mirrors
 * `PatternIcon.swift`.
 */
@Composable
fun PatternIcon(
    pattern: HapticPattern,
    isPlaying: Boolean,
    modifier: Modifier = Modifier,
    isFavorite: Boolean = false,
    size: Dp = 44.dp,
) {
    val tint = pattern.tint
    val background by animateColorAsState(tint.copy(alpha = if (isPlaying) 0.25f else 0.15f), snappy(), label = "icon")
    Box(modifier.size(size)) {
        Box(
            Modifier.matchParentSize().background(background, RoundedCornerShape(size * 0.27f)),
            contentAlignment = Alignment.Center,
        ) {
            PatternSymbol(pattern.symbol, tint, size * 0.5f)
        }
        AnimatedVisibility(
            visible = isFavorite,
            enter = scaleIn(snappy()) + fadeIn(),
            exit = scaleOut(snappy()) + fadeOut(),
            modifier = Modifier.align(Alignment.TopEnd).offset(x = size * 0.14f, y = -size * 0.14f),
        ) {
            // A ring in the card color keeps the star clear of the icon behind it.
            Icon(
                Icons.Rounded.Star,
                contentDescription = null,
                tint = DemoTint.Yellow.color,
                modifier = Modifier
                    .background(LocalDemoColors.current.card, CircleShape)
                    .padding(2.dp)
                    .size(size * 0.28f),
            )
        }
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

/** Shrinks slightly while pressed, so a tap feels physical even without haptics. */
fun Modifier.pressScale(interactionSource: MutableInteractionSource): Modifier = composed {
    val pressed by interactionSource.collectIsPressedAsState()
    val scale by animateFloatAsStateCompat(if (pressed) 0.96f else 1f)
    graphicsLayer { scaleX = scale; scaleY = scale }
}

@Composable
private fun animateFloatAsStateCompat(target: Float) =
    androidx.compose.animation.core.animateFloatAsState(target, snappy(), label = "press")

/** A small uppercase heading over a group of rows or tiles, as in a system inset list. */
@Composable
fun GroupHeader(title: String, modifier: Modifier = Modifier) {
    Text(
        title.uppercase(),
        style = MaterialTheme.typography.labelMedium,
        fontWeight = FontWeight.SemiBold,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = modifier.padding(start = 12.dp).semantics { heading() },
    )
}

/** A heading inside the now-playing bar's details, with an optional count at its end. */
@Composable
fun SectionTitle(title: String, modifier: Modifier = Modifier, trailing: String? = null) {
    Row(modifier.fillMaxWidth().padding(top = 8.dp, bottom = 4.dp), verticalAlignment = Alignment.CenterVertically) {
        Text(title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold, modifier = Modifier.weight(1f).semantics { heading() })
        if (trailing != null) {
            Text(trailing, style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
    }
}

/** The rounded surface rows sit on, over the grouped background, as in a system inset list. */
fun Modifier.groupedCard(): Modifier = composed {
    clip(RoundedCornerShape(CardRadius)).background(LocalDemoColors.current.card)
}

/** One row's piece of a grouped card: its corners on the first and last rows only. For lazy lists. */
fun Modifier.groupedCardRow(isFirst: Boolean, isLast: Boolean): Modifier = composed {
    val shape: Shape = RoundedCornerShape(
        topStart = if (isFirst) CardRadius else 0.dp,
        topEnd = if (isFirst) CardRadius else 0.dp,
        bottomStart = if (isLast) CardRadius else 0.dp,
        bottomEnd = if (isLast) CardRadius else 0.dp,
    )
    clip(shape).background(LocalDemoColors.current.card)
}

/** A hairline between rows of a grouped card, inset to line up with the text past the icon. */
@Composable
fun RowDivider(modifier: Modifier = Modifier, inset: Dp = 64.dp) {
    HorizontalDivider(modifier.padding(start = inset), thickness = 0.5.dp, color = LocalDemoColors.current.separator)
}
