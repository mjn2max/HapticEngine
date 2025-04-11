import CoreHaptics

public class HapticEngine: ObservableObject, HapticEngineProtocol {
    // MARK: - Initialization
    @Published private var engine: CHHapticEngine?
    
    public init() {
        guard isHapticsSupported else {
            return
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Properties
    public var isHapticsSupported: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
}

// MARK: - Methods
extension HapticEngine {
    public func startSimpleHaptic() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    public func startComplexHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // Define intensity levels
        let mediumIntensity: Float = 0.5
        let hardIntensity: Float = 1.0
        let softIntensity: Float = 0.2
        
        // Create continuous events for each 1.5-second segment
        let segments: [(intensity: Float, startTime: TimeInterval)] = [
            (mediumIntensity, 0.0),  // Medium: 0-1.5 seconds
            (hardIntensity, 1.5),    // Hard: 1.5-3 seconds
            (softIntensity, 3.0),    // Soft: 3-4.5 seconds
            (hardIntensity, 4.5)     // Hard: 4.5-6 seconds
        ]
        
        // Create events for each segment with multiple points for smooth continuous effect
        for (intensity, startTime) in segments {
            for offset in stride(from: 0.0, to: 1.5, by: 0.1) {
                let event = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: intensity)
                    ],
                    relativeTime: startTime + offset,
                    duration: 0.15)
                events.append(event)
            }
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
