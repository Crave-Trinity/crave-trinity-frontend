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
            
            HStack {
                Spacer()
                // Character count using the global caption style.
                Text("\(text.count)/300")
                    .font(CraveTheme.Typography.caption)
                    .foregroundColor(
                        text.count > 280 ? .red :
                        text.count > 250 ? .orange :
                        CraveTheme.Colors.secondaryText
                    )
                    .padding(.trailing, CraveTheme.Spacing.small)
            }
        }
        .padding(.vertical, CraveTheme.Spacing.medium)
    }
}
