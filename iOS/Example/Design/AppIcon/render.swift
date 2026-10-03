// Renders the demo's app icon from ripple.svg into the asset catalog: the icon, and the dark and tinted
// versions the home screen uses in those appearances. Opaque, as App Store icons must be.
//
//     swift iOS/Example/Design/AppIcon/render.swift

import AppKit
import Foundation

let iconURL = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
let sourceURL = iconURL.appendingPathComponent("ripple.svg")
let outputURL = iconURL.appendingPathComponent("../../HapticEngineDemo/Assets.xcassets/AppIcon.appiconset", isDirectory: true)
let source = try String(contentsOf: sourceURL, encoding: .utf8)

func replacing(_ source: String, _ replacements: [(String, String)]) -> String {
    replacements.reduce(source) { result, pair in result.replacingOccurrences(of: pair.0, with: pair.1) }
}

// Dark: the rings take the color, on a deep plum.
let dark = replacing(source, [
    ("#FF7A59", "#32172D"), ("#FF2D78", "#100D20"),
    ("#FFFFFF", "#FF9ABB"), ("stop-opacity=\"0.3\"", "stop-opacity=\"0.12\""),
])
// Tinted: white rings on black, which the system tints.
let tinted = replacing(source, [
    ("#FF7A59", "#000000"), ("#FF2D78", "#000000"), ("stop-opacity=\"0.3\"", "stop-opacity=\"0\""),
])

func render(_ svg: String, to filename: String) throws {
    guard let image = NSImage(data: Data(svg.utf8)) else { fatalError("Couldn't decode the SVG for \(filename)") }
    let size = 1024
    // No alpha channel: drawn over black, which the icon's background covers.
    guard let context = CGContext(
        data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
        space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    ) else { fatalError("Couldn't make a bitmap for \(filename)") }
    context.setFillColor(.black)
    context.fill(CGRect(x: 0, y: 0, width: size, height: size))
    NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
    image.draw(in: CGRect(x: 0, y: 0, width: size, height: size))
    NSGraphicsContext.current = nil
    guard let png = NSBitmapImageRep(cgImage: context.makeImage()!).representation(using: .png, properties: [:]) else {
        fatalError("Couldn't encode \(filename)")
    }
    try png.write(to: outputURL.appendingPathComponent(filename))
}

try render(source, to: "AppIcon-light.png")
try render(dark, to: "AppIcon-dark.png")
try render(tinted, to: "AppIcon-tinted.png")
