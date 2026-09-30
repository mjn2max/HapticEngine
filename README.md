# HapticEngine

A small haptics library for **iOS** and **Android** with the same API on both platforms. It wraps
[Core Haptics](https://developer.apple.com/documentation/corehaptics) on iOS and
[`Vibrator`](https://developer.android.com/reference/android/os/Vibrator) /
[`VibrationEffect`](https://developer.android.com/reference/android/os/VibrationEffect) on Android.

> **Status:** pre-1.0. The API may change between minor versions until 1.0.0.

## Features

- Ten built-in patterns, defined once and held to the same spec on both platforms:
  - **Simple:** one sharp tap, then nine taps of rising strength over about one second.
  - **Complex:** four 1.5 second segments: medium, hard, soft, hard.
  - **Feedback:** tick, success, warning and error.
  - **Rhythm and texture:** heartbeat, knock, rumble and pulse.
- On iOS, 90 more patterns, for 100 in all, in seven groups: feedback (impacts, toggles, drag and
  drop…), alerts (notification, alarm, ring, SOS…), rhythm, texture, nature (rain, thunder, ocean
  wave…), mechanical (typewriter, lock, engine…) and game (coin, power up, explosion…). These are iOS
  only for now; play them with `play(_:)`.
- On Android 12+ phones that support them, taps play as haptic primitives, which feel much closer to
  iOS than a plain vibration. Other phones get an equivalent waveform.
- Safe to call anywhere: on devices without haptic hardware every call does nothing, and one engine can
  be shared across threads (it's `Sendable` on iOS).
- Respects the user's vibration settings on Android: patterns follow "Touch feedback" by default, or the
  notification or media setting if you choose `HapticUsage.Notification` or `HapticUsage.Media`.
- Recovers automatically after the app is backgrounded or the system resets the haptic engine (iOS).
- Falls back to on/off vibration on Android phones that can't vary vibration strength.
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
    .package(url: "https://github.com/mjn2max/HapticEngine.git", from: "0.1.0"),
],
targets: [
    .target(name: "MyApp", dependencies: ["HapticEngine"]),
]
```

### Android: Maven Central

Available from the first release (0.1.0). In your module's `build.gradle.kts`:

```kotlin
dependencies {
    implementation("dev.codepassion:hapticengine:0.1.0")
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
| Simple pattern | `startSimpleHaptic()` | `startSimpleHaptic()` |
| Complex pattern | `startComplexHaptic()` | `startComplexHaptic()` |
| Tick, success, warning, error | `startTickHaptic()`, `startSuccessHaptic()`, `startWarningHaptic()`, `startErrorHaptic()` | Same |
| Heartbeat, knock, rumble, pulse | `startHeartbeatHaptic()`, `startKnockHaptic()`, `startRumbleHaptic()`, `startPulseHaptic()` | Same |
| How long a pattern plays | `HapticPattern.duration: TimeInterval` (seconds) | `HapticPattern.durationMs: Long` |

On both platforms an implementation only provides `isHapticsSupported` and `play`; the `start…Haptic()`
shorthands come from a protocol extension on iOS and default interface methods on Android.

For tests and previews, pass your own implementation of the protocol / interface.

## Demo apps

Each platform has a demo app with the same screens: every pattern in a grid, card or list layout (the iOS
demo also has search across its 100 patterns), a
now-playing card with the pattern's description and progress, and an activity history you can replay
from, swipe to delete, or start from suggestions when it's empty.

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

# Android (JDK 17+; Android Studio's bundled JDK works)
cd Android && ./gradlew check :example:assembleDebug
```

Pattern definitions live in `iOS/Sources/HapticEngine/HapticPatterns.swift` and
`Android/hapticengine/src/main/kotlin/dev/codepassion/hapticengine/HapticPatterns.kt`. For the ten
patterns on both platforms, change both together and update the tests on both sides so the platforms
stay in step. The iOS-only patterns are held to shared rules in the iOS tests instead of exact specs. A change to how a pattern
feels also needs the [device testing checklist](docs/device-testing.md).

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
