//
//  AnalyticsDTO.swift
//  CravePhone
//
//  UNCLE BOB FINAL “PASTE & RUN” VERSION – FIXES SERIALIZATION ISSUE.
//  NO DUPLICATE MODELS, NO REDECLARATIONS, CLEAN & WORKING.
//

import Foundation
import SwiftData

@Model
public final class AnalyticsDTO: Identifiable, Codable {

    // MARK: - Persisted Properties
    public var id: UUID
    public var timestamp: Date
    public var eventType: String
    public var metadataJSON: String

    // MARK: - Transient Computed Property
    @Transient
    public var metadata: [String: Any] {
        get {
            guard let data = metadataJSON.data(using: .utf8),
                  let raw = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("🚨 Failed to deserialize metadataJSON")
                return [:]
            }

            var result: [String: Any] = [:]

            result["intensity"] = (raw["intensity"] as? NSNumber)?.doubleValue ?? 0.0
            result["resistance"] = (raw["resistance"] as? NSNumber)?.doubleValue ?? 0.0
            result["resisted"] = raw["resisted"] as? Bool ?? false
            result["emotions"] = raw["emotions"] as? [String] ?? []

            return result
        }
        set {
            do {
                let data = try JSONSerialization.data(withJSONObject: newValue, options: [])
                metadataJSON = String(data: data, encoding: .utf8) ?? "{}"
            } catch {
                print("🚨 Failed to serialize metadata:", error)
                metadataJSON = "{}"
            }
        }
    }

    // MARK: - Initializer
    public init(
        id: UUID = UUID(),
        timestamp: Date,
        eventType: String,
        metadata: [String: Any] = [:]
    ) {
        self.id = id
        self.timestamp = timestamp
        self.eventType = eventType
        self.metadataJSON = "{}"
        self.metadata = metadata
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, timestamp, eventType, metadataJSON
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedID = try container.decode(UUID.self, forKey: .id)
        let decodedTS = try container.decode(Date.self, forKey: .timestamp)
        let decodedET = try container.decode(String.self, forKey: .eventType)
        let storedJSON = try container.decode(String.self, forKey: .metadataJSON)
        self.init(id: decodedID, timestamp: decodedTS, eventType: decodedET)
        self.metadataJSON = storedJSON
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(eventType, forKey: .eventType)
        try container.encode(metadataJSON, forKey: .metadataJSON)
    }
}
