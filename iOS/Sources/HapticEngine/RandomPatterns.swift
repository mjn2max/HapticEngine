//
// RandomPatterns.swift
// HapticEngine
//

import CoreHaptics
import Foundation

/// A thousand patterns drawn at random by `iOS/Scripts/GeneratePatterns.swift`, from a fixed seed, so each
/// one is the same on every device and in every version: random once, then fixed, as public patterns must be.
///
/// Each is stored as text, `RandomPatterns.encoded`, written by the generator: events separated by `|`,
/// a tap as `t:time:intensity:sharpness` and a hold as `h:time:intensity:sharpness:duration`. Text rather
/// than a thousand nested array literals, which made the compiler crawl.
enum RandomPatterns {
    static func events(_ index: Int) -> [CHHapticEvent] {
        encoded[index].split(separator: "|").map { event in
            let fields = event.split(separator: ":")
            let number = { (field: Int) in Double(fields[field])! }
            return fields[0] == "h"
                ? HapticPatterns.hold(Float(number(2)), Float(number(3)), at: number(1), for: number(4))
                : HapticPatterns.tap(Float(number(2)), Float(number(3)), at: number(1))
        }
    }
}
