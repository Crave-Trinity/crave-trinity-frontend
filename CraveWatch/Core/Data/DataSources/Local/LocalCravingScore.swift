
import Foundation
import SwiftData

/// A simple SwiftData-based store for offline craving logs.
actor LocalCravingStore {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Save a new WatchCravingEntity to local SwiftData.
    func addCraving(description: String, intensity: Int) async throws {
        let entity = WatchCravingEntity(
            description: description,
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


