//
// CravingDescriptionSectionView.swift
// CravePhone/Presentation/Views/Craving/CravingDescriptionSectionView.swift
//
// Description:
//  Presents the label "🍫 What are you craving?" and embeds CraveTextEditor.
//  Manages focus if needed, but defers character-limit logic to CraveTextEditor.
//  Now supports speech recognition via isRecording and onToggle parameters.
//
// Usage:
//  Place in your main LogCravingView (or parent) as a subview
//  to collect user input about what they're craving.
//
// Uncle Bob "Gang of Four" style: minimal view logic, clearly commented.
//

import SwiftUI

struct CravingDescriptionSectionView: View {
    // MARK: - BINDINGS
    @Binding var text: String  // The user's craving text.

    // Optional focus state management.
    @FocusState var isFocused: Bool

    // New parameters to support speech recognition.
    let isRecording: Bool
    let onToggle: () -> Void

    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
            // Section label.
            Text("🍫 What are you craving?")
                .font(CraveTheme.Typography.heading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            // Custom text editor that handles styling and character-limit internally.
            CraveTextEditor(
                text: $text,
                isRecording: isRecording,
                onToggle: onToggle
            )
            .focused($isFocused)
            .onTapGesture {
                // Tapping the editor triggers focus.
                isFocused = true
            }
            .frame(maxWidth: .infinity, minHeight: 120)
        }
        .padding(.vertical, CraveTheme.Spacing.medium)
    }
}
