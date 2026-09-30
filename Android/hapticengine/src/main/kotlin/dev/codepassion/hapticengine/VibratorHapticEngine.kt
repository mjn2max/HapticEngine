package dev.codepassion.hapticengine

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.annotation.RequiresApi

internal class VibratorHapticEngine(context: Context) : HapticEngine {
    private val vibrator: Vibrator =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Vibrator::class.java)
        }

    override val isHapticsSupported: Boolean = vibrator.hasVibrator()

    /** Every pattern, built once up front since they never change. Empty without a vibrator. */
    private val effects: Map<HapticPattern, VibrationEffect> =
        if (isHapticsSupported) HapticPattern.entries.associateWith(::makeEffect) else emptyMap()

    /** Plays [pattern]. The vibrator cancels whatever it was playing, so patterns never overlap. */
    override fun play(pattern: HapticPattern) {
        val effect = effects[pattern] ?: return
        vibrator.vibrate(effect)
    }

    private fun makeEffect(pattern: HapticPattern): VibrationEffect {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            HapticPatterns.primitives(pattern)?.let { steps -> composition(steps)?.let { return it } }
        }
        return waveform(HapticPatterns.waveform(pattern))
    }

    /**
     * Haptic primitives, for crisp taps close to iOS. `null` if the vibrator can't play every primitive
     * the pattern needs, so the pattern falls back to a waveform as a whole rather than playing partly.
     */
    // The IDs always come from `Primitive.id`, which returns only `PRIMITIVE_*` constants; lint can't follow
    // them through a list.
    @SuppressLint("WrongConstant")
    @RequiresApi(Build.VERSION_CODES.S)
    private fun composition(steps: List<PrimitiveStep>): VibrationEffect? {
        val ids = steps.map { it.primitive.id }.distinct().toIntArray()
        if (!vibrator.areAllPrimitivesSupported(*ids)) return null
        val durations = ids.zip(vibrator.getPrimitiveDurations(*ids).toList()).toMap()

        val composition = VibrationEffect.startComposition()
        var previousEndMs = 0L
        for (step in steps) {
            // A primitive's delay counts from the end of the one before, not from the start of the pattern.
            val delayMs = (step.atMs - previousEndMs).coerceAtLeast(0)
            composition.addPrimitive(step.primitive.id, step.scale.coerceIn(0f, 1f), delayMs.toInt())
            previousEndMs += delayMs + durations.getValue(step.primitive.id)
        }
        return composition.compose()
    }

    private fun waveform(waveform: Waveform): VibrationEffect {
        // Without amplitude control every "on" segment plays at the device's default strength.
        val amplitudes = if (vibrator.hasAmplitudeControl()) {
            waveform.amplitudes
        } else {
            waveform.amplitudes.map { if (it == 0) 0 else VibrationEffect.DEFAULT_AMPLITUDE }
        }
        return VibrationEffect.createWaveform(waveform.timingsMs.toLongArray(), amplitudes.toIntArray(), NO_REPEAT)
    }

    private val Primitive.id: Int
        @RequiresApi(Build.VERSION_CODES.S)
        get() = when (this) {
            Primitive.Click -> VibrationEffect.Composition.PRIMITIVE_CLICK
            Primitive.Thud -> VibrationEffect.Composition.PRIMITIVE_THUD
        }

    private companion object {
        const val NO_REPEAT = -1
    }
}
