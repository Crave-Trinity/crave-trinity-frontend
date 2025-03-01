//
//  CravingRepository+UIExtensions.swift
//  CravePhone
//
//  Adapter extensions to bridge between repository method names and UI requirements.
//

import Foundation

// MARK: - Bridge methods for UI components
extension CravingRepository {
    // Maps fetchActiveCravings() to fetchCravings() for UI components
    func fetchCravings() async throws -> [CravingEntity] {
        return try await fetchActiveCravings()
    }
    
    // Maps addCraving() to saveCraving() for UI components
    func saveCraving(_ craving: CravingEntity) async throws -> CravingEntity {
        try await addCraving(craving)
        return craving
    }
}

