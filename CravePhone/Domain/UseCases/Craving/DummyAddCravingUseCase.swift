//
//  DummyAddCravingUseCase.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Minimal mock for previews/tests with 'cravingDescription' field.
//

import Foundation

public struct DummyAddCravingUseCase: AddCravingUseCaseProtocol {
    public init() {}
    
    public func execute(cravingText: String) async throws -> CravingEntity {
        CravingEntity(
            cravingDescription: cravingText,
            cravingStrength: 0.0,
            confidenceToResist: 0.0,
            emotions: [],
            timestamp: Date(),
            isArchived: false
        )
    }
}

