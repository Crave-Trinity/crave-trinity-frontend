
import Foundation
import Combine
import WatchConnectivity

/// Monitors phone reachability and synchronizes any offline cravings.
@MainActor
class OfflineCravingSyncManager: NSObject, ObservableObject {
    
    private let localStore: LocalCravingStore
    private let watchConnectivityService: WatchConnectivityService
    private var reachabilityCancellable: AnyCancellable?
    
    init(localStore: LocalCravingStore,
         watchConnectivityService: WatchConnectivityService) {
        self.localStore = localStore
        self.watchConnectivityService = watchConnectivityService
        super.init()
        
        // Observe phone reachability changes if you have a published property for that
        reachabilityCancellable = watchConnectivityService.$phoneReachable
            .sink { [weak self] isReachable in
                guard let self = self else { return }
                if isReachable {
                    Task {
                        await self.syncOfflineCravings()
                    }
                }
            }
    }
    
    deinit {
        reachabilityCancellable?.cancel()
    }
    
    func addCravingOffline(description: String, intensity: Int) async {
        do {
            try await localStore.addCraving(
                description: description,
                intensity: intensity
            )
        } catch {
            print("🔴 Error adding craving offline: \(error)")
        }
    }
    
    func syncOfflineCravings() async {
        do {
            // Grab all unsynced cravings
            let cravings = try await localStore.fetchAllCravings()
            
            for entity in cravings {
                // Attempt to send each one to phone
                let message: [String: Any] = [
                    "action": "logCraving",
                    "id": entity.id.uuidString,
                    "description": entity.description,
                    "intensity": entity.intensity,
                    "timestamp": entity.timestamp.timeIntervalSince1970
                ]
                watchConnectivityService.sendMessageToPhone(message)
                
                // For a more robust flow, you'd wait for phone ack. For now, let's assume success:
                try await localStore.deleteCraving(entity)
            }
            
            print("✅ Synced offline cravings: \(cravings.count)")
            
        } catch {
            print("🔴 Sync error: \(error)")
        }
    }
}

