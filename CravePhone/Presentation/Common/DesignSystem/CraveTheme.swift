//
//  CraveTheme.swift
//  CravePhone
//
//  Description:
//    A blacked‑out, ultra‑modern design system for CRAVE. Centralizes brand colors,
//    typography, spacing, and layout metrics.
//
//  Uncle Bob notes:
//    - Single Responsibility: Single source of truth for styling.
//    - Open/Closed: Extensible (e.g., we can add more colors & fonts without breaking usage).
//    - Clean Code: Clear naming, modular design.
//  GoF & SOLID:
//    - Encapsulation of constants in nested structs for logical grouping.
//    - 'CraveTheme' is open for extension (add new design sections), closed for modification (existing usage unaffected).
//

import SwiftUI

public struct CraveTheme {
    
    // MARK: - Colors
    public struct Colors {
        
        // Primary background gradient: from pitch black to near-black
        public static let primaryGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color(red: 0.05, green: 0.05, blue: 0.05) // near-black
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Dark, translucent background for cards.
        public static let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.12, opacity: 0.90)
        
        // A deep red‑orange accent color for brand emphasis.
        public static let accent = Color(red: 0.95, green: 0.25, blue: 0.0)
        
        // Button text color (white on dark).
        public static let buttonText = Color.white
        
        // Primary text color (white).
        public static let primaryText = Color.white
        
        // Secondary text color (gray).
        public static let secondaryText = Color.gray
        
        // Subtle black look for text fields.
        public static let textFieldBackground = Color(red: 0.12, green: 0.12, blue: 0.14, opacity: 0.95)
        
        // Placeholder color, lighter gray.
        public static let placeholderSecondary = Color.gray.opacity(0.5)
        
        // A subtle orange-red gradient for craving highlights.
        public static let cravingOrangeGradient = LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.25, blue: 0.0),
                Color(red: 0.85, green: 0.15, blue: 0.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography
    public struct Typography {
        // (Reduced sizes to avoid overwhelming large screens)
        public static let heading      = Font.custom("HelveticaNeue-Bold", size: 20)
        public static let subheading   = Font.custom("HelveticaNeue-Medium", size: 16)
        public static let body         = Font.custom("HelveticaNeue", size: 14)
        public static let largestCraving = Font.custom("HelveticaNeue-Heavy", size: 24)
    }
    
    // MARK: - Spacing
    public struct Spacing {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
        
        // Minimum height for text editors.
        public static let textEditorMinHeight: CGFloat = 120
    }
    
    // MARK: - Layout
    public struct Layout {
        public static let cornerRadius: CGFloat = 12
        public static let cardCornerRadius: CGFloat = 16
        public static let cardPadding: CGFloat = 20
    }
    
    // MARK: - Animations
    public struct Animations {
        public static let smooth = Animation.easeInOut(duration: 0.25)
        public static let snappy = Animation.spring(response: 0.4, dampingFraction: 0.7)
    }
}
