package dev.codepassion.hapticengine.demo

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.compose.LifecycleEventEffect
import androidx.lifecycle.viewmodel.compose.viewModel
import java.time.format.DateTimeFormatter

private val timeFormat = DateTimeFormatter.ofPattern("HH:mm:ss")

@Composable
fun DemoRoute(viewModel: HapticDemoViewModel = viewModel()) {
    LifecycleEventEffect(Lifecycle.Event.ON_START) { viewModel.record("Lifecycle: started") }
    LifecycleEventEffect(Lifecycle.Event.ON_STOP) { viewModel.record("Lifecycle: stopped") }

    DemoScreen(
        isHapticsSupported = viewModel.isHapticsSupported,
        log = viewModel.log,
        onPlay = viewModel::play,
        onClearLog = viewModel::clearLog,
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DemoScreen(
    isHapticsSupported: Boolean,
    log: List<HapticDemoViewModel.LogEntry>,
    onPlay: (HapticPreset) -> Unit,
    onClearLog: () -> Unit,
) {
    Scaffold(topBar = { TopAppBar(title = { Text("HapticEngine") }) }) { padding ->
        LazyColumn(Modifier.fillMaxSize().padding(padding)) {
            item { SectionHeader("Status") }
            item {
                ListItem(
                    headlineContent = { Text("Haptic hardware") },
                    trailingContent = {
                        Text(
                            if (isHapticsSupported) "✓ Supported" else "✕ Unsupported",
                            color = if (isHapticsSupported) Color(0xFF2E7D32) else MaterialTheme.colorScheme.error,
                        )
                    },
                    supportingContent = if (isHapticsSupported) null else {
                        { Text("This device reports no vibrator. Most emulators can't vibrate; use a physical phone.") }
                    },
                )
            }

            item { SectionHeader("Presets") }
            items(HapticPreset.entries) { preset ->
                ListItem(
                    headlineContent = { Text(preset.title, color = MaterialTheme.colorScheme.primary) },
                    supportingContent = { Text(preset.subtitle) },
                    modifier = Modifier.clickable { onPlay(preset) },
                )
            }

            item {
                SectionHeader("Activity") {
                    if (log.isNotEmpty()) TextButton(onClick = onClearLog) { Text("Clear") }
                }
            }
            if (log.isEmpty()) {
                item {
                    ListItem(headlineContent = {
                        Text(
                            "Play a preset, then background and reopen the app to check playback still works.",
                            style = MaterialTheme.typography.bodySmall,
                        )
                    })
                }
            }
            items(log) { entry ->
                ListItem(
                    headlineContent = { Text(entry.message) },
                    trailingContent = { Text(entry.time.format(timeFormat)) },
                )
                HorizontalDivider()
            }
        }
    }
}

@Composable
private fun SectionHeader(title: String, action: @Composable () -> Unit = {}) {
    ListItem(
        headlineContent = {
            Text(title, style = MaterialTheme.typography.titleSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        },
        trailingContent = action,
        modifier = Modifier.padding(top = 8.dp),
    )
}

@Preview(showBackground = true)
@Composable
private fun DemoScreenSupportedPreview() {
    DemoTheme {
        DemoScreen(
            isHapticsSupported = true,
            log = listOf(HapticDemoViewModel.LogEntry("Played Simple")),
            onPlay = {},
            onClearLog = {},
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun DemoScreenUnsupportedPreview() {
    DemoTheme {
        DemoScreen(isHapticsSupported = false, log = emptyList(), onPlay = {}, onClearLog = {})
    }
}
