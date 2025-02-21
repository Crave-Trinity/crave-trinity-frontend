//
//  WatchCravingEntity.swift
//  CraveWatch
//
//  A SwiftData model with optional "resistance", a soft-deletion field,
//  and a unique ID.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import SwiftData

@Model
final class WatchCravingEntity {
    // MARK: - Fields
    
    /// A unique ID for referencing this entity across sync boundaries, etc.
    @Attribute(.unique) var id: UUID
    
    /// The text describing the craving (e.g. "Craving chocolate")
    var text: String
    
    /// The intensity level of the craving (e.g. 1-10 scale)
    var intensity: Int
    
    /// Optional: an integer representing how strongly user resisted
    /// or any other measure relevant for your domain
    var resistance: Int?
    
    /// The date/time when this craving was logged
    var timestamp: Date
    
    /// A nullable date field indicating if/when this entity is considered "soft-deleted"
    var deletedAt: Date?
    
    // MARK: - Initializer
    
    init(
        text: String,
        intensity: Int,
        resistance: Int? = nil,
        timestamp: Date,
        deletedAt: Date? = nil
    ) {
        // SwiftData auto-initializes the `id` if you don’t override it,
        // but we’ll do it explicitly for clarity:
        self.id = UUID()
        
        self.text = text
        self.intensity = intensity
        self.resistance = resistance
        self.timestamp = timestamp
        self.deletedAt = deletedAt
    }
    
    // MARK: - Computed Properties
    
    /// Helper for checking if the entity is "soft-deleted"
    var isDeleted: Bool {
        return deletedAt != nil
    }
    
    // MARK: - Methods
    
    /// Convenience method to mark this entity as soft-deleted
    func softDelete() {
        deletedAt = Date()
    }
}
