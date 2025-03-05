//
//  AnalyticsDTO.swift
//  CravePhone
//
//  UNCLE BOB FIXED VERSION – REMOVED @Attribute(.storage(.string)) FOR SWIFTDATA COMPATIBILITY.
//  GOF / SOLID / CLEAN MVVM COMPLIANT. NO EXPLANATIONS, JUST WORKS.
//

import Foundation
import SwiftData

@Model
public final class AnalyticsDTO: Identifiable, Codable {

    // MARK: - Persisted Properties
    @Attribute(.unique)
    public var id: UUID

    public var timestamp: Date
    public var eventType: String

    // Just store as String. SwiftData doesn’t support storage(.string).
    public var metadataJSON: String

    // MARK: - Transient Computed Property
    @Transient
    public var metadata: [String: Any] {
        get {
            guard
                let data = metadataJSON.data(using: .utf8),
                let raw = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else {
                return [:]
            }
            return [
                "intensity": (raw["intensity"] as? NSNumber)?.doubleValue ?? 0.0,
                "resistance": (raw["resistance"] as? NSNumber)?.doubleValue ?? 0.0,
                "resisted": raw["resisted"] as? Bool ?? false,
                "emotions": raw["emotions"] as? [String] ?? []
            ]
        }
        set {
            do {
                let data = try JSONSerialization.data(withJSONObject: newValue, options: [])
                metadataJSON = String(data: data, encoding: .utf8) ?? "{}"
            } catch {
                metadataJSON = "{}"
            }
        }
    }

    // MARK: - SwiftData Initializer
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
        case id
        case timestamp
        case eventType
        case metadataJSON
    }

    public convenience init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let decodedID = try c.decode(UUID.self, forKey: .id)
        let decodedTS = try c.decode(Date.self, forKey: .timestamp)
        let decodedET = try c.decode(String.self, forKey: .eventType)
        let storedJSON = try c.decode(String.self, forKey: .metadataJSON)
        self.init(id: decodedID, timestamp: decodedTS, eventType: decodedET)
        self.metadataJSON = storedJSON
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(timestamp, forKey: .timestamp)
        try c.encode(eventType, forKey: .eventType)
        try c.encode(metadataJSON, forKey: .metadataJSON)
    }
}
