# HapticEngine

`HapticEngine` is a lightweight cross-platform framework designed to simplify and standardize haptic feedback integration across iOS and Android applications. Built with native APIs and clean architecture, it provides developers a consistent interface to trigger device vibrations and tactile responses.

---

## 🚀 Features

- ✅ Simple API for triggering haptic feedback
- 📱 Native support for iOS (via `CoreHaptics`)
- 🤖 Android support with Kotlin using `Vibrator` and `VibrationEffect`
- 🧪 Easy integration into SwiftUI or UIKit
- 🛠 Designed for modular use via Swift Package Manager or Android Gradle
- 🔄 Supports basic haptic patterns and custom effect triggers

---

## 📦 Installation

### iOS (Swift) - Usage

#### Using Swift Package Manager

1. Open Xcode and go to **File > Add Packages**.
2. Add the following URL: `https://github.com/mjn2max/HapticEngine.git`
3. Choose the `HapticEngine` package and integrate it into your app target.

---

## 🛠 Usage

### iOS (Swift)

```swift
import HapticEngine

// Trigger simple success feedback
HapticEngine.shared.trigger(.success)

// Trigger a custom impact
HapticEngine.shared.trigger(.impact(style: .medium))
```

### Android (Kotlin)

```kotlin
import com.hapticengine.HapticEngine

// Trigger basic vibration
HapticEngine.triggerSuccessFeedback(context)

// Trigger custom vibration duration
HapticEngine.vibrate(context, durationMillis = 150)
```

## 📚 API Reference

### iOS

```swift
enum HapticType {
    case success
    case warning
    case error
    case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    case selection
}
```

### Android

```kotlin
// TODO: Add code here
```

## 📁 Project Structure

```
HapticEngine/
├── iOS/
│   └── HapticEngine.swift
├── Android/
│   └── HapticEngine.kt
└── README.md
```

## 🧪 Example App

A sample demo app is available in the Example/ folder showing usage in both SwiftUI (iOS) and Jetpack Compose (Android).

## ✅ Requirements

- iOS 13.0+ (Swift)
- Android API Level 26+ (Kotlin)

## 📄 License

MIT License. See LICENSE for more information.

## ✨ Contributions

Pull requests are welcome! For major changes, please open an issue first to discuss what you’d like to change.
