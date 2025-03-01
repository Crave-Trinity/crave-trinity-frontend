//
//  CravingRepository.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Defines persistence operations for CravingEntity.
//   - Separate interface ensures easy swapping of implementations.
//

import Foundation

public protocol CravingRepository {
    func addCraving(_ craving: CravingEntity) async throws
    func fetchActiveCravings() async throws -> [CravingEntity]
    func archiveCraving(_ craving: CravingEntity) async throws
    func deleteCraving(_ craving: CravingEntity) async throws
}

