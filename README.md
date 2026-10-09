# HapticEngine

A small haptics library for **iOS** and **Android** with the same API on both platforms. It wraps
[Core Haptics](https://developer.apple.com/documentation/corehaptics) on iOS and
[`Vibrator`](https://developer.android.com/reference/android/os/Vibrator) /
[`VibrationEffect`](https://developer.android.com/reference/android/os/VibrationEffect) on Android.

> **Status:** 1.0. The public API follows [Semantic Versioning](https://semver.org/): it only breaks in a new
> major version.

## Features

- Ten built-in patterns, defined once and held to the same spec on both platforms:
  - **Simple:** one sharp tap, then nine taps of rising strength over about one second.
  - **Complex:** four 1.5 second segments: medium, hard, soft, hard.
  - **Feedback:** tick, success, warning and error.
  - **Rhythm and texture:** heartbeat, knock, rumble and pulse.
- 3,990 more patterns, for 4,000 in all, on both platforms. On Android each is named as on iOS with a
  capital first letter: iOS's `heavyMetalHit` is `HapticPattern.HeavyMetalHit`.
  - **90 built by hand**, in seven groups: feedback (impacts, toggles, drag and drop…), alerts
    (notification, alarm, ring, SOS…), rhythm, texture, nature (rain, thunder, ocean wave…), mechanical
    (typewriter, lock, engine…) and game (coin, power up, explosion…).
  - **900 in ten families** of ninety, each a variant at nine levels: impacts (`heavyMetalHit`), tap
    counts (`fiveTapsBrisk`), signals (`urgentBell`), meters (`waltzAllegro`), surfaces (`rushOverIce`),
    waves (`fastSwell`), dynamics (`longCrescendo`), weather (`heavyRain`), machines (`redlineEngine`)
    and arcade (`epicLevelUp`).
  - **1,000 in twenty more families** of fifty, each a motif at five clearly different levels: animals
    (`hugeBark`), emotions, sports, instruments, vehicles, controls, body, kitchen, tools, space, ocean,
    city, puzzle, grooves (`quickFunk`), notifications (`doubleMail`), clocks, elements, magic, Morse code
    (`okInMorseSlow`) and electronics. Each one is tested to feel different from every other pattern.
  - **1,000 more in the seven built-in groups**, in sets of fifty at five levels: buttons, toggles,
    gestures and results in feedback (`firmButton`), chimes, calls and warnings in alerts, beats, pulses
    and footwork in rhythm, grains, hums and swells in texture, creatures, water and sky in nature, parts
    and devices in mechanical, and moves and rewards in game (`tripleGem`). Tested the same way.
  - **1,000 drawn at random**, once, from a fixed seed, so they never change: random taps and holds, each
    named with a random pair of words (`emberNebula`) and listed with the built-in group its style suits.
    Tested the same way.
- On Android 12+ phones that support them, taps play as haptic primitives, which feel much closer to
  iOS than a plain vibration. Other phones get an equivalent waveform.
- Safe to call anywhere: on devices without haptic hardware every call does nothing, and one engine can
  be shared across threads (it's `Sendable` on iOS).
- Respects the user's vibration settings on Android: patterns follow "Touch feedback" by default, or the
  notification or media setting if you choose `HapticUsage.Notification` or `HapticUsage.Media`.
- Recovers automatically after the app is backgrounded or the system resets the haptic engine (iOS).
- Falls back to on/off vibration on Android phones that can't vary vibration strength.
- On Android a phone has one vibrator, so any other vibration, such as your app's own
  `performHapticFeedback` or the keyboard's, stops a pattern that's still playing. On iOS they play together.
  Hold your own UI haptics until a pattern ends, using `HapticPattern.durationMs`, as the demo does.
- A protocol / interface you can mock in tests and previews.

## Requirements

| Platform | Minimum | Notes |
|---|---|---|
| iOS | 15.0 | Haptics play on iPhone only. Also builds for Mac Catalyst 15, macOS 13 and tvOS 15, where it reports no haptic hardware. watchOS is not supported (no Core Haptics). |
| Android | API 26 (8.0) | Needs a device with a vibrator. The `VIBRATE` permission is added to your app automatically. |

Using the Swift package needs Xcode 16 (Swift 6.0) or later. The Android library needs Kotlin 2.1 or later.
Building the demo apps needs Xcode 27 for iOS and JDK 17+ for Android.

## Installation

### iOS: Swift Package Manager

In Xcode choose **File › Add Package Dependencies…** and enter:

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

In your module's `build.gradle.kts`:

```kotlin
dependencies {
    implementation("dev.codepassion:hapticengine:1.0.0")
}
```

## Usage

Create one engine and keep it, for example in your view model. Both platforms have the same members.

### iOS (Swift)

```swift
import HapticEngine

let haptics: any HapticEngineProtocol = HapticEngine()

if haptics.isHapticsSupported {
    haptics.play(.success)
}
haptics.startComplexHaptic() // shorthand for play(.complex); no-op without haptic hardware
```

### Android (Kotlin)

```kotlin
import dev.codepassion.hapticengine.HapticEngine
import dev.codepassion.hapticengine.HapticPattern
import dev.codepassion.hapticengine.HapticUsage

val haptics: HapticEngine = HapticEngine(context)

if (haptics.isHapticsSupported) {
    haptics.play(HapticPattern.Success)
}
haptics.startComplexHaptic() // shorthand for play(HapticPattern.Complex); no-op without a vibrator

// For haptics that aren't feedback on a touch, choose the vibration setting they follow:
val alerts = HapticEngine(context, HapticUsage.Notification)
```

### API

| | iOS | Android |
|---|---|---|
| Type to depend on | `protocol HapticEngineProtocol` | `interface HapticEngine` |
| Create | `HapticEngine()` | `HapticEngine(context)` |
| Hardware check | `isHapticsSupported: Bool` | `isHapticsSupported: Boolean` |
| Vibration setting to follow | Not applicable | `HapticEngine(context, usage: HapticUsage)`, default `Touch` |
| Play any pattern | `play(_: HapticPattern)` | `play(pattern: HapticPattern)` |
| Stop the pattern playing | `stop()` | `stop()` |
| Simple pattern | `startSimpleHaptic()` | `startSimpleHaptic()` |
| Complex pattern | `startComplexHaptic()` | `startComplexHaptic()` |
| Tick, success, warning, error | `startTickHaptic()`, `startSuccessHaptic()`, `startWarningHaptic()`, `startErrorHaptic()` | Same |
| Heartbeat, knock, rumble, pulse | `startHeartbeatHaptic()`, `startKnockHaptic()`, `startRumbleHaptic()`, `startPulseHaptic()` | Same |
| How long a pattern plays | `HapticPattern.duration: TimeInterval` (seconds) | `HapticPattern.durationMs: Long` |
| A pattern's taps and holds | `HapticPattern.events: [HapticPatternEvent]` (times in seconds) | `HapticPattern.events: List<HapticPatternEvent>` (times in milliseconds) |

On both platforms an implementation only provides `isHapticsSupported` and `play`; `stop()` (which does
nothing by default) and the `start…Haptic()` shorthands come from a protocol extension on iOS and default
interface methods on Android.

For tests and previews, pass your own implementation of the protocol / interface.

## Demo apps

Each platform has a demo app: every pattern in a grid or list, a now-playing card with the pattern's
description and progress, and an activity history you can replay from, swipe to delete, or start from
suggestions when it's empty.

Both demos are built for the 4,000 patterns: search them all, filter by category from the
button beside search, and star favorites (touch and hold a pattern, or tap the star by the now-playing card) to
find them again under **Favorites**. To try the iOS UI in the Simulator, which has no haptic hardware, add
`-MockHaptics YES` to the scheme's launch arguments. A debug build of the Android demo takes
`--es haptics mock` to play nothing, or `--es haptics none` to show a phone without a vibrator, for example
`adb shell am start -n dev.codepassion.hapticengine.demo/.MainActivity --es haptics none`.

- **iOS:** open `iOS/Example/HapticEngineDemo.xcodeproj`. To run on an iPhone, copy
  `iOS/Example/Config/Signing.local.xcconfig.template` to `Signing.local.xcconfig` and set your Team ID.
- **Android:** open the `Android/` folder in Android Studio and run the `example` configuration.

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
│   └── example/             # Jetpack Compose demo app
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
