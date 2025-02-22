//
//  CravingWatchRepository.swift
//  CraveWatch
//
//  A concrete repository implementing CravingWatchRepositoryProtocol using SwiftData
//  and optional phone connectivity. Renamed to avoid conflicts with the phone app's "CravingRepository".
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import SwiftData

/// Implementation of watch-side craving persistence.
final class CravingWatchRepository: CravingWatchRepositoryProtocol {
    
    private let modelContext: ModelContext
    // Optionally store a connectivity service if you want to sync from here:
    // private let connectivityService: WatchConnectivityService
    
    init(modelContext: ModelContext /*, connectivityService: WatchConnectivityService */) {
        self.modelContext = modelContext
        // self.connectivityService = connectivityService
    }
    
    /// Saves a domain `WatchCraving` into SwiftData on watch.
    func saveCraving(_ craving: WatchCraving) throws {
        // Convert domain model -> SwiftData entity
        let entity = CravingWatchMapper.toDataModel(craving)
        
        // Insert if new. For updates, you'd typically fetch & modify the existing entity.
        modelContext.insert(entity)
        
        // Attempt to persist
        try modelContext.save()
        
        // Optionally: Trigger watch->phone sync if needed:
        // connectivityService.sendMessageToPhone(...)
    }
    
    /// Fetches all non-deleted cravings from SwiftData, mapped to domain `WatchCraving`.
    func fetchAllCravings() throws -> [WatchCraving] {
        let descriptor = FetchDescriptor<WatchCravingEntity>()
        
        // Perform the fetch
        let entities = try modelContext.fetch(descriptor)
        
        // Filter out soft-deleted items, then map to domain
        return entities
            .filter { $0.deletedAt == nil }
            .map { CravingWatchMapper.toDomainModel($0) }
    }
    
    /// Soft-deletes a specific craving by marking its `deletedAt`.
    func deleteCraving(_ craving: WatchCraving) throws {
        // 1) Fetch the SwiftData entity that matches `craving.id`.
        let descriptor = FetchDescriptor<WatchCravingEntity>()
        let entities = try modelContext.fetch(descriptor)
        
        guard let entity = entities.first(where: { $0.id == craving.id }) else {
            // If not found, do nothing or throw an error
            return
        }
        
        // 2) Mark it as soft-deleted
        entity.softDelete()
        
        // 3) Save changes
        try modelContext.save()
    }
}
