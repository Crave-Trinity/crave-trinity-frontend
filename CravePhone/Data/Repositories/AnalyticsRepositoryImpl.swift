//
//  AnalyticsRepositoryImpl.swift
//  CravePhone
//
//  UNCLE BOB FIXED VERSION – ENSURES EVENTS ARE PROPERLY FETCHED BY DATE.
//  GOF / SOLID / CLEAN MVVM COMPLIANT. NO EXPLANATIONS, JUST WORKS.
//

import Foundation

public final class AnalyticsRepositoryImpl: AnalyticsRepository {
    private let storage: AnalyticsStorageProtocol
    
    public init(storage: AnalyticsStorageProtocol) {
        self.storage = storage
    }
    
    public func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent] {
        let dtos = try await storage.fetchEvents(from: startDate, to: endDate)
        return dtos
            .filter { $0.eventType == "CRAVING" }
            .map {
                CravingEvent(
                    id: $0.id,
                    timestamp: $0.timestamp,
                    eventType: $0.eventType,
                    metadata: $0.metadata
                )
            }
    }
    
    public func storeCravingEvent(from craving: CravingEntity) async throws {
        let meta: [String: Any] = [
            "intensity": craving.cravingStrength,
            "resistance": craving.confidenceToResist,
            "emotions": craving.emotions,
            "resisted": craving.confidenceToResist > 7.0
        ]

        let dto = AnalyticsDTO(
            id: UUID(), // ✅ CRITICAL FIX: explicitly added 'id'
            timestamp: craving.timestamp,
            eventType: "CRAVING",
            metadata: meta
        )
        
        try await storage.store(dto)
    }
}
