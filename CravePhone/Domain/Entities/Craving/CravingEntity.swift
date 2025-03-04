//
//  CravingEntity.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Single source for user-submitted “cravings”
//   - Ties in with logging UI & usage analytics
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
    
    public init(
        id: UUID = UUID(),
        cravingDescription: String,
        cravingStrength: Double,
        confidenceToResist: Double,
        emotions: [String],
        timestamp: Date,
        isArchived: Bool
    ) {
        self.id = id
        self.cravingDescription = cravingDescription
        self.cravingStrength = cravingStrength
        self.confidenceToResist = confidenceToResist
        self.emotions = emotions
        self.timestamp = timestamp
        self.isArchived = isArchived
    }
}
