//
//  ScaleEffectOnPress.swift
//  CraveWatch
//
//  A custom ButtonStyle extension applying a scale effect when pressed.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI

// This extension makes the scale effect available to all views.
extension View {
    /// Adds a gentle scaling animation when the user presses the view.
    /// - Parameter scale: The scale factor applied when pressed (default is 0.95).
    /// - Returns: A view modified with a scaling button style.
    func scaleEffectOnPress(scale: CGFloat = 0.95) -> some View {
        self.buttonStyle(ScaleEffectButtonStyle(scale: scale))
    }
}

/// A custom ButtonStyle that applies a scale effect when the button is pressed.
struct ScaleEffectButtonStyle: ButtonStyle {
    let scale: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
