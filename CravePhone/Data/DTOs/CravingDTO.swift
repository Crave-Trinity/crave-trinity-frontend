//
//  CravingDTO.swift
//  CravePhone
//
//  Extended to include location, people, trigger for mapping.
//
import Foundation

struct CravingDTO {
    let id: UUID
    let text: String
    let confidenceToResist: Double
    let cravingStrength: Double
    let timestamp: Date
    let isArchived: Bool
    let emotions: [String]
    
    // NEW fields
    let location: String?
    let people: [String]?
    let trigger: String?
    
    init(
        id: UUID,
        text: String,
        confidenceToResist: Double,
        cravingStrength: Double,
        timestamp: Date,
        isArchived: Bool,
        emotions: [String] = [],
        location: String? = nil,
        people: [String]? = nil,
        trigger: String? = nil
    ) {
        self.id = id
        self.text = text
        self.confidenceToResist = confidenceToResist
        self.cravingStrength = cravingStrength
        self.timestamp = timestamp
        self.isArchived = isArchived
        self.emotions = emotions
        self.location = location
        self.people = people
        self.trigger = trigger
    }
}
