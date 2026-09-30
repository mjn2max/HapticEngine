package dev.codepassion.hapticengine.demo

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.ArrowBack
import androidx.compose.material.icons.rounded.History
import androidx.compose.material.icons.rounded.PlayArrow
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import dev.codepassion.hapticengine.HapticPattern
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle

private val timeFormat = DateTimeFormatter.ofLocalizedTime(FormatStyle.MEDIUM)

/**
 * Patterns the user switched between, newest first. Tapping one plays it again without changing the list;
 * swiping one away deletes it. Mirrors `ActivityLogView.swift`.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ActivityScreen(viewModel: HapticDemoViewModel, onBack: () -> Unit) {
    var isConfirmingClear by remember { mutableStateOf(false) }
    val colors = LocalDemoColors.current
    val log = viewModel.log

    Scaffold(
        containerColor = colors.background,
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("Activity", fontWeight = FontWeight.SemiBold) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Rounded.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    TextButton(
                        onClick = { isConfirmingClear = true },
                        enabled = log.isNotEmpty(),
                    ) {
                        Text("Clear", color = if (log.isNotEmpty()) MaterialTheme.colorScheme.error else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f))
                    }
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(containerColor = colors.background),
            )
        },
    ) { padding ->
        AnimatedContent(
            targetState = log.isEmpty(),
            transitionSpec = { fadeIn(tween(250)) togetherWith fadeOut(tween(250)) },
            modifier = Modifier.padding(padding).fillMaxSize(),
            label = "empty",
        ) { isEmpty ->
            if (isEmpty) {
                EmptyActivity(onTry = viewModel::play, onSeeAll = onBack)
            } else {
                EntryList(viewModel)
            }
        }
    }

    if (isConfirmingClear) {
        AlertDialog(
            onDismissRequest = { isConfirmingClear = false },
            title = { Text("Clear all activity?") },
            text = {
                val count = log.size
                Text("This removes $count ${if (count == 1) "entry" else "entries"}. It can't be undone.")
            },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.clearLog()
                    isConfirmingClear = false
                }) {
                    Text("Clear activity", color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { isConfirmingClear = false }) { Text("Cancel") }
            },
        )
    }
}

@Composable
private fun EntryList(viewModel: HapticDemoViewModel) {
    val log = viewModel.log
    val listState = rememberLazyListState()
    // The row swiped open to show its delete button. Only one is open at a time.
    var openEntryId by rememberSaveable { mutableStateOf<Long?>(null) }

    // Scrolling closes an open row, as in system lists.
    LaunchedEffect(listState.isScrollInProgress) {
        if (listState.isScrollInProgress) openEntryId = null
    }

    LazyColumn(
        state = listState,
        contentPadding = PaddingValues(16.dp),
        modifier = Modifier.fillMaxSize(),
    ) {
        itemsIndexed(log, key = { _, entry -> entry.id }) { index, entry ->
            // Each row rounds only its outer corners, so together they read as one card.
            val shape = RoundedCornerShape(
                topStart = if (index == 0) CardRadius else 0.dp,
                topEnd = if (index == 0) CardRadius else 0.dp,
                bottomStart = if (index == log.lastIndex) CardRadius else 0.dp,
                bottomEnd = if (index == log.lastIndex) CardRadius else 0.dp,
            )
            Column(
                Modifier
                    .animateItem()
                    .clip(shape)
                    .background(LocalDemoColors.current.card),
            ) {
                val isPlaying = viewModel.nowPlaying?.entryId == entry.id
                SwipeToDelete(
                    isOpen = openEntryId == entry.id,
                    onOpenChange = { open -> openEntryId = if (open) entry.id else null },
                    onDelete = { viewModel.deleteEntry(entry) },
                ) {
                    PatternRow(
                        pattern = entry.pattern,
                        isPlaying = isPlaying,
                        // A tap on an open row closes it, rather than playing it by surprise.
                        onClick = { if (openEntryId != null) openEntryId = null else viewModel.replay(entry) },
                        supporting = entry.time.format(timeFormat),
                        stateText = if (isPlaying) "Playing" else "Plays it again",
                    ) {
                        if (isPlaying) {
                            PlayingIndicator(entry.pattern.tint)
                        } else {
                            Icon(
                                Icons.Rounded.PlayArrow,
                                contentDescription = null,
                                tint = MaterialTheme.colorScheme.outline,
                                modifier = Modifier.size(20.dp),
                            )
                        }
                    }
                }
                if (index != log.lastIndex) RowDivider()
            }
        }
    }
}

/** One pattern from each category, so the suggestions feel distinct from one another. */
private val suggestions = listOf(HapticPattern.Success, HapticPattern.Heartbeat, HapticPattern.Rumble)

@Composable
private fun EmptyActivity(onTry: (HapticPattern) -> Unit, onSeeAll: () -> Unit) {
    Box(
        Modifier.fillMaxSize().verticalScroll(rememberScrollState()),
        // Centers the content while it fits, and lets it scroll at large text sizes.
        contentAlignment = Alignment.Center,
    ) {
        Column(
            Modifier.widthIn(max = 500.dp).padding(horizontal = 16.dp, vertical = 32.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(28.dp),
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(10.dp)) {
                EmptyBadge(Modifier.padding(bottom = 6.dp))
                Text("No activity yet", style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold)
                Text(
                    "Patterns you play show up here, so you can feel them again with one tap.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.widthIn(max = 300.dp),
                )
            }

            // Starts the log from here rather than sending the user back: playing one of these adds it, and
            // the list replaces this view with that entry already playing.
            Column(Modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    "TRY ONE",
                    style = MaterialTheme.typography.labelMedium,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(start = 12.dp),
                )
                Column(Modifier.clip(RoundedCornerShape(CardRadius)).background(LocalDemoColors.current.card)) {
                    suggestions.forEachIndexed { index, pattern ->
                        PatternRow(
                            pattern = pattern,
                            isPlaying = false,
                            onClick = { onTry(pattern) },
                            supporting = pattern.subtitle,
                            stateText = "Plays ${pattern.title}",
                        ) {
                            // A soft two-tone play button, like the hierarchical SF Symbol on iOS.
                            Box(
                                Modifier.size(30.dp).background(pattern.tint.copy(alpha = 0.18f), CircleShape),
                                contentAlignment = Alignment.Center,
                            ) {
                                Icon(
                                    Icons.Rounded.PlayArrow,
                                    contentDescription = null,
                                    tint = pattern.tint,
                                    modifier = Modifier.size(20.dp),
                                )
                            }
                        }
                        if (index != suggestions.lastIndex) RowDivider()
                    }
                }
            }

            TextButton(onClick = onSeeAll) { Text("See all patterns") }
        }
    }
}

/** The history icon inside soft rings, echoing a vibration spreading out. */
@Composable
private fun EmptyBadge(modifier: Modifier = Modifier) {
    val primary = MaterialTheme.colorScheme.primary
    // Pulses twice on arrival, like the SF Symbol on iOS.
    val pulse = remember { Animatable(1f) }
    LaunchedEffect(Unit) {
        repeat(2) {
            pulse.animateTo(0.4f, tween(400))
            pulse.animateTo(1f, tween(400))
        }
    }
    Box(modifier.size(128.dp).clearAndSetSemantics {}, contentAlignment = Alignment.Center) {
        Box(Modifier.size(128.dp).background(primary.copy(alpha = 0.06f), CircleShape))
        Box(Modifier.size(92.dp).background(primary.copy(alpha = 0.12f), CircleShape))
        Icon(
            Icons.Rounded.History,
            contentDescription = null,
            tint = primary,
            modifier = Modifier.size(44.dp).graphicsLayer { alpha = pulse.value },
        )
    }
}


// A preview has nothing to scope a view model to, so it makes one directly.
@Suppress("ViewModelConstructorInComposable")
@Preview(name = "Empty")
@Composable
private fun EmptyActivityPreview() {
    DemoTheme { ActivityScreen(HapticDemoViewModel(PreviewHapticEngine()), onBack = {}) }
}

// A preview has nothing to scope a view model to, so it makes one directly.
@Suppress("ViewModelConstructorInComposable")
@Preview(name = "With entries")
@Composable
private fun ActivityPreview() {
    val viewModel = HapticDemoViewModel(PreviewHapticEngine()).apply {
        play(HapticPattern.Heartbeat)
        play(HapticPattern.Success)
        play(HapticPattern.Knock)
    }
    DemoTheme { ActivityScreen(viewModel, onBack = {}) }
}
