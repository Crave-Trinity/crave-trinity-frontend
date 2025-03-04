//
//  CravingEvent.swift
//  CravePhone
//
//  Description:
//    A domain struct that represents a craving from the aggregator's perspective.
//
import Foundation

public struct CravingEvent: AnalyticsEvent {
    public let id: UUID
    public let timestamp: Date
    public let eventType: String
    public let metadata: [String: Any]
    
    public init(
        id: UUID,
        timestamp: Date,
        eventType: String,
        metadata: [String: Any]
    ) {
        self.id = id
        self.timestamp = timestamp
        self.eventType = eventType
        self.metadata = metadata
    }
}
