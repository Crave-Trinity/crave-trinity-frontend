//
//  AnalyticsRepositoryImpl.swift
//  CravePhone
//
//  Description:
//   Implements AnalyticsRepositoryProtocol to retrieve analytics events and store new ones.
//   It converts stored AnalyticsDTO objects into CravingEvent domain objects.
//   (Uncle Bob style: Separate persistence from domain logic.)
//

import Foundation

public final class AnalyticsRepositoryImpl: AnalyticsRepositoryProtocol {
    private let storage: AnalyticsStorageProtocol
    
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    // Fetch analytics events, filtering for events of type "CRAVING".
    public func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent] {
        let dtos = try await storage.fetchEvents(from: startDate, to: endDate)
        let cravingDtos = dtos.filter { $0.eventType == "CRAVING" }
        return cravingDtos.map { dto in
            CravingEvent(
                id: dto.id,
                timestamp: dto.timestamp,
                eventType: dto.eventType,
                metadata: dto.metadata
            )
        }
    }
    
    // Store a new analytics record derived from a CravingEntity.
    public func storeCravingEvent(from craving: CravingEntity) async throws {
        // Build metadata from the craving.
        var meta: [String: Any] = [
            "intensity": craving.cravingStrength,
            "resistance": craving.confidenceToResist,
            "emotions": craving.emotions
        ]
        // Example: Mark as resisted if confidence is high.
        meta["resisted"] = (craving.confidenceToResist > 7.0)
        
        let dto = AnalyticsDTO(
            id: UUID(),
            timestamp: craving.timestamp,
            eventType: "CRAVING",
            metadata: meta
        )
        try await storage.store(dto)
    }
}
