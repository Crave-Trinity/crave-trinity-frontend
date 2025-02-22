//
//  UltraCoolLogButton.swift
//  CraveWatch
//
//  A fancy "Log Craving" button using a clean, unified gradient style.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI

/// A fancy button that triggers the final "Log Craving" action.
/// - Uses a gradient background and a corner radius of 12 for a unified look.
/// - Hooks into a callback (`onLog`) that the parent view provides.
struct UltraCoolLogButton: View {
    
    /// Action callback triggered when the user taps the button.
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
                // Apply a gradient background with a unified corner radius.
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
        }
        // Use a plain button style and apply a scale effect when pressed.
        .buttonStyle(.plain)
        .scaleEffectOnPress(scale: 0.93)
    }
}
