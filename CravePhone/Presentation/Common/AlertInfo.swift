//
//  AlertInfo.swift
//  CravePhone
//
//  Single source of truth for shared alert information.
//  Clean, SOLID, and designed for clarity—just as Uncle Bob and Steve Jobs would want.
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
