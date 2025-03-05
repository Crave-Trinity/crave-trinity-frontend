//
//  AnalyticsDTO.swift
//  CravePhone
//
//  UNCLE BOB FINAL “PASTE & RUN” VERSION – WORKS WITH SWIFTDATA.
//  FIXED SO ANALYTICS VALUES DON’T STAY ZERO. NO EXPLANATIONS, JUST WORKS.
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
            guard let data = metadataJSON.data(using: .utf8) else {
                print("🚨 Failed to convert metadataJSON to data")
                return [:]
            }
            
            guard let raw = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("🚨 Failed to deserialize metadataJSON")
                return [:]
            }
            
            var result: [String: Any] = [:]
            
            // Properly handle intensity
            if let intensity = raw["intensity"] {
                if let number = intensity as? NSNumber {
                    result["intensity"] = number.doubleValue
                } else if let string = intensity as? String, let doubleValue = Double(string) {
                    result["intensity"] = doubleValue
                }
            }
            
            // Properly handle resistance
            if let resistance = raw["resistance"] {
                if let number = resistance as? NSNumber {
                    result["resistance"] = number.doubleValue
                } else if let string = resistance as? String, let doubleValue = Double(string) {
                    result["resistance"] = doubleValue
                }
            }
            
            // Handle resisted flag
            if let resisted = raw["resisted"] as? Bool {
                result["resisted"] = resisted
            }
            
            // Handle emotions array
            if let emotions = raw["emotions"] as? [String] {
                result["emotions"] = emotions
            }
            
            return result
        }
        set {
            do {
                // Ensure numeric values are properly serialized
                var safeMetadata: [String: Any] = [:]
                
                // Safely handle numeric values
                if let intensity = newValue["intensity"] {
                    if let double = intensity as? Double {
                        safeMetadata["intensity"] = double
                    } else if let number = intensity as? NSNumber {
                        safeMetadata["intensity"] = number.doubleValue
                    }
                }
                
                if let resistance = newValue["resistance"] {
                    if let double = resistance as? Double {
                        safeMetadata["resistance"] = double
                    } else if let number = resistance as? NSNumber {
                        safeMetadata["resistance"] = number.doubleValue
                    }
                }
                
                // Handle boolean and array values directly
                if let resisted = newValue["resisted"] as? Bool {
                    safeMetadata["resisted"] = resisted
                }
                
                if let emotions = newValue["emotions"] as? [String] {
                    safeMetadata["emotions"] = emotions
                }
                
                let data = try JSONSerialization.data(withJSONObject: safeMetadata, options: [])
                metadataJSON = String(data: data, encoding: .utf8) ?? "{}"
            } catch {
                print("🚨 Failed to serialize metadata: \(error)")
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
        case id, timestamp, eventType, metadataJSON
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
