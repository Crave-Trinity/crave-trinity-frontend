//
//  WatchHapticManager.swift
//  CraveWatch/Services
//
//  A singleton manager for triggering haptic feedback on the Apple Watch.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import WatchKit

/// A manager that provides a simple interface to trigger watchOS haptic feedback.
/// This is implemented as a singleton to allow easy access throughout the app.
class WatchHapticManager {
    
    /// The shared singleton instance of `WatchHapticManager`.
    static let shared = WatchHapticManager()
    
    /// Enum representing the different types of haptic feedback available.
    enum HapticType {
        /// Haptic feedback for a successful operation.
        case success
        /// Haptic feedback to indicate a warning.
        case warning
        /// Haptic feedback for selection changes.
        case selection
        /// Haptic feedback for notifications.
        case notification
    }
    
    /// Triggers the specified haptic feedback on the Apple Watch.
    ///
    /// - Parameter type: The type of haptic feedback to play.
    func play(_ type: HapticType) {
        switch type {
        case .success:
            WKInterfaceDevice.current().play(.success)
        case .warning:
            WKInterfaceDevice.current().play(.failure)
        case .selection:
            WKInterfaceDevice.current().play(.click)
        case .notification:
            WKInterfaceDevice.current().play(.notification)
        }
    }
}
