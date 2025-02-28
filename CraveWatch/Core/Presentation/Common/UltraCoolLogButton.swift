//
//  UltraCoolLogButton.swift
//  CraveWatch
//
//  A sleek, modern, Steve Jobs–inspired button:
//    - Clean grayscale gradient with subtle depth
//    - Gentle shadow for dimensionality
//    - Scale effect on press for tactile feedback
//
//  Uncle Bob notes:
//    - Single Responsibility: Provide a "Log Craving" button with minimal styling.
//    - Clean Code: Well-structured, easily maintainable.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI

struct UltraCoolLogButton: View {
    
    /// Callback triggered when the user taps the button.
    let onLog: () -> Void
    
    var body: some View {
        Button(action: {
            onLog()
        }) {
            Text("Log Craving")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                // Sleek grayscale gradient background
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(white: 0.20),
                                    Color(white: 0.35)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        // Subtle shadow for depth
                        .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                )
        }
        .buttonStyle(.plain)
        // Gentle scale effect for tactile feedback
        .scaleEffectOnPress(scale: 0.95)
    }
}

