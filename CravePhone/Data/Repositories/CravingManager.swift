//
//  CravingManager.swift
//  CravePhone
//
//  Description:
//  Sample manager demonstrating fetch / insert / archive / delete in SwiftData.
//  We rely on 'isArchived' and 'timestamp' from CravingEntity.
//
import SwiftData
import Foundation

@MainActor
final class CravingManager {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Fetch cravings that have NOT been archived, sorted reverse-chronologically.
    func fetchActiveCravings() async throws -> [CravingEntity] {
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { !$0.isArchived },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    // Insert a new craving entity and save.
    func insert(_ entity: CravingEntity) async throws {
        modelContext.insert(entity)
        try await save()
    }

    // Archive the given craving (set isArchived = true).
    func archive(_ entity: CravingEntity) async throws {
        let entityId = entity.id
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { $0.id == entityId }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            existing.isArchived = true
            try await save()
        }
    }

    // Permanently delete an entity from the store.
    func delete(_ entity: CravingEntity) async throws {
        let entityId = entity.id
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { $0.id == entityId }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try await save()
        }
    }

    // Helper function to explicitly save.
    private func save() async throws {
        try modelContext.save()
    }
}
