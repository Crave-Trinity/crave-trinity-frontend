
//==============================================================
//  File C: WatchHapticManager.swift
//  Description:
//    Provides watch-specific haptic feedback via WKInterfaceDevice.
//
//  Usage:
//    - Call WatchHapticManager.shared.play(.success), .warning, or .selection
//      to trigger standard watchOS haptics.
//==============================================================

import WatchKit

class WatchHapticManager {
    static let shared = WatchHapticManager()
    
    enum HapticType {
        case success
        case warning
        case selection
    }
    
    /// Triggers the specified watchOS haptic feedback.
    func play(_ type: HapticType) {
        switch type {
        case .success:
            WKInterfaceDevice.current().play(.success)
        case .warning:
            WKInterfaceDevice.current().play(.failure)
        case .selection:
            WKInterfaceDevice.current().play(.click)
        }
    }
}



