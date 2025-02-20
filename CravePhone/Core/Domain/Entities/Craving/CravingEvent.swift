//
//  CravingEvent.swift
//  CravePhone
//
//  Description:
//    A domain entity representing a single craving event,
//    conforming to your AnalyticsEvent protocol (if needed).
//

import Foundation

public struct CravingEvent: AnalyticsEvent {
    public let id: UUID
    public let timestamp: Date
    public let cravingEntity: CravingEntity

    // If your AnalyticsEvent protocol requires these:
    public var eventType: String { "interaction" }
    public var metadata: [String: Any] { [:] }

    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        cravingEntity: CravingEntity
    ) {
        self.id = id
        self.timestamp = timestamp
        self.cravingEntity = cravingEntity
    }
}
