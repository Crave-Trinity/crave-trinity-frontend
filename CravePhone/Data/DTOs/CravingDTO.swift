// CravingDTO.swift
import Foundation

struct CravingDTO {
    let id: UUID
    let text: String
    let confidenceToResist: Double  // or Double?
    let cravingStrength: Double     // or Double?
    let timestamp: Date
    let isArchived: Bool

    init(
        id: UUID,
        text: String,
        confidenceToResist: Double,
        cravingStrength: Double,
        timestamp: Date,
        isArchived: Bool
    ) {
        self.id = id
        self.text = text
        self.confidenceToResist = confidenceToResist
        self.cravingStrength = cravingStrength
        self.timestamp = timestamp
        self.isArchived = isArchived
    }
}
