//
//  AlertInfo.swift
//  CravePhone
//
//  Standardized alert information for consistent error handling UI.
//

import Foundation

public struct AlertInfo: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
