import CoreHaptics

class HapticEngine: ObservableObject, HapticEngineProtocol {
    // MARK: - Initialization
    @Published private var engine: CHHapticEngine?

    init() {
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
    var isHapticsSupported: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
}

// MARK: - Methods
extension HapticEngine {
    func startSimpleHaptic() {
        print("Test startSimpleHaptic()")
    }

    func startComplexHaptic() {
        print("Test startComplexHaptic()")
    }
}
