//
//  DummyAddCravingUseCase.swift
//  CravePhone
//
//  Description:
//    A dummy implementation of AddCravingUseCaseProtocol for preview purposes.
//    This simulates a successful craving log by returning a dummy CravingEntity.
//    Created by ChatGPT on <today’s date>.
//
//  Uncle Bob & SOLID:
//    - Single Responsibility: This dummy use case only simulates adding a craving.
//    - Open/Closed: It can be replaced with a real implementation without affecting other layers.
//
import Foundation

public struct DummyAddCravingUseCase: AddCravingUseCaseProtocol {
    public init() {}

    public func execute(cravingText: String) async throws -> CravingEntity {
        // Return a new CravingEntity with the provided text.
        // Default values (0.0) are used for both 'confidenceToResist' and 'cravingStrength'.
        return CravingEntity(text: cravingText, confidenceToResist: 0.0, cravingStrength: 0.0)
    }
}
