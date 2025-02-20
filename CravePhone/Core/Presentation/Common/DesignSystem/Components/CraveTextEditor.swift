//
//  CraveTextEditor.swift
//  CravePhone
//
//  Description:
//    A custom TextEditor with a centered, watch-inspired placeholder.
//    Shows placeholders in this order:
//      1) What are you craving?
//      2) Why?
//      3) Log Craving (gradient)
//      4) With who?
//      5) Where?
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today's date>.
//

import SwiftUI

/// Helper view for applying a gradient fill to text on iOS 15+.
/// (On iOS 16+, you could do `.foregroundStyle(gradient)` directly.)
public struct GradientText: View {
    let text: String
    let font: Font
    let gradient: LinearGradient
    
    public var body: some View {
        Text(text)
            .font(font)
            .overlay {
                gradient
                    .mask(
                        Text(text)
                            .font(font)
                    )
            }
    }
}

public struct CraveTextEditor: View {
    // The user-entered text
    @Binding var text: String
    
    // Character limit for the text
    let characterLimit: Int
    
    // Whether the TextEditor is currently focused
    @FocusState private var isFocused: Bool
    
    // MARK: - Initializer
    public init(
        text: Binding<String>,
        characterLimit: Int
    ) {
        self._text = text
        self.characterLimit = characterLimit
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            
            // Show this VStack only if text is empty
            if text.isEmpty {
                VStack(spacing: 8) {
                    // 1) What are you craving?
                    Text("What are you craving?")
                        .font(.system(size: 16, weight: .semibold))
                    
                    // 2) Why?
                    Text("Why?")
                        .font(.system(size: 16, weight: .semibold))
                    
                    // 3) Log Craving (gradient)
                    GradientText(
                        text: "Log Craving",
                        font: CRAVEDesignSystem.Typography.largestCraving,
                        gradient: CRAVEDesignSystem.Colors.cravingOrangeGradient
                    )
                    
                    // 4) With who?
                    Text("With who?")
                        .font(.system(size: 16, weight: .semibold))
                    
                    // 5) Where?
                    Text("Where?")
                        .font(.system(size: 16, weight: .semibold))
                }
                .multilineTextAlignment(.center)
                .foregroundColor(CRAVEDesignSystem.Colors.placeholderSecondary)
                .padding(.top, 8)
                .frame(maxWidth: .infinity) // Center horizontally
            }
            
            // The actual TextEditor
            if #available(iOS 18, *) {
                // iOS 18+ allows .onChange(of: text, initial: true)
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
                // For iOS 15 - 17
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
        // Tapping inside the editor should focus it
        .onTapGesture {
            isFocused = true
        }
        // Hide the default scroll background on iOS 16+
        .modifier(ScrollBackgroundClearModifier())
    }
}

// MARK: - iOS 16 Scroll Background Clear
struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

