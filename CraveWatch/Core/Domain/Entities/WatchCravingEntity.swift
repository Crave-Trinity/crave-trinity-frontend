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
    @Attribute(.unique) var id: UUID
    var text: String
    var intensity: Int
    var resistance: Int?
    var timestamp: Date
    var deletedAt: Date?

    init(
        text: String,
        intensity: Int,
        resistance: Int? = nil,
        timestamp: Date,
        deletedAt: Date? = nil
    ) {
        self.id = UUID()
        self.text = text
        self.intensity = intensity
        self.resistance = resistance
        self.timestamp = timestamp
        self.deletedAt = deletedAt
    }
    
    var isDeleted: Bool {
        return deletedAt != nil
    }
    
    func softDelete() {
        deletedAt = Date()
    }
}
