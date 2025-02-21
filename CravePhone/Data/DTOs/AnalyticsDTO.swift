// File: Core/Data/DTOs/AnalyticsDTO.swift
// Description:
// This class represents the Analytics Data Transfer Object (DTO) that is persisted by SwiftData.
// It is annotated with @Model, which makes it conform to PersistentModel. We store complex metadata
// as a JSON string, and expose a computed property (marked @Transient) to work with a [String: Any] dictionary.

import Foundation
import SwiftData

@Model
public final class AnalyticsDTO: Identifiable, Codable {
    public var id: UUID
    public var timestamp: Date
    public var eventType: String
    private var metadataJSON: String  // Stored as a JSON string for persistence

    /// Computed property to get and set metadata as a [String: Any] dictionary.
    /// Marked with @Transient so that SwiftData ignores it during persistence.
    @Transient
    public var metadata: [String: Any] {
        get {
            guard let data = metadataJSON.data(using: .utf8) else { return [:] }
            return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] ?? [:]
        }
        set {
            if let data = try? JSONSerialization.data(withJSONObject: newValue, options: []),
               let jsonString = String(data: data, encoding: .utf8) {
                metadataJSON = jsonString
            } else {
                metadataJSON = "{}"
            }
        }
    }

    /// Public initializer. We first initialize metadataJSON to a default value before using the computed setter.
    public init(id: UUID, timestamp: Date, eventType: String, metadata: [String: Any]) {
        self.id = id
        self.timestamp = timestamp
        self.eventType = eventType
        self.metadataJSON = "{}"  // Initialize stored property first
        self.metadata = metadata // Then set metadata via the computed property
    }

    // MARK: - Codable Conformance

    enum CodingKeys: String, CodingKey {
        case id, timestamp, eventType, metadataJSON
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let timestamp = try container.decode(Date.self, forKey: .timestamp)
        let eventType = try container.decode(String.self, forKey: .eventType)
        let metadataJSON = try container.decode(String.self, forKey: .metadataJSON)
        self.init(id: id, timestamp: timestamp, eventType: eventType, metadata: [:])
        self.metadataJSON = metadataJSON
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(eventType, forKey: .eventType)
        try container.encode(metadataJSON, forKey: .metadataJSON)
    }
}
