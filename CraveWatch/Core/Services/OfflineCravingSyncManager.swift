//
//  OfflineCravingSyncManager.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Monitors phone reachability and synchronizes offline cravings stored in local SwiftData.
//               When the phone becomes reachable, it iterates through unsynced cravings, sends them to the iPhone,
//               and deletes them locally upon success.
import Foundation
import Combine
import WatchConnectivity

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
        
        // Observe changes in phone reachability. The closure parameter is explicitly typed as Bool.
        reachabilityCancellable = watchConnectivityService.$phoneReachable
            .sink { (isReachable: Bool) in
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
    
    /// Adds a craving to the local SwiftData store when offline.
    /// - Parameters:
    ///   - cravingDescription: The craving text.
    ///   - intensity: The intensity value.
    func addCravingOffline(cravingDescription: String, intensity: Int) async {
        do {
            try await localStore.addCraving(cravingDescription: cravingDescription,
                                            intensity: intensity)
        } catch {
            print("🔴 Error adding craving offline: \(error)")
        }
    }
    
    /// Synchronizes all unsynced cravings by sending them to the iPhone.
    /// After a successful send, the local craving is deleted.
    func syncOfflineCravings() async {
        do {
            let cravings = try await localStore.fetchAllCravings()
            for entity in cravings {
                // Build the message dictionary.
                let message: [String: Any] = [
                    "action": "logCraving",
                    "id": String(describing: entity.id),  // Convert id to String.
                    "description": entity.text,           // Use 'text' property.
                    "intensity": entity.intensity,
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
