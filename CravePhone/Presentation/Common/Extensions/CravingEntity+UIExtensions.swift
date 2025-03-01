//
//  CravingEntity+UIExtensions.swift
//  CravePhone
//
//  Adapter extensions to bridge between model property names and UI requirements.
//

import Foundation

// MARK: - Bridge properties for UI components
extension CravingEntity {
    // Map cravingStrength to intensity for UI components
    var intensity: Double {
        return cravingStrength
    }
    
    // Map confidenceToResist to resistance for UI components
    var resistance: Double {
        return confidenceToResist
    }
    
    // Convenience initializer for previews and testing
    static func preview(
        id: UUID = UUID(),
        description: String = "Sample craving description",
        intensity: Double = 7.0,
        resistance: Double = 5.0,
        emotions: [String] = ["Stress", "Boredom"],
        timestamp: Date = Date(),
        isArchived: Bool = false
    ) -> CravingEntity {
        return CravingEntity(
            id: id,
            cravingDescription: description,
            cravingStrength: intensity,
            confidenceToResist: resistance,
            emotions: emotions,
            timestamp: timestamp,
            isArchived: isArchived
        )
    }
}
