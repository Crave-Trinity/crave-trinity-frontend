//
//  CravingWatchRepositoryProtocol.swift
//  CraveWatch
//
//  Defines how the watch's domain layer interacts with craving data.
//  Renamed to avoid collisions with the phone side.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation

/// An interface describing how to save, fetch, and delete watch cravings.
/// Implementation details (SwiftData, phone sync, etc.) are hidden behind this protocol.
protocol CravingWatchRepositoryProtocol {
    /// Saves a domain `WatchCraving` into the watch data store.
    func saveCraving(_ craving: WatchCraving) throws

    /// Fetches all cravings (not soft-deleted).
    func fetchAllCravings() throws -> [WatchCraving]

    /// Soft-deletes a specific craving by marking its `deletedAt`.
    func deleteCraving(_ craving: WatchCraving) throws
}
