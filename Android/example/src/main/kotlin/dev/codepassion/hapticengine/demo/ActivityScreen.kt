package dev.codepassion.hapticengine.demo

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.selection.SelectionContainer
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.ArrowBack
import androidx.compose.material.icons.rounded.History
import androidx.compose.material.icons.rounded.PlayArrow
import androidx.compose.material.icons.rounded.PlayCircle
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import dev.codepassion.hapticengine.HapticPattern
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle
import java.time.format.TextStyle
import java.util.Locale

/**
 * Patterns the user switched between, newest first, grouped by day. Tapping one plays it again without
 * changing the list; swiping one away deletes it. Mirrors `ActivityLogView.swift`.
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
                title = { Text("History", fontWeight = FontWeight.SemiBold) },
                navigationIcon = {
                    IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Rounded.ArrowBack, contentDescription = "Back") }
                },
                actions = {
                    TextButton(onClick = { isConfirmingClear = true }, enabled = log.isNotEmpty()) {
                        Text("Clear", color = if (log.isNotEmpty()) DemoTint.Red.color else Color.Unspecified)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = colors.background),
            )
        },
    ) { padding ->
        AnimatedContent(log.isEmpty(), transitionSpec = { fadeIn() togetherWith fadeOut() }, label = "history", modifier = Modifier.padding(padding)) { isEmpty ->
            if (isEmpty) EmptyHistory(viewModel, onBack) else EntryList(viewModel)
        }
    }

    if (isConfirmingClear) {
        AlertDialog(
            onDismissRequest = { isConfirmingClear = false },
            title = { Text("Clear all history?") },
            text = { Text("This removes ${if (log.size == 1) "1 entry" else "${log.size} entries"}. It can't be undone.") },
            confirmButton = {
                TextButton(onClick = {
                    isConfirmingClear = false
                    viewModel.clearLog()
                }) { Text("Clear History", color = DemoTint.Red.color) }
            },
            dismissButton = { TextButton(onClick = { isConfirmingClear = false }) { Text("Cancel") } },
        )
    }
}

/**
 * Grouped by day under a header, as in a phone's recent calls: saved for weeks, entries need a date, and a
 * time on every row says it once a row instead of once a day. Lazy, so a log of a thousand opens at once.
 */
@Composable
private fun EntryList(viewModel: HapticDemoViewModel) {
    val days = viewModel.logDays
    val playingEntry = viewModel.nowPlaying?.entryId
    // The row swiped open to show its delete button. Only one is open at a time.
    var openEntry by rememberSaveable { mutableStateOf<Long?>(null) }
    val listState = rememberLazyListState()
    // Scrolling closes an open row, as in system lists.
    LaunchedEffect(listState.isScrollInProgress) { if (listState.isScrollInProgress) openEntry = null }
    val today = LocalDate.now()

    LazyColumn(
        state = listState,
        contentPadding = PaddingValues(start = 16.dp, end = 16.dp, top = 8.dp, bottom = 16.dp),
        modifier = Modifier.fillMaxSize().navigationBarsPadding(),
    ) {
        days.forEachIndexed { dayIndex, day ->
            item(key = "day-${day.day}") {
                GroupHeader(dayTitle(day.day, today), Modifier.padding(top = if (dayIndex == 0) 0.dp else 24.dp, bottom = 8.dp))
            }
            itemsIndexed(day.entries, key = { _, entry -> entry.id }) { index, entry ->
                val isLast = index == day.entries.lastIndex
                Column(Modifier.animateItem().groupedCardRow(isFirst = index == 0, isLast = isLast)) {
                    SwipeToDelete(
                        isOpen = openEntry == entry.id,
                        onOpenChange = { open -> openEntry = if (open) entry.id else null },
                        onDelete = { viewModel.deleteEntry(entry) },
                    ) {
                        ActivityRow(entry, isPlaying = playingEntry == entry.id) {
                            // A tap on an open row closes it, rather than playing it by surprise.
                            if (openEntry != null) openEntry = null else viewModel.replay(entry)
                        }
                    }
                    if (!isLast) RowDivider()
                }
            }
        }
    }
}

@Composable
private fun ActivityRow(entry: LogEntry, isPlaying: Boolean, onPlay: () -> Unit) {
    val pattern = entry.pattern
    val tint = pattern.tint
    val wash by animateColorAsState(if (isPlaying) tint.copy(alpha = 0.08f) else Color.Transparent, snappy(), label = "wash")
    Row(
        Modifier
            .fillMaxWidth()
            .background(wash)
            .clickable(onClickLabel = "Play it again", onClick = onPlay)
            .semantics(mergeDescendants = true) { stateDescription = if (isPlaying) "Playing" else "" }
            .padding(horizontal = 12.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        PatternIcon(pattern, isPlaying, size = 40.dp)
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
            Text(pattern.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold)
            Text(
                timeFormat.format(entry.time.atZone(ZoneId.systemDefault())),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        if (isPlaying) {
            PlayingIndicator(tint)
        } else {
            Icon(Icons.Rounded.PlayArrow, contentDescription = null, tint = MaterialTheme.colorScheme.outline, modifier = Modifier.size(16.dp))
        }
    }
}

private val timeFormat = DateTimeFormatter.ofLocalizedTime(FormatStyle.MEDIUM)

/** "Today", "Yesterday", the weekday within the week, then the date. Mirrors `ActivityDay.title`. */
fun dayTitle(day: LocalDate, today: LocalDate, locale: Locale = Locale.getDefault()): String = when {
    day == today -> "Today"
    day == today.minusDays(1) -> "Yesterday"
    !day.isBefore(today.minusDays(6)) -> day.dayOfWeek.getDisplayName(TextStyle.FULL, locale)
    day.year == today.year -> DateTimeFormatter.ofPattern("EEE, MMM d", locale).format(day)
    else -> DateTimeFormatter.ofPattern("MMM d, yyyy", locale).format(day)
}

/**
 * Before anything's played: what the screen is for, and a start. Playing one of the suggestions adds it, and
 * the list replaces this with that entry already playing.
 */
@Composable
private fun EmptyHistory(viewModel: HapticDemoViewModel, onSeeAll: () -> Unit) {
    Column(
        Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .navigationBarsPadding()
            .padding(horizontal = 16.dp, vertical = 32.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(28.dp, Alignment.CenterVertically),
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(10.dp)) {
            EmptyHistoryBadge()
            Text("No History Yet", style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold)
            Text(
                "Patterns you play show up here, so you can feel them again with one tap.",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center,
                modifier = Modifier.widthIn(max = 300.dp),
            )
        }
        Column(Modifier.widthIn(max = 500.dp).fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            GroupHeader("Try one")
            Column(Modifier.groupedCard()) {
                suggestions.forEachIndexed { index, pattern ->
                    SuggestionRow(pattern) { viewModel.play(pattern) }
                    if (index < suggestions.lastIndex) RowDivider()
                }
            }
        }
        TextButton(onClick = onSeeAll) { Text("See All Patterns", fontWeight = FontWeight.Medium) }
    }
}

/** One pattern from each of three groups, so the suggestions feel distinct from one another. */
private val suggestions = listOf(HapticPattern.Success, HapticPattern.Heartbeat, HapticPattern.Rumble)

/** The clock inside soft rings, echoing a vibration spreading out. */
@Composable
private fun EmptyHistoryBadge() {
    val tint = MaterialTheme.colorScheme.primary
    val reduceMotion = LocalContext.current.prefersReducedMotion()
    val pulse by rememberInfiniteTransition(label = "badge").animateFloat(
        initialValue = 1f,
        targetValue = if (reduceMotion) 1f else 0.5f,
        animationSpec = infiniteRepeatable(tween(900), RepeatMode.Reverse),
        label = "pulse",
    )
    Box(Modifier.padding(bottom = 6.dp).size(128.dp).background(tint.copy(alpha = 0.06f), CircleShape).clearAndSetSemantics {}, contentAlignment = Alignment.Center) {
        Box(Modifier.size(92.dp).background(tint.copy(alpha = 0.12f), CircleShape), contentAlignment = Alignment.Center) {
            Icon(Icons.Rounded.History, contentDescription = null, tint = tint, modifier = Modifier.size(40.dp).graphicsLayer { alpha = pulse })
        }
    }
}

@Composable
private fun SuggestionRow(pattern: HapticPattern, onPlay: () -> Unit) {
    Row(
        Modifier
            .fillMaxWidth()
            .clickable(onClickLabel = "Play ${pattern.title}", onClick = onPlay)
            .padding(horizontal = 12.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        PatternIcon(pattern, isPlaying = false, size = 40.dp)
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
            Text(pattern.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold)
            Text(pattern.subtitle, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant, maxLines = 1, overflow = TextOverflow.Ellipsis)
        }
        Icon(Icons.Rounded.PlayCircle, contentDescription = null, tint = pattern.tint, modifier = Modifier.size(28.dp))
    }
}

/** The licenses of the code the app is built from: only HapticEngine itself. Mirrors `LicensesView.swift`. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LicenseScreen(onBack: () -> Unit) {
    val colors = LocalDemoColors.current
    val context = LocalContext.current
    Scaffold(
        containerColor = colors.background,
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("License", fontWeight = FontWeight.SemiBold) },
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Rounded.ArrowBack, contentDescription = "Back") } },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = colors.background),
            )
        },
    ) { padding ->
        Column(
            Modifier
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .navigationBarsPadding()
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            GroupHeader("HapticEngine", Modifier.semantics { heading() })
            SelectionContainer(Modifier.groupedCard().padding(16.dp)) {
                Text(MIT_LICENSE, style = MaterialTheme.typography.bodySmall, fontFamily = FontFamily.Monospace)
            }
            TextButton(onClick = {
                runCatching { context.startActivity(android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(AppInfo.SOURCE_CODE))) }
            }) { Text("View on GitHub") }
        }
    }
}

/** The repository's LICENSE file. Update it here if it changes there. */
private val MIT_LICENSE = """
    MIT License

    Copyright (c) 2025 Huy D.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
""".trimIndent()
