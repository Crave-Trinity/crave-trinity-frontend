//
//  CravingWatchMapper.swift
//  CraveWatch
//
//  Converts between domain-level `WatchCraving` and SwiftData `WatchCravingEntity`.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation

/// Provides static methods to map between domain `WatchCraving` and
/// data-layer `WatchCravingEntity`.
enum CravingWatchMapper {
    
    /// Map from SwiftData entity -> domain model.
    static func toDomainModel(_ entity: WatchCravingEntity) -> WatchCraving {
        WatchCraving(
            id: entity.id,
            text: entity.text,
            intensity: entity.intensity,
            resistance: entity.resistance,
            timestamp: entity.timestamp,
            deletedAt: entity.deletedAt
        )
    }
    
    /// Map from domain model -> SwiftData entity.
    /// Creates a new entity; for an existing record, you'd typically fetch & mutate.
    static func toDataModel(_ domainCraving: WatchCraving) -> WatchCravingEntity {
        WatchCravingEntity(
            text: domainCraving.text,
            intensity: domainCraving.intensity,
            resistance: domainCraving.resistance,
            timestamp: domainCraving.timestamp,
            deletedAt: domainCraving.deletedAt
        )
    }
}
