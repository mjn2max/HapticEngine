#!/bin/sh
# Copies the iOS patterns to Android: the library's pattern entries and events, and the demo's names,
# descriptions, symbols and categories. Run from the repository root on a Mac with Xcode, after changing a
# pattern on iOS (and after `swift iOS/Scripts/GeneratePatterns.swift`), then commit what it writes.
#
# Builds the iOS library for macOS, where Core Haptics can still build the patterns, and runs
# `ExportPatterns.swift` with the iOS demo's descriptions of them.
set -eu

cd "$(git rev-parse --show-toplevel)"
build="$(mktemp -d)"
trap 'rm -rf "$build"' EXIT

xcrun swiftc -O -parse-as-library -emit-library -emit-module -module-name HapticEngine \
    -emit-module-path "$build/HapticEngine.swiftmodule" -o "$build/libHapticEngine.dylib" \
    iOS/Sources/HapticEngine/*.swift

xcrun swiftc -O -parse-as-library -I "$build" -L "$build" -lHapticEngine -Xlinker -rpath -Xlinker "$build" \
    -o "$build/export-patterns" \
    Android/scripts/ExportPatterns.swift \
    "iOS/Example/HapticEngineDemo/Model/HapticPattern+Display.swift" \
    "iOS/Example/HapticEngineDemo/Model/HapticPattern+Families.swift"

"$build/export-patterns"
