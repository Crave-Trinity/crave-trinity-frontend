//
//  CraveTextEditor.swift
//  CravePhone
//
//  Single Responsibility:
//    - Provide a consistent text input experience with placeholders, character limit, speech mic icon.
//
//  Uncle Bob & SOLID Principles:
//    - No duplication of logic that belongs in the ViewModel or global theme.
//    - Clear function naming for 'limitTextIfNeeded' and 'calculateEditorHeight'.
//

import SwiftUI

struct CraveTextEditor: View {
    @Binding var text: String
    let isRecordingSpeech: Bool
    let onMicTap: () -> Void
    
    let characterLimit: Int
    let placeholderLines: [PlaceholderLine]
    
    @State private var editorHeight: CGFloat = 120
    @FocusState private var isFocused: Bool
    
    enum PlaceholderLine: Equatable {
        case plain(String)
        case gradient(String)
    }
    
    init(
        text: Binding<String>,
        isRecordingSpeech: Bool = false,
        onMicTap: @escaping () -> Void = {},
        characterLimit: Int = 300,
        placeholderLines: [PlaceholderLine] = []
    ) {
        self._text = text
        self.isRecordingSpeech = isRecordingSpeech
        self.onMicTap = onMicTap
        self.characterLimit = characterLimit
        self.placeholderLines = placeholderLines
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Placeholder logic:
            if text.isEmpty, !placeholderLines.isEmpty {
                placeholderContent
                    .padding(.top, 12)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                    // Standard SwiftUI .opacity, no custom extension needed
                    .opacity(isFocused ? 0.4 : 0.7)
                    .animation(.easeOut(duration: 0.2), value: isFocused)
                    .onTapGesture { isFocused = true }
            }
            
            // Main text editor
            textEditorWithBackport
                .focused($isFocused)
                .frame(height: max(editorHeight, CraveTheme.Spacing.textEditorMinHeight))
                .background(SwiftUI.Color.black.opacity(0.3))
                .cornerRadius(CraveTheme.Layout.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: CraveTheme.Layout.cornerRadius)
                        .stroke(
                            isFocused
                            ? CraveTheme.Colors.accent.opacity(0.5)
                            : SwiftUI.Color.white.opacity(0.3),
                            lineWidth: 1
                        )
                        .animation(.easeInOut(duration: 0.2), value: isFocused)
                )
                // Use the newly named onChangeBackport extension
                .onChangeBackport(of: text, initial: false) { _, _ in
                    calculateEditorHeight()
                }
            
            // Speech button with animation
            Button {
                CraveHaptics.shared.lightImpact()
                onMicTap()
            } label: {
                Image(systemName: isRecordingSpeech ? "waveform.circle.fill" : "mic.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isRecordingSpeech ? CraveTheme.Colors.accent : SwiftUI.Color.white.opacity(0.8))
                    .padding(8)
                    .background(
                        Circle()
                            .fill(isRecordingSpeech ? SwiftUI.Color.white.opacity(0.2) : SwiftUI.Color.black.opacity(0.4))
                            .animation(.easeOut(duration: 0.2), value: isRecordingSpeech)
                    )
                    .overlay(
                        Circle()
                            .stroke(isRecordingSpeech ? CraveTheme.Colors.accent : Color.clear, lineWidth: 1.5)
                    )
                    .scaleEffect(isRecordingSpeech ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRecordingSpeech)
            }
            .padding(8)
            .accessibilityLabel(isRecordingSpeech ? "Stop recording" : "Start voice input")
        }
    }
    
    private var placeholderContent: some View {
        VStack(spacing: 8) {
            ForEach(placeholderLines.indices, id: \.self) { idx in
                switch placeholderLines[idx] {
                case .plain(let string):
                    Text(string)
                        .font(CraveTheme.Typography.body.weight(.medium))
                        .foregroundColor(CraveTheme.Colors.placeholderSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 2)
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
    }
    
    private func calculateEditorHeight() {
        let baseHeight: CGFloat = 120
        // Rough approximation of lines:
        let estimatedLines = text.count / 35 + 1
        let newHeight = min(max(baseHeight, CGFloat(estimatedLines) * 20), 300)
        
        if editorHeight != newHeight {
            withAnimation(.easeOut(duration: 0.2)) {
                editorHeight = newHeight
            }
        }
    }
}

// MARK: - Internal Logic for the TextEditor

extension CraveTextEditor {
    
    // Return a wrapped TextEditor that uses our onChangeBackport
    var textEditorWithBackport: some View {
        let base = TextEditor(text: $text)
            .font(CraveTheme.Typography.body)
            .foregroundColor(CraveTheme.Colors.primaryText)
            .modifier(ScrollBackgroundClearModifier())
            .padding(.trailing, 38) // Space for the mic button
        
        return AnyView(
            base.onChangeBackport(of: text, initial: false) { _, newValue in
                limitTextIfNeeded(newValue)
            }
        )
    }
    
    private func limitTextIfNeeded(_ newValue: String) {
        // Enforce character limit if needed
        if characterLimit > 0, newValue.count > characterLimit {
            text = String(newValue.prefix(characterLimit))
            CraveHaptics.shared.notification(type: .warning)
        }
    }
}

// MARK: - Background Modifier (Pre-iOS 16 fix)
struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            return AnyView(content.scrollContentBackground(.hidden))
        } else {
            return AnyView(
                content
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                    }
                    .onDisappear {
                        UITextView.appearance().backgroundColor = nil
                    }
            )
        }
    }
}
