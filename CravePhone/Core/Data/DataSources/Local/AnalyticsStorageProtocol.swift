// Core/Data/DataSources/Local/AnalyticsStorageProtocol.swift
import Foundation
import SwiftData

public protocol AnalyticsStorageProtocol {
    // Stores a single AnalyticsDTO.
    func store(_ event: AnalyticsDTO) async throws
    
    // Fetches AnalyticsDTO objects within the specified date range.
    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [AnalyticsDTO]
    
    // Fetches AnalyticsDTO objects for a specific event type.
    func fetchEvents(ofType eventType: String) async throws -> [AnalyticsDTO]
    
    // Fetches AnalyticsMetadata for a specific craving.
    func fetchMetadata(forCravingId cravingId: UUID) async throws -> AnalyticsMetadata?
    
    // Updates the provided analytics metadata.
    func update(metadata: AnalyticsMetadata) async throws
    
    // Stores a batch of AnalyticsDTO objects.
    func storeBatch(_ events: [AnalyticsDTO]) async throws
    
    // Cleans up (deletes) data older than the specified date.
    func cleanupData(before date: Date) async throws
}


