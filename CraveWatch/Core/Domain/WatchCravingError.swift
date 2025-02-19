//
//  WatchCravingError.swift
//  CraveWatch
//
//  Created by John H Jung on <date>.
//  Description: A watch-specific error type for watch-based craving features.
//

import Foundation

public struct WatchCravingError: Identifiable, Error {
    public let id = UUID()
    public let message: String

    public init(message: String) {
        self.message = message
    }
}
