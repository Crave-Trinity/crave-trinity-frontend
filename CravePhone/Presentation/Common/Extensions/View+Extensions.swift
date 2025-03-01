//
//  View+Extensions.swift
//  CravePhone
//
//  SwiftUI View extensions for common UI patterns.
//

import SwiftUI

extension View {
    // Add vertical padding to a view
    func verticalPadding(_ amount: CGFloat) -> some View {
        self.padding(.vertical, amount)
    }
    
    // Add horizontal padding to a view
    func horizontalPadding(_ amount: CGFloat) -> some View {
        self.padding(.horizontal, amount)
    }
    
    // Apply a background with corner radius and shadow
    func cardStyle(
        backgroundColor: Color = CraveTheme.Colors.cardBackground,
        cornerRadius: CGFloat = CraveTheme.Layout.cardCornerRadius,
        shadowRadius: CGFloat = 4
    ) -> some View {
        self.padding(CraveTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(color: Color.black.opacity(0.15), radius: shadowRadius, x: 0, y: 2)
            )
    }
    
    // Apply a simple outline/border
    func outlined(
        color: Color = Color.gray.opacity(0.3),
        cornerRadius: CGFloat = CraveTheme.Layout.cornerRadius,
        lineWidth: CGFloat = 1
    ) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: lineWidth)
        )
    }
    
    // Add a conditional overlay if a condition is true
    func overlayIf<Content: View>(_ condition: Bool, content: @escaping () -> Content) -> some View {
        self.overlay(
            ZStack {
                if condition {
                    content()
                }
            }
        )
    }
}
