//
// ViewModifiers.swift
// /CravePhone/Presentation/Common/DesignSystem/Components/ViewModifiers.swift
//
// Revised for consistency. This file provides custom view modifiers with no font changes,
// but now uses clear header documentation and adheres to our global styling approach.
import SwiftUI

struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            // On iOS 16+, hide the scroll background natively.
            return AnyView(content.scrollContentBackground(.hidden))
        } else {
            // For earlier versions, adjust UITextView appearance for consistency.
            return AnyView(
                content
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                    }
                    .onDisappear {
                        UITextView.appearance().backgroundColor = nil
                    }
            )
        }
    }
}

extension View {
    func scrollBackgroundClear() -> some View {
        self.modifier(ScrollBackgroundClearModifier())
    }
}
