//
//  CraveTextEditor.swift
//  CravePhone
//
//  Description:
//    A custom text editor with multi‑line placeholders and character limiting.
//    Uses conditional API for iOS 17+ onChange handling while remaining compatible
//    with older iOS versions. Follows MVVM, SOLID, and Uncle Bob’s Clean Code.
//
//  Uncle Bob notes:
//    - Single Responsibility: Manages text editing & placeholder rendering.
//    - Interface Segregation: The conditional API encapsulates version‑specific behavior.
//    - Open/Closed: Extend for additional placeholder styles or checks.
//

import SwiftUI

struct CraveTextEditor: View {
    // MARK: - Properties
    
    @Binding var text: String
    let characterLimit: Int
    let placeholderLines: [PlaceholderLine]
    
    @FocusState private var isFocused: Bool
    
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
            // Render placeholders when text is empty.
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
            
            // Actual text editor with focus and background clearing.
            textEditorWithOnChange
        }
        .frame(minHeight: 200) // Enough space to show placeholders fully
        .onTapGesture {
            withAnimation(CraveTheme.Animations.smooth) {
                isFocused = true
            }
        }
    }
    
    /// Build the TextEditor with the correct onChange approach for iOS <17 vs iOS ≥17
    var textEditorWithOnChange: some View {
        let baseEditor = TextEditor(text: $text)
            .focused($isFocused)
            .font(CraveTheme.Typography.body)
            .foregroundColor(CraveTheme.Colors.primaryText)
            .background(Color.clear)
            .modifier(ScrollBackgroundClearModifier())
        
        if #available(iOS 17.0, *) {
            return AnyView(
                baseEditor.onChange(of: text, initial: false) { _, newValue in
                    limitTextIfNeeded(newValue)
                }
            )
        } else {
            return AnyView(
                baseEditor.onChange(of: text) { (newValue: String) in
                    limitTextIfNeeded(newValue)
                }
            )
        }
    }
    
    // MARK: - Private
    
    private func limitTextIfNeeded(_ newValue: String) {
        if characterLimit > 0, newValue.count > characterLimit {
            text = String(newValue.prefix(characterLimit))
        }
    }
}

struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            return AnyView(content.scrollContentBackground(.hidden))
        } else {
            return AnyView(content)
        }
    }
}

