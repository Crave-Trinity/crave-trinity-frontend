//
//  CRAVEDesignSystem.swift
//  CRAVE
//
//  Description:
//    A centralized design system for CRAVE. We add extra typography
//    and an orange color for "Log Craving" styling.
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today’s date>.
//

import SwiftUI

enum CRAVEDesignSystem {
    
    // MARK: - Colors
    enum Colors {
        // Core brand gradient (blue)
        static let brandGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
                Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Orange gradient if needed for the button
        static let cravingOrangeGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: 0.05, saturation: 0.9, brightness: 0.9),
                Color(hue: 0.0,  saturation: 0.9, brightness: 0.8)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Single orange color for "Log Craving" text
        static let cravingOrange = Color(hue: 0.05, saturation: 0.9, brightness: 0.9)
        
        // Main black background
        static let background = Color.black
        
        // Subtle card background
        static let cardBackground = Color.white.opacity(0.08)
        
        // Text
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.7)
        
        // Placeholders
        static let placeholderPrimary = Color.white.opacity(0.8)
        static let placeholderSecondary = Color.white.opacity(0.6)
        
        // Status Colors
        static let success = Color.green
        static let warning = Color.orange
        static let danger  = Color.red
        
        // Text on primary backgrounds
        static let textOnPrimary = Color.white
    }
    
    // MARK: - Typography
    enum Typography {
        // Larger heading (24pt bold)
        static let heading = Font.system(size: 24, weight: .bold)
        
        // Subheading (14pt semibold)
        static let subheading = Font.system(size: 14, weight: .semibold)
        
        // Body text (14pt regular)
        static let body = Font.system(size: 14, weight: .regular)
        
        // Placeholder text (12pt regular)
        static let placeholder = Font.system(size: 12, weight: .regular)
        
        // NEW: Smaller triggers for "Hungry/Angry/Lonely/Tired" (16pt semibold)
        static let triggerLabel = Font.system(size: 16, weight: .semibold)
        
        // NEW: Largest font for "Log Craving" label (28pt bold)
        static let largestCraving = Font.system(size: 28, weight: .bold)
        
        // If you want bigger button text (e.g. 20pt bold):
        static let buttonLarge = Font.system(size: 20, weight: .bold)
    }
    
    // MARK: - Layout
    enum Layout {
        static let standardPadding: CGFloat = 16
        static let cornerRadius: CGFloat    = 6
        static let buttonHeight: CGFloat    = 36
        static let textEditorMinHeight: CGFloat = 60
        
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 32
    }
    
    // MARK: - Animations
    enum Animation {
        static let standardDuration = 0.3
        static let quickDuration    = 0.15
    }
    
    // MARK: - Haptics
    enum Haptics {
        private static let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
        private static let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
        private static let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
        private static let selectionGenerator = UISelectionFeedbackGenerator()
        private static let notificationGenerator = UINotificationFeedbackGenerator()
        
        static func prepareAll() {
            lightImpactGenerator.prepare()
            mediumImpactGenerator.prepare()
            heavyImpactGenerator.prepare()
            selectionGenerator.prepare()
            notificationGenerator.prepare()
        }
        
        static func lightImpact() {
            lightImpactGenerator.impactOccurred()
        }
        
        static func mediumImpact() {
            mediumImpactGenerator.impactOccurred()
        }
        
        static func heavyImpact() {
            heavyImpactGenerator.impactOccurred()
        }
        
        static func selectionChanged() {
            selectionGenerator.selectionChanged()
        }
        
        static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
            notificationGenerator.notificationOccurred(type)
        }
    }
}

