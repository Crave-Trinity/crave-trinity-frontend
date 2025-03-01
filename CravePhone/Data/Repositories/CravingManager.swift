//
//  CravingManager.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Public final class for injection into CravingRepositoryImpl.
//   - No label conflicts remain.
//

import SwiftData
import Foundation

@MainActor
public final class CravingManager {
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func fetchActiveCravings() async throws -> [CravingEntity] {
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { !$0.isArchived },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func insert(_ entity: CravingEntity) async throws {
        modelContext.insert(entity)
        try await save()
    }
    
    public func archive(_ entity: CravingEntity) async throws {
        let entityId = entity.id
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { $0.id == entityId }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            existing.isArchived = true
            try await save()
        }
    }
    
    public func delete(_ entity: CravingEntity) async throws {
        let entityId = entity.id
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { $0.id == entityId }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try await save()
        }
    }
    
    private func save() async throws {
        try modelContext.save()
    }
}

