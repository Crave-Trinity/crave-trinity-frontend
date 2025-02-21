// File: Core/Domain/Entities/Analytics/AnalyticsEvent.swift
// Description:
// This public protocol defines the required properties for any analytics event.
// Conforming types must provide an identifier, timestamp, event type, and metadata.
import Foundation

public protocol AnalyticsEvent {
    var id: UUID { get }
    var timestamp: Date { get }
    var eventType: String { get }
    var metadata: [String: Any] { get }  // Must be implemented by concrete events.
}
