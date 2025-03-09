//
//  CravingDescriptionSectionView.swift
//
//  Description:
//  Presents the label "🍫 What are you craving?" and embeds CraveTextEditor.
//  Manages focus if needed, but defers character-limit logic to CraveTextEditor.
//
//  Usage:
//    Place in your main LogCravingView (or parent) as a subview
//    to collect user input about what they're craving.
//
//  Uncle Bob "Gang of Four" style: minimal view logic, clearly commented.
//

import SwiftUI

struct CravingDescriptionSectionView: View {
    // MARK: - BINDINGS
    @Binding var text: String                 // The user's craving text.

    // Optionally manage focus here (if that’s how your original code handled it):
    @FocusState var isFocused: Bool

    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
            
            // Section label
            Text("🍫 What are you craving?")
                .font(CraveTheme.Typography.heading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            // Custom text editor that handles styling and char-limit internally
            CraveTextEditor(text: $text)
                .focused($isFocused)
                .onTapGesture {
                    // This ensures tapping the editor triggers focus
                    isFocused = true
                }
                .frame(maxWidth: .infinity, minHeight: 120)
        }
        .padding(.vertical, CraveTheme.Spacing.medium)
    }
}
