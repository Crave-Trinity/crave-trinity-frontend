//
//  LocalCravingStore.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A SwiftData-based local store for watch cravings.
//               Provides add/fetch/delete operations via an actor for concurrency safety.
//

import Foundation
import SwiftData

actor LocalCravingStore {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Saves a new WatchCravingEntity to the local SwiftData store.
    /// - Parameters:
    ///   - cravingDescription: The textual description of the craving.
    ///   - intensity: An integer representing the craving intensity.
    /// - Note: The WatchCravingEntity initializer expects 'text:' for the craving description.
    func addCraving(cravingDescription: String, intensity: Int) async throws {
        let entity = WatchCravingEntity(
            text: cravingDescription,
            intensity: intensity,
            timestamp: Date()
        )
        modelContext.insert(entity)
        
        do {
            try modelContext.save()
        } catch {
            throw error
        }
    }
    
    /// Fetches all cravings from the local store.
    func fetchAllCravings() async throws -> [WatchCravingEntity] {
        let fetchDescriptor = FetchDescriptor<WatchCravingEntity>()
        return try modelContext.fetch(fetchDescriptor)
    }
    
    /// Deletes a specified craving entity from the local store (e.g., after syncing).
    /// - Parameter entity: The WatchCravingEntity to delete.
    func deleteCraving(_ entity: WatchCravingEntity) async throws {
        modelContext.delete(entity)
        do {
            try modelContext.save()
        } catch {
            throw error
        }
    }
}
