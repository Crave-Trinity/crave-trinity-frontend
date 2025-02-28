//
//  CraveTextEditor.swift
//  CravePhone
//
//  Description:
//    A custom text editor with multi-line placeholders, character limiting,
//    and an optional microphone overlay for speech input.
//    Uses conditional API for iOS 17+ onChange handling to stay iOS 16-compatible.
//
//  Uncle Bob notes:
//    - Single Responsibility: Manages text entry + optional mic overlay
//    - Open/Closed: Placeholders, speech logic can be extended without hacking the rest
//    - Clean Code: Clear naming, distinct methods, minimal duplication
//

import SwiftUI

struct CraveTextEditor: View {
    // MARK: - Public Bindings & Callbacks
    @Binding var text: String
    let isRecordingSpeech: Bool
    let onMicTap: () -> Void
    
    // MARK: - Configurable Properties
    let characterLimit: Int
    let placeholderLines: [PlaceholderLine]
    
    // MARK: - Focus State
    @FocusState private var isFocused: Bool
    
    // MARK: - Enum for Placeholder Lines
    enum PlaceholderLine {
        case plain(String)
        case gradient(String)
    }
    
    // MARK: - Initializer
    init(
        text: Binding<String>,
        isRecordingSpeech: Bool,
        onMicTap: @escaping () -> Void,
        characterLimit: Int = 300,
        placeholderLines: [PlaceholderLine] = []
    ) {
        self._text = text
        self.isRecordingSpeech = isRecordingSpeech
        self.onMicTap = onMicTap
        self.characterLimit = characterLimit
        self.placeholderLines = placeholderLines
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            // (A) Placeholder Layer
            if text.isEmpty, !placeholderLines.isEmpty {
                VStack(spacing: 8) {
                    ForEach(placeholderLines.indices, id: \.self) { idx in
                        switch placeholderLines[idx] {
                        case .plain(let string):
                            Text(string)
                                .font(CraveTheme.Typography.body.weight(.semibold))
                                .foregroundColor(CraveTheme.Colors.placeholderSecondary)
                                .multilineTextAlignment(.center)
                        case .gradient(let string):
                            GradientText(
                                text: string,
                                font: CraveTheme.Typography.largestCraving,
                                gradient: CraveTheme.Colors.cravingOrangeGradient
                            )
                            .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation(CraveTheme.Animations.smooth) {
                        isFocused = true
                    }
                }
            }
            
            // (B) Actual TextEditor
            textEditorWithOnChange
                .frame(minHeight: 120)
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            // (C) Mic Button Overlay
            Button(action: {
                onMicTap()
            }) {
                Image(systemName: isRecordingSpeech ? "waveform" : "mic.fill")
                    .font(.system(size: 18))
                    .foregroundColor(isRecordingSpeech ? .orange : .white.opacity(0.8))
                    .padding(8)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
            }
            .padding(8)
        }
    }
}

// MARK: - Subviews & Helpers
extension CraveTextEditor {
    
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
    
    private func limitTextIfNeeded(_ newValue: String) {
        if characterLimit > 0, newValue.count > characterLimit {
            text = String(newValue.prefix(characterLimit))
        }
    }
}

/// Clears out the default scroll background on iOS 16+
struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            return AnyView(content.scrollContentBackground(.hidden))
        } else {
            return AnyView(content)
        }
    }
}
