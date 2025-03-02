//
//  CraveTheme.swift
//  CravePhone
//
//  PURPOSE:
//    - Single source of truth for design (colors, fonts, spacing, layout, animations).
//    - Now includes 'cardBackground' & 'cardCornerRadius' for CravingCard.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: only styling constants.
//
//  “DESIGNED FOR STEVE JOBS”:
//    - Minimally fussy design elements with consistent naming.
//
//  UPDATED: <today's date>
//

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
        
        public static let accent           = Color(red: 0.95, green: 0.25, blue: 0.0)
        public static let buttonText       = Color.white
        public static let primaryText      = Color.white
        public static let secondaryText    = Color.gray
        public static let placeholderSecondary = Color.gray.opacity(0.5)
        
        // The new color used by CravingCard’s background:
        public static let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.12, opacity: 0.90)
        
        // Possibly also used in emotion chips or other UI
        public static let cravingOrangeGradient = LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.25, blue: 0.0),
                Color(red: 0.85, green: 0.15, blue: 0.0)
            ],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
    
    public struct Typography {
        public static let heading = Font.custom("HelveticaNeue-Bold", size: 20)
        public static let subheading = Font.custom("HelveticaNeue-Medium", size: 16)
        public static let body = Font.custom("HelveticaNeue", size: 14)
        public static let largestCraving = Font.custom("HelveticaNeue-Heavy", size: 24)
    }
    
    public struct Spacing {
        public static let medium: CGFloat = 16
    }
    
    public struct Layout {
        public static let cornerRadius: CGFloat = 12
        
        // The new corner radius used by CravingCard
        public static let cardCornerRadius: CGFloat = 16
    }
    
    public struct Animations {
        public static let smooth = Animation.easeInOut(duration: 0.25)
    }
}
