//
//  AnalyticsRepositoryImpl.swift
//  CravePhone
//
//  Uncle Bob: A Repository acts as a gateway for data retrieval/storage.
//  This implementation specifically handles all Analytics-related CRUD
//  for CRAVING events.
//
import Foundation
public final class AnalyticsRepositoryImpl: AnalyticsRepository {
    // MARK: - Dependencies
    private let storage: AnalyticsStorageProtocol
    
    // MARK: - Initialization
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    // MARK: - Public Methods
    
    /// Retrieves all CRAVING events within a specific time window.
    public func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent] {
        // Fetch from storage
        let dtos = try await storage.fetchEvents(from: startDate, to: endDate)
        
        // Filter out only "CRAVING" event types
        let cravingDtos = dtos.filter { $0.eventType == "CRAVING" }
        
        // Convert each DTO into a domain CravingEvent
        return cravingDtos.map { dto in
            CravingEvent(
                id: dto.id,
                timestamp: dto.timestamp,
                eventType: dto.eventType,
                metadata: dto.metadata
            )
        }
    }
    
    /// Converts a CravingEntity into a CRAVING AnalyticsDTO and stores it.
    public func storeCravingEvent(from craving: CravingEntity) async throws {
        // Build out your metadata
        var meta: [String: Any] = [
            "intensity": craving.cravingStrength,
            "resistance": craving.confidenceToResist,
            "emotions": craving.emotions
        ]
        // Example logic: Mark it as "resisted" if confidence > 7
        meta["resisted"] = (craving.confidenceToResist > 7.0)
        
        // Create the DTO
        let dto = AnalyticsDTO(
            id: UUID(),
            timestamp: craving.timestamp,
            eventType: "CRAVING",
            metadata: meta
        )
        
        // Persist it
        try await storage.store(dto)
    }
}
