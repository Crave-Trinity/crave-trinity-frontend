//
//  CRAVEDesignSystem.swift
//  CRAVE
//
//  Description:
//    A centralized design system for CRAVE (colors, fonts, layout).
//    All haptic logic is now separated into CraveHaptics.swift
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today’s date>.
//

import SwiftUI

public enum CRAVEDesignSystem {
    
    // MARK: - Colors
    public enum Colors {
        // Core brand gradient (blue)
        public static let brandGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
                Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Orange gradient if needed for the button
        public static let cravingOrangeGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: 0.05, saturation: 0.9, brightness: 0.9),
                Color(hue: 0.0,  saturation: 0.9, brightness: 0.8)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Single orange color for “Log Craving” text
        public static let cravingOrange = Color(hue: 0.05, saturation: 0.9, brightness: 0.9)
        
        // Main black background
        public static let background = Color.black
        
        // Subtle card background
        public static let cardBackground = Color.white.opacity(0.08)
        
        // Text
        public static let textPrimary = Color.white
        public static let textSecondary = Color.white.opacity(0.7)
        
        // Placeholders
        public static let placeholderPrimary = Color.white.opacity(0.8)
        public static let placeholderSecondary = Color.white.opacity(0.6)
        
        // Status Colors
        public static let success = Color.green
        public static let warning = Color.orange
        public static let danger  = Color.red
        
        // Text on primary backgrounds
        public static let textOnPrimary = Color.white
    }
    
    // MARK: - Typography
    public enum Typography {
        // Larger heading (24pt bold)
        public static let heading = Font.system(size: 24, weight: .bold)
        
        // Subheading (14pt semibold)
        public static let subheading = Font.system(size: 14, weight: .semibold)
        
        // Body text (14pt regular)
        public static let body = Font.system(size: 14, weight: .regular)
        
        // Placeholder text (12pt regular)
        public static let placeholder = Font.system(size: 12, weight: .regular)
        
        // NEW: Smaller triggers for "Hungry/Angry/Lonely/Tired" (16pt semibold)
        public static let triggerLabel = Font.system(size: 16, weight: .semibold)
        
        // NEW: Largest font for "Log Craving" label (28pt bold)
        public static let largestCraving = Font.system(size: 28, weight: .bold)
        
        // If you want bigger button text (e.g. 20pt bold):
        public static let buttonLarge = Font.system(size: 20, weight: .bold)
    }
    
    // MARK: - Layout
    public enum Layout {
        public static let standardPadding: CGFloat = 16
        public static let cornerRadius: CGFloat    = 6
        public static let buttonHeight: CGFloat    = 36
        public static let textEditorMinHeight: CGFloat = 60
        
        public static let smallSpacing: CGFloat = 8
        public static let mediumSpacing: CGFloat = 16
        public static let largeSpacing: CGFloat = 32
    }
}
