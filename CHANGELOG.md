# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project uses
[Semantic Versioning](https://semver.org/). iOS and Android share version numbers.

## [Unreleased]

### Added
- iOS: 90 more patterns, for 100 in all: feedback, alerts, rhythm, texture, nature, mechanical and game
  patterns such as `toggleOn`, `alarm`, `drumroll`, `purr`, `thunder`, `typewriter` and `coin`. They
  are iOS only for now; play them with `play(_:)`.
- iOS demo: redesigned for 100 patterns. Search them all from the navigation bar, filter by category
  from a menu beside search, and star favorites from a pattern's context menu or the now-playing card.
  The filter, layout and favorites are remembered. The now-playing card moved to the bottom, and the
  layout picker and activity log into a menu at the top. The cards layout was removed; grid and list remain.
- iOS: `HapticPattern.events`, the taps and holds that make up a pattern with their timing, strength and
  sharpness, for showing or inspecting a pattern.
- iOS demo: the now-playing bar is always shown, one height in every state, with a tip before the first
  play and a warning on devices without haptics. Tap it or swipe it up to see the pattern's full
  description and a timeline of its taps and holds.
- iOS demo: the now-playing bar keeps one solid surface at every size, so its colors no longer shift as
  it's resized. Opened fully, it's always the same height, with the category's patterns pinned along
  its bottom and the one showing marked: trying them one after another never moves the bar or the row,
  and details scrolled to their end stay there. Its icon keeps its colors while a pattern plays, shown
  by the ring and a bounce instead. Made smaller, its details scroll fully back to their top, even
  right after a flick, so the summary's timeline is never cut off.
- iOS demo: the now-playing bar is a capsule when collapsed, with a round icon and a round progress
  ring drawn concentric with its ends, so their curves line up as a pattern plays.
- iOS demo: a compact header: a menu for the layout and activity log, the title inline with the filter
  and its pattern count beneath, and filter and search sharing a capsule. With a filter on, the line
  under the title is a token that clears it in one tap, and a filtered list ends with "Show All".
  Tapping search stretches it into a field up to the menu, so it takes no room from the patterns.
  Scrolling puts the keyboard away and keeps the search. Search matches the start of words, so "rain" no
  longer finds "fine-grained".
- iOS demo: UI tests for search, covering typing, clearing, cancelling, scrolling, playing a result and
  navigating away and back.
- iOS demo: `-MockHaptics YES` launch argument (debug builds) to try the UI in the Simulator.
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
- iOS: each pattern is built once, the first time it plays, instead of on every play.
- iOS: the complex pattern is now four continuous segments instead of 60 overlapping events.
- iOS: errors are logged with `os.Logger` instead of `print`.

### Fixed
- iOS: haptics now recover after the app is backgrounded or the haptic engine is reset.
- iOS: removed a silent zero-strength tap at the start of the simple pattern.

### Removed
- watchOS support. Core Haptics isn't available there, so the package doesn't build for watchOS.
