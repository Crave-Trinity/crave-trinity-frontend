//
//  UltraCoolLogButton.swift
//  CraveWatch
//
//  A fancy button that triggers the final logging action.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI

struct UltraCoolLogButton: View {
    /// Action callback triggered when the user taps the button
    let onLog: () -> Void

    var body: some View {
        Button(action: {
            onLog()
        }) {
            Text("Log Craving")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                // Feel free to replace with any fancy gradient or design
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.red]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
        // Add a simple scale effect when pressed, for "cool" factor
        .scaleEffectOnPress()
    }
}

fileprivate extension View {
    /// Adds a gentle scaling animation when the user presses the view.
    func scaleEffectOnPress(scale: CGFloat = 0.95) -> some View {
        self.buttonStyle(ScaleEffectButtonStyle(scale: scale))
    }
}

// MARK: - A custom button style that applies a scale effect on press
fileprivate struct ScaleEffectButtonStyle: ButtonStyle {
    let scale: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
