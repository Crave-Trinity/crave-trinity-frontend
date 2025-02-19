//
//  WatchHapticManager.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: Provides watch-specific haptic feedback.
import WatchKit

class WatchHapticManager {
    static let shared = WatchHapticManager()
    
    enum HapticType { case success, warning, selection }
    
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
