//
//  CravingRepositoryImpl.swift
//  CravePhone
//
//  SwiftData storage implementation.
//  The new fields (location, people, trigger) are automatically persisted
//  because CravingEntity is updated with them.
//
import SwiftData
import Foundation

@MainActor
public final class CravingRepositoryImpl: CravingRepository {
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func addCraving(_ craving: CravingEntity) async throws {
        // Insert new entity with location/people/trigger included
        modelContext.insert(craving)
        try modelContext.save()
    }
    
    public func fetchActiveCravings() async throws -> [CravingEntity] {
        let descriptor = FetchDescriptor<CravingEntity>(
            predicate: #Predicate<CravingEntity> { !$0.isArchived },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func archiveCraving(_ craving: CravingEntity) async throws {
        craving.isArchived = true
        try modelContext.save()
    }
    
    public func deleteCraving(_ craving: CravingEntity) async throws {
        modelContext.delete(craving)
        try modelContext.save()
    }
}
