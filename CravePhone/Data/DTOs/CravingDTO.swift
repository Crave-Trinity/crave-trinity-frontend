//
//  CravingDTO.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Added 'emotions' field to match CravingEntity.
//   - Ensures proper mapping in CravingMapper.
//

import Foundation

struct CravingDTO {
    let id: UUID
    let text: String
    let confidenceToResist: Double
    let cravingStrength: Double
    let timestamp: Date
    let isArchived: Bool
    
    // New: match 'emotions' to avoid mapper errors
    let emotions: [String]
    
    init(
        id: UUID,
        text: String,
        confidenceToResist: Double,
        cravingStrength: Double,
        timestamp: Date,
        isArchived: Bool,
        emotions: [String] = []
    ) {
        self.id = id
        self.text = text
        self.confidenceToResist = confidenceToResist
        self.cravingStrength = cravingStrength
        self.timestamp = timestamp
        self.isArchived = isArchived
        self.emotions = emotions
    }
}

