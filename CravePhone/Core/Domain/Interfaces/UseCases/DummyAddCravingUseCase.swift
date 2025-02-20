//
//  DummyAddCravingUseCase.swift
//  CravePhone
//
//  Description:
//    A dummy implementation of AddCravingUseCaseProtocol for preview purposes.
//    This simulates a successful craving log by returning a dummy CravingEntity.
//    Created by ChatGPT on <today’s date>.
//

import Foundation

public struct DummyAddCravingUseCase: AddCravingUseCaseProtocol {
    public init() {}

    public func execute(cravingText: String) async throws -> CravingEntity {
        // Simply return a new CravingEntity with the provided text.
        return CravingEntity(text: cravingText)
    }
}

