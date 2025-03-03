//
//  ViewModifiers.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    - Houses shared view modifiers.
//    - Example here: clearing the TextEditor background for iOS < 16.
//

import SwiftUI

struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            // On iOS 16+, we can hide the scroll background natively
            return AnyView(content.scrollContentBackground(.hidden))
        } else {
            // For earlier iOS versions, adjust UITextView appearance
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
