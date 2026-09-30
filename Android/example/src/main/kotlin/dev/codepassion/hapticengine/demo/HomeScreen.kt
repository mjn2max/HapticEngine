package dev.codepassion.hapticengine.demo

import android.content.Context
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.tween
import androidx.compose.animation.expandHorizontally
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.shrinkHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.List
import androidx.compose.material.icons.rounded.Apps
import androidx.compose.material.icons.rounded.GridView
import androidx.compose.material.icons.rounded.History
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.TransformOrigin
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.layout.onPlaced
import androidx.compose.ui.layout.positionInParent
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.core.content.edit
import dev.codepassion.hapticengine.HapticPattern

/** How the patterns are laid out, ordered from quickest to tap to most detailed. Remembered between launches. */
enum class PatternLayout(val title: String, val icon: ImageVector) {
    /** Icon and name, three to a row: for tapping quickly. */
    Grid("Grid", Icons.Rounded.Apps),

    /** Two-column cards with description and length: for browsing. */
    Cards("Cards", Icons.Rounded.GridView),

    /** One row per pattern with description and length: for scanning details. */
    List("List", Icons.AutoMirrored.Rounded.List);

    companion object {
        private const val PREFS = "demo"
        private const val KEY = "patternLayout"

        /** The layout saved last time, or the default. A saved value from a removed layout falls back too. */
        fun saved(context: Context): PatternLayout =
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString(KEY, null)
                ?.let { name -> entries.firstOrNull { it.name == name } } ?: Grid

        fun save(context: Context, layout: PatternLayout) =
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit { putString(KEY, layout.name) }
    }
}

/** The home screen: what's playing pinned at the top, then every pattern. Mirrors `ContentView.swift`. */
@Composable
fun HomeScreen(viewModel: HapticDemoViewModel, onOpenActivity: () -> Unit) {
    val colors = LocalDemoColors.current
    Column(Modifier.fillMaxSize().background(colors.background)) {
        // Pinned, so what's playing stays visible while scrolling to the lower patterns.
        Row(
            Modifier
                .statusBarsPadding()
                .padding(horizontal = 16.dp, vertical = 8.dp)
                // Lets the history button match the card's height.
                .height(IntrinsicSize.Min),
            horizontalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            val cardInteraction = remember { MutableInteractionSource() }
            val lastPlayed = viewModel.lastPlayed
            PlayerCard(
                playback = viewModel.nowPlaying,
                lastPlayed = lastPlayed,
                isHapticsSupported = viewModel.isHapticsSupported,
                modifier = Modifier
                    .weight(1f)
                    .pressScale(cardInteraction)
                    .clip(RoundedCornerShape(CardRadius))
                    // Nothing to replay until a pattern has been played.
                    .clickable(
                        enabled = lastPlayed != null,
                        interactionSource = cardInteraction,
                        indication = null,
                        onClickLabel = "Play again",
                    ) { lastPlayed?.let(viewModel::play) },
            )
            HistoryButton(enabled = viewModel.isHapticsSupported, onClick = onOpenActivity)
        }

        Column(
            Modifier
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
                .padding(top = 8.dp, bottom = 16.dp)
                .navigationBarsPadding(),
        ) {
            PatternsSection(
                playing = viewModel.nowPlaying?.pattern,
                canPlay = viewModel.isHapticsSupported,
                onPlay = viewModel::play,
            )
        }
    }
}

@Composable
private fun HistoryButton(enabled: Boolean, onClick: () -> Unit) {
    val interaction = remember { MutableInteractionSource() }
    Box(
        Modifier
            .width(56.dp)
            .fillMaxHeight()
            .pressScale(interaction)
            // Nothing can be played without a vibrator, so there's no activity to show. Dimmed to match the patterns.
            .alpha(if (enabled) 1f else 0.4f)
            .clip(RoundedCornerShape(CardRadius))
            .background(LocalDemoColors.current.card)
            .clickable(enabled = enabled, interactionSource = interaction, indication = null, onClick = onClick)
            .semantics { contentDescription = "Activity" },
        contentAlignment = Alignment.Center,
    ) {
        Icon(Icons.Rounded.History, contentDescription = null, tint = MaterialTheme.colorScheme.primary, modifier = Modifier.size(26.dp))
    }
}

/** Every pattern, grouped by category, in the layout the user picked. Mirrors `PatternsView.swift`. */
@Composable
fun PatternsSection(playing: HapticPattern?, canPlay: Boolean, onPlay: (HapticPattern) -> Unit) {
    val context = LocalContext.current
    val haptics = LocalHapticFeedback.current
    var layout by remember { mutableStateOf(PatternLayout.saved(context)) }

    Column(verticalArrangement = Arrangement.spacedBy(20.dp)) {
        Row(Modifier.padding(start = 4.dp), verticalAlignment = Alignment.CenterVertically) {
            Text("Patterns", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Spacer(Modifier.weight(1f))
            LayoutSwitcher(layout) {
                layout = it
                PatternLayout.save(context, it)
                // A light tick on each change, fitting for a haptics demo.
                haptics.performHapticFeedback(HapticFeedbackType.SegmentTick)
            }
        }

        // All sections, headings included, change as one block: the old layout leaves at once and the new one
        // fades in from slightly smaller. Every layout keeps the same order and colors, so the eye can follow
        // a pattern across.
        AnimatedContent(
            targetState = layout,
            transitionSpec = {
                (fadeIn(tween(250)) + scaleIn(tween(250), initialScale = 0.98f, transformOrigin = TransformOrigin(0.5f, 0f)))
                    .togetherWith(ExitTransition.None)
            },
            label = "layout",
        ) { shown ->
            Column(
                Modifier.alpha(if (canPlay) 1f else 0.4f),
                verticalArrangement = Arrangement.spacedBy(20.dp),
            ) {
                PatternCategory.entries.forEach { category ->
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        Text(
                            category.title,
                            style = MaterialTheme.typography.titleSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier.padding(start = 4.dp),
                        )
                        when (shown) {
                            PatternLayout.Grid -> PatternGrid(category.patterns, playing, onPlay, enabled = canPlay)
                            PatternLayout.Cards -> PatternCards(category.patterns, playing, onPlay, enabled = canPlay)
                            PatternLayout.List -> PatternList(category.patterns, playing, onPlay, enabled = canPlay)
                        }
                    }
                }
            }
        }
    }
}

/**
 * Picks the layout. The selected option shows its icon and name, the others only their icon, and the
 * highlight slides between them, so it's always clear which layout is showing.
 */
@Composable
private fun LayoutSwitcher(selection: PatternLayout, onSelect: (PatternLayout) -> Unit) {
    val density = LocalDensity.current
    // Where each option sits, so the highlight can slide to the selected one.
    val bounds = remember { mutableStateMapOf<PatternLayout, Pair<Dp, Dp>>() }
    val target = bounds[selection]
    val highlightX by animateDpAsState(target?.first ?: 0.dp, snappy(), label = "x")
    val highlightWidth by animateDpAsState(target?.second ?: 0.dp, snappy(), label = "width")

    Box(
        Modifier
            .clip(CircleShape)
            .background(MaterialTheme.colorScheme.surfaceContainerHighest)
            .padding(3.dp)
            .selectableGroup()
            .semantics { contentDescription = "Layout" },
    ) {
        if (target != null) {
            Box(
                Modifier
                    .offset { IntOffset(highlightX.roundToPx(), 0) }
                    .width(highlightWidth)
                    .height(34.dp)
                    .background(MaterialTheme.colorScheme.primary, CircleShape),
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(2.dp)) {
            PatternLayout.entries.forEach { layout ->
                val isSelected = layout == selection
                val content by animateColorAsState(
                    if (isSelected) MaterialTheme.colorScheme.onPrimary else MaterialTheme.colorScheme.onSurfaceVariant,
                    snappy(),
                    label = "content",
                )
                Row(
                    Modifier
                        .height(34.dp)
                        .clip(CircleShape)
                        .selectable(selected = isSelected, role = Role.Tab) { onSelect(layout) }
                        .semantics { contentDescription = layout.title }
                        .onPlaced { coordinates ->
                            with(density) {
                                bounds[layout] = coordinates.positionInParent().x.toDp() to coordinates.size.width.toDp()
                            }
                        }
                        .padding(horizontal = if (isSelected) 14.dp else 11.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp),
                ) {
                    Icon(layout.icon, contentDescription = null, tint = content, modifier = Modifier.size(20.dp))
                    AnimatedVisibility(
                        visible = isSelected,
                        enter = fadeIn() + expandHorizontally(expandFrom = Alignment.Start),
                        exit = fadeOut() + shrinkHorizontally(shrinkTowards = Alignment.Start),
                    ) {
                        Text(layout.title, style = MaterialTheme.typography.labelLarge, color = content, maxLines = 1)
                    }
                }
            }
        }
    }
}


// A preview has nothing to scope a view model to, so it makes one directly.
@Suppress("ViewModelConstructorInComposable")
@Preview(name = "Supported")
@Composable
private fun HomePreview() {
    DemoTheme { HomeScreen(HapticDemoViewModel(PreviewHapticEngine()), onOpenActivity = {}) }
}

// A preview has nothing to scope a view model to, so it makes one directly.
@Suppress("ViewModelConstructorInComposable")
@Preview(name = "No vibrator")
@Composable
private fun HomeUnsupportedPreview() {
    DemoTheme { HomeScreen(HapticDemoViewModel(PreviewHapticEngine(isHapticsSupported = false)), onOpenActivity = {}) }
}
