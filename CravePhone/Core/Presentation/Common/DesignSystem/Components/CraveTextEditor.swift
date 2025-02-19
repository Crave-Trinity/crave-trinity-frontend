//
//
//  🍒
//  CRAVEApp/Core/DesignSystem/Components/CraveTextEditor.swift
//  Purpose: A custom TextEditor with a placeholder and character limit.
//
//

import SwiftUI

struct CraveTextEditor: View {
    @Binding var text: String
    var placeholder: String = "Enter craving..."
    var characterLimit: Int? = 280 // Optional character limit

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder Text (only visible when text is empty)
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.secondary)  // System secondary color
                    .font(.body)                  // System body font
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }

            // The actual TextEditor
            TextEditor(text: $text)
                .frame(minHeight: 120)
                .padding(4)
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius) // This is fine
                .font(.body)                  // System body font
                .foregroundColor(.primary)     // System primary color
                .scrollContentBackground(.hidden)
                .accessibilityIdentifier("CravingTextEditor")
                .overlay(alignment: .bottomTrailing) {
                    if let limit = characterLimit {
                        Text("\(text.count) / \(limit)")
                            .font(.caption2)
                            .foregroundColor(text.count > limit ? .red : .secondary)
                            .padding(.trailing, 8)
                            .padding(.bottom, 8)
                    }
                }
        }
        .onChange(of: text) { oldValue, newValue in
            if let limit = characterLimit, newValue.count > limit {
                text = String(newValue.prefix(limit))
                CRAVEDesignSystem.Haptics.notification(type: .warning) // Use .warning
            }
        }
    }
}
