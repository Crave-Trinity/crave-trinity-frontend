//
// CravingDescriptionSectionView.swift
// /CravePhone/Presentation/Views/Craving/CravingDescriptionSectionView.swift
//
// Revised for consistent typography and spacing.
// The section now uses global styles for the title, text editor, and character counter.
import SwiftUI

struct CravingDescriptionSectionView: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
            // Section title using the global heading style.
            Text("🍫 What are you craving?")
                .font(CraveTheme.Typography.heading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            // Custom text editor.
            CraveTextEditor(text: $text)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }
                .frame(maxWidth: .infinity, minHeight: 120)
        }
        .padding(.vertical, CraveTheme.Spacing.medium)
    }
}
