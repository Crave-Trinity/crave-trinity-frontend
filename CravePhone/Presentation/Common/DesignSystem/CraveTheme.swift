//
//  CraveTheme.swift
//  CravePhone
//
//  Description:
//    A refined design system for CRAVE. Centralizes brand colors, typography,
//    spacing, and layout metrics. Minimal but polished to Steve Jobs-level.
//
//  Uncle Bob notes:
//    - Single Responsibility: This struct is your one source of truth for design.
//    - Open/Closed: Extend with new substructures (e.g., Animations) without modifying existing code.
//

import SwiftUI

public struct CraveTheme {
    
    // MARK: - Colors
    public struct Colors {
        /// A luxurious background gradient reminiscent of a sunrise, giving a hopeful vibe.
        public static let primaryGradient = LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.1),
                                        Color(red: 0.1, green: 0.1, blue: 0.25)]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        /// For elevated cards and surfaces
        public static let cardBackground = Color("CardBackground").opacity(0.8)
        
        /// Accent color across the app
        public static let accent = Color.orange
        
        /// Button text color
        public static let buttonText = Color.white
        
        /// Primary text color
        public static let primaryText = Color.white
        
        /// Secondary text color
        public static let secondaryText = Color.gray
        
        /// Subtle backgrounds
        public static let textFieldBackground = Color(UIColor.secondarySystemBackground).opacity(0.9)
        
        /// A more subtle gradient for placeholders or overlay highlights
        public static let cravingOrangeGradient = LinearGradient(
            colors: [.orange, .red],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        /// Placeholder color
        public static let placeholderSecondary = Color.gray.opacity(0.5)
    }
    
    // MARK: - Typography
    public struct Typography {
        public static let largestCraving = Font.system(size: 30, weight: .heavy)
        public static let heading = Font.system(size: 24, weight: .bold)
        public static let subheading = Font.system(size: 18, weight: .semibold)
        public static let body = Font.system(size: 16, weight: .regular)
        public static let caption = Font.system(size: 14, weight: .light)
    }
    
    // MARK: - Spacing
    public struct Spacing {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
        
        /// Minimum height for text editors
        public static let textEditorMinHeight: CGFloat = 120
    }
    
    // MARK: - Layout
    public struct Layout {
        public static let cornerRadius: CGFloat = 12
        public static let cardCornerRadius: CGFloat = 16
        public static let cardPadding: CGFloat = 20
    }
    
    // MARK: - Animations (Optional)
    public struct Animations {
        public static let smooth = Animation.easeInOut(duration: 0.25)
        public static let snappy = Animation.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.1)
    }
}
