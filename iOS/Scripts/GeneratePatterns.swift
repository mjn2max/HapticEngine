#!/usr/bin/env swift
//
// GeneratePatterns.swift
//
// Writes the 2,900 family patterns: their cases in `HapticPattern`, `HapticPattern.variant` in the library,
// and their names, descriptions, symbols and categories in the demo. How each one feels is in
// `Sources/HapticEngine/PatternFamilies.swift`; this only names them.
//
// Run from the repository root after changing a name here:
//
//     swift iOS/Scripts/GeneratePatterns.swift
//
// Descriptions that give a count, a tempo or a length must stay in step with the formulas in
// `PatternFamilies.swift`; each is noted where it's used.

import Foundation

struct Variant {
    let title: String
    let symbol: String
    /// Used in descriptions.
    let phrase: String
}

struct Level {
    let title: String
    /// Used in descriptions.
    let phrase: String
}

struct Family {
    /// The case of `PatternFamily`, and of the demo's `HapticPattern.Category`.
    let id: String
    let heading: String
    let variants: [Variant]
    let levels: [Level]
    let title: (Variant, Level) -> String
    let subtitle: (Variant, Level, Int) -> String
    /// The demo category it's listed under, when not one of its own: a hand-built group, such as "feedback".
    var category: String? = nil
}

func variants(_ items: [(String, String, String)]) -> [Variant] {
    items.map { Variant(title: $0.0, symbol: $0.1, phrase: $0.2) }
}

func levels(_ items: [(String, String)]) -> [Level] {
    items.map { Level(title: $0.0, phrase: $0.1) }
}

let numbers = ["Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven"]
let timesSaid = ["once", "twice", "three times", "four times", "five times"]
let cyclesSaid = ["once", "one and a half times", "twice", "two and a half times", "three times",
                  "three and a half times", "four times", "four and a half times", "five times"]


// The five-level families: how their levels are named, by how their motifs change.
let size = levels([("Tiny", "tiny"), ("Small", "small"), ("Medium", "medium"), ("Large", "large"), ("Huge", "huge")])
let strength = levels([("Faint", "faint"), ("Soft", "soft"), ("Firm", "firm"), ("Strong", "strong"), ("Intense", "intense")])
let tempo = levels([("Slow", "slow"), ("Easy", "easy"), ("Steady", "steady"), ("Quick", "quick"), ("Rapid", "rapid")])
// Played 1 + level times, as `MotifFamilies.shaped` repeats them.
let repeats = levels([("Single", "once"), ("Double", "twice"), ("Triple", "three times"), ("Quadruple", "four times"), ("Quintuple", "five times")])

/// A family of ten motifs at five levels, titled "Huge Bark" and described "A dog's bark, huge".
func motifFamily(_ id: String, _ heading: String, _ levels: [Level], _ items: [(String, String, String)], in category: String? = nil) -> Family {
    Family(
        id: id,
        heading: heading,
        variants: variants(items),
        levels: levels,
        title: { "\($1.title) \($0.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase), \(level.phrase)" },
        category: category
    )
}

let families: [Family] = [
    Family(
        id: "impacts",
        heading: "Impacts: a hit on a material, from feather-light to crushing",
        variants: variants([
            ("Wood", "tree", "a hollow knock"), ("Metal", "wrench.and.screwdriver", "ringing on"),
            ("Glass", "wineglass", "with a tinkle"), ("Stone", "mountain.2", "dull and solid"),
            ("Rubber", "circle.circle", "bouncing back"), ("Plastic", "cube", "with a click"),
            ("Paper", "doc", "with a rustle"), ("Cloth", "tshirt", "muffled"),
            ("Water", "drop", "with a splash"), ("Ceramic", "cup.and.saucer", "with a clink"),
        ]),
        levels: levels([
            ("Feather", "feather-light"), ("Light", "light"), ("Soft", "soft"), ("Gentle", "gentle"),
            ("Medium", "medium"), ("Firm", "firm"), ("Heavy", "heavy"), ("Hard", "hard"), ("Crushing", "crushing"),
        ]),
        title: { "\($1.title) \($0.title) Hit" },
        subtitle: { variant, level, _ in "A \(level.phrase) hit on \(variant.title.lowercased()), \(variant.phrase)" }
    ),
    Family(
        id: "tapCounts",
        heading: "Tap counts: two to eleven taps, from a lazy pace to a rapid one",
        variants: numbers.enumerated().map { index, number in
            Variant(title: number, symbol: "\(index + 2).circle", phrase: number)
        },
        levels: levels([
            ("Lazy", "lazy"), ("Slow", "slow"), ("Relaxed", "relaxed"), ("Easy", "easy"), ("Steady", "steady"),
            ("Brisk", "brisk"), ("Quick", "quick"), ("Fast", "fast"), ("Rapid", "rapid"),
        ]),
        title: { "\($0.title) Taps, \($1.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase) taps at a \(level.phrase) pace, the last strongest" }
    ),
    Family(
        id: "signals",
        heading: "Signals: attention signals, from calm to critical",
        variants: variants([
            ("Ping", "dot.radiowaves.right", "A crisp ping"), ("Chime", "bell.and.waves.left.and.right", "A chime that rings on"),
            ("Bell", "bell", "A bell that fades"), ("Beep", "speaker.wave.1", "A short beep"),
            ("Buzz", "bolt", "A low buzz"), ("Ding", "bell.badge", "A rising two-note ding"),
            ("Pip", "smallcircle.filled.circle", "A quick double pip"), ("Tone", "waveform", "A long, even tone"),
            ("Siren", "light.beacon.max", "A wavering siren"), ("Horn", "megaphone", "A two-blast horn"),
        ]),
        levels: levels([
            ("Calm", "calmly"), ("Soft", "softly"), ("Gentle", "gently"), ("Clear", "clearly"), ("Firm", "firmly"),
            ("Prompt", "promptly"), ("Pressing", "insistently"), ("Urgent", "urgently"), ("Critical", "with alarm"),
        ]),
        title: { "\($1.title) \($0.title)" },
        // Repeats 1 + level / 2 times, as `PatternFamilies.signal` does.
        subtitle: { variant, level, index in "\(variant.phrase), \(timesSaid[index / 2]) \(level.phrase)" }
    ),
    Family(
        id: "meters",
        heading: "Meters: one bar of a meter, from 60 to 180 beats per minute",
        variants: variants([
            ("March", "figure.walk", "march"), ("Waltz", "figure.dance", "waltz"),
            ("Four-Four", "metronome", "four-four"), ("Five-Four", "5.square", "five-four"),
            ("Jig", "music.note", "jig"), ("Seven-Eight", "7.square", "seven-eight"),
            ("Swing", "music.quarternote.3", "swing"), ("Shuffle", "shuffle", "shuffle"),
            ("Clave", "music.note.list", "son clave"), ("Bossa Nova", "guitars", "bossa nova"),
        ]),
        levels: levels([
            ("Largo", ""), ("Larghetto", ""), ("Adagio", ""), ("Andante", ""), ("Moderato", ""),
            ("Allegretto", ""), ("Allegro", ""), ("Vivace", ""), ("Presto", ""),
        ]),
        title: { "\($0.title), \($1.title)" },
        // 60 + 15 × level beats per minute, as `PatternFamilies.meter` does.
        subtitle: { variant, _, index in "One bar of \(variant.phrase) at \(60 + 15 * index) BPM" }
    ),
    Family(
        id: "surfaces",
        heading: "Surfaces: a finger drawn across a surface, from a crawl to a rush",
        variants: variants([
            ("Sand", "beach.umbrella", ""), ("Gravel", "circle.grid.3x3", ""), ("Silk", "wind", ""),
            ("Velvet", "rectangle.fill", ""), ("Corduroy", "line.3.horizontal", ""),
            ("Brick", "rectangle.split.3x3", ""), ("Tile", "square.grid.3x3", ""), ("Ice", "snowflake", ""),
            ("Bark", "tree", ""), ("Carpet", "rectangle.grid.1x2", ""),
        ]),
        levels: levels([
            ("Crawl", "barely moving"), ("Creep", "creeping"), ("Drift", "drifting"), ("Stroll", "at a stroll"),
            ("Walk", "at a walk"), ("Jog", "jogging"), ("Run", "running"), ("Sprint", "sprinting"), ("Rush", "in a rush"),
        ]),
        title: { "\($1.title) over \($0.title)" },
        subtitle: { variant, level, _ in "A finger across \(variant.title.lowercased()), \(level.phrase)" }
    ),
    Family(
        id: "waves",
        heading: "Waves: waveforms over a second and a half, from one cycle to five",
        variants: variants([
            ("Swell", "water.waves", "Swelling and easing smoothly"), ("Rise", "chart.line.uptrend.xyaxis", "Rising, then dropping back"),
            ("Fall", "chart.line.downtrend.xyaxis", "Falling, then jumping back"), ("Square", "square.on.square", "Switching hard on and off"),
            ("Triangle", "triangle", "Rising and falling evenly"), ("Flutter", "wind", "Flickering crisp and soft"),
            ("Throb", "waveform.path.ecg", "Peaking in sharp throbs"), ("Breath", "lungs", "Breathing softly in and out"),
            ("Ripple", "circle.dotted", "Rippling as it fades"), ("Wobble", "tornado", "Wavering in sharpness"),
        ]),
        levels: levels([
            ("Glacial", ""), ("Languid", ""), ("Slow", ""), ("Easy", ""), ("Moderate", ""),
            ("Lively", ""), ("Fast", ""), ("Rapid", ""), ("Frantic", ""),
        ]),
        title: { "\($1.title) \($0.title)" },
        // 1 + 0.5 × level cycles, as `PatternFamilies.wave` does.
        subtitle: { variant, _, index in "\(variant.phrase), \(cyclesSaid[index])" }
    ),
    Family(
        id: "dynamics",
        heading: "Dynamics: changes in strength or sharpness, from 0.2 to 1.8 seconds long",
        variants: variants([
            ("Crescendo", "arrow.up.right", "Growing steadily stronger"), ("Decrescendo", "arrow.down.right", "Fading steadily weaker"),
            ("Surge", "bolt.horizontal", "A quick rise and a slow fall"), ("Ebb", "arrow.uturn.down", "A slow fall and a small return"),
            ("Climb", "stairs", "Taps climbing in strength"), ("Plunge", "arrow.down.to.line", "Taps dropping in strength"),
            ("Bloom", "sparkle", "Steady, growing sharper"), ("Wilt", "leaf", "Softening and dulling"),
            ("Spike", "chart.bar", "A sharp peak, then a low hum"), ("Plateau", "chart.line.flattrend.xyaxis", "Rising, holding, then falling"),
        ]),
        levels: levels([
            ("Flash", ""), ("Quick", ""), ("Short", ""), ("Measured", ""), ("Medium", ""),
            ("Long", ""), ("Extended", ""), ("Slow", ""), ("Sustained", ""),
        ]),
        title: { "\($1.title) \($0.title)" },
        // 0.2 × (level + 1) seconds, as `PatternFamilies.dynamic` does.
        subtitle: { variant, _, index in
            "\(variant.phrase) over \(String(format: "%.1f", 0.2 * Double(index + 1))) s"
        }
    ),
    Family(
        id: "weather",
        heading: "Weather: weather and water, from faint to extreme",
        variants: variants([
            ("Drizzle", "cloud.drizzle", "Fine, scattered drops"), ("Rain", "cloud.rain", "Drops falling at random"),
            ("Hail", "cloud.hail", "Hard, sharp pellets"), ("Wind", "wind", "Gusts rising and falling"),
            ("Thunder", "cloud.bolt", "A crack, then a rolling rumble"), ("Surf", "water.waves", "Waves rolling in"),
            ("Stream", "drop", "Water running over stones"), ("Tremor", "waveform.path", "The ground shaking"),
            ("Fire", "flame", "A crackling fire"), ("Sleet", "cloud.sleet", "Icy drops in a cold hiss"),
        ]),
        levels: levels([
            ("Faint", "faint"), ("Light", "light"), ("Gentle", "gentle"), ("Moderate", "moderate"), ("Steady", "steady"),
            ("Strong", "strong"), ("Heavy", "heavy"), ("Intense", "intense"), ("Extreme", "extreme"),
        ]),
        title: { "\($1.title) \($0.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase), \(level.phrase)" }
    ),
    Family(
        id: "machines",
        heading: "Machines: machines running, from idle to the redline",
        variants: variants([
            ("Motor", "powerplug", "A humming motor"), ("Engine", "engine.combustion", "An engine's firing strokes"),
            ("Fan", "fan", "Fan blades sweeping past"), ("Drill", "wrench.adjustable", "A drill bit spinning"),
            ("Pump", "arrow.up.arrow.down", "A pump pushing and releasing"), ("Saw", "scissors", "A saw rasping back and forth"),
            ("Gearbox", "gearshape.2", "Gears meshing"), ("Ratchet", "wrench", "A ratchet clicking"),
            ("Clockwork", "clock", "Clockwork ticking"), ("Sewing Machine", "lines.measurement.horizontal", "A needle stitching"),
        ]),
        levels: levels([
            ("Idle", "at idle"), ("Low", "turning slowly"), ("Easy", "at an easy pace"), ("Cruising", "cruising"),
            ("Steady", "running steadily"), ("Busy", "working hard"), ("High", "at high speed"), ("Racing", "racing"),
            ("Redline", "at the redline"),
        ]),
        title: { "\($1.title) \($0.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase), \(level.phrase)" }
    ),
    Family(
        id: "arcade",
        heading: "Arcade: game actions, from tiny to epic",
        variants: variants([
            ("Jump", "arrow.up", "A push upward"), ("Landing", "arrow.down.to.line", "A thud and a settle"),
            ("Hit", "burst", "A strike and a rebound"), ("Dash", "hare", "A quick burst forward"),
            ("Shot", "scope", "A crisp shot and its kick"), ("Charge", "bolt.fill", "Power building up"),
            ("Pickup", "star", "Bright rising taps"), ("Level Up", "arrow.up.circle", "Rising taps and a bright hold"),
            ("Damage", "heart.slash", "A blow and a shake"), ("Shield", "shield", "A shimmering barrier"),
        ]),
        levels: levels([
            ("Tiny", "tiny"), ("Small", "small"), ("Light", "light"), ("Medium", "medium"), ("Big", "big"),
            ("Heavy", "heavy"), ("Huge", "huge"), ("Giant", "giant"), ("Epic", "epic"),
        ]),
        title: { "\($1.title) \($0.title)" },
        subtitle: { variant, level, _ in "\(variant.phrase), \(level.phrase)" }
    ),
    // MARK: Twenty more, ten motifs each at five levels: see PatternFamilies.swift and MotifFamilies.swift.
] + [
    motifFamily("animals", "Animals: animal sounds and movements, from tiny to huge", size, [
        ("Purr", "cat", "A cat's purr"), ("Bark", "dog", "A dog's bark"),
        ("Hoofbeats", "figure.equestrian.sports", "Hooves on the ground"), ("Hop", "hare", "A rabbit's hops"),
        ("Peck", "bird", "A bird pecking"), ("Wingbeat", "bird.fill", "Wings beating"),
        ("Paws", "pawprint", "Soft paws padding"), ("Slither", "lizard", "A snake slithering"),
        ("Bee", "ant", "A bee buzzing"), ("Whale", "fish", "A whale's song"),
    ]),
    motifFamily("emotions", "Emotions: feelings, from tiny to huge", size, [
        ("Joy", "face.smiling", "Rising bright taps"), ("Calm", "leaf", "A slow, soft swell"),
        ("Surprise", "exclamationmark", "A sudden sharp tap"), ("Anger", "flame", "Hard, pounding pulses"),
        ("Sadness", "cloud", "A slowly fading weight"), ("Fear", "bolt.heart", "A quick trembling"),
        ("Love", "heart", "A warm heartbeat"), ("Laughter", "face.smiling.inverse", "Bubbling, bouncing taps"),
        ("Sigh", "wind", "A breath in and out"), ("Excitement", "sparkles", "Taps quickening with excitement"),
    ]),
    motifFamily("sports", "Sports: moments of play, from faint to intense", strength, [
        ("Kick", "figure.soccer", "A boot striking a ball"), ("Dribble", "basketball", "A ball bouncing down"),
        ("Serve", "tennisball", "A toss and a crisp serve"), ("Swish", "figure.basketball", "A clean swish"),
        ("Bat", "baseball", "The crack of a bat"), ("Whistle", "flag", "A referee's whistle"),
        ("Goal", "soccerball", "A goal and a cheer"), ("Volley", "volleyball", "A rally of volleys"),
        ("Punch", "figure.boxing", "Two quick punches"), ("Finish Line", "flag.checkered", "A sprint to the line"),
    ]),
    motifFamily("instruments", "Instruments: notes and hits, from faint to intense", strength, [
        ("Snare", "music.note", "A crisp snare hit"), ("Kick Drum", "speaker.wave.2", "A deep kick drum"),
        ("Cymbal", "circle.hexagongrid", "A shimmering cymbal"), ("Bass", "guitars", "A plucked bass note"),
        ("Strum", "guitars.fill", "A strummed chord"), ("Chord", "pianokeys", "A rolled piano chord"),
        ("Harp", "music.quarternote.3", "A rising harp glissando"), ("Xylophone", "music.note.list", "Rising xylophone notes"),
        ("Gong", "circle.fill", "A ringing gong"), ("Triangle", "triangle", "A triangle's ring"),
    ]),
    motifFamily("vehicles", "Vehicles: on the move, from slow to rapid", tempo, [
        ("Train", "tram.fill", "Wheels clacking over rails"), ("Motorbike", "scooter", "A motorbike revving"),
        ("Helicopter", "airplane", "Helicopter blades thumping"), ("Boat", "ferry", "A boat on the swell"),
        ("Bicycle Bell", "bicycle", "A bicycle bell"), ("Skateboard", "figure.skateboarding", "A skateboard over joints"),
        ("Subway", "tram", "A subway stop"), ("Rocket", "airplane.departure", "A rocket climbing"),
        ("Cable Car", "cablecar", "A cable car's bell and roll"), ("Jet", "airplane.circle", "A jet passing over"),
    ]),
    motifFamily("controls", "Controls: interface feedback, from faint to intense", strength, [
        ("Switch", "switch.2", "A switch flipped on"), ("Slider", "slider.horizontal.3", "A slider's detents"),
        ("Stepper", "plus.forwardslash.minus", "A stepper's click"), ("Pull to Refresh", "arrow.clockwise", "Pulling, then a snap"),
        ("Page Turn", "book", "A page turning"), ("Key Press", "keyboard", "A key pressed"),
        ("Scroll Stop", "hand.draw", "A scroll settling"), ("Pop", "bubble", "A button popping"),
        ("Snap Back", "arrow.uturn.backward", "Springing back"), ("Grab", "hand.raised", "An item grabbed"),
    ]),
    motifFamily("body", "Body: the body's rhythms, from faint to intense", strength, [
        ("Breath", "lungs", "Two slow breaths"), ("Footstep", "figure.walk", "Two footsteps"),
        ("Finger Snap", "hand.point.up", "A finger snap"), ("Knuckles", "hand.raised.fingers.spread", "Cracking knuckles"),
        ("Shiver", "thermometer.snowflake", "A shiver"), ("Yawn", "moon.zzz", "A long yawn"),
        ("Hiccup", "mouth", "Two hiccups"), ("Sneeze", "nose", "A building sneeze"),
        ("Hug", "figure.2.arms.open", "A warm hug"), ("Flutter", "heart.circle", "A fluttering heart"),
    ]),
    motifFamily("kitchen", "Kitchen: cooking sounds, from slow to rapid", tempo, [
        ("Chop", "carrot", "A knife chopping"), ("Sizzle", "frying.pan", "Oil sizzling"),
        ("Boil", "cooktop", "Water bubbling"), ("Whisk", "fork.knife", "A whisk beating"),
        ("Pour", "waterbottle", "Liquid pouring"), ("Kettle", "cup.and.saucer", "A kettle coming to the boil"),
        ("Toaster", "square.split.1x2", "Bread popping up"), ("Microwave", "microwave", "A microwave finishing"),
        ("Blender", "tornado", "A blender whirring"), ("Timer Ding", "bell", "A kitchen timer"),
    ]),
    motifFamily("tools", "Tools: work in progress, from faint to intense", strength, [
        ("Hammer", "hammer", "Three hammer blows"), ("Hand Saw", "scissors", "A saw cutting"),
        ("Screwdriver", "screwdriver", "A screwdriver turning"), ("Wrench", "wrench.adjustable", "A wrench tightening"),
        ("Power Drill", "wrench.and.screwdriver", "A drill spinning up"), ("Sander", "square.grid.3x3.fill", "A sander buzzing"),
        ("Stapler", "paperclip", "A stapler pressed"), ("Nail Gun", "hammer.fill", "A nail gun firing"),
        ("Tape Measure", "ruler", "A tape measure reeling"), ("Chisel", "triangle.fill", "A chisel tapped"),
    ]),
    motifFamily("space", "Space: out in orbit, from tiny to huge", size, [
        ("Launch", "airplane.departure", "A launch rumbling up"), ("Orbit", "globe", "Circling in orbit"),
        ("Beacon", "dot.radiowaves.left.and.right", "A blinking beacon"), ("Warp", "sparkles", "Jumping to warp"),
        ("Docking", "link", "Docking, step by step"), ("Meteor", "flame", "A meteor striking"),
        ("Thruster", "arrow.up.circle", "Thrusters firing"), ("Signal", "antenna.radiowaves.left.and.right", "A fading signal"),
        ("Comet", "sparkle", "A comet's tail"), ("Black Hole", "circle.circle.fill", "Pulled into a black hole"),
    ]),
    motifFamily("ocean", "Ocean: by and under the sea, from tiny to huge", size, [
        ("Tide", "water.waves", "The tide rolling in"), ("Sonar", "dot.radiowaves.right", "A sonar ping and echo"),
        ("Bubbles", "bubbles.and.sparkles", "Bubbles rising"), ("Splash", "drop.fill", "A splash and drips"),
        ("Current", "arrow.right", "A steady current"), ("Buoy Bell", "bell.circle", "A buoy's bell"),
        ("Undertow", "arrow.down", "A pulling undertow"), ("Sea Spray", "humidity", "Sea spray"),
        ("Dolphin", "fish.fill", "Dolphin clicks"), ("Ship Horn", "ferry.fill", "A ship's horn"),
    ]),
    motifFamily("city", "City: street sounds, from faint to intense", strength, [
        ("Traffic", "car", "Traffic rumbling"), ("Crosswalk", "figure.walk.circle", "A crosswalk ticking"),
        ("Elevator", "arrow.up.arrow.down.square", "An elevator arriving"), ("Turnstile", "arrow.triangle.turn.up.right.circle", "A turnstile turning"),
        ("Jackhammer", "hammer.circle", "A jackhammer"), ("Car Horn", "car.fill", "A car horn"),
        ("Train Doors", "door.sliding.left.hand.open", "Doors closing"), ("Bus Stop", "bus", "A bus pulling in"),
        ("Parking", "parkingsign", "Parking sensors"), ("Church Bells", "bell.fill", "Bells ringing"),
    ]),
    motifFamily("puzzle", "Puzzle: puzzle game moments, from tiny to huge", size, [
        ("Match", "puzzlepiece", "A match made"), ("Combo", "bolt", "A rising combo"),
        ("Line Clear", "line.3.horizontal", "A line cleared"), ("Block Drop", "square.stack", "A block landing"),
        ("Rotate", "rotate.right", "A piece rotated"), ("Swap", "arrow.left.arrow.right", "Two pieces swapped"),
        ("Bonus", "star.circle", "A bonus earned"), ("Miss", "xmark.circle", "A missed move"),
        ("Hint", "lightbulb", "A hint appearing"), ("Level Clear", "checkmark.seal", "A level cleared"),
    ]),
    motifFamily("grooves", "Grooves: one bar of a beat, from slow to rapid", tempo, [
        ("Rock", "guitars", "A rock beat"), ("Funk", "music.mic", "A funk groove"),
        ("Reggae", "sun.max", "A reggae one-drop"), ("Disco", "sparkles", "A disco beat"),
        ("Hip Hop", "headphones", "A hip hop beat"), ("Samba", "music.quarternote.3", "A samba rhythm"),
        ("Tango", "figure.dance", "A tango rhythm"), ("Polka", "music.note", "A polka beat"),
        ("Techno", "waveform", "A techno pulse"), ("Afrobeat", "music.note.list", "An afrobeat groove"),
    ]),
    motifFamily("notifications", "Notifications: alerts, from once to five times", repeats, [
        ("Mail", "envelope", "New mail"), ("Calendar", "calendar", "A calendar alert"),
        ("Payment", "creditcard", "A payment sent"), ("Download", "arrow.down.circle", "A download done"),
        ("Upload", "arrow.up.circle", "An upload done"), ("Battery", "battery.25", "A battery warning"),
        ("Note", "note.text", "A new note"), ("Sync", "arrow.triangle.2.circlepath", "A sync finished"),
        ("Friend", "person.crop.circle", "A friend request"), ("News", "newspaper", "Breaking news"),
    ]),
    motifFamily("clocks", "Clocks: timekeeping, from slow to rapid", tempo, [
        ("Tick-Tock", "clock", "A clock's tick-tock"), ("Hour Chime", "bell", "An hour chiming"),
        ("Cuckoo", "bird", "A cuckoo clock"), ("Stopwatch", "stopwatch", "A stopwatch started"),
        ("Hourglass", "hourglass", "Sand running through"), ("Pendulum", "metronome", "A swinging pendulum"),
        ("Alarm Clock", "alarm", "An alarm clock ringing"), ("Egg Timer", "timer", "An egg timer ticking"),
        ("Grandfather Clock", "clock.fill", "A grandfather clock striking"), ("Digital", "clock.badge", "A digital beep"),
    ]),
    motifFamily("elements", "Elements: the elements, from tiny to huge", size, [
        ("Earth", "globe.americas", "Earth's heavy weight"), ("Air", "wind", "Air moving"),
        ("Water", "drop", "Water flowing"), ("Lightning", "bolt", "A lightning strike"),
        ("Ice", "snowflake", "Ice cracking"), ("Lava", "flame.fill", "Lava churning"),
        ("Steam", "cloud.fog", "Steam hissing"), ("Sand", "hourglass.bottomhalf.filled", "Sand shifting"),
        ("Crystal", "diamond", "Crystal chiming"), ("Storm", "cloud.bolt.rain", "A storm raging"),
    ]),
    motifFamily("magic", "Magic: spells and charms, from tiny to huge", size, [
        ("Spell", "wand.and.stars", "A spell cast"), ("Portal", "circle.dashed", "A portal opening"),
        ("Wand", "wand.and.rays", "A wand flick"), ("Charm", "sparkle", "A charm"),
        ("Curse", "moon.stars", "A curse falling"), ("Heal", "cross.case", "A healing glow"),
        ("Teleport", "arrow.up.and.down.and.arrow.left.and.right", "Vanishing and reappearing"), ("Summon", "star.circle.fill", "Something summoned"),
        ("Hex", "hexagon", "A hex"), ("Fizzle", "sparkles", "A spell fizzling"),
    ]),
    Family(
        id: "morse",
        heading: "Morse: short words in Morse code, from 12 to 26 words a minute",
        variants: ["OK", "Yes", "No", "Hi", "Go", "On", "Off", "Up", "Win", "End"].map {
            Variant(title: $0, symbol: "ellipsis", phrase: $0.uppercased())
        },
        levels: tempo,
        title: { "\($0.title) in Morse, \($1.title)" },
        // 12, 15, 18, 22 and 26 words a minute, as `MotifFamilies.morse` plays them.
        subtitle: { variant, _, index in "\(variant.phrase) in Morse code at \([12, 15, 18, 22, 26][index]) words a minute" }
    ),
    motifFamily("electronics", "Electronics: devices at work, from faint to intense", strength, [
        ("Power On", "power", "Powering on"), ("Power Off", "power.circle", "Powering off"),
        ("Charging", "bolt.batteryblock", "Charging up"), ("Vibrate", "iphone.radiowaves.left.and.right", "A phone vibrating"),
        ("Scanner", "barcode.viewfinder", "A scanner beam"), ("Printer", "printer", "A printer running"),
        ("Modem", "network", "A modem connecting"), ("Glitch", "exclamationmark.triangle", "A glitch"),
        ("Click", "cursorarrow.click", "A mouse click"), ("Static", "tv", "Static noise"),
    ]),
    // MARK: Twenty more, listed with the hand-built groups rather than as families of their own.
] + [
    motifFamily("feedbackTaps", "Feedback taps: buttons and other targets, from faint to intense", strength, [
        ("Button", "button.programmable", "A button pressed"), ("Card Tap", "rectangle.portrait", "A card tapped"),
        ("Icon Tap", "app", "An icon tapped"), ("Chip", "capsule", "A chip selected"),
        ("Tab", "rectangle.split.3x1", "A tab chosen"), ("Badge", "app.badge", "A badge cleared"),
        ("Checkbox", "checkmark.square", "A box checked"), ("Radio", "circle.inset.filled", "A radio button chosen"),
        ("Link", "link.circle", "A link followed"), ("Menu Item", "filemenu.and.selection", "A menu item chosen"),
    ], in: "feedback"),
    motifFamily("feedbackToggles", "Feedback toggles: switches and catches, from tiny to huge", size, [
        ("Flip", "arrow.left.arrow.right.circle", "Flipped over"), ("Latch", "lock.open", "A latch catching"),
        ("Dial Click", "dial.low", "A dial clicking round"), ("Lever", "arrow.down.square", "A lever pulled"),
        ("Knob", "dial.high", "A knob turned"), ("Rocker", "power.dotted", "A rocker switch"),
        ("Push Button", "button.horizontal", "A push button"), ("Slide Lock", "lock.rectangle", "A lock slid open"),
        ("Thumb Switch", "hand.thumbsup", "A thumb switch"), ("Detent", "slider.vertical.3", "A detent"),
    ], in: "feedback"),
    motifFamily("feedbackGestures", "Feedback gestures: touches and swipes, from slow to rapid", tempo, [
        ("Fling", "hand.point.right", "A fling"), ("Pinch", "arrow.down.right.and.arrow.up.left", "A pinch closing"),
        ("Spread", "arrow.up.left.and.arrow.down.right", "A pinch opening"), ("Drag", "hand.draw.fill", "Dragged, then dropped"),
        ("Long Hold", "hand.tap.fill", "Held, then released"), ("Flick", "hand.point.up.left", "A flick"),
        ("Pan", "arrow.up.and.down.and.arrow.left.and.right", "Panning around"), ("Edge Swipe", "rectangle.lefthalf.inset.filled", "A swipe from the edge"),
        ("Twist", "arrow.triangle.2.circlepath.circle", "A twist"), ("Double Press", "hand.tap", "Pressed twice"),
    ], in: "feedback"),
    motifFamily("feedbackResults", "Feedback results: actions done, from once to five times", repeats, [
        ("Save", "square.and.arrow.down", "Saved"), ("Send", "paperplane", "Sent"),
        ("Copy", "doc.on.doc", "Copied"), ("Remove Item", "trash", "Removed"),
        ("Revert", "arrow.uturn.backward.circle", "Reverted"), ("Add", "plus.circle", "Added"),
        ("Discard", "xmark.bin", "Discarded"), ("Upload Done", "icloud.and.arrow.up", "Uploaded"),
        ("Like", "hand.thumbsup.fill", "Liked"), ("Share", "square.and.arrow.up", "Shared"),
    ], in: "feedback"),
    motifFamily("alertsChimes", "Alert chimes: bells and tones, from once to five times", repeats, [
        ("Door Chime", "bell.and.waves.left.and.right", "A two-tone door chime"), ("Wind Chime", "wind", "Wind chimes"),
        ("Tone Pair", "music.note", "A pair of tones"), ("Arpeggio", "music.quarternote.3", "A rising arpeggio"),
        ("Low Bell", "bell", "A low bell"), ("Harmonic", "waveform", "A held harmonic"),
        ("Glass Chime", "wineglass", "A glass chime"), ("Twin Bell", "bell.badge", "Twin bells"),
        ("Soft Gong", "circle.fill", "A soft gong"), ("Bright Tone", "sun.max", "A bright tone"),
    ], in: "alerts"),
    motifFamily("alertsCalls", "Alert calls: rings and calls, from slow to rapid", tempo, [
        ("Ringtone", "phone", "A phone ringing"), ("Intercom", "speaker.wave.2.circle", "An intercom buzz"),
        ("Pager", "bell.circle.fill", "A pager going off"), ("Walkie-Talkie", "antenna.radiowaves.left.and.right", "A walkie-talkie click"),
        ("Buzzer", "bell.slash", "A long buzzer"), ("Hotline", "phone.fill", "A hotline ringing"),
        ("Telegraph", "dot.radiowaves.right", "A telegraph key"), ("Hold Music", "music.note.list", "On hold"),
        ("Busy Signal", "phone.down", "A busy signal"), ("Voicemail", "recordingtape", "A voicemail waiting"),
    ], in: "alerts"),
    motifFamily("alertsWarnings", "Alert warnings: something's wrong, from faint to intense", strength, [
        ("Caution", "exclamationmark.triangle", "Caution"), ("Hazard", "light.beacon.max", "A hazard flashing"),
        ("Overheat", "thermometer.sun", "Heat building"), ("Low Signal", "cellularbars", "A signal fading"),
        ("Storage Full", "externaldrive.badge.exclamationmark", "Storage full"), ("Timeout", "clock.badge.exclamationmark", "Timed out"),
        ("Blocked", "nosign", "Blocked"), ("Denied", "hand.raised.slash", "Denied"),
        ("Error Tone", "xmark.octagon", "An error tone"), ("Critical Alert", "exclamationmark.octagon", "A critical alert"),
    ], in: "alerts"),
    motifFamily("rhythmBeats", "Rhythm beats: drum patterns, from slow to rapid", tempo, [
        ("Backbeat", "music.note", "A backbeat"), ("Offbeat", "music.note.list", "Offbeat hits"),
        ("Half Time", "metronome", "A half-time feel"), ("Double Time", "metronome.fill", "A double-time feel"),
        ("Triplet", "music.quarternote.3", "Triplets"), ("Syncopated", "waveform.path", "A syncopated beat"),
        ("Cross Beat", "xmark", "A cross rhythm"), ("Breakbeat", "speaker.wave.3", "A breakbeat"),
        ("Paradiddle", "hands.clap", "A paradiddle"), ("Flam", "hand.tap", "Flams"),
    ], in: "rhythm"),
    motifFamily("rhythmPulses", "Rhythm pulses: single beats, from once to five times", repeats, [
        ("Thump", "circle.fill", "A thump"), ("Pound", "hammer", "A pound"),
        ("Patter", "drop.triangle", "A patter"), ("Bump", "arrow.up.circle", "A bump"),
        ("Thud", "square.fill", "A thud"), ("Strike", "bolt", "A strike"),
        ("Rap", "hand.raised", "A rap on a door"), ("Tap Pair", "hand.tap.fill", "A pair of taps"),
        ("Drumbeat", "music.note", "A drumbeat"), ("Heave", "arrow.up", "A heave"),
    ], in: "rhythm"),
    motifFamily("rhythmFootwork", "Rhythm footwork: steps, from slow to rapid", tempo, [
        ("Walking", "figure.walk", "Walking"), ("Running", "figure.run", "Running"),
        ("Marching Feet", "figure.walk.motion", "Marching"), ("Tiptoe", "shoeprints.fill", "Tiptoeing"),
        ("Skipping", "figure.jumprope", "Skipping"), ("Stomping", "figure.stand", "Stomping"),
        ("Tap Dance", "figure.dance", "Tap dancing"), ("Jogging", "figure.run.circle", "Jogging"),
        ("Climbing Stairs", "figure.stairs", "Climbing stairs"), ("Shuffling Feet", "figure.walk.arrival", "Shuffling along"),
    ], in: "rhythm"),
    motifFamily("textureGrains", "Texture grains: grainy surfaces, from faint to intense", strength, [
        ("Grit", "circle.grid.3x3.fill", "Fine grit"), ("Pebbles", "circle.grid.2x2", "Pebbles"),
        ("Salt", "aqi.low", "Grains of salt"), ("Gravel Path", "road.lanes", "A gravel path"),
        ("Crumbs", "circle.dotted", "Crumbs"), ("Velcro", "rectangle.split.2x1", "Velcro pulled apart"),
        ("Bubble Wrap", "bubble.left.and.bubble.right", "Bubble wrap popping"), ("Corrugated", "line.3.horizontal", "Corrugated card"),
        ("Beads", "smallcircle.filled.circle", "Beads rolling"), ("Sawdust", "aqi.medium", "Sawdust"),
    ], in: "texture"),
    motifFamily("textureHums", "Texture hums: steady sounds, from tiny to huge", size, [
        ("Drone", "waveform", "A low drone"), ("Whirr", "fan", "A whirr"),
        ("Murmur", "bubble.left", "A murmur"), ("Vibration", "iphone.radiowaves.left.and.right", "A vibration"),
        ("Resonance", "dot.radiowaves.left.and.right", "A fading resonance"), ("Thrum", "speaker.wave.2", "A thrum"),
        ("Fizz", "bubbles.and.sparkles", "A fizz"), ("Crackle", "flame", "A crackle"),
        ("Hiss", "wind", "A hiss"), ("Warble", "waveform.path.ecg", "A warble"),
    ], in: "texture"),
    motifFamily("textureSwells", "Texture swells: rising and falling, from slow to rapid", tempo, [
        ("Crest", "water.waves", "A crest"), ("Undulation", "water.waves.and.arrow.up", "An undulation"),
        ("Glide", "arrow.right.circle", "A glide sharpening"), ("Billow", "cloud", "A billow"),
        ("Flare", "sun.max.fill", "A flare"), ("Fade In", "speaker.wave.1", "Fading in"),
        ("Fade Away", "speaker.slash", "Fading away"), ("Breathing", "lungs", "Breathing"),
        ("Tremolo", "waveform.path", "A tremolo"), ("Lull", "moon", "A lull"),
    ], in: "texture"),
    motifFamily("natureCreatures", "Nature creatures: wildlife, from tiny to huge", size, [
        ("Frog", "tortoise", "A frog croaking"), ("Owl", "moon.stars", "An owl hooting"),
        ("Hummingbird", "bird", "A hummingbird hovering"), ("Squirrel", "leaf", "A squirrel chattering"),
        ("Snake Rattle", "lizard", "A rattlesnake"), ("Lion Roar", "pawprint", "A lion's roar"),
        ("Elephant", "pawprint.fill", "An elephant's stomp"), ("Mosquito", "ant", "A mosquito"),
        ("Firefly", "sparkle", "Fireflies"), ("Bat Wings", "bird.fill", "Bat wings"),
    ], in: "nature"),
    motifFamily("natureWater", "Nature water: water in motion, from faint to intense", strength, [
        ("Drip", "drop", "A slow drip"), ("Puddle", "drop.circle", "A puddle splash"),
        ("Waterfall", "water.waves", "A waterfall"), ("Brook", "drop.triangle", "A babbling brook"),
        ("Fountain", "humidity.fill", "A fountain"), ("Geyser", "arrow.up.circle.fill", "A geyser erupting"),
        ("Lake Lap", "water.waves.and.arrow.down", "Water lapping a shore"), ("Icicle", "snowflake", "Icicles dripping"),
        ("Hot Spring", "flame", "A hot spring"), ("River Rapids", "arrow.right.to.line", "River rapids"),
    ], in: "nature"),
    motifFamily("natureSky", "Nature sky: weather overhead, from slow to rapid", tempo, [
        ("Breeze", "wind", "A breeze"), ("Gale", "tornado", "A gale"),
        ("Sunrise", "sunrise", "A sunrise"), ("Sunset", "sunset", "A sunset"),
        ("Rainbow", "rainbow", "A rainbow"), ("Snowfall", "cloud.snow", "Falling snow"),
        ("Fog Roll", "cloud.fog", "Fog rolling in"), ("Aurora", "sparkles", "An aurora"),
        ("Starlight", "star", "Starlight"), ("Overcast", "smoke", "An overcast sky"),
    ], in: "nature"),
    motifFamily("mechanicalParts", "Mechanical parts: moving parts, from faint to intense", strength, [
        ("Cog", "gearshape", "A cog turning"), ("Spring Coil", "arrow.up.and.down", "A spring bouncing"),
        ("Piston", "rectangle.compress.vertical", "A piston pumping"), ("Valve", "spigot", "A valve releasing"),
        ("Gear Shift", "gearshape.2", "A gear shift"), ("Bearing", "circle.circle", "A bearing spinning"),
        ("Hinge", "door.left.hand.open", "A hinge swinging"), ("Latch Bolt", "lock", "A bolt sliding home"),
        ("Crank", "arrow.clockwise.circle", "A crank turning"), ("Pulley", "arrow.up.arrow.down.circle", "A pulley hauling"),
    ], in: "mechanical"),
    motifFamily("mechanicalDevices", "Mechanical devices: machines at home, from slow to rapid", tempo, [
        ("Turntable", "opticaldisc", "A turntable spinning"), ("Projector", "film", "A projector running"),
        ("Cassette", "recordingtape", "A cassette playing"), ("Vending Machine", "takeoutbag.and.cup.and.straw", "A vending machine"),
        ("Washing Machine", "washer", "A washing machine"), ("Dishwasher", "dishwasher", "A dishwasher"),
        ("Lawn Mower", "leaf.fill", "A lawn mower"), ("Vacuum", "wind", "A vacuum cleaner"),
        ("Air Conditioner", "air.conditioner.horizontal", "An air conditioner"), ("Coffee Machine", "cup.and.saucer.fill", "A coffee machine"),
    ], in: "mechanical"),
    motifFamily("gameMoves", "Game moves: a character's moves, from tiny to huge", size, [
        ("Sprint", "figure.run", "A sprint"), ("Slide", "arrow.right", "A slide"),
        ("Roll", "arrow.clockwise", "A roll"), ("Ledge Climb", "figure.climbing", "Climbing a ledge"),
        ("Wall Jump", "arrow.up.right", "A wall jump"), ("Dodge", "arrow.left", "A dodge"),
        ("Block", "shield.lefthalf.filled", "A block"), ("Parry", "shield.righthalf.filled", "A parry"),
        ("Grapple", "link", "A grapple"), ("Crouch", "arrow.down.circle", "A crouch"),
    ], in: "game"),
    motifFamily("gameRewards", "Game rewards: things collected, from once to five times", repeats, [
        ("Gem", "diamond", "A gem collected"), ("Star", "star.fill", "A star collected"),
        ("Key", "key", "A key collected"), ("Chest", "shippingbox", "A chest opened"),
        ("Heart", "heart.fill", "A heart collected"), ("Trophy", "trophy", "A trophy won"),
        ("Medal", "medal", "A medal won"), ("Token", "circle.circle.fill", "A token collected"),
        ("Crown", "crown", "A crown won"), ("Scroll", "scroll", "A scroll found"),
    ], in: "game"),
]

// MARK: Building

struct Pattern {
    let name: String
    let title: String
    let subtitle: String
    let symbol: String
    let family: Family
    let variant: Int
    let level: Int
}

/// "Four-Four, Largo" gives "fourFourLargo".
func caseName(_ title: String) -> String {
    let words = title.split { !$0.isLetter && !$0.isNumber }.map(String.init)
    return words.enumerated().map { index, word in
        index == 0 ? word.lowercased() : word.prefix(1).uppercased() + word.dropFirst().lowercased()
    }.joined()
}

let patterns: [Pattern] = families.flatMap { family in
    family.variants.enumerated().flatMap { variantIndex, variant in
        family.levels.enumerated().map { levelIndex, level in
            let title = family.title(variant, level)
            return Pattern(
                name: caseName(title),
                title: title,
                subtitle: family.subtitle(variant, level, levelIndex),
                symbol: variant.symbol,
                family: family,
                variant: variantIndex,
                level: levelIndex
            )
        }
    }
}

// MARK: Files

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
func path(_ relative: String) -> URL { root.appendingPathComponent(relative) }
let enumFile = path("iOS/Sources/HapticEngine/HapticPattern.swift")
let variantFile = path("iOS/Sources/HapticEngine/HapticPattern+Variant.swift")
let demoFile = path("iOS/Example/HapticEngineDemo/Model/HapticPattern+Families.swift")
let displayFile = path("iOS/Example/HapticEngineDemo/Model/HapticPattern+Display.swift")

let begin = "    // BEGIN GENERATED PATTERNS: written by iOS/Scripts/GeneratePatterns.swift. Don't edit by hand.\n"
let end = "    // END GENERATED PATTERNS\n"

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("error: \(message)\n".utf8))
    exit(1)
}

guard var enumSource = try? String(contentsOf: enumFile, encoding: .utf8) else {
    fail("Run from the repository root: \(enumFile.path) not found")
}

// The hand-written cases and titles, which the generated ones mustn't repeat.
if let start = enumSource.range(of: "\n" + begin), let stop = enumSource.range(of: end) {
    // With the blank line written before it, so running again changes nothing.
    enumSource.removeSubrange(start.lowerBound..<stop.upperBound)
}
let handNames = Set(enumSource.split(separator: "\n").compactMap { line -> String? in
    guard line.hasPrefix("    case ") else { return nil }
    return String(line.dropFirst("    case ".count))
})
let displaySource = (try? String(contentsOf: displayFile, encoding: .utf8)) ?? ""
let handTitles = Set(displaySource.components(separatedBy: "Details(title: \"").dropFirst().compactMap { rest in
    rest.split(separator: "\"", maxSplits: 1).first.map(String.init)
})
guard handNames.count == 100, handTitles.count == 100 else {
    fail("Expected 100 hand-written patterns, found \(handNames.count) cases and \(handTitles.count) titles")
}

for (label, values, existing) in [("case name", patterns.map(\.name), handNames), ("title", patterns.map(\.title), handTitles)] {
    let repeated = Dictionary(grouping: values, by: { $0 }).filter { $0.value.count > 1 }.keys
    guard repeated.isEmpty else { fail("Repeated \(label)s: \(repeated.sorted())") }
    let clashes = Set(values).intersection(existing)
    guard clashes.isEmpty else { fail("\(label)s already used by hand-written patterns: \(clashes.sorted())") }
}
guard patterns.count == 2900 else { fail("Expected 2,900 patterns, made \(patterns.count)") }

// The cases, after the hand-written ones.
var cases = begin
for family in families {
    cases += "\n    // MARK: \(family.heading)\n"
    for pattern in patterns where pattern.family.id == family.id {
        cases += "\n    /// \(pattern.subtitle).\n    case \(pattern.name)\n"
    }
}
cases += end
guard let anchor = enumSource.range(of: "\n    /// How long the pattern plays") else {
    fail("Couldn't find where the cases end in \(enumFile.lastPathComponent)")
}
enumSource.insert(contentsOf: "\n" + cases, at: anchor.lowerBound)

var variantSource = """
//
// HapticPattern+Variant.swift
// HapticEngine
//
// Written by iOS/Scripts/GeneratePatterns.swift. Don't edit by hand.
//

extension HapticPattern {
    /// Where a family pattern sits in its family. `nil` for the hundred built by hand.
    var variant: PatternVariant? {
        switch self {

"""
for pattern in patterns {
    variantSource += "        case .\(pattern.name): PatternVariant(.\(pattern.family.id), \(pattern.variant), \(pattern.level))\n"
}
variantSource += """
        default: nil
        }
    }
}

"""

var demoSource = """
//
// HapticPattern+Families.swift
// HapticEngineDemo
//
// Written by iOS/Scripts/GeneratePatterns.swift. Don't edit by hand.
//

import HapticEngine

extension HapticPattern {
    /// A family pattern's name, description, symbol and category. `nil` for the hundred described by hand.
    var familyDetails: FamilyDetails? {
        switch self {

"""
for pattern in patterns {
    demoSource += "        case .\(pattern.name): FamilyDetails(\"\(pattern.title)\", \"\(pattern.subtitle)\", \"\(pattern.symbol)\", .\(pattern.family.category ?? pattern.family.id))\n"
}
demoSource += """
        default: nil
        }
    }
}

"""

do {
    try enumSource.write(to: enumFile, atomically: true, encoding: .utf8)
    try variantSource.write(to: variantFile, atomically: true, encoding: .utf8)
    try demoSource.write(to: demoFile, atomically: true, encoding: .utf8)
} catch {
    fail("Couldn't write: \(error)")
}
print("Wrote \(patterns.count) patterns in \(families.count) families.")
