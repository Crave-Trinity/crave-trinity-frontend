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

/// Implementation of watch-side craving persistence using SwiftData.
/// This repository converts domain models to data entities and vice versa,
/// and optionally supports phone synchronization.
final class CravingWatchRepository: CravingWatchRepositoryProtocol {
    
    // MARK: - Properties
    
    /// The SwiftData context used for persistence operations.
    private let modelContext: ModelContext
    
    /// Optional connectivity service for synchronizing data with the paired phone.
    // private let connectivityService: WatchConnectivityService
    
    // MARK: - Initialization
    
    /// Initializes the repository with a SwiftData model context.
    ///
    /// - Parameter modelContext: The context used for data persistence.
    /// - Note: An optional connectivity service can be added for watch-to-phone sync.
    init(modelContext: ModelContext /*, connectivityService: WatchConnectivityService */) {
        self.modelContext = modelContext
        // self.connectivityService = connectivityService
    }
    
    // MARK: - Repository Methods
    
    /// Saves a domain `WatchCraving` into SwiftData on the watch.
    ///
    /// This method converts the domain model into a SwiftData entity,
    /// inserts it into the model context, and then persists the changes.
    ///
    /// - Parameter craving: The domain model to be saved.
    /// - Throws: An error if saving to the context fails.
    func saveCraving(_ craving: WatchCraving) throws {
        // Convert domain model -> SwiftData entity using the mapper.
        let entity = CravingWatchMapper.toDataModel(craving)
        
        // Insert the new entity. For updates, you'd typically fetch the existing entity and modify it.
        modelContext.insert(entity)
        
        // Persist the changes to storage.
        try modelContext.save()
        
        // Optional: Trigger synchronization to the phone if needed.
        // connectivityService.sendMessageToPhone(...)
    }
    
    /// Fetches all non-deleted cravings from SwiftData and maps them to domain models.
    ///
    /// - Returns: An array of `WatchCraving` domain models representing non-deleted cravings.
    /// - Throws: An error if the fetch operation fails.
    func fetchAllCravings() throws -> [WatchCraving] {
        // Create a fetch descriptor to retrieve all WatchCravingEntity records.
        let descriptor = FetchDescriptor<WatchCravingEntity>()
        
        // Perform the fetch operation.
        let entities = try modelContext.fetch(descriptor)
        
        // Filter out soft-deleted items (where deletedAt is set) and convert to domain models.
        return entities
            .filter { $0.deletedAt == nil }
            .map { CravingWatchMapper.toDomainModel($0) }
    }
    
    /// Soft-deletes a specific craving by marking it as deleted.
    ///
    /// The method locates the corresponding SwiftData entity using the domain model's ID,
    /// marks it as deleted by updating its `deletedAt` property, and persists the change.
    ///
    /// - Parameter craving: The domain model representing the craving to delete.
    /// - Throws: An error if the deletion or save operation fails.
    func deleteCraving(_ craving: WatchCraving) throws {
        // 1) Fetch all entities and locate the one that matches the domain model's ID.
        let descriptor = FetchDescriptor<WatchCravingEntity>()
        let entities = try modelContext.fetch(descriptor)
        
        guard let entity = entities.first(where: { $0.id == craving.id }) else {
            // If the matching entity is not found, exit the method or consider throwing an error.
            return
        }
        
        // 2) Mark the entity as soft-deleted by setting its deletedAt timestamp.
        entity.softDelete()
        
        // 3) Persist the change to the storage.
        try modelContext.save()
    }
}
