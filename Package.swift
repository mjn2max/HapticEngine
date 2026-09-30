// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HapticEngine",
    // CoreHaptics is unavailable on watchOS. Haptics only play on iPhone; other
    // platforms build so shared code compiles, and report no haptic hardware.
    platforms: [.iOS(.v15), .macOS(.v13), .macCatalyst(.v15), .tvOS(.v15)],
    products: [
        .library(name: "HapticEngine", targets: ["HapticEngine"]),
    ],
    targets: [
        .target(
            name: "HapticEngine",
            path: "iOS/Sources"
        ),
        .testTarget(
            name: "HapticEngineTests",
            dependencies: ["HapticEngine"],
            path: "iOS/Tests"
        ),
    ]
)
