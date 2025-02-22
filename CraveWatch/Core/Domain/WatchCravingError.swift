//
//  WatchCravingError.swift
//  CraveWatch
//
//  A watch-specific error type used for handling errors related to craving operations.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation

/// A structured error type for handling watch craving-related errors.
/// Conforms to `Identifiable` and `Error` protocols for better error management and display.
public struct WatchCravingError: Identifiable, Error {
    
    /// Unique identifier for the error instance.
    public let id = UUID()
    
    /// A descriptive message explaining the error.
    public let message: String

    /// Initializes a new instance of `WatchCravingError` with a provided error message.
    ///
    /// - Parameter message: A string describing the error.
    public init(message: String) {
        self.message = message
    }
}

