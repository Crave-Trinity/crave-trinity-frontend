//
//  CraveTextEditor.swift
//
//  Description:
//  Custom SwiftUI TextEditor with a built-in 300-character limit,
//  visual character counter, and styling consistent with CraveTheme.
//
//  Usage:
//    Embed CraveTextEditor in other views to get a
//    fully functional text editor with enforced limit and UI styling.
//
//  Uncle Bob "Gang of Four" style: small, single-purpose, well-commented.
//

import SwiftUI

struct CraveTextEditor: View {
    // MARK: - BINDINGS & STATE
    @Binding var text: String                  // The text being edited.
    @State private var editorHeight: CGFloat = 100

    // MARK: - CONSTANTS
    private let characterLimit = 300           // Enforce up to 300 chars.

    // MARK: - BODY
    var body: some View {
        // Use a ZStack so we can overlay the character count in the bottom-right corner.
        ZStack(alignment: .bottomTrailing) {

            // Actual text editor with styling + logic.
            TextEditor(text: $text)
                .font(CraveTheme.Typography.body)  // Match your custom font.
                .foregroundColor(CraveTheme.Colors.primaryText)
                .frame(height: max(editorHeight, 100))
                .padding(.trailing, CraveTheme.Spacing.small)
                .background(Color.black.opacity(0.3))
                .cornerRadius(CraveTheme.Layout.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: CraveTheme.Layout.cornerRadius)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                // If your original code had a custom modifier to handle scroll backgrounds:
                .modifier(ScrollBackgroundClearModifier())
                // onChangeBackport or onChange (depending on iOS version) to enforce limit:
                .onChangeBackport(of: text, initial: false) { _, newVal in
                    if newVal.count > characterLimit {
                        // Trim any excess text.
                        text = String(newVal.prefix(characterLimit))
                        // Optional haptic feedback for user awareness.
                        CraveHaptics.shared.notification(type: .warning)
                    }
                    recalcHeight()
                }

            // Character count displayed in bottom-right corner.
            Text("\(text.count)/\(characterLimit)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
                .padding(6)
        }
        .onAppear { recalcHeight() }
    }

    // MARK: - HELPER
    private func recalcHeight() {
        // If your original text editor auto-resized:
        // 1) measure the text size with a hidden text or
        // 2) keep a minimum if you want a stable layout.
        // For brevity, we just keep a fixed or minimal height here.
    }
}
