//
// AndroidParityTests.swift
// HapticEngineTests
//

import Foundation
import Testing
import HapticEngine

/// The Android library plays the same patterns: the same names, in the same order, with the same events.
/// Android's are copied from these by `Android/scripts/export-patterns.sh`; a pattern changed here without
/// running it fails until it is.
@Suite("Android parity")
struct AndroidParityTests {
    private static let androidSources = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .appending(path: "../../../Android/hapticengine/src/main/kotlin/dev/codepassion/hapticengine")
        .standardized

    /// The enum entries in `HapticPattern.kt`, in order.
    private static func androidNames() throws -> [String] {
        let source = try String(contentsOf: androidSources.appending(path: "HapticPattern.kt"), encoding: .utf8)
        let body = source.components(separatedBy: "public enum class HapticPattern {")[1]
            .components(separatedBy: "public val durationMs")[0]
        return body.split(separator: "\n").compactMap { line in
            let entry = line.trimmingCharacters(in: .whitespaces)
            guard let last = entry.last, last == "," || last == ";",
                  entry.first?.isUppercase == true, !entry.contains(" ") else { return nil }
            return String(entry.dropLast())
        }
    }

    /// Each pattern's encoded events in `HapticPatternData.kt`, in order.
    private static func androidEvents() throws -> [String] {
        let source = try String(contentsOf: androidSources.appending(path: "HapticPatternData.kt"), encoding: .utf8)
        return source.split(separator: "\n").compactMap { line in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard trimmed.hasPrefix("\""), trimmed.hasSuffix("\",") else { return nil }
            return String(trimmed.dropFirst().dropLast(2))
        }
    }

    @Test func androidHasEveryPatternByTheSameName() throws {
        let expected = HapticPattern.allCases.map { $0.rawValue.prefix(1).uppercased() + $0.rawValue.dropFirst() }
        #expect(try Self.androidNames() == expected)
    }

    @Test func androidPlaysTheSameEvents() throws {
        let android = try Self.androidEvents()
        try #require(android.count == HapticPattern.allCases.count)
        for (pattern, encoded) in zip(HapticPattern.allCases, android) {
            let events = encoded.split(separator: ";").map { $0.split(separator: ",").map(String.init) }
            #expect(events.count == pattern.events.count, "\(pattern)")
            for (event, fields) in zip(pattern.events, events) {
                let isTap = fields[0] == "t"
                let levels = isTap ? (fields[2], fields[3]) : (fields[3], fields[4])
                #expect(isTap == (event.kind == .tap), "\(pattern)")
                // Rounded to the millisecond and to a thousandth.
                #expect(abs(Double(fields[1])! / 1000 - event.time) <= 0.0006, "\(pattern)")
                #expect(abs(Float(levels.0)! / 1000 - event.intensity) <= 0.0006, "\(pattern)")
                #expect(abs(Float(levels.1)! / 1000 - event.sharpness) <= 0.0006, "\(pattern)")
                if !isTap {
                    #expect(abs(Double(fields[2])! / 1000 - event.duration) <= 0.0011, "\(pattern)")
                }
            }
        }
    }
}
