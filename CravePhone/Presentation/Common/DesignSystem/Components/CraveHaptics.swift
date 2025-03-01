//
//  CraveHaptics.swift
//  CravePhone
//
//  Centralized haptic feedback service for consistent tactile responses.
//

import UIKit

public final class CraveHaptics {
    // Singleton instance
    public static let shared = CraveHaptics()
    
    // Private initialization to enforce singleton
    private init() {}
    
    // MARK: - Impact Feedback
    
    public func lightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    public func mediumImpact() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    public func heavyImpact() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    // MARK: - Selection Feedback
    
    public func selectionChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    // MARK: - Notification Feedback
    
    public func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    public func success() {
        notification(type: .success)
    }
    
    public func warning() {
        notification(type: .warning)
    }
    
    public func error() {
        notification(type: .error)
    }
}
