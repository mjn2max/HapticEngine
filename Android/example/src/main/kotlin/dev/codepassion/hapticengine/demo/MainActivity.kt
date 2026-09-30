package dev.codepassion.hapticengine.demo

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewmodel.compose.viewModel
import dev.codepassion.hapticengine.HapticEngine

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            DemoTheme {
                DemoApp()
            }
        }
    }
}

/** The two screens, pushed and popped with a slide like a navigation stack. */
@Composable
fun DemoApp() {
    val context = LocalContext.current
    val viewModel = viewModel { HapticDemoViewModel(HapticEngine(context)) }
    var showsActivity by rememberSaveable { mutableStateOf(false) }

    BackHandler(enabled = showsActivity) { showsActivity = false }

    AnimatedContent(
        targetState = showsActivity,
        transitionSpec = {
            val duration = 300
            if (targetState) {
                slideInHorizontally(tween(duration)) { it } togetherWith slideOutHorizontally(tween(duration)) { -it / 4 }
            } else {
                slideInHorizontally(tween(duration)) { -it / 4 } togetherWith slideOutHorizontally(tween(duration)) { it }
            }
        },
        label = "screen",
    ) { activity ->
        if (activity) {
            ActivityScreen(viewModel, onBack = { showsActivity = false })
        } else {
            HomeScreen(viewModel, onOpenActivity = { showsActivity = true })
        }
    }
}
