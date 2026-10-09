package dev.codepassion.hapticengine.demo

import android.os.Bundle
import android.os.SystemClock
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.hapticfeedback.HapticFeedback
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.lifecycle.viewmodel.compose.viewModel
import dev.codepassion.hapticengine.HapticEngine
import kotlinx.coroutines.delay

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            DemoTheme {
                DemoApp(engineOverride())
            }
        }
    }

    /**
     * Debug builds take `--es haptics none` to try the screen a phone without a vibrator shows, and
     * `--es haptics mock` to try the UI on an emulator without vibrating anything, like `-MockHaptics YES` on iOS.
     */
    private fun engineOverride(): HapticEngine? {
        if (!BuildConfig.DEBUG) return null
        return when (intent.getStringExtra("haptics")) {
            "none" -> PreviewHapticEngine(isHapticsSupported = false)
            "mock" -> PreviewHapticEngine()
            else -> null
        }
    }
}

/** Screens the patterns lead to, pushed and popped with a slide like a navigation stack. */
private enum class Screen { Home, History, License }

@Composable
fun DemoApp(engineOverride: HapticEngine? = null) {
    val context = LocalContext.current.applicationContext
    val viewModel = viewModel {
        HapticDemoViewModel(
            engine = engineOverride ?: HapticEngine(context),
            preferences = Preferences(context),
            activity = SqliteActivityStore(context),
        )
    }
    var screen by rememberSaveable { mutableStateOf(Screen.Home) }
    var isMenuOpen by rememberSaveable { mutableStateOf(false) }
    var revealStart by rememberSaveable { mutableStateOf<Long?>(null) }
    // Android has one vibrator, and any vibration cancels the one before: a tick from the screen would cut
    // a playing pattern short. On iOS the two mix. So the screen's own haptics wait until patterns end.
    val systemHaptics = LocalHapticFeedback.current
    val haptics = remember(systemHaptics) { PatternAwareHaptics(systemHaptics) { viewModel.nowPlaying != null } }

    // Once the first frame is up, never on it, or there'd be nothing to animate from. Felt along with the
    // wave on the first launch, though not with animations off, where there's no wave.
    LaunchedEffect(Unit) {
        if (revealStart != null) return@LaunchedEffect
        delay(120)
        revealStart = SystemClock.uptimeMillis()
        if (!context.prefersReducedMotion() && viewModel.claimLaunchRipple()) LaunchRipple.play(context)
    }
    LaunchedEffect(isMenuOpen) { if (isMenuOpen) haptics.performHapticFeedback(HapticFeedbackType.ContextClick) }
    BackHandler(enabled = screen != Screen.Home) { screen = if (screen == Screen.License) Screen.Home else Screen.Home }

    CompositionLocalProvider(LocalHapticFeedback provides haptics) {
    Box(Modifier.fillMaxSize()) {
        AnimatedContent(
            targetState = screen,
            transitionSpec = {
                val duration = 300
                if (targetState != Screen.Home) {
                    slideInHorizontally(tween(duration)) { it } togetherWith slideOutHorizontally(tween(duration)) { -it / 4 }
                } else {
                    slideInHorizontally(tween(duration)) { -it / 4 } togetherWith slideOutHorizontally(tween(duration)) { it }
                }
            },
            label = "screen",
        ) { shown ->
            when (shown) {
                Screen.Home -> CompositionLocalProvider(LocalLaunchRevealStart provides revealStart) {
                    HomeScreen(viewModel, onOpenMenu = { isMenuOpen = true })
                }
                Screen.History -> ActivityScreen(viewModel, onBack = { screen = Screen.Home })
                Screen.License -> LicenseScreen(onBack = { screen = Screen.Home })
            }
        }
        // Over everything, the top bar included. Slides in from the edge its button is on.
        AnimatedVisibility(
            visible = isMenuOpen,
            enter = if (context.prefersReducedMotion()) fadeIn() else slideInHorizontally(tween(350)) { -it },
            exit = if (context.prefersReducedMotion()) fadeOut() else slideOutHorizontally(tween(350)) { -it },
        ) {
            MenuScreen(viewModel) { action ->
                // Pushed at once, beneath the page, so it's uncovered as the page slides away.
                when (action) {
                    MenuAction.ShowHistory -> screen = Screen.History
                    MenuAction.ShowLicense -> screen = Screen.License
                    null -> Unit
                }
                isMenuOpen = false
            }
        }
    }
    }
}

/** Haptics for the screen's own controls, which stay silent while a pattern plays, so it plays in full. */
private class PatternAwareHaptics(private val system: HapticFeedback, private val isPatternPlaying: () -> Boolean) : HapticFeedback {
    override fun performHapticFeedback(hapticFeedbackType: HapticFeedbackType) {
        if (!isPatternPlaying()) system.performHapticFeedback(hapticFeedbackType)
    }
}
