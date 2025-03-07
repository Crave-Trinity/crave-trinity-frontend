//
//  CravingEntity.swift
//  CravePhone
//
//  Adds location, people, trigger fields to the model.
//
import SwiftData
import Foundation

@Model
public final class CravingEntity {
    @Attribute(.unique) public var id: UUID
    public var cravingDescription: String
    public var cravingStrength: Double
    public var confidenceToResist: Double
    public var emotions: [String]
    public var timestamp: Date
    public var isArchived: Bool
    
    // NEW fields
    public var location: String?
    public var people: [String]?
    public var trigger: String?
    
    public init(
        id: UUID = UUID(),
        cravingDescription: String,
        cravingStrength: Double,
        confidenceToResist: Double,
        emotions: [String],
        timestamp: Date,
        isArchived: Bool,
        // Add new fields to initializer
        location: String? = nil,
        people: [String]? = nil,
        trigger: String? = nil
    ) {
        self.id = id
        self.cravingDescription = cravingDescription
        self.cravingStrength = cravingStrength
        self.confidenceToResist = confidenceToResist
        self.emotions = emotions
        self.timestamp = timestamp
        self.isArchived = isArchived
        self.location = location
        self.people = people
        self.trigger = trigger
    }
}
