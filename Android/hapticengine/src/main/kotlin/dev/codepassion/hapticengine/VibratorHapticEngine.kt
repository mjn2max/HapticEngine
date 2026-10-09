package dev.codepassion.hapticengine

import android.annotation.SuppressLint
import android.content.Context
import android.media.AudioAttributes
import android.os.Build
import android.os.VibrationAttributes
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.annotation.RequiresApi
import java.util.concurrent.ConcurrentHashMap

internal class VibratorHapticEngine(context: Context, usage: HapticUsage) : HapticEngine {
    private val vibrator: Vibrator =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Vibrator::class.java)
        }

    override val isHapticsSupported: Boolean = vibrator.hasVibrator()

    /** Tells the system which of the user's vibration settings apply. Built once, like the effects. */
    private val attributes: Any =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            VibrationAttributes.createForUsage(usage.vibrationUsage)
        } else {
            AudioAttributes.Builder().setUsage(usage.audioUsage).build()
        }

    /**
     * Each pattern's effect, built the first time it plays, then kept since patterns never change. Not built
     * up front: there are four thousand, and an app plays a few. Two threads racing to build one only do the
     * work twice.
     */
    private val effects = ConcurrentHashMap<HapticPattern, VibrationEffect>()

    /**
     * How long the vibrator plays each primitive, or `null` if it can't play them all. Asked once, on the
     * first pattern made of taps, as each question is a call to the system.
     */
    private val primitiveDurations: Map<Primitive, Int>? by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) supportedPrimitiveDurations() else null
    }

    /** Plays [pattern]. The vibrator cancels whatever it was playing, so patterns never overlap. */
    override fun play(pattern: HapticPattern) {
        if (!isHapticsSupported) return
        val effect = effects.getOrPut(pattern) { makeEffect(pattern) }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            vibrator.vibrate(effect, attributes as VibrationAttributes)
        } else {
            // Replaced by the `VibrationAttributes` overload in Android 13, which is used above.
            @Suppress("DEPRECATION")
            vibrator.vibrate(effect, attributes as AudioAttributes)
        }
    }

    override fun stop() {
        if (isHapticsSupported) vibrator.cancel()
    }

    private fun makeEffect(pattern: HapticPattern): VibrationEffect {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            HapticPatterns.primitives(pattern)?.let { steps -> composition(steps)?.let { return it } }
        }
        return waveform(HapticPatterns.waveform(pattern))
    }

    /** Both primitives' durations, or `null` unless the vibrator plays both. */
    // The IDs always come from `Primitive.id`, which returns only `PRIMITIVE_*` constants; lint can't follow
    // them through a list.
    @SuppressLint("WrongConstant")
    @RequiresApi(Build.VERSION_CODES.S)
    private fun supportedPrimitiveDurations(): Map<Primitive, Int>? {
        val primitives = Primitive.entries
        val ids = primitives.map { it.id }.toIntArray()
        if (!vibrator.areAllPrimitivesSupported(*ids)) return null
        return primitives.zip(vibrator.getPrimitiveDurations(*ids).toList()).toMap()
    }

    /**
     * Haptic primitives, for crisp taps close to iOS. `null` if the vibrator can't play every primitive
     * the pattern needs, or plays one too long to keep the pattern's timing, so the pattern falls back to
     * a waveform as a whole rather than playing partly or late.
     */
    // As above, the IDs are only ever `PRIMITIVE_*` constants.
    @SuppressLint("WrongConstant")
    @RequiresApi(Build.VERSION_CODES.S)
    private fun composition(steps: List<PrimitiveStep>): VibrationEffect? {
        val durations = primitiveDurations ?: return null
        val delays = HapticPatterns.primitiveDelays(steps) { durations.getValue(it) } ?: return null

        val composition = VibrationEffect.startComposition()
        steps.zip(delays) { step, delayMs ->
            composition.addPrimitive(step.primitive.id, step.scale.coerceIn(0f, 1f), delayMs)
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
