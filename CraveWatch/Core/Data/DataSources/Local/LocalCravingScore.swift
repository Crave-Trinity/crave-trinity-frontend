// LocalCravingScore.swift
import Foundation
import SwiftData

/// A simple SwiftData-based store for offline craving logs.
actor LocalCravingStore {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Save a new WatchCravingEntity to local SwiftData.
    func addCraving(cravingDescription: String, intensity: Int) async throws {  // ONLY CHANGE: parameter name from description to cravingDescription
        let entity = WatchCravingEntity(
            cravingDescription: cravingDescription,  // ONLY CHANGE: parameter name from description to cravingDescription
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
    
    /// Fetch all unsynced cravings.
    func fetchAllCravings() async throws -> [WatchCravingEntity] {
        let fetchDescriptor = FetchDescriptor<WatchCravingEntity>()
        return try modelContext.fetch(fetchDescriptor)
    }
    
    /// Delete an entity after it's been successfully synced to phone.
    func deleteCraving(_ entity: WatchCravingEntity) async throws {
        modelContext.delete(entity)
        do {
            try modelContext.save()
        } catch {
            throw error
        }
    }
}
