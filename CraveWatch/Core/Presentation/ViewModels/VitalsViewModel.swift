import Foundation
import HealthKit
import Combine

/// Demonstrates reading basic vitals from HealthKit (heart rate, etc.).
/// In reality, you'd set up HK queries and handle them in a similar pattern.
@MainActor
class VitalsViewModel: ObservableObject {
    
    @Published var heartRate: Double?  // BPM
    @Published var isAuthorized = false
    
    private let healthStore: HKHealthStore?
    private var heartRateQuery: HKQuery?
    private var cancellable: AnyCancellable?

    init() {
        // Check if HealthKit is available on watch
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
        } else {
            self.healthStore = nil
        }
    }

    func requestAuthorization() async {
        guard let healthStore = healthStore else { return }

        let typesToRead: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
            isAuthorized = true
            await startHeartRateQuery()
        } catch {
            print("🔴 HealthKit auth error: \(error.localizedDescription)")
            isAuthorized = false
        }
    }

    private func startHeartRateQuery() async {
        guard let healthStore = healthStore,
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        else { return }
        
        // Create the query
        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            guard let self = self else { return }
            
            if let error = error {
                print("🔴 Error: \(error.localizedDescription)")
                return
            }
            
            // Process new samples
            if let samples = samples as? [HKQuantitySample] {
                Task { @MainActor in
                    await self.process(heartRateSamples: samples)
                }
            }
        }
        
        // Update handler for continuous monitoring
        query.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            guard let self = self else { return }
            
            if let error = error {
                print("🔴 Error: \(error.localizedDescription)")
                return
            }
            
            // Process new samples
            if let samples = samples as? [HKQuantitySample] {
                Task { @MainActor in
                    await self.process(heartRateSamples: samples)
                }
            }
        }
        
        heartRateQuery = query
        healthStore.execute(query)
    }
    
    private func process(heartRateSamples samples: [HKQuantitySample]) async {
        guard let lastSample = samples.last else { return }
        
        // Convert to BPM
        let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
        let bpm = lastSample.quantity.doubleValue(for: heartRateUnit)
        
        self.heartRate = bpm
    }

    deinit {
        if let query = heartRateQuery {
            healthStore?.stop(query)
        }
        cancellable?.cancel()
    }
}
