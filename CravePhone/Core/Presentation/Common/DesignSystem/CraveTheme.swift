//
//  CraveTheme.swift
//  CravePhone
//
//  Directory: CravePhone/Core/Presentation/Common/DesignSystem/CraveTheme.swift
//
//  Description:
//    A unified design system for CRAVE. This file centralizes colors, typography,
//    spacing, and layout metrics to maintain consistency across the app.
//    Adheres to SOLID and Clean Architecture principles, referencing one source of truth.
//
//  Created by <Your Name> on <date>.
//  Updated by ChatGPT on <today's date>.
//

import SwiftUI

public struct CraveTheme {
    
    // MARK: - Colors
    public struct Colors {
        // Primary backgrounds
        public static let primaryBackground = Color.black
        public static let secondaryBackground = Color("SecondaryBackground")
          // If you want a custom color, define "SecondaryBackground" in Assets.xcassets.

        // Accents & text
        public static let accent = Color.blue
        public static let buttonText = Color.white
        public static let primaryText = Color.white
        public static let secondaryText = Color.gray
        
        // Form elements
        public static let textFieldBackground = Color(UIColor.secondarySystemBackground)
        
        // Additional elements
        public static let cardBackground = Color("CardBackground")
          // Define "CardBackground" in Assets.xcassets or replace with a default, e.g. Color(UIColor.systemGray6).
        
        // Placeholders & gradients
        public static let placeholderSecondary = Color.gray.opacity(0.5)
        public static let cravingOrangeGradient = LinearGradient(
            colors: [.orange, .red],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography
    public struct Typography {
        public static let heading = Font.system(size: 24, weight: .bold)
        public static let subheading = Font.system(size: 18, weight: .semibold)
        public static let body = Font.system(size: 16, weight: .regular)
        public static let largestCraving = Font.system(size: 28, weight: .heavy)
    }
    
    // MARK: - Spacing
    public struct Spacing {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
        public static let textEditorMinHeight: CGFloat = 120
    }
    
    // MARK: - Layout
    public struct Layout {
        public static let cornerRadius: CGFloat = 10
    }
}
