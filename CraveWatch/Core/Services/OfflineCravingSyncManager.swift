//
//  OfflineCravingSyncManager.swift
//  CraveWatch/Core/Services
//
//  Manages offline craving synchronization by storing cravings locally when offline,
//  and syncing them with the paired phone once connectivity is restored.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import Combine
import WatchConnectivity
import SwiftData

@MainActor
class OfflineCravingSyncManager: NSObject, ObservableObject {
    
    // MARK: - Dependencies
    
    /// The local store for handling craving persistence when offline.
    private let localStore: LocalCravingStore
    
    /// Service responsible for managing connectivity with the paired phone.
    private let watchConnectivityService: WatchConnectivityService
    
    /// A Combine subscription to observe changes in phone reachability.
    private var reachabilityCancellable: AnyCancellable?
    
    // MARK: - Initialization
    
    /// Initializes a new instance of OfflineCravingSyncManager.
    /// - Parameters:
    ///   - localStore: The local storage mechanism for cravings.
    ///   - watchConnectivityService: The connectivity service for communicating with the phone.
    init(localStore: LocalCravingStore,
         watchConnectivityService: WatchConnectivityService) {
        self.localStore = localStore
        self.watchConnectivityService = watchConnectivityService
        super.init()
        
        // Observe changes in phone reachability. When the phone becomes reachable,
        // attempt to sync offline cravings.
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
        // Cancel the reachability subscription when the manager is deallocated.
        reachabilityCancellable?.cancel()
    }
    
    // MARK: - Offline Craving Handling
    
    /// Adds a craving to the local SwiftData store when offline.
    ///
    /// - Parameters:
    ///   - cravingDescription: The text description of the craving.
    ///   - intensity: The intensity level of the craving.
    ///   - resistance: The resistance value associated with the craving.
    func addCravingOffline(cravingDescription: String, intensity: Int, resistance: Int) async {
        do {
            try await localStore.addCraving(cravingDescription: cravingDescription,
                                             intensity: intensity,
                                             resistance: resistance)
        } catch {
            // Log any errors that occur while adding a craving offline.
            print("🔴 Error adding craving offline: \(error)")
        }
    }
    
    /// Synchronizes all unsynced cravings from the local store with the paired phone.
    /// For each craving, it builds a message dictionary, sends it to the phone,
    /// and then deletes the craving from the local store.
    func syncOfflineCravings() async {
        do {
            // Fetch all stored cravings from the local store.
            let cravings = try await localStore.fetchAllCravings()
            for entity in cravings {
                // Construct a message dictionary with the necessary craving details.
                let message: [String: Any] = [
                    "action": "logCraving",
                    "id": String(describing: entity.id), // Convert unique identifier to String.
                    "text": entity.text,
                    "intensity": entity.intensity,
                    "resistance": entity.resistance ?? NSNull(), // Use NSNull for nil resistance.
                    "timestamp": entity.timestamp.timeIntervalSince1970
                ]
                
                // Send the constructed message to the paired phone.
                watchConnectivityService.sendMessageToPhone(message)
                
                // For a robust flow, you might wait for an acknowledgment here.
                // Once the message is successfully sent, delete the local record.
                try await localStore.deleteCraving(entity)
            }
            print("✅ Synced offline cravings: \(cravings.count)")
        } catch {
            // Log any errors encountered during synchronization.
            print("🔴 Sync error: \(error)")
        }
    }
}
