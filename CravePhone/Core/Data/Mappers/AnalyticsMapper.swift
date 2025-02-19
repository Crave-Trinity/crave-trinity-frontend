// File: Core/Data/Mappers/AnalyticsMapper.swift

import Foundation

// Make the class public so it can be used in public APIs.
public final class AnalyticsMapper {
    // Public initializer so external code can create an instance.
    public init() {}
    
    // Public function to map a DTO to an AnalyticsEvent.
    public func mapToEntity(_ dto: AnalyticsDTO) -> any AnalyticsEvent {
        // Here, we directly use the computed property 'metadata' from the DTO.
        return ConcreteAnalyticsEvent(
            id: dto.id,
            timestamp: dto.timestamp,
            eventType: dto.eventType,
            metadata: dto.metadata
        )
    }
}

// Example concrete event type.
// This struct must be public because it's returned by the public mapper function.
public struct ConcreteAnalyticsEvent: AnalyticsEvent {
    public var id: UUID
    public var timestamp: Date
    public var eventType: String
    public var metadata: [String: Any]

    // Public initializer.
    public init(id: UUID, timestamp: Date, eventType: String, metadata: [String: Any]) {
        self.id = id
        self.timestamp = timestamp
        self.eventType = eventType
        self.metadata = metadata
    }
}
