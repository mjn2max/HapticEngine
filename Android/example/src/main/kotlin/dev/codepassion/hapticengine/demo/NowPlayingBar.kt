package dev.codepassion.hapticengine.demo

import androidx.activity.compose.BackHandler
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.rememberDraggableState
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.KeyboardArrowUp
import androidx.compose.material.icons.rounded.Replay
import androidx.compose.material.icons.rounded.Star
import androidx.compose.material.icons.rounded.StarOutline
import androidx.compose.material.icons.rounded.TouchApp
import androidx.compose.material.icons.rounded.Warning
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.layout.positionInParent
import androidx.compose.ui.layout.onPlaced
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.CustomAccessibilityAction
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.customActions
import androidx.compose.ui.semantics.onClick
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.selected
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import dev.codepassion.hapticengine.HapticPattern
import dev.codepassion.hapticengine.HapticPatternEvent
import kotlinx.coroutines.launch
import java.util.Locale
import kotlin.math.abs
import kotlin.math.roundToInt

/** How much of the pattern the bar shows, like a sheet's detents. */
enum class BarSize {
    /** One row: what's playing, with star and replay. */
    Collapsed,

    /** Adds the description and timeline: enough to compare what's felt with what's drawn. */
    Summary,

    /** Adds the numbers, each event, and similar patterns to try next. Scrolls when it's too tall. */
    Full,
}

/** The bar's height collapsed: the room the patterns leave it. */
val BarCollapsedHeight = 64.dp

/** The gap to the screen's sides and bottom, and above the bar. */
val BarMargin = 12.dp

private val BarVerticalPadding = 10.dp
private val DetailsGap = 16.dp

/**
 * A floating bar pinned to the bottom, like a music app's mini player. Mirrors `NowPlayingBar.swift`. It
 * always shows one of:
 *
 * - **A tip**, before anything is played: how to play a pattern and how to keep one.
 * - **The pattern last played**, with buttons to star it and play it again. It stays after the pattern ends,
 *   so the pattern can still be starred or replayed. While it plays, a ring fills around its icon. It opens
 *   to three sizes, like a sheet: see [BarSize].
 * - **A warning**, on a device without a vibrator, where nothing can play.
 *
 * @param maxHeight the tallest the bar may grow, so the top bar stays in sight above it.
 * @param onOpenHeightChange how much taller than collapsed the bar has settled, which the patterns can
 *   scroll past.
 * @param onOpennessChange how far it has opened, from 0 collapsed to 1 at the summary and above.
 */
@Composable
fun NowPlayingBar(
    viewModel: HapticDemoViewModel,
    maxHeight: Dp,
    onOpenHeightChange: (Dp) -> Unit,
    onOpennessChange: (Float) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = LocalDemoColors.current
    val lastPlayed = viewModel.lastPlayed
    var openness by remember { mutableFloatStateOf(0f) }
    val isWarning = !viewModel.isHapticsSupported && lastPlayed == null
    val shape = RoundedCornerShape(BarCollapsedHeight / 2)
    val surface by animateColorAsState(
        when {
            isWarning -> DemoTint.Orange.color.copy(alpha = 0.14f).compositeOver(colors.card)
            else -> colors.card
        },
        label = "surface",
    )
    Box(
        modifier
            .widthIn(max = 500.dp)
            .fillMaxWidth()
            .padding(horizontal = BarMargin)
            .padding(top = BarMargin, bottom = BarMargin)
            .shadow(if (openness > 0f) 16.dp else 8.dp, shape, ambientColor = Color.Black.copy(alpha = 0.2f), spotColor = Color.Black.copy(alpha = 0.2f))
            .clip(shape)
            .background(surface)
            .border(0.5.dp, colors.separator, shape)
            .heightIn(min = BarCollapsedHeight),
    ) {
        AnimatedContent(
            targetState = lastPlayed != null,
            transitionSpec = { fadeIn(tween(200, delayMillis = 100)) togetherWith fadeOut(tween(100)) },
            label = "bar",
        ) { isPlayer ->
            if (isPlayer && lastPlayed != null) {
                PlayerRow(
                    viewModel = viewModel,
                    maxHeight = maxHeight - BarMargin * 2 - BarVerticalPadding * 2,
                    onOpenHeightChange = onOpenHeightChange,
                    onOpennessChange = {
                        openness = it
                        onOpennessChange(it)
                    },
                )
            } else if (!viewModel.isHapticsSupported) {
                MessageRow(Icons.Rounded.Warning, DemoTint.Orange.color, "No Vibrator on This Device", "Tap a pattern to see how it plays.")
            } else {
                MessageRow(Icons.Rounded.TouchApp, MaterialTheme.colorScheme.primary, "Tap Any Pattern to Feel It", "Touch and hold one to add it to Favorites.")
            }
        }
    }
}

private fun Color.compositeOver(background: Color): Color {
    val a = alpha
    return Color(red * a + background.red * (1 - a), green * a + background.green * (1 - a), blue * a + background.blue * (1 - a), 1f)
}

/** An icon, a title and a one-line message, styled like the player so the bar keeps one shape in every state. */
@Composable
private fun MessageRow(icon: androidx.compose.ui.graphics.vector.ImageVector, tint: Color, title: String, message: String) {
    Row(
        Modifier
            .fillMaxWidth()
            .heightIn(min = BarCollapsedHeight)
            .padding(start = 12.dp, end = 12.dp, top = BarVerticalPadding, bottom = BarVerticalPadding)
            .semantics(mergeDescendants = true) {},
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        Box(Modifier.size(40.dp).background(tint.copy(alpha = 0.15f), CircleShape), contentAlignment = Alignment.Center) {
            Icon(icon, contentDescription = null, tint = tint, modifier = Modifier.size(20.dp))
        }
        Column(Modifier.weight(1f)) {
            Text(title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold, maxLines = 1, overflow = TextOverflow.Ellipsis)
            Text(message, style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onSurfaceVariant, maxLines = 2, overflow = TextOverflow.Ellipsis)
        }
    }
}

/**
 * The pattern last played: one row collapsed, which grows into its details. Dragging on it resizes it under
 * the finger, and letting go settles on the nearest size, carried by the flick. Mirrors `PlayerRow.swift`.
 */
@Composable
private fun PlayerRow(
    viewModel: HapticDemoViewModel,
    maxHeight: Dp,
    onOpenHeightChange: (Dp) -> Unit,
    onOpennessChange: (Float) -> Unit,
) {
    val pattern = viewModel.lastPlayed ?: return
    val playback = viewModel.nowPlaying
    val density = LocalDensity.current
    val haptics = LocalHapticFeedback.current
    val scope = rememberCoroutineScope()
    val maxPx = with(density) { maxHeight.toPx() }.coerceAtLeast(1f)

    var size by remember { mutableStateOf(BarSize.Collapsed) }
    var rowHeight by remember { mutableIntStateOf(with(density) { 44.dp.roundToPx() }) }
    // Where the summary ends in the details, and where they all end.
    var summaryEnd by remember { mutableFloatStateOf(0f) }
    val gapPx = with(density) { DetailsGap.toPx() }

    fun heightOf(size: BarSize): Float = when (size) {
        BarSize.Collapsed -> rowHeight.toFloat()
        BarSize.Summary -> minOf(rowHeight + gapPx + summaryEnd, maxPx)
        // As tall as it may grow whatever the pattern, like a sheet's large size, so playing another from the
        // patterns at its bottom never resizes it.
        BarSize.Full -> maxOf(maxPx, heightOf(BarSize.Summary))
    }

    val height = remember { Animatable(rowHeight.toFloat()) }
    var isDragging by remember { mutableStateOf(false) }
    val detailsScroll = rememberScrollState()

    fun settle(target: BarSize) {
        if (target != size) haptics.performHapticFeedback(HapticFeedbackType.SegmentTick)
        size = target
        scope.launch { height.animateTo(heightOf(target), spring(dampingRatio = 0.82f, stiffness = Spring.StiffnessMediumLow)) }
        // Smaller than full, the details show from their top, so the summary shows its whole timeline.
        if (target != BarSize.Full) scope.launch { detailsScroll.animateScrollTo(0) }
    }

    // Measured, or the room changed: keep the settled size's height.
    LaunchedEffect(rowHeight, summaryEnd, maxPx) {
        if (!isDragging && !height.isRunning) height.snapTo(heightOf(size))
    }
    // A new filter means new patterns to look at, which the full size leaves no room for.
    LaunchedEffect(viewModel.filter) {
        if (size == BarSize.Full) settle(BarSize.Summary)
    }
    LaunchedEffect(size, rowHeight, summaryEnd, maxPx) {
        onOpenHeightChange(with(density) { (heightOf(size) - heightOf(BarSize.Collapsed)).coerceAtLeast(0f).toDp() })
    }
    val openness = run {
        val range = heightOf(BarSize.Summary) - heightOf(BarSize.Collapsed)
        if (range <= 0f) 0f else ((height.value - heightOf(BarSize.Collapsed)) / range).coerceIn(0f, 1f)
    }
    val fullness = run {
        val range = heightOf(BarSize.Full) - heightOf(BarSize.Summary)
        if (range <= 0f) (if (size == BarSize.Full) 1f else 0f) else ((height.value - heightOf(BarSize.Summary)) / range).coerceIn(0f, 1f)
    }
    LaunchedEffect(openness) { onOpennessChange(openness) }

    // Back closes the open bar before leaving the screen, as it would a sheet.
    BackHandler(enabled = size != BarSize.Collapsed) { settle(BarSize.Collapsed) }

    val drag = Modifier.draggable(
        orientation = Orientation.Vertical,
        state = rememberDraggableState { delta ->
            // Past the smallest or largest size it gives less and less, as a sheet does.
            val low = heightOf(BarSize.Collapsed)
            val high = heightOf(BarSize.Full)
            val proposed = height.value - delta
            val resisted = when {
                proposed < low -> height.value - delta * 0.2f
                proposed > high -> height.value - delta * 0.3f
                else -> proposed
            }
            scope.launch { height.snapTo(resisted) }
        },
        onDragStarted = { isDragging = true },
        onDragStopped = { velocity ->
            isDragging = false
            // Where the flick would carry the bar, then the nearest size to there.
            val projected = height.value - velocity * 0.18f
            settle(BarSize.entries.minBy { abs(heightOf(it) - projected) })
        },
    )

    Box(Modifier.fillMaxWidth().height(with(density) { maxOf(height.value, rowHeight.toFloat()).toDp() } + BarVerticalPadding * 2)) {
        Column(Modifier.padding(start = 12.dp, end = 6.dp, top = BarVerticalPadding, bottom = BarVerticalPadding)) {
            Row(
                Modifier
                    .onSizeChanged { rowHeight = it.height }
                    .then(drag),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(4.dp),
            ) {
                Header(
                    pattern = pattern,
                    playback = playback,
                    size = size,
                    isHapticsSupported = viewModel.isHapticsSupported,
                    onToggle = { settle(if (size == BarSize.Collapsed) BarSize.Summary else BarSize.Collapsed) },
                    onResize = { larger ->
                        val target = BarSize.entries.getOrNull(size.ordinal + if (larger) 1 else -1)
                        if (target != null) settle(target)
                    },
                    modifier = Modifier.weight(1f),
                )
                val isFavorite = viewModel.isFavorite(pattern)
                IconButton(onClick = { viewModel.toggleFavorite(pattern) }) {
                    Icon(
                        if (isFavorite) Icons.Rounded.Star else Icons.Rounded.StarOutline,
                        contentDescription = if (isFavorite) "Remove from Favorites" else "Add to Favorites",
                        tint = if (isFavorite) DemoTint.Yellow.color else MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                IconButton(onClick = { viewModel.play(pattern) }) {
                    Icon(Icons.Rounded.Replay, contentDescription = "Play Again")
                }
            }
            // Only built while open or opening: built collapsed, they'd cost every play a rebuild nobody sees.
            if (openness > 0f || size != BarSize.Collapsed || summaryEnd == 0f) {
                Box(
                    Modifier
                        .fillMaxWidth()
                        .height(with(density) { (height.value - rowHeight).coerceAtLeast(0f).toDp() })
                        .graphicsLayer { alpha = openness }
                        .then(if (size != BarSize.Full) drag else Modifier),
                ) {
                    Column(
                        Modifier
                            .fillMaxWidth()
                            .verticalScroll(detailsScroll, enabled = size == BarSize.Full)
                            .padding(top = DetailsGap, end = 6.dp, bottom = if (size == BarSize.Full) 120.dp else 16.dp),
                    ) {
                        PatternDetails(
                            pattern = pattern,
                            playback = playback,
                            isFull = size == BarSize.Full,
                            onToggleFull = { settle(if (size == BarSize.Full) BarSize.Summary else BarSize.Full) },
                            onSummaryEnd = { summaryEnd = it },
                        )
                    }
                    // Pinned rather than at the end of the details, so it stays in one place whichever pattern plays.
                    if (fullness > 0.4f) {
                        SimilarPatterns(
                            pattern = pattern,
                            onPlay = viewModel::play,
                            modifier = Modifier
                                .align(Alignment.BottomCenter)
                                .graphicsLayer { alpha = (fullness - 0.4f) / 0.6f },
                        )
                    }
                }
            }
        }
        Grabber(
            onClick = { settle(if (size == BarSize.Full) BarSize.Collapsed else BarSize.entries[size.ordinal + 1]) },
            modifier = Modifier.align(Alignment.TopCenter).then(drag),
        )
    }
}

/** A tap shows or hides the details: never a replay, so a tap that misses the star can't play by surprise. */
@Composable
private fun Header(
    pattern: HapticPattern,
    playback: HapticDemoViewModel.Playback?,
    size: BarSize,
    isHapticsSupported: Boolean,
    onToggle: () -> Unit,
    onResize: (larger: Boolean) -> Unit,
    modifier: Modifier = Modifier,
) {
    Row(
        modifier
            .clickable(onClickLabel = if (size == BarSize.Collapsed) "Show details" else "Hide details", onClick = onToggle)
            .semantics(mergeDescendants = true) {
                stateDescription = if (playback != null) "Playing" else ""
                customActions = listOf(
                    CustomAccessibilityAction("Larger") { onResize(true); true },
                    CustomAccessibilityAction("Smaller") { onResize(false); true },
                )
            }
            .testTag("nowPlaying"),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        val tint = pattern.tint
        Box(Modifier.size(40.dp), contentAlignment = Alignment.Center) {
            Box(Modifier.size(40.dp).background(tint.copy(alpha = 0.15f), CircleShape), contentAlignment = Alignment.Center) {
                PatternSymbol(pattern.symbol, tint, 20.dp)
            }
            // Every play gets the ring: long patterns fill it over their length, short ones sweep it at a glance.
            if (playback != null) {
                key(playback.id) {
                    ProgressRing(maxOf(pattern.durationMs, MINIMUM_SWEEP_MS), tint, Modifier.size(48.dp))
                }
            }
        }
        Column(Modifier.weight(1f)) {
            Text(pattern.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold, maxLines = 1, overflow = TextOverflow.Ellipsis)
            // Open, the full description is below, so this line shows the facts instead.
            if (!isHapticsSupported) {
                Text("Not felt on this device", style = MaterialTheme.typography.bodyMedium, color = DemoTint.Orange.color, maxLines = 1)
            } else {
                Text(
                    if (size != BarSize.Collapsed) "${pattern.category.title} · ${pattern.durationText}" else pattern.subtitle,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
        }
    }
}

/** The quickest the ring fills, so a pattern over in a blink still shows a sweep rather than a flash. */
private const val MINIMUM_SWEEP_MS = 350L

/** A ring around the icon that fills over the pattern's duration, clockwise from the top. */
@Composable
private fun ProgressRing(durationMs: Long, tint: Color, modifier: Modifier = Modifier) {
    val progress = remember { Animatable(0f) }
    LaunchedEffect(Unit) { progress.animateTo(1f, tween(durationMs.toInt(), easing = LinearEasing)) }
    Canvas(modifier) {
        val stroke = 2.5.dp.toPx()
        drawArc(tint, -90f, 360f * progress.value, false, topLeft = Offset(stroke / 2, stroke / 2), size = Size(size.width - stroke, size.height - stroke), style = Stroke(stroke, cap = StrokeCap.Round))
    }
}

/** The handle along the bar's top edge, hinting that it can be resized. Tapping it steps to the next size. */
@Composable
private fun Grabber(onClick: () -> Unit, modifier: Modifier = Modifier) {
    Box(
        modifier
            .size(width = 72.dp, height = 20.dp)
            .clickable(onClick = onClick)
            .clearAndSetSemantics {},
        contentAlignment = Alignment.TopCenter,
    ) {
        Box(Modifier.padding(top = 4.dp).size(width = 36.dp, height = 4.dp).background(MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.4f), CircleShape))
    }
}

/**
 * What the open bar adds. The summary first: the full description, and a timeline to compare with what's
 * felt. Then, in the full size: the numbers and each event. Mirrors `PatternDetails.swift`.
 */
@Composable
private fun PatternDetails(
    pattern: HapticPattern,
    playback: HapticDemoViewModel.Playback?,
    isFull: Boolean,
    onToggleFull: () -> Unit,
    onSummaryEnd: (Float) -> Unit,
) {
    val tint = pattern.tint
    val events = pattern.events
    val density = LocalDensity.current
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Text(pattern.subtitle, style = MaterialTheme.typography.bodyMedium)
        PatternTimeline(pattern, playback)
        Text(
            "${eventSummary(events)}. Taller is stronger; deeper color is sharper.",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        // Peeks out at the bottom of the summary, so there's plainly more, and one tap reaches it.
        val chevron by animateFloatAsState(if (isFull) 180f else 0f, label = "chevron")
        Row(
            Modifier
                .fillMaxWidth()
                .heightIn(min = 44.dp)
                .clip(CircleShape)
                .background(tint.copy(alpha = 0.12f))
                .clickable(onClick = onToggleFull)
                .onPlaced { onSummaryEnd(it.positionInParent().y + it.size.height + with(density) { 12.dp.toPx() }) }
                .testTag("toggleFullDetails"),
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(if (isFull) "Fewer Details" else "More Details", color = tint, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
            Spacer(Modifier.width(6.dp))
            Icon(Icons.Rounded.KeyboardArrowUp, contentDescription = null, tint = tint, modifier = Modifier.size(18.dp).rotate(chevron))
        }
        PatternStats(pattern, tint)
        EventList(events, tint)
    }
}

/** Such as "3 taps", "1 hold" or "8 taps, 1 hold". */
private fun eventSummary(events: List<HapticPatternEvent>): String {
    val taps = events.count { it.kind == HapticPatternEvent.Kind.Tap }
    val holds = events.size - taps
    return listOfNotNull(
        if (taps > 0) (if (taps == 1) "1 tap" else "$taps taps") else null,
        if (holds > 0) (if (holds == 1) "1 hold" else "$holds holds") else null,
    ).joinToString(", ")
}

/**
 * The pattern drawn over time: taps as thin bars, holds as blocks as long as they last. Height is strength
 * and color depth is sharpness. While the pattern plays, a playhead crosses it. Mirrors `PatternTimeline.swift`.
 */
@Composable
private fun PatternTimeline(pattern: HapticPattern, playback: HapticDemoViewModel.Playback?) {
    val tint = pattern.tint
    val baseline = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.1f)
    val playhead = MaterialTheme.colorScheme.onSurface
    val events = pattern.events
    val total = pattern.durationMs
    Column(
        Modifier.clearAndSetSemantics { contentDescription = "Timeline, ${events.size} events over ${pattern.durationText}" },
        verticalArrangement = Arrangement.spacedBy(4.dp),
    ) {
        Box(Modifier.fillMaxWidth().height(88.dp)) {
            Canvas(Modifier.matchParentSize()) {
                val tapWidth = 4.dp.toPx()
                val usable = size.width - tapWidth
                // A faint baseline, so a quiet pattern still reads as a timeline.
                drawRect(baseline, Offset(0f, size.height - 1), Size(size.width, 1f))
                for (event in events) {
                    // A pattern with no length, such as a single tap, sits in the middle.
                    val x = if (total > 0) usable * event.timeMs / total else usable / 2
                    val width = when (event.kind) {
                        HapticPatternEvent.Kind.Tap -> tapWidth
                        // A pixel short, so back-to-back holds stay distinct.
                        HapticPatternEvent.Kind.Hold -> maxOf(tapWidth, usable * event.durationMs / total - 1)
                    }
                    val height = maxOf(3.dp.toPx(), size.height * event.intensity)
                    drawRoundRect(
                        tint.copy(alpha = 0.3f + 0.7f * event.sharpness),
                        Offset(x, size.height - height),
                        Size(width, height),
                        CornerRadius(minOf(2.dp.toPx(), width / 2)),
                    )
                }
            }
            if (playback != null && total > 0) {
                key(playback.id) {
                    val progress = remember { Animatable(0f) }
                    LaunchedEffect(Unit) { progress.animateTo(1f, tween(total.toInt(), easing = LinearEasing)) }
                    Canvas(Modifier.matchParentSize()) {
                        val x = (size.width - 2.dp.toPx()) * progress.value
                        drawRoundRect(playhead, Offset(x, 0f), Size(2.dp.toPx(), size.height), CornerRadius(1.dp.toPx()))
                    }
                }
            }
        }
        Row(Modifier.fillMaxWidth()) {
            Text("0 s", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Spacer(Modifier.weight(1f))
            Text(pattern.durationText, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
    }
}

/** The pattern in four numbers, as tiles. */
@Composable
private fun PatternStats(pattern: HapticPattern, tint: Color) {
    val events = pattern.events
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            StatTile("Length", pattern.durationText, tint, Modifier.weight(1f))
            StatTile("Events", "${events.size}", tint, Modifier.weight(1f))
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            StatTile("Strongest", percent(events.maxOf { it.intensity }), tint, Modifier.weight(1f))
            StatTile("Average Sharpness", percent(events.map { it.sharpness }.average().toFloat()), tint, Modifier.weight(1f))
        }
    }
}

@Composable
private fun StatTile(title: String, value: String, tint: Color, modifier: Modifier) {
    Column(
        modifier
            .background(tint.copy(alpha = 0.08f), RoundedCornerShape(14.dp))
            .padding(12.dp)
            .semantics(mergeDescendants = true) {},
    ) {
        Text(value, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.SemiBold)
        Text(title, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

/** Every event in order: when it starts, what it is, and how strong, drawn as on the timeline. */
@Composable
private fun EventList(events: List<HapticPatternEvent>, tint: Color) {
    val track = LocalDemoColors.current.fill
    Column {
        SectionTitle("Events", trailing = "${events.size}")
        // Long textures have dozens; past this, the timeline tells the story better than rows.
        events.take(EVENT_LIMIT).forEachIndexed { index, event ->
            if (index > 0) HorizontalDivider(thickness = 0.5.dp, color = LocalDemoColors.current.separator)
            val kind = if (event.kind == HapticPatternEvent.Kind.Tap) "Tap" else "Hold ${seconds(event.durationMs)}"
            Row(
                Modifier
                    .padding(vertical = 10.dp)
                    .clearAndSetSemantics {
                        contentDescription = "${if (event.kind == HapticPatternEvent.Kind.Tap) "Tap" else "Hold for ${seconds(event.durationMs)}"} at " +
                            "${seconds(event.timeMs)}, strength ${percent(event.intensity)}, sharpness ${percent(event.sharpness)}"
                    },
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                Text(seconds(event.timeMs), style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.widthIn(min = 52.dp))
                Box(
                    Modifier
                        .size(if (event.kind == HapticPatternEvent.Kind.Tap) 7.dp else 7.dp)
                        .background(MaterialTheme.colorScheme.onSurfaceVariant, if (event.kind == HapticPatternEvent.Kind.Tap) CircleShape else RoundedCornerShape(2.dp)),
                )
                Text(kind, style = MaterialTheme.typography.bodyMedium, modifier = Modifier.weight(1f))
                // Like the timeline: the bar's length is strength, its color depth sharpness.
                Box(Modifier.size(width = 56.dp, height = 6.dp).background(track, CircleShape)) {
                    Box(Modifier.width(maxOf(6.dp, 56.dp * event.intensity)).height(6.dp).background(tint.copy(alpha = 0.3f + 0.7f * event.sharpness), CircleShape))
                }
                Text(percent(event.intensity), style = MaterialTheme.typography.bodySmall, modifier = Modifier.widthIn(min = 38.dp))
            }
        }
        if (events.size > EVENT_LIMIT) {
            HorizontalDivider(thickness = 0.5.dp, color = LocalDemoColors.current.separator)
            Text("And ${events.size - EVENT_LIMIT} more", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.padding(vertical = 10.dp))
        }
    }
}

private const val EVENT_LIMIT = 24

/** Such as "0.25 s". */
private fun seconds(ms: Long): String = String.format(Locale.getDefault(), "%.2f s", ms / 1_000f)

/** Such as "80%". */
private fun percent(value: Float): String = "${(value * 100).roundToInt()}%"

/**
 * The category's patterns, to feel side by side, pinned along the bottom of the full size. A tap plays one,
 * and the bar shows it. The one showing stays in the row, marked, so the row never reflows as they're tried
 * one after another. Mirrors `SimilarPatterns.swift`.
 */
@Composable
private fun SimilarPatterns(pattern: HapticPattern, onPlay: (HapticPattern) -> Unit, modifier: Modifier = Modifier) {
    val card = LocalDemoColors.current.card
    val patterns = pattern.category.patterns
    val scroll = rememberScrollState()
    val density = LocalDensity.current
    // Where each chip starts, to bring the one showing into view.
    val starts = remember(pattern.category) { mutableMapOf<HapticPattern, Pair<Int, Int>>() }
    LaunchedEffect(pattern) {
        val (start, width) = starts[pattern] ?: return@LaunchedEffect
        val viewport = scroll.viewportSize
        // Only as far as needed, so a tap never moves the row.
        val target = when {
            start < scroll.value -> start
            start + width > scroll.value + viewport -> start + width - viewport
            else -> return@LaunchedEffect
        }
        scroll.animateScrollTo(target)
    }
    Column(
        modifier
            .fillMaxWidth()
            .background(Brush.verticalGradient(0f to card.copy(alpha = 0f), 0.2f to card, 1f to card))
            .padding(top = 24.dp, end = 6.dp, bottom = 4.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        SectionTitle("More in ${pattern.category.title}")
        Row(Modifier.horizontalScroll(scroll), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            patterns.forEach { similar ->
                val isSelected = similar == pattern
                val tint = similar.tint
                Row(
                    Modifier
                        .onPlaced { starts[similar] = it.positionInParent().x.roundToInt() to it.size.width }
                        .heightIn(min = 36.dp)
                        .clip(CircleShape)
                        .background(if (isSelected) tint else tint.copy(alpha = 0.12f))
                        .clickable(onClickLabel = if (isSelected) "Play it again" else "Play it") { onPlay(similar) }
                        .semantics { selected = isSelected; role = Role.Button }
                        .padding(horizontal = 12.dp)
                        .testTag("similar.${similar.name}"),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp),
                ) {
                    val content = if (isSelected) Color.White else tint
                    PatternSymbol(similar.symbol, content, 18.dp)
                    Text(similar.title, color = content, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.Medium, maxLines = 1)
                }
            }
        }
    }
}
