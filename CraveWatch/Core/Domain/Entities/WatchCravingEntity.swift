//
//  WatchCravingEntity.swift
//  CraveWatch
//
//  Description:
//  SwiftData model with a soft-deletion field `deletedAt`.
//

// CraveWatch/Core/Domain/Entities/WatchCravingEntity.swift (MODIFIED)
import Foundation
import SwiftData

@Model
final class WatchCravingEntity {
    var text: String
    var intensity: Int
    var resistance: Int? // ADDED - Make optional
    var timestamp: Date
    var deletedAt: Date?

    init(text: String, intensity: Int, resistance: Int? = nil, timestamp: Date, deletedAt: Date? = nil) {
        self.text = text
        self.intensity = intensity
        self.resistance = resistance // Set the resistance
        self.timestamp = timestamp
        self.deletedAt = deletedAt
    }
}


