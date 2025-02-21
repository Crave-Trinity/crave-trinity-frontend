// Core/Domain/Entities/Analytics/AnalyticsEntity.swift
import Foundation

public struct AnalyticsEntity {
    public let id: UUID
    public let eventType: String
    public let timestamp: Date
    public let metadata: [String: Any]

    public init(id: UUID = UUID(), eventType: String, timestamp: Date = Date(), metadata: [String: Any] = [:]) {
        self.id = id
        self.eventType = eventType
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

