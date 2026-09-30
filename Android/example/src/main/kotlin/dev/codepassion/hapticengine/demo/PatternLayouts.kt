package dev.codepassion.hapticengine.demo

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import dev.codepassion.hapticengine.HapticPattern

/** Patterns as compact tiles, at least 100 dp wide: the grid layout. */
@Composable
fun PatternGrid(
    patterns: List<HapticPattern>,
    playing: HapticPattern?,
    onPlay: (HapticPattern) -> Unit,
    enabled: Boolean = true,
) {
    AdaptiveGrid(patterns, minWidth = 100.dp) { pattern ->
        PatternCard(pattern, isPlaying = playing == pattern, enabled = enabled, onPlay = onPlay) {
            Column(
                Modifier.fillMaxWidth().padding(horizontal = 8.dp, vertical = 14.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                PatternIcon(pattern, isPlaying = playing == pattern)
                Text(
                    pattern.title,
                    style = MaterialTheme.typography.titleSmall,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
        }
    }
}

/** Patterns as cards with their description and length, at least 160 dp wide: the cards layout. */
@Composable
fun PatternCards(
    patterns: List<HapticPattern>,
    playing: HapticPattern?,
    onPlay: (HapticPattern) -> Unit,
    enabled: Boolean = true,
) {
    AdaptiveGrid(patterns, minWidth = 160.dp) { pattern ->
        val isPlaying = playing == pattern
        PatternCard(pattern, isPlaying = isPlaying, enabled = enabled, onPlay = onPlay) {
            Column(Modifier.fillMaxWidth().padding(14.dp), verticalArrangement = Arrangement.spacedBy(6.dp)) {
                Row(verticalAlignment = Alignment.Top) {
                    PatternIcon(pattern, isPlaying = isPlaying)
                    Spacer(Modifier.weight(1f))
                    DurationOrPlaying(pattern, isPlaying)
                }
                Spacer(Modifier.height(4.dp))
                Text(pattern.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold)
                Text(
                    pattern.subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    // Reserved so every card in a row is the same height.
                    minLines = 2,
                    maxLines = 2,
                )
            }
        }
    }
}

/** Patterns as rows in one card, with their description and length: the list layout. */
@Composable
fun PatternList(
    patterns: List<HapticPattern>,
    playing: HapticPattern?,
    onPlay: (HapticPattern) -> Unit,
    enabled: Boolean = true,
) {
    Column(
        Modifier
            .clip(RoundedCornerShape(CardRadius))
            .background(LocalDemoColors.current.card),
    ) {
        patterns.forEachIndexed { index, pattern ->
            val isPlaying = playing == pattern
            PatternRow(
                pattern = pattern,
                isPlaying = isPlaying,
                onClick = { onPlay(pattern) },
                enabled = enabled,
                supporting = pattern.subtitle,
                stateText = if (isPlaying) "Playing" else pattern.durationText,
            ) {
                DurationOrPlaying(pattern, isPlaying)
            }
            if (index != patterns.lastIndex) RowDivider()
        }
    }
}

/**
 * One row of a pattern's icon, name and a supporting line, used by the list layout and the activity screen.
 * Tints while playing, like the cards, so a pattern responds the same way everywhere.
 */
@Composable
fun PatternRow(
    pattern: HapticPattern,
    isPlaying: Boolean,
    onClick: () -> Unit,
    supporting: String,
    stateText: String,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    trailing: @Composable () -> Unit,
) {
    val wash by animateColorAsState(
        if (isPlaying) pattern.tint.copy(alpha = 0.08f) else Color.Transparent,
        snappy(),
        label = "wash",
    )
    Row(
        modifier
            .fillMaxWidth()
            .background(wash)
            .clickable(enabled = enabled, onClick = onClick)
            .semantics { stateDescription = stateText }
            .padding(horizontal = 12.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        PatternIcon(pattern, isPlaying = isPlaying, size = 40.dp)
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
            Text(pattern.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold)
            Text(
                supporting,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis,
            )
        }
        trailing()
    }
}

/** Inset to line up with the text, as in system lists. */
@Composable
fun RowDivider() {
    HorizontalDivider(Modifier.padding(start = 64.dp), color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.6f))
}

/** The pattern's length, or a pulsing waveform while it plays. */
@Composable
fun DurationOrPlaying(pattern: HapticPattern, isPlaying: Boolean) {
    AnimatedContent(
        targetState = isPlaying,
        transitionSpec = { (fadeIn() + scaleIn(initialScale = 0.6f)) togetherWith (fadeOut() + scaleOut(targetScale = 0.6f)) },
        contentAlignment = Alignment.CenterEnd,
        label = "duration",
    ) { playing ->
        if (playing) {
            PlayingIndicator(pattern.tint)
        } else {
            Text(
                pattern.durationText,
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

/**
 * A tile or card: ripples while pressed, fills with a soft wash of the pattern's color and gains a
 * border in it while playing. The same states as the rows, so every layout responds alike.
 */
@Composable
private fun PatternCard(
    pattern: HapticPattern,
    isPlaying: Boolean,
    enabled: Boolean,
    onPlay: (HapticPattern) -> Unit,
    content: @Composable () -> Unit,
) {
    val shape = RoundedCornerShape(CardRadius)
    val tint = pattern.tint
    val wash by animateColorAsState(if (isPlaying) tint.copy(alpha = 0.08f) else Color.Transparent, snappy(), label = "wash")
    val borderWidth by animateDpAsState(if (isPlaying) 2.dp else 0.dp, snappy(), label = "border")
    Column(
        Modifier
            .fillMaxSize()
            .clip(shape)
            .background(LocalDemoColors.current.card)
            .background(wash)
            .border(BorderStroke(borderWidth, if (borderWidth > 0.dp) tint else Color.Transparent), shape)
            .clickable(enabled = enabled) { onPlay(pattern) }
            .semantics { stateDescription = if (isPlaying) "Playing" else pattern.durationText },
    ) {
        content()
    }
}

/** As many equal columns of at least [minWidth] as fit, 12 dp apart, like SwiftUI's adaptive grid. */
@Composable
private fun AdaptiveGrid(
    items: List<HapticPattern>,
    minWidth: Dp,
    item: @Composable (HapticPattern) -> Unit,
) {
    BoxWithConstraints {
        val spacing = 12.dp
        val columns = maxOf(1, ((maxWidth + spacing) / (minWidth + spacing)).toInt())
        Column(verticalArrangement = Arrangement.spacedBy(spacing)) {
            items.chunked(columns).forEach { row ->
                // Equal heights across a row, as SwiftUI's grid gives.
                Row(Modifier.height(IntrinsicSize.Min), horizontalArrangement = Arrangement.spacedBy(spacing)) {
                    row.forEach { pattern ->
                        Box(Modifier.weight(1f).fillMaxHeight()) { item(pattern) }
                    }
                    repeat(columns - row.size) { Spacer(Modifier.weight(1f)) }
                }
            }
        }
    }
}
