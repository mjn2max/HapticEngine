package dev.codepassion.hapticengine

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager

internal class VibratorHapticEngine(context: Context) : HapticEngine {
    private val vibrator: Vibrator =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Vibrator::class.java)
        }

    override val isHapticsSupported: Boolean
        get() = vibrator.hasVibrator()

    override fun startSimpleHaptic() = play(HapticPatterns.simple)

    override fun startComplexHaptic() = play(HapticPatterns.complex)

    private fun play(waveform: Waveform) {
        if (!isHapticsSupported) return

        // Without amplitude control every "on" segment plays at the device's default strength.
        val amplitudes = if (vibrator.hasAmplitudeControl()) {
            waveform.amplitudes
        } else {
            waveform.amplitudes.map { if (it == 0) 0 else VibrationEffect.DEFAULT_AMPLITUDE }
        }

        val effect = VibrationEffect.createWaveform(
            waveform.timingsMs.toLongArray(),
            amplitudes.toIntArray(),
            NO_REPEAT,
        )
        vibrator.vibrate(effect)
    }

    private companion object {
        const val NO_REPEAT = -1
    }
}
