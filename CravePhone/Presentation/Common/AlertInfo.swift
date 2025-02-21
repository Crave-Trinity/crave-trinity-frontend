//
//  AlertInfo.swift
//  CravePhone
//
//  Description:
//    A single, shared struct for user-facing alerts.
//    All ViewModels can reference this to display messages.
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
