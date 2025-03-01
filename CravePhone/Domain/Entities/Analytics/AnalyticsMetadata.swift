//
//  AnalyticsMetadata.swift
//  CravePhone
//
//  Description:
//  Example SwiftData model for analytics metadata, also as a final class.
//
import SwiftData
import Foundation

@Model
public final class AnalyticsMetadata {
    
    // Unique identifier for the metadata.
    @Attribute(.unique)
    public var id: UUID
    
    // Optional array of user actions. Must be Codable if we want to store them as transformable.
    public var userActions: [UserAction]?
    
    // Required public initializer for a final class with custom stored properties.
    public init(id: UUID, userActions: [UserAction]? = nil) {
        self.id = id
        self.userActions = userActions
    }
    
    // Nested struct representing a user action. It's Codable so SwiftData can persist it.
    public struct UserAction: Codable {
        public var actionType: String
        public var timestamp: Date
        public var details: String?
        
        public init(actionType: String, timestamp: Date, details: String? = nil) {
            self.actionType = actionType
            self.timestamp = timestamp
            self.details = details
        }
    }
}
