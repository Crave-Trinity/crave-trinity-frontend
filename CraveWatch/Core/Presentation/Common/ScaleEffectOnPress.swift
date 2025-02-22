//
//  ScaleEffectOnPress.swift
//  CraveWatch
//
//  A custom ButtonStyle extension applying a scale effect when pressed.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI

// Ensure not to mark it fileprivate, so other files can see it.
extension View {
    /// Adds a gentle scaling animation when the user presses the view.
    func scaleEffectOnPress(scale: CGFloat = 0.95) -> some View {
        self.buttonStyle(ScaleEffectButtonStyle(scale: scale))
    }
}

struct ScaleEffectButtonStyle: ButtonStyle {
    let scale: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
