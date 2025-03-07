//
// CraveTheme.swift
// /CravePhone/Presentation/Common/DesignSystem/Components/CraveTheme.swift
//
// Revised for consistent typography and styling across the Log Craving view.
// This file now provides a single source of truth for fonts, colors, spacing, and layout,
// including an added caption style for small text elements.
import SwiftUI

public struct CraveTheme {
    
    public struct Colors {
        public static let primaryGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color(red: 0.05, green: 0.05, blue: 0.05)
            ]),
            startPoint: .top, endPoint: .bottom
        )
        
        public static let accent                = Color(red: 0.95, green: 0.25, blue: 0.0)
        public static let buttonText            = Color.white
        public static let primaryText           = Color.white
        public static let secondaryText         = Color.gray
        public static let placeholderSecondary  = Color.gray.opacity(0.5)
        public static let cardBackground        = Color(red: 0.10, green: 0.10, blue: 0.12, opacity: 0.90)
        
        public static let cravingOrangeGradient = LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.25, blue: 0.0),
                Color(red: 0.85, green: 0.15, blue: 0.0)
            ],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
    
    public struct Typography {
        // Headings for section titles.
        public static let heading = Font.custom("HelveticaNeue-Bold", size: 20)
        // Subheadings for labels (e.g. slider labels, chip titles).
        public static let subheading = Font.custom("HelveticaNeue-Medium", size: 16)
        // Body text for general content.
        public static let body = Font.custom("HelveticaNeue", size: 14)
        // Caption for less prominent details (e.g. character count).
        public static let caption = Font.custom("HelveticaNeue", size: 12)
        // For emphasizing large craving values or alerts.
        public static let largestCraving = Font.custom("HelveticaNeue-Heavy", size: 24)
    }
    
    public struct Spacing {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
    }
    
    public struct Layout {
        public static let cornerRadius: CGFloat = 12
        public static let cardCornerRadius: CGFloat = 16
    }
    
    public struct Animations {
        public static let smooth = Animation.easeInOut(duration: 0.25)
    }
}
