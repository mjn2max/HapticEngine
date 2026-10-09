package dev.codepassion.hapticengine.demo

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyGridScope
import androidx.compose.foundation.lazy.grid.LazyGridState
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.History
import androidx.compose.material.icons.outlined.SearchOff
import androidx.compose.material.icons.outlined.StarOutline
import androidx.compose.material.icons.rounded.PlayArrow
import androidx.compose.material.icons.rounded.Star
import androidx.compose.material.icons.rounded.StarOutline
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.CustomAccessibilityAction
import androidx.compose.ui.semantics.customActions
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.onClick
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import dev.codepassion.hapticengine.HapticPattern

/** What shows when a filter or search has no patterns. */
sealed interface EmptyState {
    data object NoFavorites : EmptyState
    data object NoRecent : EmptyState
    data class NoResults(val query: String) : EmptyState
}

/**
 * Every pattern, filtered from the top bar or by a search, in the layout the user picked. Mirrors
 * `PatternsView.swift`.
 *
 * @param bottomPadding room below the patterns for the now-playing bar, so the last ones can scroll clear
 *   of it.
 */
@Composable
fun PatternsView(
    viewModel: HapticDemoViewModel,
    sections: List<PatternSection>,
    emptyState: EmptyState,
    footerCount: Int?,
    gridState: LazyGridState,
    contentPadding: PaddingValues,
    onShowAll: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val layout = viewModel.layout
    val playing = viewModel.nowPlaying?.pattern
    val favorites = viewModel.favorites

    // Wider at the largest text sizes, so names fit two to a row rather than breaking mid-word in three.
    val minWidth = if (LocalDensity.current.fontScale > 1.3f) GRID_MIN_WIDTH_LARGE_TEXT else GRID_MIN_WIDTH
    BoxWithConstraints(modifier.fillMaxSize()) {
        // How many tiles fit across, for where each comes in the launch wave, as the adaptive grid works it out.
        val columnCount = if (layout == PatternLayout.Grid) {
            ((maxWidth - 32.dp + GRID_SPACING) / (minWidth + GRID_SPACING)).toInt().coerceAtLeast(1)
        } else {
            1
        }
        LazyVerticalGrid(
            columns = if (layout == PatternLayout.Grid) GridCells.Adaptive(minWidth) else GridCells.Fixed(1),
            state = gridState,
            contentPadding = contentPadding,
            horizontalArrangement = Arrangement.spacedBy(GRID_SPACING),
            verticalArrangement = Arrangement.spacedBy(if (layout == PatternLayout.Grid) GRID_SPACING else 0.dp),
            modifier = Modifier
                .fillMaxSize()
                // A list row is read across, name to length: on a tablet's whole width they sat far apart.
                .then(if (layout == PatternLayout.List) Modifier.widthIn(max = 700.dp).align(Alignment.TopCenter) else Modifier)
                .testTag("patternList"),
        ) {
            if (sections.isEmpty()) {
                item(span = { GridItemSpan(maxLineSpan) }) {
                    EmptyView(emptyState, Modifier.padding(top = 40.dp).launchReveal(row = 0.0))
                }
                return@LazyVerticalGrid
            }
            var row = 0.0
            sections.forEachIndexed { index, section ->
                if (section.title != null) {
                    val titleRow = row
                    item(key = "title-${section.id}", span = { GridItemSpan(maxLineSpan) }, contentType = "title") {
                        Text(
                            section.title,
                            style = MaterialTheme.typography.titleSmall,
                            fontWeight = FontWeight.SemiBold,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier
                                .padding(start = 4.dp, top = if (index == 0) 0.dp else 20.dp, bottom = if (layout == PatternLayout.Grid) 0.dp else 8.dp)
                                .semantics { heading() }
                                .launchReveal(row = titleRow),
                        )
                    }
                    row += 0.5
                }
                val firstRow = row
                patterns(section, layout, firstRow, columnCount, playing, favorites, viewModel)
                row += ((section.patterns.size + columnCount - 1) / columnCount).toDouble()
            }
            if (footerCount != null) {
                val footerRow = row
                item(key = "footer", span = { GridItemSpan(maxLineSpan) }) {
                    ShowAllFooter(footerCount, onShowAll, Modifier.padding(top = 16.dp).launchReveal(row = footerRow))
                }
            }
        }
    }
}

private fun LazyGridScope.patterns(
    section: PatternSection,
    layout: PatternLayout,
    firstRow: Double,
    columnCount: Int,
    playing: HapticPattern?,
    favorites: List<HapticPattern>,
    viewModel: HapticDemoViewModel,
) {
    itemsIndexed(section.patterns, key = { _, pattern -> "${section.id}-${pattern.name}" }, contentType = { _, _ -> layout }) { offset, pattern ->
        val isFavorite = pattern in favorites
        val isPlaying = pattern == playing
        when (layout) {
            PatternLayout.Grid -> PatternTile(
                pattern, isPlaying, isFavorite,
                onPlay = { viewModel.play(pattern) },
                onToggleFavorite = { viewModel.toggleFavorite(pattern) },
                modifier = Modifier.launchReveal(row = firstRow + offset / columnCount, column = offset % columnCount),
            )
            PatternLayout.List -> PatternRow(
                pattern, isPlaying, isFavorite,
                isFirst = offset == 0,
                isLast = offset == section.patterns.lastIndex,
                onPlay = { viewModel.play(pattern) },
                onToggleFavorite = { viewModel.toggleFavorite(pattern) },
                modifier = Modifier.launchReveal(row = firstRow + offset),
            )
        }
    }
}

private val GRID_MIN_WIDTH = 100.dp
private val GRID_MIN_WIDTH_LARGE_TEXT = 160.dp
private val GRID_SPACING = 12.dp

/** Icon and name, the quickest to tap. The now-playing bar shows the description of the one last played. */
@Composable
private fun PatternTile(
    pattern: HapticPattern,
    isPlaying: Boolean,
    isFavorite: Boolean,
    onPlay: () -> Unit,
    onToggleFavorite: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val tint = pattern.tint
    val border by animateDpAsState(if (isPlaying) 2.dp else 0.dp, snappy(), label = "border")
    val wash by animateColorAsState(if (isPlaying) tint.copy(alpha = 0.08f) else Color.Transparent, snappy(), label = "wash")
    val interaction = remember { MutableInteractionSource() }
    PatternActions(pattern, isFavorite, onPlay, onToggleFavorite, interaction, modifier.pressScale(interaction)) { actions ->
        Column(
            Modifier
                .clip(RoundedCornerShape(CardRadius))
                .background(LocalDemoColors.current.card)
                .background(wash)
                .border(border, if (isPlaying) tint else Color.Transparent, RoundedCornerShape(CardRadius))
                .then(actions)
                .padding(vertical = 14.dp, horizontal = 8.dp)
                .fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            PatternIcon(pattern, isPlaying, isFavorite = isFavorite)
            Text(
                pattern.title,
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.SemiBold,
                textAlign = TextAlign.Center,
                // Two lines, kept even when one is enough, so every tile is one height.
                minLines = 2,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis,
            )
        }
    }
}

/** A row with the description and length: for reading what each pattern does. */
@Composable
private fun PatternRow(
    pattern: HapticPattern,
    isPlaying: Boolean,
    isFavorite: Boolean,
    isFirst: Boolean,
    isLast: Boolean,
    onPlay: () -> Unit,
    onToggleFavorite: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val tint = pattern.tint
    val wash by animateColorAsState(if (isPlaying) tint.copy(alpha = 0.08f) else Color.Transparent, snappy(), label = "wash")
    val interaction = remember { MutableInteractionSource() }
    PatternActions(pattern, isFavorite, onPlay, onToggleFavorite, interaction, modifier, detail = pattern.durationText) { actions ->
        Column(Modifier.groupedCardRow(isFirst, isLast)) {
            Row(
                Modifier
                    .background(wash)
                    .then(actions)
                    .padding(horizontal = 12.dp, vertical = 10.dp)
                    .fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                PatternIcon(pattern, isPlaying, isFavorite = isFavorite, size = 40.dp)
                Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                    Text(pattern.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold)
                    Text(pattern.subtitle, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
                if (isPlaying) {
                    PlayingIndicator(tint)
                } else {
                    Text(pattern.durationText, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            }
            if (!isLast) RowDivider()
        }
    }
}

/**
 * The actions every pattern offers wherever it appears: a tap plays it, and touching and holding opens a
 * menu to play it or star it, with the same actions for TalkBack. Mirrors `patternActions` on iOS.
 *
 * @param content draws the pattern, applying the modifier it's given where the pattern is tapped.
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun PatternActions(
    pattern: HapticPattern,
    isFavorite: Boolean,
    onPlay: () -> Unit,
    onToggleFavorite: () -> Unit,
    interaction: MutableInteractionSource,
    modifier: Modifier = Modifier,
    detail: String? = null,
    content: @Composable (Modifier) -> Unit,
) {
    var isMenuOpen by remember { mutableStateOf(false) }
    val haptics = LocalHapticFeedback.current
    val favoriteTitle = if (isFavorite) "Remove from Favorites" else "Add to Favorites"
    val actions = Modifier
        .combinedClickable(
            interactionSource = interaction,
            indication = androidx.compose.material3.ripple(),
            onClickLabel = "Play",
            onLongClickLabel = "More",
            onLongClick = {
                haptics.performHapticFeedback(HapticFeedbackType.LongPress)
                isMenuOpen = true
            },
            onClick = onPlay,
        )
        .semantics {
            stateDescription = listOfNotNull(if (isFavorite) "Favorite" else null, detail).joinToString(", ")
            customActions = listOf(CustomAccessibilityAction(favoriteTitle) { onToggleFavorite(); true })
        }
    Box(modifier.testTag("pattern.${pattern.name}")) {
        content(actions)
        DropdownMenu(expanded = isMenuOpen, onDismissRequest = { isMenuOpen = false }) {
            MenuItem("Play", Icons.Rounded.PlayArrow) {
                isMenuOpen = false
                onPlay()
            }
            MenuItem(favoriteTitle, if (isFavorite) Icons.Rounded.StarOutline else Icons.Rounded.Star) {
                isMenuOpen = false
                onToggleFavorite()
            }
        }
    }
}

@Composable
private fun MenuItem(title: String, icon: ImageVector, onClick: () -> Unit) {
    DropdownMenuItem(text = { Text(title) }, leadingIcon = { Icon(icon, contentDescription = null) }, onClick = onClick)
}

/**
 * At the end of a filtered list, how much of the whole it is and the way back to everything: someone who
 * scrolled through a category finishes here, far from the filter at the top.
 */
@Composable
private fun ShowAllFooter(shown: Int, onShowAll: () -> Unit, modifier: Modifier = Modifier) {
    Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.Center, verticalAlignment = Alignment.CenterVertically) {
        Text(
            "Showing $shown of ${HapticPattern.entries.size} ·",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        TextButton(onClick = onShowAll, modifier = Modifier.testTag("showAll")) {
            Text("Show All", fontWeight = FontWeight.SemiBold)
        }
    }
}

@Composable
private fun EmptyView(state: EmptyState, modifier: Modifier = Modifier) {
    val (icon, title, message) = when (state) {
        is EmptyState.NoResults -> Triple(Icons.Outlined.SearchOff, "No Results for “${state.query.trim()}”", "Check the spelling or try a new search.")
        EmptyState.NoRecent -> Triple(Icons.Outlined.History, "Nothing Played Yet", "Patterns you play show up here, newest first, to feel them again.")
        // Favorites and Recent are the only filters that can be empty: every category has patterns.
        EmptyState.NoFavorites -> Triple(Icons.Outlined.StarOutline, "No Favorites Yet", "Touch and hold a pattern, or tap the star after playing one, to keep it here.")
    }
    Column(
        modifier.fillMaxWidth().padding(horizontal = 32.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        Icon(icon, contentDescription = null, tint = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.size(48.dp))
        Spacer(Modifier.size(4.dp))
        Text(title, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center)
        Text(message, style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onSurfaceVariant, textAlign = TextAlign.Center)
    }
}
