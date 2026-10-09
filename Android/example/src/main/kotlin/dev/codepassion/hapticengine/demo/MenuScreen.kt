package dev.codepassion.hapticengine.demo

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.activity.compose.BackHandler
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.rememberDraggableState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.ArrowBack
import androidx.compose.material.icons.automirrored.rounded.KeyboardArrowRight
import androidx.compose.material.icons.rounded.BugReport
import androidx.compose.material.icons.rounded.Check
import androidx.compose.material.icons.rounded.Code
import androidx.compose.material.icons.rounded.ContentCopy
import androidx.compose.material.icons.rounded.Description
import androidx.compose.material.icons.rounded.Inventory2
import androidx.compose.material.icons.rounded.MobileOff
import androidx.compose.material.icons.rounded.NorthEast
import androidx.compose.material.icons.rounded.Schedule
import androidx.compose.material.icons.rounded.Vibration
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.math.roundToInt

/** What to show once the menu has closed. */
enum class MenuAction { ShowHistory, ShowLicense }

/**
 * The page behind the menu button, laid out like Settings: what the app is and whether haptics play here,
 * then the history and the layout, then what a developer trying the library reaches for next: adding it to
 * their app, its code, reporting a bug, its license. Mirrors `MenuView.swift`.
 *
 * Covers the whole screen, sliding in from the start edge where its button is, and back out the same way:
 * by its back button, the system back gesture, or by swiping it back.
 */
@Composable
fun MenuScreen(viewModel: HapticDemoViewModel, onClose: (MenuAction?) -> Unit) {
    val context = LocalContext.current
    val haptics = LocalHapticFeedback.current
    val colors = LocalDemoColors.current
    val scope = rememberCoroutineScope()
    val density = LocalDensity.current
    val dragOffset = remember { Animatable(0f) }

    BackHandler { onClose(null) }

    Column(
        Modifier
            .fillMaxSize()
            .offset { IntOffset(dragOffset.value.roundToInt(), 0) }
            .background(colors.background)
            // Follows a finger swiping the page back toward the start, and closes it if let go far or fast enough.
            .draggable(
                orientation = Orientation.Horizontal,
                state = rememberDraggableState { delta -> scope.launch { dragOffset.snapTo((dragOffset.value + delta).coerceAtMost(0f)) } },
                onDragStopped = { velocity ->
                    if (dragOffset.value < -with(density) { 120.dp.toPx() } || velocity < -with(density) { 1_000.dp.toPx() }) {
                        onClose(null)
                    } else {
                        dragOffset.animateTo(0f, snappy())
                    }
                },
            )
            .statusBarsPadding(),
    ) {
        // Where the menu button was, so the same spot opens and closes the page.
        IconButton(onClick = { onClose(null) }, modifier = Modifier.padding(start = 4.dp, top = 4.dp).testTag("menu.done")) {
            Icon(Icons.AutoMirrored.Rounded.ArrowBack, contentDescription = "Back")
        }
        Column(
            Modifier
                .fillMaxWidth()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
                .navigationBarsPadding()
                .padding(bottom = 24.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp),
        ) {
            Column(Modifier.widthIn(max = 600.dp).align(Alignment.CenterHorizontally), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Header(viewModel.isHapticsSupported)
                if (!viewModel.isHapticsSupported) {
                    Text(
                        "This device has no vibrator, so patterns can't be felt here, but each one still shows how it plays. Try the demo on a phone to feel them.",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(horizontal = 12.dp),
                    )
                }
            }
            Column(Modifier.widthIn(max = 600.dp).align(Alignment.CenterHorizontally).groupedCard()) {
                // History, not Activity, which suggested fitness: the record of plays, with their times.
                MenuRow("History", Icons.Rounded.Schedule, DemoTint.Blue, Modifier.testTag("menu.activity"), onClick = { onClose(MenuAction.ShowHistory) }) {
                    if (viewModel.log.isNotEmpty()) Badge(viewModel.log.size)
                    Chevron()
                }
                RowDivider(inset = 58.dp)
                LayoutRow(viewModel.layout) { layout ->
                    haptics.performHapticFeedback(HapticFeedbackType.SegmentTick)
                    viewModel.selectLayout(layout)
                    // Closes the page, so the patterns are seen taking the new layout.
                    onClose(null)
                }
                RowDivider(inset = 58.dp)
                CopyDependencyRow(context)
                RowDivider(inset = 58.dp)
                MenuRow("Source Code", Icons.Rounded.Code, DemoTint.Gray, onClick = { context.open(Uri.parse(AppInfo.SOURCE_CODE)) }) { External() }
                RowDivider(inset = 58.dp)
                MenuRow("Report an Issue", Icons.Rounded.BugReport, DemoTint.Indigo, onClick = {
                    context.open(AppInfo.newIssue(context, viewModel.isHapticsSupported))
                }) { External() }
                RowDivider(inset = 58.dp)
                MenuRow("License", Icons.Rounded.Description, DemoTint.Purple, onClick = { onClose(MenuAction.ShowLicense) }) { Chevron() }
            }
            Text(
                "Made with care by Huy D. · MIT License",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth(),
            )
        }
    }
}

/**
 * The app's icon and version, and whether this device can play haptics: the first thing to check when
 * nothing is felt. Tapping the icon taps back: this is an app about haptics, after all.
 */
@Composable
private fun Header(isHapticsSupported: Boolean) {
    val context = LocalContext.current
    val haptics = LocalHapticFeedback.current
    val scope = rememberCoroutineScope()
    val iconScale = remember { Animatable(1f) }
    Row(
        Modifier.fillMaxWidth().groupedCard().padding(16.dp).semantics(mergeDescendants = true) {},
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(16.dp),
    ) {
        Image(
            painterResource(R.drawable.app_icon),
            contentDescription = null,
            modifier = Modifier
                .size(64.dp)
                .scale(iconScale.value)
                .clip(RoundedCornerShape(14.5.dp))
                .border(0.5.dp, MaterialTheme.colorScheme.onSurface.copy(alpha = 0.08f), RoundedCornerShape(14.5.dp))
                .clickable(interactionSource = null, indication = null) {
                    haptics.performHapticFeedback(HapticFeedbackType.Confirm)
                    // Pressed in and sprung back, in time with the tap felt.
                    scope.launch {
                        iconScale.animateTo(0.88f, androidx.compose.animation.core.tween(80))
                        iconScale.animateTo(1f, spring(dampingRatio = Spring.DampingRatioMediumBouncy))
                    }
                }
                .clearAndSetSemantics {},
        )
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
            Text("Haptic Engine", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Text(AppInfo.version(context), style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Spacer(Modifier.height(4.dp))
            HapticsStatus(isHapticsSupported)
        }
    }
}

/** A pill saying whether haptics play here, green when they do. */
@Composable
private fun HapticsStatus(isSupported: Boolean) {
    val tint = (if (isSupported) DemoTint.Green else DemoTint.Orange).color
    Row(
        Modifier.background(tint.copy(alpha = 0.14f), CircleShape).padding(horizontal = 8.dp, vertical = 3.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(4.dp),
    ) {
        Icon(if (isSupported) Icons.Rounded.Vibration else Icons.Rounded.MobileOff, contentDescription = null, tint = tint, modifier = Modifier.size(14.dp))
        Text(
            if (isSupported) "Haptics Ready" else "No Vibrator on This Device",
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.SemiBold,
            color = tint,
        )
    }
}

/** How the home screen lays out the patterns: a setting, here with the app's others. */
@Composable
private fun LayoutRow(layout: PatternLayout, onSelect: (PatternLayout) -> Unit) {
    var isOpen by remember { mutableStateOf(false) }
    Box {
        MenuRow("Layout", if (layout == PatternLayout.Grid) symbolIcon(layout.symbol) else symbolIcon(layout.symbol), DemoTint.Teal, Modifier.testTag("menu.layout"), onClick = { isOpen = true }) {
            Text(layout.title, style = MaterialTheme.typography.bodyLarge, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
        DropdownMenu(expanded = isOpen, onDismissRequest = { isOpen = false }, modifier = Modifier.align(Alignment.CenterEnd)) {
            PatternLayout.entries.forEach { option ->
                DropdownMenuItem(
                    text = { Text(option.title) },
                    leadingIcon = { Icon(symbolIcon(option.symbol), contentDescription = null) },
                    trailingIcon = { if (option == layout) Icon(Icons.Rounded.Check, contentDescription = "Selected") },
                    onClick = {
                        isOpen = false
                        onSelect(option)
                    },
                )
            }
        }
    }
}

/** Copies the Gradle dependency, and says so for a moment. */
@Composable
private fun CopyDependencyRow(context: Context) {
    val haptics = LocalHapticFeedback.current
    var copies by remember { mutableIntStateOf(0) }
    var isShowingCopied by remember { mutableStateOf(false) }
    LaunchedEffect(copies) {
        if (copies == 0) return@LaunchedEffect
        isShowingCopied = true
        delay(2_500)
        isShowingCopied = false
    }
    MenuRow(
        "Use in Your App",
        Icons.Rounded.Inventory2,
        DemoTint.Orange,
        Modifier.testTag("menu.package"),
        subtitle = if (isShowingCopied) "Copied. Paste it in your module's build.gradle.kts." else "Copy the Gradle dependency",
        onClick = {
            val clipboard = context.getSystemService(ClipboardManager::class.java)
            clipboard.setPrimaryClip(ClipData.newPlainText("Gradle dependency", AppInfo.DEPENDENCY))
            haptics.performHapticFeedback(HapticFeedbackType.Confirm)
            copies++
        },
    ) {
        AnimatedContent(isShowingCopied, transitionSpec = { fadeIn() togetherWith fadeOut() }, label = "copied") { copied ->
            Icon(
                if (copied) Icons.Rounded.Check else Icons.Rounded.ContentCopy,
                contentDescription = null,
                tint = if (copied) DemoTint.Green.color else MaterialTheme.colorScheme.outline,
                modifier = Modifier.size(18.dp),
            )
        }
    }
}

/**
 * A row on the menu page, as in Settings: a white symbol on a colored tile, the title and perhaps a line under
 * it, then whatever goes at the end, such as a count or where the row leads. Mirrors `MenuRow.swift`.
 */
@Composable
private fun MenuRow(
    title: String,
    icon: ImageVector,
    tint: DemoTint,
    modifier: Modifier = Modifier,
    subtitle: String? = null,
    onClick: () -> Unit,
    accessory: @Composable () -> Unit = {},
) {
    Row(
        modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(horizontal = 14.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(14.dp),
    ) {
        Box(Modifier.size(30.dp).background(tint.color, RoundedCornerShape(8.dp)), contentAlignment = Alignment.Center) {
            Icon(icon, contentDescription = null, tint = Color.White, modifier = Modifier.size(18.dp))
        }
        Column(Modifier.weight(1f)) {
            Text(title, style = MaterialTheme.typography.bodyLarge)
            if (subtitle != null) {
                Text(subtitle, style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
        }
        accessory()
    }
}

@Composable
private fun Badge(count: Int) {
    Text("$count", style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
}

@Composable
private fun Chevron() {
    Icon(Icons.AutoMirrored.Rounded.KeyboardArrowRight, contentDescription = null, tint = MaterialTheme.colorScheme.outline)
}

/** Leaves the app, for the browser. */
@Composable
private fun External() {
    Icon(Icons.Rounded.NorthEast, contentDescription = null, tint = MaterialTheme.colorScheme.outline, modifier = Modifier.size(18.dp))
}

private fun Context.open(uri: Uri) {
    runCatching { startActivity(Intent(Intent.ACTION_VIEW, uri)) }
}
