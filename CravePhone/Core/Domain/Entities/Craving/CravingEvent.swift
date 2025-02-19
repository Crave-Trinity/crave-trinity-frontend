// File: Core/Domain/Entities/Craving/CravingEvent.swift
// Description:
// This struct represents a craving event and conforms to the AnalyticsEvent protocol.
// Instead of using an undefined `EventType`, we provide a computed property `eventType`
// that returns a string (e.g. "interaction"). We also provide a computed property `metadata`
// to satisfy the AnalyticsEvent protocol, returning an empty dictionary by default.

import Foundation

public struct CravingEvent: AnalyticsEvent {
    public let id: UUID
    public let timestamp: Date
    public let cravingEntity: CravingEntity

    // Conformance to AnalyticsEvent: return a string representing the event type.
    public var eventType: String {
        return "interaction"
    }
    
    // Conformance to AnalyticsEvent: if no metadata exists for a craving event,
    // we return an empty dictionary. Modify as needed to include real metadata.
    public var metadata: [String: Any] {
        return [:]
    }
    
    // Public initializer.
    public init(id: UUID = UUID(), timestamp: Date = Date(), cravingEntity: CravingEntity) {
        self.id = id
        self.timestamp = timestamp
        self.cravingEntity = cravingEntity
    }
}
