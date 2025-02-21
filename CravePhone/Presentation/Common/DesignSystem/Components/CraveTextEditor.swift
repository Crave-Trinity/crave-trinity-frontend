//
//  CraveTextEditor.swift
//  CravePhone
//
//  Description:
//    A custom TextEditor with a centered, watch-inspired placeholder system.
//    It displays multiple placeholder lines if the editor is empty.
//    You can pass in an array of placeholders for easy extension.
//    Follows MVVM and SOLID: single responsibility (managing text editing & placeholder).
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today's date>.
//

import SwiftUI

/// A helper view for applying a gradient fill to text.
public struct GradientText: View {
    let text: String
    let font: Font
    let gradient: LinearGradient
    
    public var body: some View {
        Text(text)
            .font(font)
            .overlay {
                gradient
                    .mask(Text(text).font(font))
            }
    }
}

public struct CraveTextEditor: View {
    // MARK: - Bound/Text State
    @Binding var text: String
    
    /// Provide a default limit to avoid “missing argument” errors
    let characterLimit: Int
    
    /// Placeholder lines to display when text is empty
    let placeholderLines: [PlaceholderLine]
    
    /// Track focus for the text editor
    @FocusState private var isFocused: Bool
    
    // MARK: - Nested Types
    public enum PlaceholderLine {
        case plain(String)
        case gradient(String)
    }
    
    // MARK: - Initializer
    public init(
        text: Binding<String>,
        characterLimit: Int = 200,  // default limit
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
            
            // Show placeholder lines if text is empty
            if text.isEmpty {
                VStack(spacing: CraveTheme.Spacing.small) {
                    ForEach(placeholderLines.indices, id: \.self) { idx in
                        switch placeholderLines[idx] {
                        case .plain(let string):
                            Text(string)
                                .font(.system(size: 16, weight: .semibold))
                        case .gradient(let string):
                            GradientText(
                                text: string,
                                font: CraveTheme.Typography.largestCraving,
                                gradient: CraveTheme.Colors.cravingOrangeGradient
                            )
                        }
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundColor(CraveTheme.Colors.placeholderSecondary)
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
            }
            
            // The actual TextEditor
            if #available(iOS 18, *) {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .font(CraveTheme.Typography.body)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                    .background(Color.clear)
                    .onChange(of: text, initial: true) { _, newValue in
                        limitTextIfNeeded(newValue)
                    }
            } else {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .font(CraveTheme.Typography.body)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                    .background(Color.clear)
                    .onChange(of: text) { newValue in
                        limitTextIfNeeded(newValue)
                    }
            }
        }
        .frame(minHeight: CraveTheme.Spacing.textEditorMinHeight)
        .onTapGesture { isFocused = true }
        .modifier(ScrollBackgroundClearModifier())
    }
    
    // MARK: - Private Helpers
    private func limitTextIfNeeded(_ newValue: String) {
        if characterLimit > 0 && newValue.count > characterLimit {
            text = String(newValue.prefix(characterLimit))
        }
    }
}

/// iOS 16+ scroll background clear
struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}
