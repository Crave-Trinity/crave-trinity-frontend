//
//  AnalyticsDTO.swift
//  CravePhone
//
//  ✅ FINAL CORRECTED & FULLY COMMENTED VERSION
//  Explicitly fixes subtle serialization/deserialization issues.
//  Uncle Bob approved: single responsibility, explicit clarity.
//

import Foundation
import SwiftData

@Model
public final class AnalyticsDTO: Identifiable, Codable {
    
    // MARK: - Persisted Properties
    public var id: UUID                 // Unique identifier for analytics entry
    public var timestamp: Date          // Exact time analytics event was logged
    public var eventType: String        // Explicit event type ("CRAVING")
    
    // Stored explicitly as JSON string to allow future flexibility
    private var metadataJSON: String
    
    // MARK: - Computed Transient Metadata
    // Transient properties are NOT persisted explicitly by SwiftData,
    // thus we manually handle serialization/deserialization to metadataJSON.
    @Transient
    public var metadata: [String: Any] {
        get {
            guard let data = metadataJSON.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("⚠️ Metadata decoding explicitly failed. Returning empty dictionary.")
                return [:]
            }

            // Explicitly decode values safely from stored JSON:
            var safeMetadata: [String: Any] = [:]
            safeMetadata["intensity"] = (json["intensity"] as? NSNumber)?.doubleValue ?? 0.0
            safeMetadata["resistance"] = (json["resistance"] as? NSNumber)?.doubleValue ?? 0.0
            safeMetadata["resisted"] = json["resisted"] as? Bool ?? false
            safeMetadata["emotions"] = json["emotions"] as? [String] ?? []

            return safeMetadata
        }
        set {
            do {
                // Explicitly serialize metadata dictionary to JSON:
                let data = try JSONSerialization.data(withJSONObject: newValue, options: [])
                metadataJSON = String(data: data, encoding: .utf8) ?? "{}"
            } catch {
                print("🚨 Metadata encoding explicitly failed with error:", error)
                metadataJSON = "{}"
            }
        }
    }
    
    // MARK: - Standard Initializer (Explicitly Corrected)
    public init(
        id: UUID,
        timestamp: Date,
        eventType: String,
        metadata: [String: Any]
    ) {
        self.id = id
        self.timestamp = timestamp
        self.eventType = eventType
        self.metadataJSON = "{}"
        self.metadata = metadata  // Automatically sets metadataJSON explicitly
    }
    
    // MARK: - Codable Conformance (Explicitly Corrected)
    enum CodingKeys: String, CodingKey {
        case id, timestamp, eventType, metadataJSON
    }
    
    // Explicit decoding initializer for Codable protocol:
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Explicitly decode each required property:
        let id = try container.decode(UUID.self, forKey: .id)
        let timestamp = try container.decode(Date.self, forKey: .timestamp)
        let eventType = try container.decode(String.self, forKey: .eventType)
        let metadataJSON = try container.decode(String.self, forKey: .metadataJSON)
        
        // Initialize explicitly with empty metadata first, then set metadataJSON directly:
        self.init(id: id, timestamp: timestamp, eventType: eventType, metadata: [:])
        self.metadataJSON = metadataJSON
    }
    
    // Explicit encoding method for Codable protocol:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Explicitly encode each persisted property:
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(eventType, forKey: .eventType)
        try container.encode(metadataJSON, forKey: .metadataJSON)
    }
}
