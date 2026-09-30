package dev.codepassion.hapticengine.demo

import android.os.SystemClock
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.Spring
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.spring
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.MobileOff
import androidx.compose.material.icons.outlined.TouchApp
import androidx.compose.material.icons.rounded.Replay
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.setValue
import androidx.compose.runtime.withFrameMillis
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import dev.codepassion.hapticengine.HapticPattern

/**
 * Pinned above the patterns: shows what's playing, then keeps showing that pattern once it ends so its
 * description can be read. Before anything is played, it shows a prompt. Mirrors `PlayerCard.swift`.
 *
 * Styled like a pattern card, and it changes in place rather than appearing and disappearing, so
 * tapping doesn't make the layout jump.
 */
@Composable
fun PlayerCard(
    playback: HapticDemoViewModel.Playback?,
    lastPlayed: HapticPattern?,
    isHapticsSupported: Boolean,
    modifier: Modifier = Modifier,
) {
    val pattern = playback?.pattern ?: lastPlayed
    val isPlaying = playback != null
    // Without a vibrator nothing can play, so the card becomes a warning instead of a prompt.
    val isUnavailable = !isHapticsSupported && pattern == null
    val colors = LocalDemoColors.current
    val tint = pattern?.tint ?: if (isUnavailable) colors.caution else MaterialTheme.colorScheme.primary
    val shape = RoundedCornerShape(CardRadius)
    val borderWidth by animateDpAsState(
        when {
            isPlaying -> 2.dp
            isUnavailable -> 1.5.dp
            else -> 0.dp
        },
        snappy(),
        label = "border",
    )
    val borderColor by animateColorAsState(if (borderWidth > 0.dp) tint else Color.Transparent, snappy(), label = "borderColor")

    Box(
        modifier
            .clip(shape)
            .background(colors.card)
            // A tint over the card color, so the warning stands out from the pattern cards.
            .background(if (isUnavailable) tint.copy(alpha = 0.12f) else Color.Transparent)
            .border(borderWidth, borderColor, shape),
    ) {
        Row(
            Modifier.fillMaxWidth().padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            PlayerIcon(pattern, isPlaying, isUnavailable, tint, playbackId = playback?.id)

            Column(
                Modifier
                    .weight(1f)
                    // Read out when the pattern changes, as the iOS demo announces "Playing …".
                    .semantics { liveRegion = LiveRegionMode.Polite },
                verticalArrangement = Arrangement.spacedBy(2.dp),
            ) {
                Text(
                    pattern?.title ?: if (isUnavailable) "Haptics unavailable" else "Tap a pattern",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    maxLines = 1,
                )
                Text(
                    pattern?.subtitle ?: if (isUnavailable) {
                        "No vibrator here. Run on a phone to feel the patterns."
                    } else {
                        "Haptics are on"
                    },
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    // Two lines are always reserved, so the card keeps one height for every description.
                    minLines = 2,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis,
                )
            }

            AnimatedContent(
                targetState = when {
                    isPlaying -> TrailingState.Playing
                    pattern != null -> TrailingState.Replay
                    else -> TrailingState.None
                },
                transitionSpec = { (fadeIn() + scaleIn(initialScale = 0.6f)) togetherWith (fadeOut() + scaleOut(targetScale = 0.6f)) },
                label = "trailing",
            ) { state ->
                when (state) {
                    TrailingState.Playing -> PlayingIndicator(tint)
                    // Shows the card can be tapped to play the pattern again.
                    TrailingState.Replay -> Icon(
                        Icons.Rounded.Replay,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.size(22.dp),
                    )
                    TrailingState.None -> Spacer(Modifier.width(0.dp))
                }
            }
        }

        if (playback != null) {
            PlaybackProgress(
                playback,
                tint,
                Modifier.align(Alignment.BottomCenter).padding(start = 20.dp, end = 20.dp, bottom = 4.dp),
            )
        }
    }
}

private enum class TrailingState { Playing, Replay, None }


@Composable
private fun PlayerIcon(
    pattern: HapticPattern?,
    isPlaying: Boolean,
    isUnavailable: Boolean,
    tint: Color,
    playbackId: Long?,
) {
    val background by animateColorAsState(if (isPlaying) tint else tint.copy(alpha = 0.15f), snappy(), label = "iconBackground")
    val foreground by animateColorAsState(if (isPlaying) Color.White else tint, snappy(), label = "iconForeground")
    // Bounces on every play, including repeat plays of the same pattern.
    val bounce = remember { Animatable(1f) }
    LaunchedEffect(playbackId) {
        if (playbackId == null) return@LaunchedEffect
        bounce.snapTo(0.8f)
        bounce.animateTo(1f, spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessMedium))
    }
    Box(
        Modifier
            .size(44.dp)
            .graphicsLayer { scaleX = bounce.value; scaleY = bounce.value }
            .background(background, RoundedCornerShape(12.dp)),
        contentAlignment = Alignment.Center,
    ) {
        AnimatedContent(
            targetState = pattern?.icon ?: if (isUnavailable) Icons.Outlined.MobileOff else Icons.Outlined.TouchApp,
            transitionSpec = { (fadeIn() + scaleIn(initialScale = 0.5f)) togetherWith (fadeOut() + scaleOut(targetScale = 0.5f)) },
            label = "icon",
        ) { icon ->
            Icon(icon, contentDescription = null, tint = foreground, modifier = Modifier.size(24.dp))
        }
    }
}

/** A thin bar along the card's bottom edge that fills over the pattern's duration. */
@Composable
private fun PlaybackProgress(playback: HapticDemoViewModel.Playback, tint: Color, modifier: Modifier) {
    var progress by remember(playback.id) { mutableFloatStateOf(0f) }
    // Follows the clock rather than an animation, like iOS's timer-based progress view, so it stays true
    // even with animations turned off. A new playback restarts it, including a repeat tap of the same pattern.
    LaunchedEffect(playback.id) {
        while (progress < 1f) {
            withFrameMillis {
                progress = ((SystemClock.elapsedRealtime() - playback.startMs).toFloat() / playback.displayMs).coerceIn(0f, 1f)
            }
        }
    }
    LinearProgressIndicator(
        progress = { progress },
        modifier = modifier.fillMaxWidth().height(3.dp),
        color = tint,
        trackColor = MaterialTheme.colorScheme.surfaceVariant,
        strokeCap = StrokeCap.Round,
        gapSize = 0.dp,
        drawStopIndicator = {},
    )
}

@Preview(name = "Idle")
@Composable
private fun PlayerCardIdlePreview() {
    DemoTheme { PlayerCard(playback = null, lastPlayed = null, isHapticsSupported = true) }
}

@Preview(name = "Playing")
@Composable
private fun PlayerCardPlayingPreview() {
    DemoTheme {
        PlayerCard(
            playback = HapticDemoViewModel.Playback(HapticPattern.Heartbeat, entryId = null),
            lastPlayed = HapticPattern.Heartbeat,
            isHapticsSupported = true,
        )
    }
}

@Preview(name = "No vibrator")
@Composable
private fun PlayerCardUnavailablePreview() {
    DemoTheme { PlayerCard(playback = null, lastPlayed = null, isHapticsSupported = false) }
}
