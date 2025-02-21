
//
//  CraveMinimalButton.swift
//  CravePhone
//
//  Description:
//    A modern, minimal SwiftUI button with a gentle press effect.
//
//  Uncle Bob notes:
//    - Single Responsibility: Renders a consistent button style with an action.
//    - Liskov Substitution: Could swap in a different label without changing usage.
//

import SwiftUI

struct CraveMinimalButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
            // Subtle scale effect on press
            withAnimation(CraveTheme.Animations.snappy) {
                isPressed = false
            }
            action()
        }) {
            label()
                .font(CraveTheme.Typography.body)
                .padding()
                .frame(maxWidth: .infinity)
                .background(CraveTheme.Colors.accent)
                .foregroundColor(CraveTheme.Colors.buttonText)
                .cornerRadius(CraveTheme.Layout.cornerRadius)
                .shadow(color: CraveTheme.Colors.accent.opacity(0.4),
                        radius: 6, x: 0, y: 3)
        }
        .scaleEffect(isPressed ? 0.98 : 1.0) // simple press animation
        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
            withAnimation(CraveTheme.Animations.snappy) {
                isPressed = pressing
            }
        }, perform: {})
        .buttonStyle(.plain)
    }
}
