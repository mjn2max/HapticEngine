# Device testing

Haptics can't be felt in the iOS Simulator or an Android emulator, and they feel different on every
vibration motor. Unit tests check that each pattern has the right events; only a person holding a phone
can check that it feels right. Run this checklist before every release that changes a pattern or how
patterns are played, and record the results in the release pull request.

## Devices

Cover each kind of hardware at least once:

| Kind | Why | Example |
|---|---|---|
| iPhone, current generation | Reference feel for every pattern | iPhone 17 |
| iPhone, oldest with a Taptic Engine you support | Older Taptic Engines are weaker | iPhone XR |
| Android with haptic primitives (Android 12+) | Plays taps as primitives, closest to iOS | Pixel 8 or later |
| Android with amplitude control but no primitives | Plays everything as a waveform | Many mid-range Samsung and Motorola phones |
| Android without amplitude control | Every vibration plays at one strength | Budget phones with an ERM motor |

To see which kind an Android phone is, connect it and run:

```sh
adb shell dumpsys vibrator_manager | grep -E "capabilities =|supportedPrimitives"
```

`COMPOSE_EFFECTS` and a `supportedPrimitives` list containing `CLICK` and `THUD` mean primitives;
`AMPLITUDE_CONTROL` means amplitude control.

## What each pattern should feel like

Play each one from the demo app, on each device.

| Pattern | Should feel like | Watch for |
|---|---|---|
| Simple | One sharp tap, then nine taps getting stronger | The first ramp taps are faint by design, but should be felt |
| Complex | Four steady buzzes: medium, strong, soft, strong | Clear steps between the levels |
| Tick | One light, crisp tap | Felt at all, especially on budget phones |
| Success | A soft tap, then a firmer one | The second tap is clearly stronger |
| Warning | A strong tap, then a weaker one | The reverse of Success |
| Error | Three strong taps, quickly | Three distinct taps, not one buzz |
| Heartbeat | Two lub-dub beats | The pairs are easy to tell apart |
| Knock | Three dull taps, evenly spaced | Dull rather than sharp |
| Rumble | A low, steady buzz for under a second | Smooth, no gaps |
| Pulse | Five short, even bursts | Five, evenly spaced |

Also check across patterns:

- A new pattern stops the one still playing: start Complex, then tap Tick during it.
- The same pattern feels alike on iOS and on the Android phone with primitives. Note any pattern that
  doesn't.

## Settings and app state

- **Android touch feedback off** (Settings › Sound & vibration › Vibration & haptics › Touch feedback):
  patterns don't play with the default `HapticUsage.Touch`. Turn it back on and they play again.
- **Android touch feedback strength**: lowering it makes patterns weaker.
- **iOS System Haptics off** (Settings › Sounds & Haptics): record whether patterns still play. The
  README should state the result.
- **Backgrounding**: play a pattern, send the app to the background, return, and play again. It still plays.
- **Low Power Mode (iOS) and Battery Saver (Android)**: record whether patterns still play.

## Checking what Android played

The system logs every vibration with the settings group it used and what it played:

```sh
adb shell dumpsys vibrator_manager | grep dev.codepassion
```

Each line shows `usage:`, which is `TOUCH` for the default `HapticUsage.Touch`, and `played:`, which is
`Primitive=CLICK(...)` or `Primitive=THUD(...)` on phones with primitives, or `Step=...` for a waveform.

## Recording results

Copy this table into the release pull request:

| Device | OS | Kind | Patterns OK | Notes |
|---|---|---|---|---|
| | | | | |
