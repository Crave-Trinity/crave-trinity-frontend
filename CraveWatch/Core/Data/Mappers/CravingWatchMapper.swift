//
//  CravingWatchMapper.swift
//  CraveWatch
//
//  Converts between the domain-level model `WatchCraving` and the data-layer `WatchCravingEntity`.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation

/// Provides static mapping methods for converting between the domain model `WatchCraving`
/// and the SwiftData entity `WatchCravingEntity`.
enum CravingWatchMapper {
    
    /// Maps a SwiftData `WatchCravingEntity` to the domain model `WatchCraving`.
    ///
    /// - Parameter entity: The `WatchCravingEntity` to be converted.
    /// - Returns: A corresponding `WatchCraving` domain model.
    static func toDomainModel(_ entity: WatchCravingEntity) -> WatchCraving {
        return WatchCraving(
            id: entity.id,
            text: entity.text,
            intensity: entity.intensity,
            resistance: entity.resistance,
            timestamp: entity.timestamp,
            deletedAt: entity.deletedAt
        )
    }
    
    /// Maps a domain model `WatchCraving` to a new SwiftData `WatchCravingEntity`.
    ///
    /// Note: This creates a new entity. For updating an existing record,
    /// you would typically fetch the existing entity and modify its properties.
    ///
    /// - Parameter domainCraving: The domain model to be converted.
    /// - Returns: A new instance of `WatchCravingEntity` representing the domain model.
    static func toDataModel(_ domainCraving: WatchCraving) -> WatchCravingEntity {
        return WatchCravingEntity(
            text: domainCraving.text,
            intensity: domainCraving.intensity,
            resistance: domainCraving.resistance,
            timestamp: domainCraving.timestamp,
            deletedAt: domainCraving.deletedAt
        )
    }
}
