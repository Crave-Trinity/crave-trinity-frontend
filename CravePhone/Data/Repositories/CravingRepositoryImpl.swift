// File: Core/Data/Repositories/CravingRepositoryImpl.swift

import Foundation
import SwiftData

@MainActor
internal final class CravingRepositoryImpl: CravingRepository {
    private let cravingManager: CravingManager
    
    internal init(cravingManager: CravingManager) {
        self.cravingManager = cravingManager
    }
    
    // MARK: - CravingRepository protocol conformance
    // These can be internal because the class is internal and we only need to satisfy the public protocol internally.
    func fetchAllActiveCravings() async throws -> [CravingEntity] {
        try await cravingManager.fetchActiveCravings()
    }
    
    func addCraving(_ craving: CravingEntity) async throws {
        try await cravingManager.insert(craving)
    }
    
    func archiveCraving(_ craving: CravingEntity) async throws {
        try await cravingManager.archive(craving)
    }
    
    func deleteCraving(_ craving: CravingEntity) async throws {
        try await cravingManager.delete(craving)
    }
}
