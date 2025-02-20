//
//  CraveTextEditor.swift
//  CravePhone
//
//  Description:
//    A UI component representing a text editor styled using CRAVEDesignSystem.
//    Handles character limits and placeholder display.
//    Created by John H Jung on 2/12/25.
//    Updated by ChatGPT on <today’s date> to remove duplicate declarations.
//

import SwiftUI

public struct CraveTextEditor: View {
    // Binding to the text content.
    @Binding var text: String
    
    // Primary and secondary placeholders shown when text is empty.
    let primaryPlaceholder: String
    let secondaryPlaceholder: String
    
    // Character limit for the text input.
    let characterLimit: Int
    
    // Focus state to manage keyboard interaction.
    @FocusState private var isFocused: Bool
    
    public init(
        text: Binding<String>,
        primaryPlaceholder: String,
        secondaryPlaceholder: String,
        characterLimit: Int
    ) {
        self._text = text
        self.primaryPlaceholder = primaryPlaceholder
        self.secondaryPlaceholder = secondaryPlaceholder
        self.characterLimit = characterLimit
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            // Display placeholders when the text is empty.
            if text.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text(primaryPlaceholder)
                        .foregroundColor(CRAVEDesignSystem.Colors.placeholderPrimary)
                        .font(CRAVEDesignSystem.Typography.subheading)
                    Text(secondaryPlaceholder)
                        .foregroundColor(CRAVEDesignSystem.Colors.placeholderSecondary)
                        .font(CRAVEDesignSystem.Typography.placeholder)
                }
                .padding(.leading, 4)
                .padding(.top, 8)
            }
            
            // Use the onChange handler based on iOS version.
            if #available(iOS 18, *) {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .font(CRAVEDesignSystem.Typography.body)
                    .foregroundColor(CRAVEDesignSystem.Colors.textPrimary)
                    .background(Color.clear)
                    .onChange(of: text, initial: true) { _, newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                    }
            } else {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .font(CRAVEDesignSystem.Typography.body)
                    .foregroundColor(CRAVEDesignSystem.Colors.textPrimary)
                    .background(Color.clear)
                    .onChange(of: text) { newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                    }
            }
        }
        .frame(minHeight: CRAVEDesignSystem.Layout.textEditorMinHeight)
        .onTapGesture {
            isFocused = true
        }
    }
}

