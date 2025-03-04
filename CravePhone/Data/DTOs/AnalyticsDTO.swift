//
//  AnalyticsDTO.swift
//  CravePhone
//
//  Description:
//    A SwiftData @Model that stores analytics data for aggregator usage.
//    We store extra fields in metadataJSON so it's easy to expand later.
//
import Foundation
import SwiftData

@Model
public final class AnalyticsDTO: Identifiable, Codable {
    public var id: UUID
    public var timestamp: Date
    public var eventType: String
    
    private var metadataJSON: String
    
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
        self.metadata = metadata
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, timestamp, eventType, metadataJSON
    }
    
    public convenience init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let id = try c.decode(UUID.self, forKey: .id)
        let ts = try c.decode(Date.self, forKey: .timestamp)
        let et = try c.decode(String.self, forKey: .eventType)
        let mj = try c.decode(String.self, forKey: .metadataJSON)
        self.init(id: id, timestamp: ts, eventType: et, metadata: [:])
        self.metadataJSON = mj
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(timestamp, forKey: .timestamp)
        try c.encode(eventType, forKey: .eventType)
        try c.encode(metadataJSON, forKey: .metadataJSON)
    }
}
