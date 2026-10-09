package dev.codepassion.hapticengine.demo

import android.content.Context
import android.net.Uri
import android.os.Build

/** What the menu says about the app: its version, and where the project lives. Mirrors `AppInfo.swift`. */
object AppInfo {
    const val SOURCE_CODE = "https://github.com/mjn2max/HapticEngine"

    /** The line to add to a module's `build.gradle.kts`, for the library this demo was built with. */
    const val DEPENDENCY = "implementation(\"dev.codepassion:hapticengine:${BuildConfig.LIBRARY_VERSION}\")"

    /** Such as "Version 1.0 (1)", from the app's version name and code. */
    fun version(context: Context): String {
        val info = context.packageManager.getPackageInfo(context.packageName, 0)
        val code = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) info.longVersionCode else @Suppress("DEPRECATION") info.versionCode.toLong()
        return version(info.versionName, code)
    }

    fun version(name: String?, code: Long): String {
        val marketing = name ?: "–"
        return if (code.toString() == marketing) "Version $marketing" else "Version $marketing ($code)"
    }

    /**
     * A new issue on GitHub, its description started with what a haptics bug depends on: the device, its
     * system, the app's version, and whether it has a vibrator. The reporter sees all of it before posting,
     * and can change it.
     */
    fun newIssue(context: Context, isHapticsSupported: Boolean): Uri =
        newIssue(issueBody(deviceModel, "Android ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})", version(context), isHapticsSupported))

    fun newIssue(body: String): Uri =
        Uri.parse("$SOURCE_CODE/issues/new").buildUpon().appendQueryParameter("body", body).build()

    fun issueBody(device: String, system: String, appVersion: String, isHapticsSupported: Boolean): String = """
        |**What happened?**
        |
        |
        |**What did you expect?**
        |
        |
        |---
        |Device: $device
        |System: $system
        |Demo app: $appVersion
        |Haptics: ${if (isHapticsSupported) "Supported" else "Not supported"}
    """.trimMargin()

    /** The maker and model, such as "Google Pixel 9": which vibrator it has depends on both. */
    val deviceModel: String
        get() = if (Build.MODEL.startsWith(Build.MANUFACTURER, ignoreCase = true)) Build.MODEL else "${Build.MANUFACTURER} ${Build.MODEL}"
}
