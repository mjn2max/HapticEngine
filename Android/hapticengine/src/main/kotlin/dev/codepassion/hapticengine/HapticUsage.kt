package dev.codepassion.hapticengine

import android.media.AudioAttributes
import android.os.Build
import android.os.VibrationAttributes
import androidx.annotation.RequiresApi

/**
 * What the haptics are for. Android applies the user's matching vibration setting, so haptics stay quiet
 * when the user has turned that kind of vibration off, and match the strength they chose.
 *
 * iOS has no equivalent: Core Haptics plays app haptics whenever the device supports them.
 */
public enum class HapticUsage {
    /** Feedback for something the user touched, such as a button or a toggle. Follows "Touch feedback". */
    Touch,

    /** Something that happened without a touch, such as a message arriving. Follows "Notification vibration". */
    Notification,

    /** Part of media or a game, such as an effect timed to audio. Follows "Media vibration". */
    Media,
}

/** The `VibrationAttributes` usage, for Android 13 and later. */
internal val HapticUsage.vibrationUsage: Int
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    get() = when (this) {
        HapticUsage.Touch -> VibrationAttributes.USAGE_TOUCH
        HapticUsage.Notification -> VibrationAttributes.USAGE_NOTIFICATION
        HapticUsage.Media -> VibrationAttributes.USAGE_MEDIA
    }

/** The `AudioAttributes` usage, which Android 12 and earlier use to pick the vibration setting. */
internal val HapticUsage.audioUsage: Int
    get() = when (this) {
        // What system touch feedback uses before `USAGE_TOUCH` existed.
        HapticUsage.Touch -> AudioAttributes.USAGE_ASSISTANCE_SONIFICATION
        HapticUsage.Notification -> AudioAttributes.USAGE_NOTIFICATION
        HapticUsage.Media -> AudioAttributes.USAGE_MEDIA
    }
