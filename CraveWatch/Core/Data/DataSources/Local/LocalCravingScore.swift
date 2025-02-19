// File: CraveWatch/Core/Data/DataSources/Local/LocalCravingScore.swift
// Description: A SwiftData-based local store (using an actor) for offline craving logs.
//              This store provides functions to add, fetch, and delete WatchCravingEntity objects.
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
    /// - Note: The WatchCravingEntity initializer expects the parameter label "text:" for the description.
    func addCraving(cravingDescription: String, intensity: Int) async throws {
        // IMPORTANT: Use "text:" instead of "cravingDescription:" because WatchCravingEntity's initializer is defined with "text".
        let entity = WatchCravingEntity(
            text: cravingDescription,  // Updated parameter label to "text:"
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
    
    /// Fetches all unsynced cravings from the local store.
    func fetchAllCravings() async throws -> [WatchCravingEntity] {
        let fetchDescriptor = FetchDescriptor<WatchCravingEntity>()
        return try modelContext.fetch(fetchDescriptor)
    }
    
    /// Deletes a specified craving entity from the local store after it has been synced.
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
