//
//  CraveTextEditor.swift
//  CravePhone
//
//  Description:
//    A custom TextEditor with a centered, watch-inspired placeholder system.
//    It displays multiple placeholder lines if the editor is empty.
//    You can pass in an array of placeholders for easy extension.
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
    // MARK: - Bound/Text State
    @Binding var text: String
    
    // Character limit for the text
    let characterLimit: Int
    
    // Placeholder lines (you can pass in custom prompts)
    let placeholderLines: [PlaceholderLine]
    
    // Keep track of focus
    @FocusState private var isFocused: Bool
    
    // MARK: - Nested Types
    public enum PlaceholderLine {
        /// A simple text line
        case plain(String)
        /// A gradient text line (bigger, stylized)
        case gradient(String)
        
        // Additional expansions possible, e.g. icons, images, etc.
    }
    
    // MARK: - Initializer
    public init(
        text: Binding<String>,
        characterLimit: Int,
        placeholderLines: [PlaceholderLine] = [
            .plain("What are you craving?"),
            .plain("Why?"),
            .gradient("Log Craving"),
            .plain("With who?"),
            .plain("Where?")
        ]
    ) {
        self._text = text
        self.characterLimit = characterLimit
        self.placeholderLines = placeholderLines
    }
    
    // MARK: - Body
    public var body: some View {
        ZStack(alignment: .topLeading) {
            
            // Show placeholder lines only if text is empty
            if text.isEmpty {
                VStack(spacing: CRAVEDesignSystem.Layout.smallSpacing) {
                    ForEach(placeholderLines.indices, id: \.self) { index in
                        let line = placeholderLines[index]
                        switch line {
                        case .plain(let string):
                            Text(string)
                                .font(.system(size: 16, weight: .semibold))
                        case .gradient(let string):
                            GradientText(
                                text: string,
                                font: CRAVEDesignSystem.Typography.largestCraving,
                                gradient: CRAVEDesignSystem.Colors.cravingOrangeGradient
                            )
                        }
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundColor(CRAVEDesignSystem.Colors.placeholderSecondary)
                .padding(.top, 8)
                .frame(maxWidth: .infinity) // Center horizontally
            }
            
            // The actual TextEditor
            if #available(iOS 18, *) {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .font(CRAVEDesignSystem.Typography.body)
                    .foregroundColor(CRAVEDesignSystem.Colors.textPrimary)
                    .background(Color.clear)
                    .onChange(of: text, initial: true) { _, newValue in
                        limitTextIfNeeded(newValue)
                    }
            } else {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .font(CRAVEDesignSystem.Typography.body)
                    .foregroundColor(CRAVEDesignSystem.Colors.textPrimary)
                    .background(Color.clear)
                    .onChange(of: text) { newValue in
                        limitTextIfNeeded(newValue)
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
    
    // MARK: - Private Helpers
    private func limitTextIfNeeded(_ newValue: String) {
        if newValue.count > characterLimit {
            text = String(newValue.prefix(characterLimit))
        }
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
