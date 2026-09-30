# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project uses
[Semantic Versioning](https://semver.org/). iOS and Android share version numbers.

## [Unreleased]

### Added
- iOS: eight new patterns: tick, success, warning, error, heartbeat, knock, rumble and pulse.
- iOS: `HapticPattern` enum and `HapticEngineProtocol.play(_:)` to play any pattern. The
  `start…Haptic()` methods, including the new `startTickHaptic()` and so on, are now shorthands for it.
- Android library (`Android/hapticengine`) with the same API and patterns as iOS, requiring API 26+:
  a `HapticPattern` enum, `HapticEngine.play(pattern)`, and all ten `start…Haptic()` shorthands.
- Android: taps play as haptic primitives on Android 12+ phones that support them, falling back to a
  vibration waveform elsewhere.
- `HapticPattern.duration` (iOS, seconds) and `HapticPattern.durationMs` (Android), to time UI to a
  pattern, since the engine doesn't report when one ends.
- Android: `HapticUsage` and `HapticEngine(context, usage)` to choose which of the user's vibration
  settings apply. The default, `Touch`, follows "Touch feedback".
- Android: published to Maven Central as `dev.codepassion:hapticengine`, with sources and javadoc.
- Release workflow: a version tag publishes the Android library and creates the GitHub release.
- Public API tracking: `check` fails on unrecorded Android API changes, and iOS pull requests report API
  changes against the latest release.
- Device testing checklist in `docs/device-testing.md`.
- Demo apps for iOS (SwiftUI) and Android (Jetpack Compose) with the same screens: grid, card and list
  layouts, a now-playing card, and an activity history with suggestions and swipe to delete.
- Unit tests for the haptic patterns on both platforms.
- CI for iOS and Android, and Dependabot updates.

### Changed
- iOS: the Swift package needs Xcode 16 (Swift 6.0) or later.
- iOS: `HapticEngine` is `Sendable` and safe to call from any thread, and `HapticEngineProtocol` now
  requires `Sendable`. Custom conformers must be `Sendable` too.
- Android: built for Kotlin 2.1 and later, so it doesn't force the newest Kotlin on apps.
- iOS: `HapticEngineProtocol` is now public.
- iOS: `HapticEngine` is now `final` and no longer an `ObservableObject`.
- iOS: custom `HapticEngineProtocol` conformers now implement only `isHapticsSupported` and `play(_:)`.
- iOS: `isHapticsSupported` is `false` if the haptic engine couldn't be created, not only without hardware.
- iOS: playing a pattern now stops the one still playing, matching Android, instead of overlapping it.
- iOS: patterns are built once when the engine is created instead of on every play.
- iOS: the complex pattern is now four continuous segments instead of 60 overlapping events.
- iOS: errors are logged with `os.Logger` instead of `print`.

### Fixed
- iOS: haptics now recover after the app is backgrounded or the haptic engine is reset.
- iOS: removed a silent zero-strength tap at the start of the simple pattern.

### Removed
- watchOS support. Core Haptics isn't available there, so the package doesn't build for watchOS.
