//
//  ViewModifiers.swift
//  CravePhone
//
//  RESPONSIBILITY: Contains shared view modifiers used across the app.
//  Following Uncle Bob’s principles, this file isolates common UI behavior
//  from the business logic and UI components, making it easier to maintain and reuse.
//

import SwiftUI

struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            // On iOS 16+, use the native scrollContentBackground modifier.
            return AnyView(content.scrollContentBackground(.hidden))
        } else {
            // For earlier iOS versions, adjust UITextView appearance.
            return AnyView(
                content
                    .onAppear { UITextView.appearance().backgroundColor = .clear }
                    .onDisappear { UITextView.appearance().backgroundColor = nil }
            )
        }
    }
}

extension View {
    func scrollBackgroundClear() -> some View {
        self.modifier(ScrollBackgroundClearModifier())
    }
}
