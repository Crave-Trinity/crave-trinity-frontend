//
//  LocalCravingStore.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: An actor-based local store for concurrency-safe
//               read/write to SwiftData on the watch.
//

import Foundation
import SwiftData

actor LocalCravingStore {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Inserts a new WatchCravingEntity into SwiftData
    func addCraving(cravingDescription: String, intensity: Int) async throws {
        let entity = WatchCravingEntity(text: cravingDescription, intensity: intensity)
        modelContext.insert(entity)
        try modelContext.save()
    }
    
    /// Fetches all cravings from SwiftData
    func fetchAllCravings() async throws -> [WatchCravingEntity] {
        let descriptor = FetchDescriptor<WatchCravingEntity>()
        return try modelContext.fetch(descriptor)
    }
    
    /// Deletes a specific craving
    func deleteCraving(_ entity: WatchCravingEntity) async throws {
        modelContext.delete(entity)
        try modelContext.save()
    }
}
