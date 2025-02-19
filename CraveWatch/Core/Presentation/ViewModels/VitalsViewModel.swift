
//CRAVEWatch/Core/Presentation/ViewModels/VitalsViewModel.swift
import Foundation
import HealthKit
import Combine

/// Demonstrates reading basic vitals from HealthKit (heart rate, etc.).
/// In reality, you'd set up HK queries and handle them in a similar pattern.
@MainActor
class VitalsViewModel: ObservableObject {
    
    @Published var heartRate: Double?  // BPM
    @Published var isAuthorized = false
    
    private var healthStore: HKHealthStore?
    private var cancellable: AnyCancellable?

    init() {
        // Check if HealthKit is available on watch
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
        }
    }

    func requestAuthorization() async {
        guard let healthStore = healthStore else { return }

        // For example: reading heart rate data
        if let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: [heartRateType])
                isAuthorized = true
                // Possibly start observing heart rate changes
                startHeartRateQuery()
            } catch {
                print("🔴 HealthKit auth error: \(error.localizedDescription)")
            }
        }
    }

    private func startHeartRateQuery() {
        guard let healthStore = healthStore,
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        else { return }
        
        // Real implementation: set up a HKAnchoredObjectQuery or HKObserverQuery
        // For the sake of example, let's just set up a timer that fakes random BPM updates
        cancellable = Timer.publish(every: 3.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.heartRate = Double.random(in: 60...120)
            }
    }

    deinit {
        cancellable?.cancel()
    }
}

