//
//  CravingWatchRepositoryProtocol.swift
//  CraveWatch
//
//  Defines how the watch's domain layer interacts with craving data.
//  Renamed to avoid collisions with the phone side.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation

/// Protocol outlining the interactions for managing watch cravings in the data store.
/// This abstraction hides the underlying persistence details (e.g., SwiftData) and any
/// optional phone synchronization logic.
protocol CravingWatchRepositoryProtocol {
    
    /// Saves a domain-level `WatchCraving` instance to the watch's persistent data store.
    ///
    /// - Parameter craving: The `WatchCraving` instance to be saved.
    /// - Throws: An error if the save operation fails.
    func saveCraving(_ craving: WatchCraving) throws
    
    /// Retrieves all non-deleted cravings from the data store.
    ///
    /// - Returns: An array of `WatchCraving` domain models.
    /// - Throws: An error if the fetch operation fails.
    func fetchAllCravings() throws -> [WatchCraving]
    
    /// Soft-deletes a specific craving by marking it as deleted.
    ///
    /// - Parameter craving: The `WatchCraving` instance to be soft-deleted.
    /// - Throws: An error if the deletion or save operation fails.
    func deleteCraving(_ craving: WatchCraving) throws
}
