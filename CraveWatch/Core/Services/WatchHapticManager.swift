//
//  WatchHapticManager.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A simple manager for watch haptic feedback.
//

import WatchKit

class WatchHapticManager {
    static let shared = WatchHapticManager()

    enum HapticType {
        case success
        case warning
        case selection
    }

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
