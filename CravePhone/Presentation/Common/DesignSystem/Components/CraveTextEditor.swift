//
//  CraveTextEditor.swift
//  CravePhone
//
//  Description:
//    A custom text editor with multi‑line placeholders and character limiting.
//    Uses conditional API for iOS 17+ onChange handling while remaining compatible
//    with older iOS versions.
//    Follows MVVM, SOLID, and Uncle Bob’s Clean Code principles.
//  Uncle Bob notes:
//    - Single Responsibility: This view manages text editing and placeholder rendering.
//    - Interface Segregation: The conditional API encapsulates version‑specific behavior.
//    - Open/Closed: Easily extendable for additional placeholder styles or character checks.
//

import SwiftUI

struct CraveTextEditor: View {
    // MARK: - Properties
    
    /// The bound text being edited.
    @Binding var text: String
    
    /// Maximum allowed characters. Beyond this limit, text will be truncated.
    let characterLimit: Int
    
    /// Placeholder lines to display when the text is empty.
    let placeholderLines: [PlaceholderLine]
    
    /// Tracks focus state for the text editor.
    @FocusState private var isFocused: Bool
    
    // MARK: - Nested Types
    
    /// Represents a placeholder line, which can be plain or gradient‑styled.
    enum PlaceholderLine {
        case plain(String)
        case gradient(String)
    }
    
    // MARK: - Initializer
    
    init(
        text: Binding<String>,
        characterLimit: Int = 200,
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
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Render placeholders when the text is empty.
            if text.isEmpty {
                VStack(spacing: CraveTheme.Spacing.small) {
                    ForEach(placeholderLines.indices, id: \.self) { idx in
                        switch placeholderLines[idx] {
                        case .plain(let string):
                            Text(string)
                                .font(CraveTheme.Typography.body.weight(.semibold))
                                .foregroundColor(CraveTheme.Colors.placeholderSecondary)
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
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
            }
            
            // Insert the custom TextEditor with the appropriate onChange handler.
            textEditorWithOnChange
        }
        .frame(minHeight: CraveTheme.Spacing.textEditorMinHeight)
        .onTapGesture {
            // Animate focus change.
            withAnimation(CraveTheme.Animations.smooth) {
                isFocused = true
            }
        }
    }
    
    /// A computed property that constructs the TextEditor with the proper onChange modifier.
    /// Uses the new two‑parameter API on iOS 17+ and the legacy one‑parameter version on older systems.
    var textEditorWithOnChange: some View {
        let baseEditor = TextEditor(text: $text)
            .focused($isFocused)
            .font(CraveTheme.Typography.body)
            .foregroundColor(CraveTheme.Colors.primaryText)
            .background(Color.clear)
            .modifier(ScrollBackgroundClearModifier())
        
        if #available(iOS 17.0, *) {
            // Use the new onChange API with two parameters: old and new values.
            return AnyView(
                baseEditor.onChange(of: text, initial: false) { oldValue, newValue in
                    limitTextIfNeeded(newValue)
                }
            )
        } else {
            // Use the legacy onChange API with a single parameter.
            return AnyView(
                baseEditor.onChange(of: text) { (newValue: String) in
                    limitTextIfNeeded(newValue)
                }
            )
        }
    }
    
    // MARK: - Private Helpers
    
    /// Enforces the character limit by truncating any excess characters.
    private func limitTextIfNeeded(_ newValue: String) {
        if characterLimit > 0, newValue.count > characterLimit {
            text = String(newValue.prefix(characterLimit))
        }
    }
}

/// A view modifier to clear the scroll background for iOS 16+.
struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            return AnyView(content.scrollContentBackground(.hidden))
        } else {
            return AnyView(content)
        }
    }
}

