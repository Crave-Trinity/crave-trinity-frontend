//
//  CravingDescriptionSectionView.swift
//  CravePhone
//
import SwiftUI

struct CravingDescriptionSectionView: View {
    @Binding var text: String

    // This must be a FocusState.Binding<Bool>,
    // which can be passed to .focused(...)
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // CHANGED: Now uses .heading to match "Craving Logs" & "Analytics"
            Text("🍫 What are you craving?")
                .font(CraveTheme.Typography.heading)
                .foregroundColor(CraveTheme.Colors.primaryText)

            CraveTextEditor(text: $text)
                // Tie the editor focus to this parent's focus binding
                .focused($isFocused)
                // Let the user tap the text area to become focused
                .onTapGesture {
                    isFocused = true
                }
                .frame(maxWidth: .infinity, minHeight: 120)
            
            HStack {
                Spacer()
                Text("\(text.count)/300")
                    .font(.system(size: 12))
                    .foregroundColor(
                        text.count > 280 ? .red :
                        text.count > 250 ? .orange :
                        CraveTheme.Colors.secondaryText
                    )
                    .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
    }
}

