//
//  CraveTheme.swift
//  CRAVE
//
//  Description:
//    Simplified theme structure. In larger apps, you might merge this with
//    CRAVEDesignSystem or keep it separate if you want a dedicated "Theme" concept.
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today's date>.
//

import SwiftUI

public struct CraveTheme {
    public struct Colors {
        public static let primary = Color.blue
        public static let secondaryBackground = Color.gray.opacity(0.2)
    }
    
    public struct Layout {
        public static let standardPadding: CGFloat = 16
        public static let cornerRadius: CGFloat = 10
    }
}
