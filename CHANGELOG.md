# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project uses
[Semantic Versioning](https://semver.org/). iOS and Android share version numbers.

## [Unreleased]

## [1.0.0] - 2026-10-03

### Added
- `stop()` on both platforms, to stop the pattern that is playing. It has a default implementation that
  does nothing, so existing conforming types and fakes keep compiling.
- iOS: 3,990 more patterns, for 4,000 in all, iOS only for now; play them with `play(_:)`. Ninety are built
  by hand: feedback, alerts, rhythm, texture, nature, mechanical and game patterns such as `toggleOn`,
  `alarm`, `drumroll`, `purr`, `thunder`, `typewriter` and `coin`. The other 900 come in ten families of
  ninety, each a variant at nine levels: impacts, tap counts, signals, meters, surfaces, waves, dynamics,
  weather, machines and arcade, such as `heavyMetalHit`, `waltzAllegro` and `epicLevelUp`. The last 1,000
  come in twenty families of fifty, each a motif at five levels, such as `hugeBark`, `quickFunk`,
  `doubleMail` and `okInMorseSlow`, each tested to feel different from every other pattern. A further
  1,000 join the seven built-in groups, such as `firmButton` in Feedback and `tripleGem` in Game, and
  1,000 more are drawn at random from a fixed seed, such as `emberNebula`, all tested the same way.
- Android: apps can compile against SDK 33 or later; the library no longer asks for the SDK it was built
  with (36.1).
- iOS demo: a filter panel in place of the filter menu: All, Favorites, Recent, the seven built-in groups and
  the ten pattern families as tiles with their counts, all in sight at once. A sheet on iPhone, a popover on
  iPad.
- iOS demo: a Recent filter, the patterns played lately, newest first, each once.
- iOS demo: the layout moved to the menu page; choosing one goes back to the patterns. The activity log is
  now called History.
- iOS demo on iPad and other devices without haptics: patterns can still be tapped to show their card and
  timeline, marked as not felt. The full-size card stops at about a phone's height, and the list at a
  readable width.
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
- iOS demo: smoother. Resizing the now-playing bar no longer updates the whole screen on every frame,
  only the patterns' fade; its details are no longer rebuilt as it's dragged; playing a pattern updates
  only the tiles that start or stop playing; and search folds each pattern's words once instead of on
  every keystroke. Patterns are handed to the engine off the main thread, so restarting an idle engine
  can't stall a tap's animation.
- iOS demo: reorganized by feature, with what's saved in one `Preferences` store, which patterns show in
  a testable `PatternCatalog`, and the iOS 26 fallbacks in one file. New unit tests cover search,
  filters, favorites, the activity log, saved preferences and every SF Symbol name.
- iOS demo: text without letters or digits, such as "-", no longer counts as a search that lists every
  pattern.
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
- iOS: reading any pattern's `duration` or `events` no longer builds every pattern's events first; each is
  built the first time it's asked for.
- iOS demo: on iPad the list could start partway down, with the first section under the navigation bar,
  as the window opened at launch.
- iOS demo: changing the layout in the filter menu now closes the menu, as picking a filter does.

### Removed
- watchOS support. Core Haptics isn't available there, so the package doesn't build for watchOS.

[Unreleased]: https://github.com/mjn2max/HapticEngine/compare/1.0.0...HEAD
[1.0.0]: https://github.com/mjn2max/HapticEngine/releases/tag/1.0.0
