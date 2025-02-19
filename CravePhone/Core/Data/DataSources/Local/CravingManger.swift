// Core/Data/DataSources/Local/CravingManager.swift
import Foundation
import SwiftData

@MainActor
final class CravingManager {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchActiveCravings() async throws -> [CravingEntity] {
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { !$0.isArchived },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func insert(_ entity: CravingEntity) async throws {
        modelContext.insert(entity)
        try await save()
    }

    func archive(_ entity: CravingEntity) async throws {
        let entityId = entity.id // Extract the ID here
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { $0.id == entityId } // Use the local constant
        )
        if let existing = try modelContext.fetch(descriptor).first {
            existing.isArchived = true
            try await save()
        }
    }

    func delete(_ entity: CravingEntity) async throws {
        let entityId = entity.id // Extract the ID here
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { $0.id == entityId } // Use the local constant
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

