package dev.codepassion.hapticengine.demo

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.CheckCircle
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.selected
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

/**
 * Which patterns the home screen shows: every place to go as a tile with its count, all in sight at once.
 * Picking one applies it and closes the panel, as a menu does. Mirrors `FilterPanel.swift`.
 *
 * Thirty-seven categories don't fit a menu on a phone, and a menu row has no room to say how many patterns
 * are behind it. Tiles do both, and give each choice a target as big as a thumb.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FilterPanel(viewModel: HapticDemoViewModel, onDismiss: () -> Unit) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    val scope = rememberCoroutineScope()
    fun close() {
        scope.launch { sheetState.hide() }.invokeOnCompletion { onDismiss() }
    }
    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheetState, containerColor = LocalDemoColors.current.background) {
        Row(Modifier.fillMaxWidth().padding(horizontal = 16.dp), verticalAlignment = Alignment.CenterVertically) {
            Text("Filter", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.SemiBold, modifier = Modifier.weight(1f))
            TextButton(onClick = ::close, modifier = Modifier.testTag("filter.done")) { Text("Done", fontWeight = FontWeight.SemiBold) }
        }
        LazyVerticalGrid(
            columns = GridCells.Adaptive(104.dp),
            contentPadding = PaddingValues(start = 16.dp, end = 16.dp, top = 8.dp, bottom = 24.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            // The way back to everything, your own and what you played, first, under their own heading.
            item(span = { GridItemSpan(maxLineSpan) }) { GroupHeader("Show") }
            item(span = { GridItemSpan(maxLineSpan) }) {
                // All as tall as the tallest.
                Row(Modifier.height(IntrinsicSize.Min), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf(PatternFilter.All, PatternFilter.Favorites, PatternFilter.Recent).forEach { filter ->
                        FilterTile(filter, viewModel, Modifier.weight(1f).fillMaxHeight()) {
                            viewModel.selectFilter(filter)
                            close()
                        }
                    }
                }
            }
            CategoryGroup.entries.forEach { group ->
                item(span = { GridItemSpan(maxLineSpan) }) { GroupHeader(group.title, Modifier.padding(top = 12.dp)) }
                items(PatternCategory.entries.filter { it.group == group }) { category ->
                    val filter = PatternFilter.Category(category)
                    FilterTile(filter, viewModel) {
                        viewModel.selectFilter(filter)
                        close()
                    }
                }
            }
        }
    }
}

/**
 * A place to go: its icon in its color, its name and how many patterns it holds. What's showing is marked
 * with a wash and a border in its color and a check, with the text kept as it is.
 */
@Composable
private fun FilterTile(filter: PatternFilter, viewModel: HapticDemoViewModel, modifier: Modifier = Modifier, onClick: () -> Unit) {
    val isSelected = filter == viewModel.filter
    val tint = filter.tint?.color ?: MaterialTheme.colorScheme.primary
    val count = PatternCatalog.count(filter, viewModel.favorites, viewModel.recentPatterns)
    // Favorites and Recent start empty, and fill as patterns are starred and played.
    val isEmptyToStart = (filter == PatternFilter.Favorites || filter == PatternFilter.Recent) && count == 0
    val shape = RoundedCornerShape(12.dp)
    Column(
        modifier
            .clip(shape)
            .background(LocalDemoColors.current.card)
            .background(tint.copy(alpha = if (isSelected) 0.15f else 0f))
            .border(if (isSelected) 2.dp else 0.dp, if (isSelected) tint else LocalDemoColors.current.card, shape)
            .clickable(onClick = onClick)
            .semantics(mergeDescendants = true) {
                selected = isSelected
                role = Role.Button
                contentDescription = filter.title
                stateDescription = if (isEmptyToStart) "None yet" else if (count == 1) "1 pattern" else "$count patterns"
            }
            .padding(10.dp)
            .testTag("filter.${filter.storageValue}"),
        verticalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            // All's own icon: the toolbar button's lines mean "filter" there, but on a tile they'd read as one.
            PatternSymbol(if (filter == PatternFilter.All) "square.grid.2x2" else filter.symbol, tint, 22.dp)
            Spacer(Modifier.weight(1f))
            Text(
                if (isEmptyToStart) "None yet" else "%,d".format(count),
                style = MaterialTheme.typography.labelMedium,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                filter.title,
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.SemiBold,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                modifier = Modifier.weight(1f),
            )
            AnimatedVisibility(isSelected, enter = scaleIn() + fadeIn(), exit = scaleOut() + fadeOut()) {
                Icon(Icons.Rounded.CheckCircle, contentDescription = null, tint = tint, modifier = Modifier.size(16.dp))
            }
        }
    }
}
