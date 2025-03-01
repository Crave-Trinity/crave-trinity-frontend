//
//  CravingRepositoryImpl.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Updated call to constructor: 'manager:' instead of 'cravingManager:' in DependencyContainer.
//   - No further changes needed.
//

import Foundation

@MainActor
public final class CravingRepositoryImpl: CravingRepository {
    private let manager: CravingManager
    
    public init(manager: CravingManager) {
        self.manager = manager
    }
    
    public func addCraving(_ craving: CravingEntity) async throws {
        try await manager.insert(craving)
    }
    
    public func fetchActiveCravings() async throws -> [CravingEntity] {
        try await manager.fetchActiveCravings()
    }
    
    public func archiveCraving(_ craving: CravingEntity) async throws {
        try await manager.archive(craving)
    }
    
    public func deleteCraving(_ craving: CravingEntity) async throws {
        try await manager.delete(craving)
    }
}

