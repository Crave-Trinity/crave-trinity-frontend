//=================================================================
// 6) CravingRepositoryImpl.swift
//    CravePhone/Data/Repositories/CravingRepositoryImpl.swift
//
//  PURPOSE:
//  - Basic repository for cravings, using CravingManager or a DB approach.
//  - Does not talk directly to the backend in this example.
//
//=================================================================

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
