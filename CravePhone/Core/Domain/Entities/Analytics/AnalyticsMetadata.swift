// File: AnalyticsMetadata.swift
// Description:
// This file defines the AnalyticsMetadata model used for analytics storage.
// It is marked public so it can be used in public API methods (e.g., in AnalyticsStorageProtocol).
// The nested UserAction struct is also explicitly marked public, ensuring that all types used
// in public method signatures are public, thus preventing any access level issues.

import SwiftData
import Foundation

@Model
public final class AnalyticsMetadata {
    // Unique identifier for the metadata.
    @Attribute(.unique) public var id: UUID
    
    // An optional array of user actions associated with this metadata.
    // UserAction is a public nested type.
    public var userActions: [UserAction]?
    
    // Public initializer.
    public init(id: UUID, userActions: [UserAction]? = nil) {
        self.id = id
        self.userActions = userActions
    }
    
    // Public nested type representing a user action.
    public struct UserAction: Codable {
        public var actionType: String
        public var timestamp: Date
        public var details: String?
        
        // Public initializer for UserAction.
        public init(actionType: String, timestamp: Date, details: String? = nil) {
            self.actionType = actionType
            self.timestamp = timestamp
            self.details = details
        }
    }
}
