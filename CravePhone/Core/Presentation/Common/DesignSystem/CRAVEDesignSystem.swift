// CRAVEDesignSystem.swift
// CRAVE
//
// Created by John H Jung on 2/12/25.
//
// A centralized design system for CRAVE, meticulously crafted to ensure
// a consistent, beautiful, and intuitive user experience.  Every detail
// matters, from colors and typography to subtle haptic feedback.

import UIKit
import SwiftUI


enum CRAVEDesignSystem {

    // MARK: - Colors (Carefully Chosen Palette)

    enum Colors {
        // Primary and Secondary Colors (Adapt to Light/Dark Mode)
        static let primary = Color.blue  // Energetic, trustworthy
        static let secondary = Color.gray // Calm, supportive

        // Status Colors (Clear and Unambiguous)
        static let success = Color.green
        static let warning = Color.orange
        static let danger = Color.red

        // Background Colors (Layered for Depth)
        static let background = Color(UIColor.systemBackground)          // Main background
        static let secondaryBackground = Color(UIColor.secondarySystemBackground) // For cards, lists, etc.
        static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)  // For subtle layering

        // Text Colors (High Contrast for Readability)
        static let textPrimary = Color(UIColor.label)                // Main text color
        static let textSecondary = Color(UIColor.secondaryLabel)     // For less prominent text
        static let textOnPrimary = Color.white                        // Text on primary color backgrounds
    }

    // MARK: - Typography (Precise and Readable)

    enum Typography {
        // System fonts are used for optimal legibility and dynamic type support.
        // Weights and sizes are carefully chosen for a clear hierarchy.

        static let largeTitle = Font.system(size: 34, weight: .bold)
        static let title1     = Font.system(size: 28, weight: .bold)
        static let title2     = Font.system(size: 22, weight: .bold)
        static let title3     = Font.system(size: 20, weight: .bold)
        static let headline   = Font.system(size: 17, weight: .semibold)
        static let body       = Font.system(size: 17, weight: .regular)
        static let callout    = Font.system(size: 16, weight: .regular)
        static let subhead    = Font.system(size: 15, weight: .regular)
        static let footnote   = Font.system(size: 13, weight: .regular)
        static let caption1   = Font.system(size: 12, weight: .regular)
        static let caption2   = Font.system(size: 11, weight: .regular)
    }

    // MARK: - Layout (Consistent Spacing and Proportions)

    enum Layout {
        // Based on a 4pt grid system for consistent vertical and horizontal rhythm.
        static let standardPadding: CGFloat = 16  // Most common padding
        static let compactPadding: CGFloat  = 8   // For tighter layouts
        static let buttonHeight: CGFloat    = 52  // Slightly taller for easier tapping, was 50
        static let textFieldHeight: CGFloat = 44  // Standard height, was 40
        static let cornerRadius: CGFloat    = 10  // Slightly rounder, was 8

        // Additional spacing values
        static let largeSpacing: CGFloat = 32
        static let mediumSpacing: CGFloat = 20
        static let smallSpacing: CGFloat = 8
        static let tinySpacing: CGFloat = 4
    }

    // MARK: - Animations (Subtle and Purposeful)

    enum Animation {
        static let standardDuration = 0.3  // Standard animation duration
        static let quickDuration    = 0.15 // For faster feedback, was 0.2
    }

    // MARK: - Haptics (Delicate and Refined Feedback)

    enum Haptics {
        // Prepare generators in advance for optimal performance.
        private static let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
        private static let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
        private static let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
        private static let selectionGenerator = UISelectionFeedbackGenerator()
        private static let notificationGenerator = UINotificationFeedbackGenerator()
        
        // Prepares all the generators at app launch.
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
        
        // Call this at app launch (e.g., in your App struct's init)
        CRAVEDesignSystem.Haptics.prepareAll()  //COMMENT THIS OUT TEMPORARILY UNTIL YOU CALL IT, THEN UNCOMMENT IT
            
        }
    }
}

