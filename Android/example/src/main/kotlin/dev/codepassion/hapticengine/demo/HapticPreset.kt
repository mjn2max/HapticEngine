package dev.codepassion.hapticengine.demo

import dev.codepassion.hapticengine.HapticEngine

/** The library's built-in patterns, described for display in the demo. */
enum class HapticPreset(val title: String, val subtitle: String) {
    Simple("Simple", "Sharp tap followed by a rising ramp"),
    Complex("Complex", "Medium → hard → soft → hard, 6 seconds");

    fun play(engine: HapticEngine) = when (this) {
        Simple -> engine.startSimpleHaptic()
        Complex -> engine.startComplexHaptic()
    }
}
