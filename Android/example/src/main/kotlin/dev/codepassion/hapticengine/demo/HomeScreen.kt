package dev.codepassion.hapticengine.demo

import androidx.activity.compose.BackHandler
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Cancel
import androidx.compose.material.icons.rounded.Close
import androidx.compose.material.icons.rounded.Menu
import androidx.compose.material.icons.rounded.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

/**
 * The home screen: every pattern, searched or filtered from the top bar, with the now-playing bar pinned at
 * the bottom within thumb reach. Mirrors `ContentView.swift`.
 */
@Composable
fun HomeScreen(viewModel: HapticDemoViewModel, onOpenMenu: () -> Unit, modifier: Modifier = Modifier) {
    val colors = LocalDemoColors.current
    var query by rememberSaveable { mutableStateOf("") }
    var isSearchOpen by rememberSaveable { mutableStateOf(false) }
    var isFilterOpen by remember { mutableStateOf(false) }
    var barOpenHeight by remember { mutableStateOf(0.dp) }
    var barOpenness by remember { mutableFloatStateOf(0f) }
    val gridState = rememberLazyGridState()
    val keyboard = LocalSoftwareKeyboardController.current
    val focusManager = LocalFocusManager.current
    val scope = rememberCoroutineScope()

    val search = remember(query) { PatternSearch(query) }
    val filter = viewModel.filter
    // Worked out once per change, here, rather than in each place that needs them.
    val sections = remember(filter, search, viewModel.favorites, viewModel.recentPatterns) {
        PatternCatalog.sections(filter, search, viewModel.favorites, viewModel.recentPatterns)
    }
    // Results replace the browsing sections once something is typed; until then, the filter's patterns stay.
    val footerCount = if (search.isEmpty && filter != PatternFilter.All && sections.isNotEmpty()) sections.sumOf { it.patterns.size } else null
    val emptyState = when {
        !search.isEmpty -> EmptyState.NoResults(query)
        filter == PatternFilter.Recent -> EmptyState.NoRecent
        else -> EmptyState.NoFavorites
    }

    fun closeSearch() {
        focusManager.clearFocus()
        query = ""
        isSearchOpen = false
    }

    // A new filter, or a search, starts at the top, not partway down: the patterns are all new.
    LaunchedEffect(filter, search) { gridState.scrollToItem(0) }
    // Scrolling puts the keyboard away. With nothing typed, search simply closes.
    LaunchedEffect(gridState) {
        snapshotFlow { gridState.isScrollInProgress }.collect { scrolling ->
            if (!scrolling) return@collect
            keyboard?.hide()
            if (isSearchOpen && search.isEmpty) isSearchOpen = false
        }
    }
    // Playing a result puts the keyboard away, so the now-playing bar can show it.
    LaunchedEffect(viewModel.nowPlaying?.id) {
        if (viewModel.nowPlaying != null) keyboard?.hide()
    }
    BackHandler(enabled = isSearchOpen) { closeSearch() }

    val isImeVisible = WindowInsets.ime.asPaddingValues().calculateBottomPadding() > 0.dp
    Column(modifier.fillMaxSize().background(colors.background)) {
        TopBar(
            viewModel = viewModel,
            query = query,
            onQueryChange = { query = it },
            isSearchOpen = isSearchOpen,
            onOpenSearch = { isSearchOpen = true },
            onCloseSearch = ::closeSearch,
            onOpenFilter = { isFilterOpen = true },
            onOpenMenu = {
                focusManager.clearFocus()
                onOpenMenu()
            },
        )
        BoxWithConstraints(Modifier.weight(1f).fillMaxWidth()) {
            val navigationBar = WindowInsets.navigationBars.asPaddingValues().calculateBottomPadding()
            // The patterns leave room for the collapsed bar, and no more: opened, it grows over them as a sheet
            // does. They gain only room to scroll past it.
            val barRoom = BarCollapsedHeight + BarMargin * 2 + navigationBar
            val barMaxHeight = maxHeight - navigationBar
            // As the bar grows toward the top bar, the patterns recede, as the content behind a full-height
            // sheet does.
            val room = maxHeight - barRoom - barOpenHeight
            val visibility by animateFloatAsState(((room - 80.dp) / 120.dp).coerceIn(0f, 1f), tween(300), label = "recede")
            PatternsView(
                viewModel = viewModel,
                sections = sections,
                emptyState = emptyState,
                footerCount = footerCount,
                gridState = gridState,
                contentPadding = PaddingValues(start = 16.dp, end = 16.dp, top = 8.dp, bottom = barRoom + barOpenHeight + 16.dp),
                onShowAll = { viewModel.selectFilter(PatternFilter.All) },
                modifier = Modifier.graphicsLayer { alpha = visibility },
            )
            // The keyboard covers the bar, which would only crowd the results, so it steps aside meanwhile.
            androidx.compose.animation.AnimatedVisibility(
                visible = !isImeVisible,
                enter = fadeIn(tween(200)),
                exit = fadeOut(tween(200)),
                modifier = Modifier.align(Alignment.BottomCenter),
            ) {
                NowPlayingBar(
                    viewModel = viewModel,
                    maxHeight = barMaxHeight,
                    onOpenHeightChange = { barOpenHeight = it },
                    onOpennessChange = { barOpenness = it },
                    // Docks from below as the patterns land, like a mini player arriving.
                    modifier = Modifier.navigationBarsPadding().launchRise(LaunchReveal.BAR_DELAY_MS, 60.dp),
                )
            }
        }
    }
    if (isFilterOpen) {
        FilterPanel(viewModel, onDismiss = { isFilterOpen = false })
    }
    // Announces each pattern as it plays, for TalkBack.
    val playing = viewModel.nowPlaying
    Box(Modifier.size(0.dp).semantics { liveRegion = LiveRegionMode.Polite; contentDescription = playing?.let { "Playing ${it.pattern.title}" } ?: "" })
}

/**
 * The top bar: the menu at the start; the title, with what's showing beneath it; then the filter and search
 * at the end, nearest the thumb. Opened, search widens into a field over the title and filter: results
 * ignore the filter. Mirrors `HeaderTitle.swift` and `SearchControls.swift`.
 */
@Composable
private fun TopBar(
    viewModel: HapticDemoViewModel,
    query: String,
    onQueryChange: (String) -> Unit,
    isSearchOpen: Boolean,
    onOpenSearch: () -> Unit,
    onCloseSearch: () -> Unit,
    onOpenFilter: () -> Unit,
    onOpenMenu: () -> Unit,
) {
    // The bar is one height, so its text stops growing where the system's own top bars do; past that, the
    // title's second line was cut off. Mirrors `HeaderTitle.largestTypeSize` on iOS.
    val density = LocalDensity.current
    CompositionLocalProvider(LocalDensity provides Density(density.density, minOf(density.fontScale, MAX_HEADER_FONT_SCALE))) {
    Row(
        Modifier
            .fillMaxWidth()
            .statusBarsPadding()
            .height(64.dp)
            .padding(horizontal = 4.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        IconButton(onClick = onOpenMenu, modifier = Modifier.testTag("appMenu")) {
            Icon(Icons.Rounded.Menu, contentDescription = "Menu")
        }
        AnimatedContent(
            targetState = isSearchOpen,
            transitionSpec = { fadeIn(tween(200)) togetherWith fadeOut(tween(150)) },
            modifier = Modifier.weight(1f),
            label = "search",
        ) { searching ->
            if (searching) {
                SearchField(query, onQueryChange, onCloseSearch)
            } else {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    HeaderTitle(viewModel, Modifier.weight(1f))
                    FilterButton(viewModel.filter, onOpenFilter)
                    IconButton(onClick = onOpenSearch, modifier = Modifier.testTag("searchButton")) {
                        Icon(Icons.Rounded.Search, contentDescription = "Search")
                    }
                }
            }
        }
    }
    }
}

/** The largest text the top bar draws, relative to the default. */
private const val MAX_HEADER_FONT_SCALE = 1.3f

/**
 * The title, with what's showing beneath it. With a filter on, that line is a token in the filter's color
 * that clears it in one tap: the filter and the way out of it, side by side.
 */
@Composable
private fun HeaderTitle(viewModel: HapticDemoViewModel, modifier: Modifier = Modifier) {
    val filter = viewModel.filter
    val haptics = LocalHapticFeedback.current
    val count = PatternCatalog.count(filter, viewModel.favorites, viewModel.recentPatterns)
    // A tick when the filter changes, as iOS's `sensoryFeedback(.selection, trigger:)` gives: not each time the
    // title comes back, as when search closes, nor on launch.
    var shownFilter by remember { mutableStateOf(filter) }
    LaunchedEffect(filter) {
        if (filter != shownFilter) haptics.performHapticFeedback(HapticFeedbackType.SegmentTick)
        shownFilter = filter
    }
    Column(modifier, horizontalAlignment = Alignment.CenterHorizontally) {
        Text("Haptic Engine", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold, maxLines = 1, modifier = Modifier.semantics { heading() })
        AnimatedContent(filter, transitionSpec = { (fadeIn() + scaleIn(initialScale = 0.8f)) togetherWith fadeOut() }, label = "token") { shown ->
            if (shown == PatternFilter.All) {
                Text("All · ${"%,d".format(count)}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant, maxLines = 1)
            } else {
                val tint = shown.tint?.color ?: MaterialTheme.colorScheme.primary
                Row(
                    Modifier
                        .clip(CircleShape)
                        .background(tint.copy(alpha = 0.15f))
                        .clickable(onClickLabel = "Clear the filter to show all patterns") { viewModel.selectFilter(PatternFilter.All) }
                        .semantics(mergeDescendants = true) { contentDescription = "Showing ${shown.title}" }
                        .padding(horizontal = 8.dp, vertical = 2.dp)
                        .testTag("clearFilter"),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(4.dp),
                ) {
                    PatternSymbol(shown.symbol, tint, 12.dp)
                    Text("${shown.title} · $count", style = MaterialTheme.typography.labelMedium, fontWeight = FontWeight.SemiBold, color = tint, maxLines = 1)
                    Icon(Icons.Rounded.Close, contentDescription = null, tint = tint.copy(alpha = 0.7f), modifier = Modifier.size(12.dp))
                }
            }
        }
    }
}

/** Opens the filter panel. Shows the selected filter's icon, in its color, so the bar says what's showing. */
@Composable
private fun FilterButton(filter: PatternFilter, onClick: () -> Unit) {
    IconButton(
        onClick = onClick,
        modifier = Modifier
            .testTag("filterButton")
            .semantics { stateDescription = filter.title },
    ) {
        AnimatedContent(filter, transitionSpec = { fadeIn() togetherWith fadeOut() }, label = "filter") { shown ->
            Box(Modifier.semantics { contentDescription = "Filter" }) {
                PatternSymbol(shown.symbol, shown.tint?.color ?: MaterialTheme.colorScheme.onSurface, 24.dp)
            }
        }
    }
}

@Composable
private fun SearchField(query: String, onQueryChange: (String) -> Unit, onClose: () -> Unit) {
    val focus = remember { FocusRequester() }
    LaunchedEffect(Unit) { focus.requestFocus() }
    Row(verticalAlignment = Alignment.CenterVertically) {
        TextField(
            value = query,
            onValueChange = onQueryChange,
            placeholder = { Text("Search") },
            leadingIcon = { Icon(Icons.Rounded.Search, contentDescription = null) },
            trailingIcon = {
                if (query.isNotEmpty()) {
                    IconButton(onClick = { onQueryChange("") }) { Icon(Icons.Rounded.Cancel, contentDescription = "Clear Search") }
                }
            },
            singleLine = true,
            shape = CircleShape,
            keyboardOptions = KeyboardOptions(capitalization = KeyboardCapitalization.None, autoCorrectEnabled = false, imeAction = ImeAction.Search),
            keyboardActions = KeyboardActions(onSearch = { focus.freeFocus() }),
            colors = TextFieldDefaults.colors(
                focusedIndicatorColor = androidx.compose.ui.graphics.Color.Transparent,
                unfocusedIndicatorColor = androidx.compose.ui.graphics.Color.Transparent,
                focusedContainerColor = LocalDemoColors.current.card,
                unfocusedContainerColor = LocalDemoColors.current.card,
            ),
            modifier = Modifier.weight(1f).height(52.dp).focusRequester(focus).testTag("searchField"),
        )
        IconButton(onClick = onClose) { Icon(Icons.Rounded.Close, contentDescription = "Cancel") }
    }
}
