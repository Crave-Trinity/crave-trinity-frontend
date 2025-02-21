// CraveWatch/Core/Services/OfflineCravingSyncManager.swift
import Foundation
import Combine
import WatchConnectivity
import SwiftData

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
        
        // Observe changes in phone reachability.
        reachabilityCancellable = watchConnectivityService.$phoneReachable
            .sink { [weak self] isReachable in
                if isReachable {
                    Task {
                        await self?.syncOfflineCravings()
                    }
                }
            }
    }
    
    deinit {
        reachabilityCancellable?.cancel()
    }
    
    /// Adds a craving to the local SwiftData store when offline.
    func addCravingOffline(cravingDescription: String, intensity: Int, resistance: Int) async {
        do {
            try await localStore.addCraving(cravingDescription: cravingDescription,
                                             intensity: intensity, resistance: resistance)
        } catch {
            print("🔴 Error adding craving offline: \(error)")
        }
    }
    
    /// Synchronizes all unsynced cravings.
    func syncOfflineCravings() async {
        do {
            let cravings = try await localStore.fetchAllCravings()
            for entity in cravings {
                // Build the message dictionary.
                let message: [String: Any] = [
                    "action": "logCraving",
                    "id": String(describing: entity.id), // Convert PersistentIdentifier to String
                    "text": entity.text,
                    "intensity": entity.intensity,
                    "resistance": entity.resistance ?? NSNull(), // Include resistance
                    "timestamp": entity.timestamp.timeIntervalSince1970
                ]
                watchConnectivityService.sendMessageToPhone(message)

                // For a robust flow, you'd wait for an acknowledgment.
                try await localStore.deleteCraving(entity)
            }
            print("✅ Synced offline cravings: \(cravings.count)")
        } catch {
            print("🔴 Sync error: \(error)")
        }
    }
}

