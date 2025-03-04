//
//  AnalyticsRepositoryImpl.swift
//  CravePhone
//
//  Description:
//    Pulls real data from AnalyticsStorage, creates CravingEvent domain objects.
//    Also, upon logging a new craving, stores a matching AnalyticsDTO.
//
import Foundation

public final class AnalyticsRepositoryImpl: AnalyticsRepositoryProtocol {
    
    private let storage: AnalyticsStorageProtocol
    
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    public func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent] {
        let dtos = try await storage.fetchEvents(from: startDate, to: endDate)
        let cravingDtos = dtos.filter { $0.eventType == "CRAVING" } // or any event type you want
        return cravingDtos.map { dto in
            CravingEvent(
                id: dto.id,
                timestamp: dto.timestamp,
                eventType: dto.eventType,
                metadata: dto.metadata
            )
        }
    }
    
    public func storeCravingEvent(from craving: CravingEntity) async throws {
        // Build up metadata for aggregator usage
        var meta: [String: Any] = [
            "intensity": craving.cravingStrength,
            "resistance": craving.confidenceToResist,
            "emotions": craving.emotions
        ]
        
        // Set "resisted" if you wish:
        meta["resisted"] = (craving.confidenceToResist > 7.0) // Example logic
        
        let dto = AnalyticsDTO(
            id: UUID(),
            timestamp: craving.timestamp,
            eventType: "CRAVING",
            metadata: meta
        )
        try await storage.store(dto)
    }
}
