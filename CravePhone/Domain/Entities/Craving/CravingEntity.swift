//
//  CravingEntity.swift
//  CravePhone
//
//  Description:
//  A SwiftData model representing a craving entry, stored as a final class.
//
//  Key points:
//  - Must be a final class if you want to reference it as a PersistentModel.
//  - We add 'isArchived' and 'timestamp' to match your CravingManager fetch queries.
//  - Provide a public init for SwiftData's code generation.
//
import SwiftData
import Foundation

@Model
public final class CravingEntity {
    
    // Unique identifier (primary key).
    @Attribute(.unique)
    public var id: UUID
    
    // Core properties.
    public var text: String
    public var confidenceToResist: Double
    public var cravingStrength: Double
    
    // Additional fields your CravingManager references:
    public var isArchived: Bool
    public var timestamp: Date
    
    // SwiftData requires an initializer for final classes with these stored properties.
    public init(
        id: UUID = UUID(),
        text: String,
        confidenceToResist: Double,
        cravingStrength: Double,
        timestamp: Date = Date(),
        isArchived: Bool = false
    ) {
        self.id = id
        self.text = text
        self.confidenceToResist = confidenceToResist
        self.cravingStrength = cravingStrength
        self.timestamp = timestamp
        self.isArchived = isArchived
    }
}
