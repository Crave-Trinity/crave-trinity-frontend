// File: Core/Data/DataSources/Local/AnalyticsStorage.swift
// Description:
// This internal class implements the analytics storage functionality using SwiftData.
// It operates on AnalyticsDTO, which is now a proper @Model (and PersistentModel) type.
// All methods use AnalyticsDTO for inserting, fetching, and deleting data.

import Foundation
import SwiftData

internal final class AnalyticsStorage: AnalyticsStorageProtocol {
    private let modelContext: ModelContext
    
    internal init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func store(_ event: AnalyticsDTO) async throws {
        modelContext.insert(event)
        try modelContext.save()
    }
    
    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [AnalyticsDTO] {
        let predicate = #Predicate<AnalyticsDTO> {
            $0.timestamp >= startDate && $0.timestamp <= endDate
        }
        let descriptor = FetchDescriptor<AnalyticsDTO>(predicate: predicate, sortBy: [SortDescriptor(\AnalyticsDTO.timestamp)])
        return try modelContext.fetch(descriptor)
    }
    
    func fetchEvents(ofType eventType: String) async throws -> [AnalyticsDTO] {
        let predicate = #Predicate<AnalyticsDTO> {
            $0.eventType == eventType
        }
        let descriptor = FetchDescriptor<AnalyticsDTO>(predicate: predicate)
        return try modelContext.fetch(descriptor)
    }
    
    func fetchMetadata(forCravingId cravingId: UUID) async throws -> AnalyticsMetadata? {
        let predicate = #Predicate<AnalyticsMetadata> {
            $0.id == cravingId
        }
        let descriptor = FetchDescriptor<AnalyticsMetadata>(predicate: predicate)
        return try modelContext.fetch(descriptor).first
    }
    
    func update(metadata: AnalyticsMetadata) async throws {
        try modelContext.save()
    }
    
    func storeBatch(_ events: [AnalyticsDTO]) async throws {
        events.forEach { modelContext.insert($0) }
        try modelContext.save()
    }
    
    func cleanupData(before date: Date) async throws {
        let predicate = #Predicate<AnalyticsDTO> {
            $0.timestamp < date
        }
        try modelContext.delete(model: AnalyticsDTO.self, where: predicate)
        try modelContext.save()
    }
}

