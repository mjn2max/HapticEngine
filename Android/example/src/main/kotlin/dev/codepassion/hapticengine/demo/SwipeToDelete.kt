package dev.codepassion.hapticengine.demo

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.rememberDraggableState
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Delete
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.semantics.CustomAccessibilityAction
import androidx.compose.ui.semantics.customActions
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import kotlin.math.roundToInt

/**
 * Swipe a row left to uncover a plain trash icon on the card's own background, instead of a filled
 * action button. A short swipe leaves the icon showing to tap; a long one deletes straight away.
 * Mirrors `SwipeToDelete.swift`.
 */
@Composable
fun SwipeToDelete(
    isOpen: Boolean,
    onOpenChange: (Boolean) -> Unit,
    onDelete: () -> Unit,
    modifier: Modifier = Modifier,
    content: @Composable () -> Unit,
) {
    val density = LocalDensity.current
    val haptics = LocalHapticFeedback.current
    val scope = rememberCoroutineScope()
    /** How far an open row sits, leaving room for the icon. */
    val openWidth = with(density) { OPEN_WIDTH.toPx() }
    var width by remember { mutableFloatStateOf(0f) }
    val offset = remember { Animatable(0f) }
    var isDragging by remember { mutableStateOf(false) }
    var isDeleting by remember { mutableStateOf(false) }

    val passesDeleteThreshold = width > 0 && -offset.value > width * DELETE_FRACTION

    fun delete() {
        if (isDeleting) return
        isDeleting = true
        // Slides the row the rest of the way out, then removes it so the rows below move up.
        scope.launch {
            offset.animateTo(-width, tween(220))
            onDelete()
        }
    }

    // Closes when another row opens, the list scrolls, or the row is tapped.
    LaunchedEffect(isOpen) {
        if (!isDragging && !isDeleting) offset.animateTo(if (isOpen) -openWidth else 0f, snappy())
    }
    // A tick as the swipe passes the point where letting go deletes, and again if it comes back.
    LaunchedEffect(passesDeleteThreshold) {
        if (isDragging) haptics.performHapticFeedback(HapticFeedbackType.GestureThresholdActivate)
    }

    Box(
        modifier
            .onSizeChanged { width = it.width.toFloat() }
            .semantics {
                customActions = listOf(CustomAccessibilityAction("Delete") { delete(); true })
            },
    ) {
        DeleteIcon(
            isArmed = passesDeleteThreshold,
            // Fades in as the row uncovers it.
            visibility = (-offset.value / openWidth).coerceIn(0f, 1f),
            onClick = ::delete,
            modifier = Modifier.align(Alignment.CenterEnd).width(OPEN_WIDTH).fillMaxHeight(),
        )
        Box(
            Modifier
                .offset { IntOffset(offset.value.roundToInt(), 0) }
                // Opaque, so the icon stays hidden until the row moves.
                .background(LocalDemoColors.current.card)
                .draggable(
                    orientation = Orientation.Horizontal,
                    state = rememberDraggableState { delta ->
                        // Only leftward from rest; resists a little past the full width.
                        val proposed = (offset.value + delta).coerceAtMost(0f)
                        val resisted = if (proposed < -width) -width + (proposed + width) / 4 else proposed
                        scope.launch { offset.snapTo(resisted) }
                    },
                    enabled = !isDeleting,
                    onDragStarted = {
                        isDragging = true
                        // Starting to swipe one row closes any other that's open, so only one is ever open.
                        if (!isOpen) onOpenChange(false)
                    },
                    onDragStopped = { velocity ->
                        isDragging = false
                        val flingPx = with(density) { FLING_VELOCITY.toPx() }
                        when {
                            // A quick flick counts as a full swipe, as in system lists.
                            passesDeleteThreshold || (offset.value < -openWidth && velocity < -flingPx) -> delete()
                            else -> {
                                val opens = (offset.value < -openWidth / 2 || velocity < -flingPx / 5) && velocity < flingPx / 5
                                offset.animateTo(if (opens) -openWidth else 0f, snappy())
                                onOpenChange(opens)
                            }
                        }
                    },
                ),
        ) {
            content()
        }
    }
}

@Composable
private fun DeleteIcon(isArmed: Boolean, visibility: Float, onClick: () -> Unit, modifier: Modifier) {
    // Gray until letting go would delete, then red: the only color in the whole gesture.
    val tint by animateColorAsState(
        if (isArmed) MaterialTheme.colorScheme.error else MaterialTheme.colorScheme.onSurfaceVariant,
        tween(200),
        label = "tint",
    )
    val scale by animateFloatAsState(if (isArmed) 1.15f else 1f, snappy(), label = "scale")
    Box(
        modifier
            .graphicsLayer { alpha = visibility }
            .clickable(enabled = visibility > 0.5f, onClickLabel = "Delete", onClick = onClick),
        contentAlignment = Alignment.Center,
    ) {
        Icon(
            Icons.Outlined.Delete,
            contentDescription = null,
            tint = tint,
            modifier = Modifier.size(24.dp).graphicsLayer { scaleX = scale; scaleY = scale },
        )
    }
}

private val OPEN_WIDTH = 64.dp
private val FLING_VELOCITY = 1_500.dp // per second
/** Past this share of the row's width, letting go deletes. */
private const val DELETE_FRACTION = 0.5f
