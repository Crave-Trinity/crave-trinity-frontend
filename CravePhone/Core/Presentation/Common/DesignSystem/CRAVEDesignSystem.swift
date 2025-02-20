//
//  CRAVEDesignSystem.swift
//  CRAVE
//
//  Description:
//    A centralized design system for CRAVE, inspired by the watch’s
//    dark aesthetic and premium blue gradient.
//    Updated to match a watch-like, “Steve Jobs–approved” style.
//
//  Step 1: Refine typography and layout for minimal, bold watch-like design.
//

import UIKit
import SwiftUI

enum CRAVEDesignSystem {
    
    // MARK: - Colors
    enum Colors {
        // Core brand gradient: “Premium Blue”
        // Matches the watch’s top-to-bottom gradient.
        static let brandGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
                Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Main background is black to mimic the watch’s dark interface
        static let background = Color.black
        
        // A subtle card background, matching the watch’s 0.08 white overlay
        static let cardBackground = Color.white.opacity(0.08)
        
        // White text on black background for primary content
        static let textPrimary = Color.white
        // Slightly translucent white for secondary text
        static let textSecondary = Color.white.opacity(0.7)
        
        // For placeholders, which on the watch are also a bit translucent
        static let placeholderPrimary = Color.white.opacity(0.8)
        static let placeholderSecondary = Color.white.opacity(0.6)
        
        // If you need a fallback “solid” primary color (non-gradient):
        static let solidPrimary = Color(hue: 0.58, saturation: 0.8, brightness: 0.7)
        
        // Status Colors (you can darken these if you prefer)
        static let success = Color.green
        static let warning = Color.orange
        static let danger  = Color.red
        
        // textOnPrimary for text displayed on primary elements (e.g., buttons).
        static let textOnPrimary = textPrimary
    }
    
    // MARK: - Typography
    enum Typography {
        // Larger heading for watch-like emphasis
        static let heading = Font.system(size: 24, weight: .bold)
        
        // Subheading for smaller labels (reduced to 14 for minimal watch style)
        static let subheading = Font.system(size: 14, weight: .semibold)
        
        // Body text (reduced to 14 for consistency)
        static let body = Font.system(size: 14, weight: .regular)
        
        // Placeholder text (kept at 12, slightly smaller than body)
        static let placeholder = Font.system(size: 12, weight: .regular)
    }
    
    // MARK: - Layout
    enum Layout {
        // Stick to a consistent grid – the watch UI is pretty compact.
        // Keep 16 for standardPadding, or reduce further if you want an even tighter look.
        static let standardPadding: CGFloat = 16
        
        // Slightly smaller corner radius for a watch-like feel
        static let cornerRadius: CGFloat = 6
        
        // Reduced button height from 44 to 36 for watch-like minimalism
        static let buttonHeight: CGFloat = 36
        
        // Minimum height for text editor, can be lowered or removed if you want an even smaller text box
        static let textEditorMinHeight: CGFloat = 60
        
        // Additional spacing if needed
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 32
    }
    
    // MARK: - Animations
    enum Animation {
        // Keep these subtle and purposeful.
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
        
        // Uncomment at app launch if you want to pre-warm all haptics:
        // CRAVEDesignSystem.Haptics.prepareAll()
    }
}

