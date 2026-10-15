# HapticEngine

Ready-made haptic patterns for **iOS** and **Android**, with the same API on both platforms. Pick one of 4,000
patterns, from a crisp tick to a thunderstorm, and play it with one line. It wraps
[Core Haptics](https://developer.apple.com/documentation/corehaptics) on iOS and
[`Vibrator`](https://developer.android.com/reference/android/os/Vibrator) /
[`VibrationEffect`](https://developer.android.com/reference/android/os/VibrationEffect) on Android.

```swift
haptics.play(.success)                 // iOS
```
```kotlin
haptics.play(HapticPattern.Success)    // Android
```

> **Status:** 1.0. The public API follows [Semantic Versioning](https://semver.org/): it only breaks in a new
> major version.

**Contents:** [Features](#features) · [Requirements](#requirements) · [Installation](#installation) ·
[Quick start](#quick-start) · [Guide](#guide) · [API](#api) · [Platform differences](#platform-differences) ·
[Troubleshooting](#troubleshooting) · [Demo apps](#demo-apps) · [Development](#development)

## Features

- **4,000 patterns, the same on both platforms**: the same names, in the same order, with the same taps and
  holds. A test fails if the two ever differ.
  - **100 built by hand**, for everyday needs: feedback (`tick`, `success`, `warning`, `error`, impacts,
    toggles, drag and drop…), alerts (notification, alarm, ring, SOS…), rhythm, texture, nature (rain,
    thunder, ocean wave…), mechanical (typewriter, lock, engine…) and game (coin, power up, explosion…).
  - **900 in ten families** of ninety, each a variant at nine levels: impacts (`heavyMetalHit`), tap
    counts (`fiveTapsBrisk`), signals (`urgentBell`), meters (`waltzAllegro`), surfaces (`rushOverIce`),
    waves (`fastSwell`), dynamics (`longCrescendo`), weather (`heavyRain`), machines (`redlineEngine`)
    and arcade (`epicLevelUp`).
  - **2,000 in forty more families** of fifty, each a motif at five clearly different levels, such as
    animals (`hugeBark`), grooves (`quickFunk`), notifications (`doubleMail`), Morse code
    (`okInMorseSlow`), and more for the built-in groups, such as `firmButton` and `tripleGem`.
  - **1,000 drawn at random**, once, from a fixed seed, so they never change, each named with a random pair
    of words (`emberNebula`).
  - Every generated pattern is tested to feel different from every other.
- **Inspect any pattern**: how long it plays, and each tap and hold with its timing, strength and
  sharpness, for timing your UI to it or drawing it.
- **Safe to call anywhere**: on devices without haptic hardware every call does nothing, and one engine can
  be shared across threads (it's `Sendable` on iOS).
- **Feels as close to iOS as the phone allows on Android**: on Android 12+ phones that support haptic
  primitives, taps play as primitives; other phones get an equivalent waveform, and phones that can't vary
  strength get on/off vibration.
- **Respects the user's settings on Android**: patterns follow "Touch feedback" by default, or the
  notification or media setting if you choose `HapticUsage.Notification` or `HapticUsage.Media`.
- **Recovers by itself** after the app is backgrounded or the system resets the haptic engine (iOS).
- **Easy to test**: depend on a protocol / interface and swap in a fake for tests and previews.
- **No setup**: no permission to declare, no ProGuard / R8 rules, no dependencies.

## Requirements

| Platform | Minimum | Notes |
|---|---|---|
| iOS | 15.0 | Haptics play on iPhone only. Also builds for Mac Catalyst 15, macOS 13 and tvOS 15, where it reports no haptic hardware. watchOS is not supported (no Core Haptics). Needs Xcode 16 (Swift 6.0) or later. |
| Android | API 26 (8.0) | Needs a device with a vibrator. Your app must compile against SDK 33 or later and use Kotlin 2.1 or later (or Java). |

## Installation

### iOS: Swift Package Manager

In Xcode choose **File › Add Package Dependencies…**, enter the URL below, and add the **HapticEngine**
library to your app target:

```
https://github.com/mjn2max/HapticEngine.git
```

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/mjn2max/HapticEngine.git", from: "1.0.0"),
],
targets: [
    .target(name: "MyApp", dependencies: ["HapticEngine"]),
]
```

### Android: Maven Central

In your module's `build.gradle.kts` (Maven Central is in the default repositories of new projects):

```kotlin
dependencies {
    implementation("dev.codepassion:hapticengine:1.0.0")
}
```

That's all: the `VIBRATE` permission is added to your app's manifest for you, and the library needs no
ProGuard / R8 rules.

## Quick start

Create **one engine** and keep it for as long as you need haptics, for example in your app's model or view
model, then play patterns from it.

### iOS (Swift)

```swift
import HapticEngine

let haptics: any HapticEngineProtocol = HapticEngine()

haptics.play(.success)
haptics.play(.heavyMetalHit)
haptics.stop() // stops the pattern that's playing, if any
```

### Android (Kotlin)

```kotlin
import dev.codepassion.hapticengine.HapticEngine
import dev.codepassion.hapticengine.HapticPattern

val haptics: HapticEngine = HapticEngine(context)

haptics.play(HapticPattern.Success)
haptics.play(HapticPattern.HeavyMetalHit)
haptics.stop() // stops the pattern that's playing, if any
```

`HapticEngine(context)` keeps only the application context, so any `Context` is fine and the engine can
outlive the activity that made it.

You don't need to check `isHapticsSupported` before playing: without haptic hardware `play` does nothing.
Check it only to change your UI, for example to hide a "Haptics" setting.

## Guide

### Where to keep the engine

Make one and share it: making the engine is the expensive part, and each pattern is prepared the first time
it plays, then reused.

**SwiftUI**: own it in your model, and take the protocol so tests can pass a fake:

```swift
import HapticEngine
import Observation

@Observable
final class CheckoutModel {
    private let haptics: any HapticEngineProtocol

    init(haptics: any HapticEngineProtocol = HapticEngine()) {
        self.haptics = haptics
    }

    func pay() async {
        // ...
        haptics.play(.success)
    }
}
```

**Jetpack Compose and ViewModels**: keep it in your view model, or `remember` it in a composable:

```kotlin
class CheckoutViewModel(private val haptics: HapticEngine) : ViewModel() {
    fun pay() {
        // ...
        haptics.play(HapticPattern.Success)
    }
}

// Or in a composable:
val context = LocalContext.current
val haptics = remember { HapticEngine(context) }
Button(onClick = { haptics.play(HapticPattern.Tick) }) { Text("Tap") }
```

### Choosing a pattern

Patterns have the same names on both platforms; on Android the first letter is a capital, so iOS's
`.lightImpact` is `HapticPattern.LightImpact`. Some good places to start:

| For | iOS | Android |
|---|---|---|
| A button or a tap | `.tick`, `.lightImpact`, `.buttonPress` | `Tick`, `LightImpact`, `ButtonPress` |
| A picker or slider moving one step | `.selection` | `Selection` |
| A switch turning on / off | `.toggleOn`, `.toggleOff` | `ToggleOn`, `ToggleOff` |
| Something worked / needs attention / failed | `.success`, `.warning`, `.error` | `Success`, `Warning`, `Error` |
| Long press, drag and drop | `.longPress`, `.dragStart`, `.drop`, `.snap` | `LongPress`, `DragStart`, `Drop`, `Snap` |
| Pull to refresh, delete, undo | `.refresh`, `.delete`, `.undo` | `Refresh`, `Delete`, `Undo` |
| A message or reminder arriving | `.notification`, `.message`, `.reminder` | `Notification`, `Message`, `Reminder` |
| Games | `.coin`, `.levelUp`, `.hit`, `.explosion`, `.victory` | `Coin`, `LevelUp`, `Hit`, `Explosion`, `Victory` |

To find others:

- **Feel them in the demo app** ([below](#demo-apps)): search all 4,000 by name or description, filter by
  group, and copy down the name of the one you like.
- **Read them in your editor**: every pattern is documented, so Xcode's Quick Help and Android Studio's
  quick documentation describe each one as you type `.` or `HapticPattern.`.
- **Family patterns are named by level**, so you can step up or down: `featherWoodHit`, `lightWoodHit` …
  `crushingWoodHit`, or `tinyBark` … `hugeBark`.

### Timing your UI to a pattern

The engine doesn't report when a pattern ends; use its duration. A single tap, like `tick`, lasts 0.

```swift
haptics.play(.levelUp)
try await Task.sleep(for: .seconds(HapticPattern.levelUp.duration)) // seconds; iOS 16+
showReward()
```

```kotlin
haptics.play(HapticPattern.LevelUp)
delay(HapticPattern.LevelUp.durationMs) // milliseconds
showReward()
```

Playing a pattern stops the one before it, so patterns never overlap. `stop()` stops it early.

### Choosing which vibration setting applies (Android)

Android lets users turn kinds of vibration on and off. Patterns follow **Touch feedback** by default, which
suits feedback on something the user touched. For other haptics, choose the setting they follow:

```kotlin
val alerts = HapticEngine(context, HapticUsage.Notification) // follows "Notification vibration"
val game = HapticEngine(context, HapticUsage.Media)          // follows "Media vibration"
```

iOS has no equivalent: Core Haptics plays app haptics whenever the device supports them.

### Inspecting a pattern

Each pattern's taps and holds, in time order, for drawing a timeline or matching an animation to it:

```swift
for event in HapticPattern.heartbeat.events {
    print(event.kind, event.time, event.duration, event.intensity, event.sharpness) // times in seconds
}
```

```kotlin
for (event in HapticPattern.Heartbeat.events) {
    println("${event.kind} ${event.timeMs} ${event.durationMs} ${event.intensity} ${event.sharpness}") // milliseconds
}
```

Intensity and sharpness run from 0 to 1. A tap's duration is 0.

### Tests and previews

Depend on `HapticEngineProtocol` (iOS) or `HapticEngine` (Android) rather than the concrete engine, and pass a
fake. A fake only needs `isHapticsSupported` and `play`; everything else has a default.

```swift
struct SilentHaptics: HapticEngineProtocol {
    var isHapticsSupported = true
    func play(_ pattern: HapticPattern) {}
}

let model = CheckoutModel(haptics: SilentHaptics())
```

```kotlin
class FakeHaptics : HapticEngine {
    override val isHapticsSupported = true
    val played = mutableListOf<HapticPattern>()
    override fun play(pattern: HapticPattern) { played += pattern }
}

val haptics = FakeHaptics()
CheckoutViewModel(haptics).pay()
assertEquals(listOf(HapticPattern.Success), haptics.played)
```

### Java (Android)

```java
HapticEngine haptics = HapticEngineKt.HapticEngine(context);
haptics.play(HapticPattern.Success);
```

## API

| | iOS | Android |
|---|---|---|
| Type to depend on | `protocol HapticEngineProtocol` | `interface HapticEngine` |
| Create | `HapticEngine()` | `HapticEngine(context)` |
| Hardware check | `isHapticsSupported: Bool` | `isHapticsSupported: Boolean` |
| Vibration setting to follow | Not applicable | `HapticEngine(context, usage: HapticUsage)`, default `Touch` |
| Play any pattern | `play(_: HapticPattern)` | `play(pattern: HapticPattern)` |
| Stop the pattern playing | `stop()` | `stop()` |
| Every pattern | `HapticPattern.allCases` | `HapticPattern.entries` |
| How long a pattern plays | `HapticPattern.duration: TimeInterval` (seconds) | `HapticPattern.durationMs: Long` |
| A pattern's taps and holds | `HapticPattern.events: [HapticPatternEvent]` (times in seconds) | `HapticPattern.events: List<HapticPatternEvent>` (times in milliseconds) |
| Shorthands for the first ten | `startSimpleHaptic()`, `startComplexHaptic()`, `startTickHaptic()`, `startSuccessHaptic()`, `startWarningHaptic()`, `startErrorHaptic()`, `startHeartbeatHaptic()`, `startKnockHaptic()`, `startRumbleHaptic()`, `startPulseHaptic()` | Same |

`stop()` and the `start…Haptic()` shorthands come from a protocol extension on iOS and default interface
methods on Android, so your own implementations only provide `isHapticsSupported` and `play`.

## Platform differences

The API and patterns are the same; these are the differences to know about.

| | iOS | Android |
|---|---|---|
| Pattern names | `.heavyMetalHit` | `HapticPattern.HeavyMetalHit` |
| Times | Seconds (`duration`, `event.time`) | Milliseconds (`durationMs`, `event.timeMs`) |
| User settings | None for app haptics | Follows the setting for the `HapticUsage` you choose |
| Other vibrations while a pattern plays | Play together | Stop the pattern: a phone has one vibrator |
| Sharpness | Every tap and hold | Taps only, as crisp or dull haptic primitives, on Android 12+ phones that support them; holds play at their strength only |
| How it feels | Much the same on every iPhone with a Taptic Engine | Depends on the phone's vibrator: see [device testing](docs/device-testing.md) |
| App size added | About 1 MB of code (arm64, before App Store compression) | About 350 KB |

On Android, any other vibration, such as your app's own `performHapticFeedback` or the keyboard's, stops a
pattern that's still playing. If your UI makes its own haptics, hold them until the pattern ends, using
`HapticPattern.durationMs`, as the demo does.

## Troubleshooting

**Nothing is felt.**
- The iOS Simulator, iPads, Macs and most Android emulators have no haptic hardware: `isHapticsSupported`
  is `false` and nothing plays. Use a physical phone.
- On Android, check the setting your engine follows is on: by default **Settings › Sound & vibration ›
  Vibration & haptics › Touch feedback**, and that vibration isn't off for the phone as a whole.
- Very faint patterns can be hard to feel on some phones; try a stronger one, such as `success`.

**A pattern is cut short on Android.** Another vibration started: see [Platform differences](#platform-differences).

**A pattern feels flatter on Android than on iOS.** Phones without haptic primitives play patterns as a
plain vibration, and phones without amplitude control play every vibration at one strength. The timing is
the same; the feel depends on the vibrator.

**Haptics stop when the app goes to the background (iOS).** Core Haptics only plays in the foreground. The
engine restarts by itself when the app comes back.

## Demo apps

Each platform has a demo app, built the same way on both, to feel every pattern before you use it: browse all
4,000 in a grid or list, search them by name or description, filter by group, and star favorites (touch and
hold a pattern, or tap the star in the now-playing bar) to find them again under **Favorites**, or find the
ones you played under **Recent** and **History**. The now-playing bar opens to show the pattern's
description, a timeline of its taps and holds, and similar patterns to try.

- **iOS:** open `iOS/Example/HapticEngineDemo.xcodeproj`. To run on an iPhone, copy
  `iOS/Example/Config/Signing.local.xcconfig.template` to `Signing.local.xcconfig` and set your Team ID.
  To try the UI in the Simulator, add `-MockHaptics YES` to the scheme's launch arguments.
- **Android:** open the `Android/` folder in Android Studio and run the `example` configuration. A debug
  build takes `--es haptics mock` to play nothing, or `--es haptics none` to show a phone without a
  vibrator, for example
  `adb shell am start -n dev.codepassion.hapticengine.demo/.MainActivity --es haptics none`.

Haptics can't be felt in the iOS Simulator or most Android emulators. Use a physical phone.

## Project structure

```
HapticEngine/
├── Package.swift            # Swift package manifest (must stay at the repo root)
├── iOS/
│   ├── Sources/HapticEngine # Swift library
│   ├── Tests/               # Swift Testing unit tests
│   └── Example/             # SwiftUI demo app
├── Android/                 # Gradle project
│   ├── hapticengine/        # Kotlin library
│   ├── example/             # Jetpack Compose demo app
│   └── scripts/             # Copies the iOS patterns to Android
├── docs/                    # Device testing checklist
└── .github/                 # CI and Dependabot
```

## Development

```sh
# iOS
swift test

# iOS demo unit tests: search, filters, favorites, the activity log and what's saved (seconds)
xcodebuild test -project iOS/Example/HapticEngineDemo.xcodeproj -scheme HapticEngineDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17e' -only-testing:HapticEngineDemoTests

# iOS demo unit and UI tests: the UI tests drive search, scrolling and navigation like a person would
# (about 10 minutes)
xcodebuild test -project iOS/Example/HapticEngineDemo.xcodeproj -scheme HapticEngineDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17e'

# Android library and demo unit tests, lint and the API check (JDK 17+; Android Studio's bundled JDK works)
cd Android && ./gradlew check :example:assembleDebug
```

Patterns are defined once, on iOS, in `iOS/Sources/HapticEngine/HapticPatterns.swift` and the files
described below. Android plays copies of them: after changing a pattern, run
`Android/scripts/export-patterns.sh` from the repository root on a Mac, which writes the Android entries
(`HapticPattern.kt`), their events (`HapticPatternData.kt`) and the Android demo's names, descriptions and
categories (`PatternDetailsData.kt`), then run `./gradlew :hapticengine:apiDump` and commit it all.
`AndroidParityTests` on iOS fails until the copies match. The first ten patterns are also held to exact
specs in the tests on both sides; the rest to shared rules. How Android plays them, as haptic primitives
or a waveform, is in `HapticPatterns.kt` and `VibratorHapticEngine.kt`. A change to how a pattern feels
also needs the [device testing checklist](docs/device-testing.md).

The 2,900 family patterns, and the 1,000 drawn at random, are generated. How each family feels is in
`iOS/Sources/HapticEngine/PatternFamilies.swift` and `MotifFamilies.swift`, and changing it needs nothing
else; the tests check every new pattern still feels distinct from all the others. Their cases, names,
descriptions, symbols and demo categories come from `iOS/Scripts/GeneratePatterns.swift`: after changing a
name there, run `swift iOS/Scripts/GeneratePatterns.swift` from the repository root and commit what it
writes. Renaming a family pattern changes the public API, and a test fails until it's acknowledged.

The Android public API is recorded in `Android/hapticengine/api/hapticengine.api`, and `check` fails if
it changes without that file. After an intended API change, run `./gradlew :hapticengine:apiDump` and
commit the file. On iOS, pull requests report API changes against the latest release.

## Versioning

The project follows [Semantic Versioning](https://semver.org). iOS and Android share one version
number: a git tag such as `1.2.0` (no `v` prefix) is the Swift package version, and the Android
`VERSION_NAME` in `Android/gradle.properties` matches it. Changes are listed in
[CHANGELOG.md](CHANGELOG.md).

To release, set `VERSION_NAME`, add a `## [x.y.z]` section to the changelog, and push the tag. The release
workflow checks the versions match, publishes the Android library to Maven Central for review at
central.sonatype.com, and creates the GitHub release from the changelog.

## Contributing

Pull requests are welcome. For larger changes, please open an issue first. Any change to the public
API or to a pattern should land on both platforms in the same pull request.

## License

MIT. See [LICENSE](LICENSE).
