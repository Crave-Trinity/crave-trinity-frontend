//
//  CraveHaptics.swift
//  CRAVE
//
//  Description:
//    A dedicated class for haptic feedback. Testable via a protocol.
//    Single Responsibility: separate from design tokens.
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today’s date>.
//

import SwiftUI
import UIKit

public protocol HapticFeedbackProviding {
    func prepareAll()
    func lightImpact()
    func mediumImpact()
    func heavyImpact()
    func selectionChanged()
    func notification(type: UINotificationFeedbackGenerator.FeedbackType)
}

public final class CraveHaptics: HapticFeedbackProviding {
    
    // MARK: - Generators
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    // Singleton or instance-based approach
    public static let shared = CraveHaptics()
    
    private init() { /* Intentionally private for singleton pattern */ }
    
    // MARK: - Public Methods
    
    public func prepareAll() {
        lightImpactGenerator.prepare()
        mediumImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        selectionGenerator.prepare()
        notificationGenerator.prepare()
    }
    
    public func lightImpact() {
        lightImpactGenerator.impactOccurred()
    }
    
    public func mediumImpact() {
        mediumImpactGenerator.impactOccurred()
    }
    
    public func heavyImpact() {
        heavyImpactGenerator.impactOccurred()
    }
    
    public func selectionChanged() {
        selectionGenerator.selectionChanged()
    }
    
    public func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.notificationOccurred(type)
    }
}
