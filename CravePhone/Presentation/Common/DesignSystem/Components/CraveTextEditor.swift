//
//  CraveTextEditor.swift
//  CravePhone
//
//  An enhanced TextEditor with responsive layout,
//  improved placeholder animations, and speech recognition button.
//  Single Responsibility: Provides a consistent text input experience.
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
            // Placeholder with animation
            if text.isEmpty, !placeholderLines.isEmpty {
                placeholderContent
                    .padding(.top, 12)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                    .opacity(isFocused ? 0.4 : 0.7)
                    .animation(.easeOut(duration: 0.2), value: isFocused)
                    .onTapGesture {
                        isFocused = true
                    }
            }
            
            // Main TextEditor
            textEditorWithOnChange
                .focused($isFocused)
                .frame(height: max(editorHeight, CraveTheme.Spacing.textEditorMinHeight))
                .background(Color.black.opacity(0.3))
                .cornerRadius(CraveTheme.Layout.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: CraveTheme.Layout.cornerRadius)
                        .stroke(
                            isFocused ?
                                CraveTheme.Colors.accent.opacity(0.5) :
                                Color.white.opacity(0.3),
                            lineWidth: 1
                        )
                        .animation(.easeInOut(duration: 0.2), value: isFocused)
                )
                .onChange(of: text) { _ in
                    calculateEditorHeight()
                }
            
            // Speech button with animation
            Button {
                CraveHaptics.shared.lightImpact()
                onMicTap()
            } label: {
                Image(systemName: isRecordingSpeech ? "waveform.circle.fill" : "mic.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isRecordingSpeech ? CraveTheme.Colors.accent : .white.opacity(0.8))
                    .padding(8)
                    .background(
                        Circle()
                            .fill(isRecordingSpeech ?
                                  Color.white.opacity(0.2) :
                                  Color.black.opacity(0.4))
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
        // Calculate based on text length with a reasonable limit
        let estimatedLines = text.count / 35 + 1 // Rough estimate of chars per line
        let newHeight = min(max(baseHeight, CGFloat(estimatedLines) * 20), 300)
        
        if editorHeight != newHeight {
            withAnimation(.easeOut(duration: 0.2)) {
                editorHeight = newHeight
            }
        }
    }
}

// MARK: - Text Editor Implementation
extension CraveTextEditor {
    var textEditorWithOnChange: some View {
        let base = TextEditor(text: $text)
            .font(CraveTheme.Typography.body)
            .foregroundColor(CraveTheme.Colors.primaryText)
            .modifier(ScrollBackgroundClearModifier())
            .padding(.trailing, 38) // Space for the mic button
        
        if #available(iOS 17.0, *) {
            return AnyView(
                base.onChange(of: text, initial: false) { _, newValue in
                    limitTextIfNeeded(newValue)
                }
            )
        } else {
            return AnyView(
                base.onChange(of: text) { newValue in
                    limitTextIfNeeded(newValue)
                }
            )
        }
    }
    
    private func limitTextIfNeeded(_ newValue: String) {
        if characterLimit > 0, newValue.count > characterLimit {
            text = String(newValue.prefix(characterLimit))
            CraveHaptics.shared.notification(type: .warning)
        }
    }
}

// MARK: - Background Modifier
struct ScrollBackgroundClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            return AnyView(content.scrollContentBackground(.hidden))
        } else {
            return AnyView(
                content
                    .onAppear {
                        // Pre-iOS 16 background appearance fix
                        UITextView.appearance().backgroundColor = .clear
                    }
                    .onDisappear {
                        UITextView.appearance().backgroundColor = nil
                    }
            )
        }
    }
}

// MARK: - Previews
struct CraveTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            CraveTextEditor(
                text: .constant(""),
                isRecordingSpeech: false,
                onMicTap: {},
                placeholderLines: [
                    .plain("What are you craving?"),
                    .plain("When did it start?"),
                    .plain("Where are you?")
                ]
            )
            .padding()
        }
    }
}
