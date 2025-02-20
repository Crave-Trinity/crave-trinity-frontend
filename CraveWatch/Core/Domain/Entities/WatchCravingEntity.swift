//
//  WatchCravingEntity.swift
//  CraveWatch
//
//  Description:
//  SwiftData model with a soft-deletion field `deletedAt`.
//
//  Created by [Your Name] on [Date]
//

import Foundation
import SwiftData

@Model
final class WatchCravingEntity {
    var text: String
    var intensity: Int
    var timestamp: Date
    
    // Soft deletion: if not nil, treat as "deleted"
    var deletedAt: Date?
    
    init(text: String, intensity: Int, timestamp: Date, deletedAt: Date? = nil) {
        self.text = text
        self.intensity = intensity
        self.timestamp = timestamp
        self.deletedAt = deletedAt
    }
}

