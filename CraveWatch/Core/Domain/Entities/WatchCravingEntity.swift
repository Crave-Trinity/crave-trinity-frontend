//
//  WatchCravingEntity.swift
//  CraveWatch
//
//  A SwiftData model representing a craving record on the watch.
//  It includes an optional "resistance" value, a soft-deletion timestamp, and a unique ID.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import SwiftData

/// A model representing a craving record for the watch app.
/// Uses SwiftData for persistence.
@Model
final class WatchCravingEntity {
    
    /// Unique identifier for the craving record.
    @Attribute(.unique) var id: UUID
    
    /// Textual description or message of the craving.
    var text: String
    
    /// The intensity level of the craving (e.g., scale 1-10).
    var intensity: Int
    
    /// Optional resistance metric associated with the craving.
    var resistance: Int?
    
    /// Timestamp indicating when the craving was recorded.
    var timestamp: Date
    
    /// Optional timestamp used for soft-deleting the record.
    var deletedAt: Date?
    
    /// Initializes a new instance of WatchCravingEntity.
    /// - Parameters:
    ///   - text: A description of the craving.
    ///   - intensity: The intensity level of the craving.
    ///   - resistance: An optional resistance metric.
    ///   - timestamp: The date and time when the craving was recorded.
    ///   - deletedAt: An optional deletion timestamp (defaults to nil).
    init(
        text: String,
        intensity: Int,
        resistance: Int? = nil,
        timestamp: Date,
        deletedAt: Date? = nil
    ) {
        // Generate a new unique identifier for this craving record.
        self.id = UUID()
        self.text = text
        self.intensity = intensity
        self.resistance = resistance
        self.timestamp = timestamp
        self.deletedAt = deletedAt
    }
    
    /// A computed property that returns true if the record has been soft-deleted.
    var isDeleted: Bool {
        return deletedAt != nil
    }
    
    /// Marks the record as deleted by setting the `deletedAt` timestamp to the current date.
    func softDelete() {
        deletedAt = Date()
    }
}
