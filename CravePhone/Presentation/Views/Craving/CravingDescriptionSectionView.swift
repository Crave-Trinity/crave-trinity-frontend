//
//  CravingDescriptionSectionView.swift
//  CravePhone
//
//  RESPONSIBILITY: Collects text for describing a craving.
//

import SwiftUI

struct CravingDescriptionSectionView: View {
    @Binding var text: String
    // Accept a FocusState binding from the parent.
    @FocusState var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🍫 What are you craving?")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)

            CraveTextEditor(text: $text)
                .frame(maxWidth: .infinity, minHeight: 120)
                // Attach the focus modifier to control the keyboard.
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }

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
