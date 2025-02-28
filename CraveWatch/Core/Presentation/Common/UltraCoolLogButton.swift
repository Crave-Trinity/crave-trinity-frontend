//
//  UltraCoolLogButton.swift
//  CraveWatch
//
//  Redesigned to be elegantly minimal:
//    - A single, subtle accent or grayscale palette
//    - Gentle scale effect on press
//    - Eliminated flashy purple-red gradient
//
//  Uncle Bob notes:
//    - Single Responsibility: Provide a "Log Craving" button with minimal styling.
//    - Clean Code: Easily read and extended if brand colors change.
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
                // Minimal grayscale gradient
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.30),
                            Color.gray.opacity(0.50)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
        // Subtle scale effect on press: a quick “tap” feedback
        .scaleEffectOnPress(scale: 0.95)
    }
}

