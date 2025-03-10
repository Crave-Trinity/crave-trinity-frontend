//==================================================
// File: CraveTextEditor.swift
// Directory: CravePhone/Presentation/Common/DesignSystem/Components/CraveTextEditor.swift
//
// Purpose:
//   Refactor the CraveTextEditor so that it focuses solely on text input,
//   dynamic height calculation, and enforcing the character limit.
//   The accessory controls (character count and mic toggle) are delegated
//   to a dedicated accessory row, making the component adhere to the
//   Single Responsibility Principle.
//==================================================
import SwiftUI

struct CraveTextEditor: View {
    @Binding var text: String
    
    // Maximum number of characters allowed.
    let characterLimit: Int = 300
    
    // New parameters for accessory behavior.
    let isRecording: Bool
    let onToggle: () -> Void
    
    // Tracks the dynamic height of the TextEditor; starting with a minimal height.
    @State private var editorHeight: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            // Main TextEditor for text input with placeholder handling.
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    // Placeholder handling can be customized here.
                    EmptyView()
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $text)
                    .font(CraveTheme.Typography.body)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                    .frame(height: max(editorHeight, 100))
                    .padding(.trailing, CraveTheme.Spacing.small)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(CraveTheme.Layout.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: CraveTheme.Layout.cornerRadius)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .modifier(ScrollBackgroundClearModifier())
                    .onChangeBackport(of: text, initial: false) { _, newVal in
                        // Enforce character limit and recalculate dynamic height.
                        if newVal.count > characterLimit {
                            text = String(newVal.prefix(characterLimit))
                            CraveHaptics.shared.notification(type: .warning)
                        }
                        recalcHeight()
                    }
            }
            
            // Accessory row displaying character count and speech-to-text mic button.
            CraveTextEditorAccessoryRow(
                text: $text,
                characterLimit: characterLimit,
                isRecording: isRecording,
                onToggle: onToggle
            )
        }
    }
    
    // MARK: - Dynamic Height Calculation
    private func recalcHeight() {
        // Estimate lines based on character count (approximately 35 chars per line).
        let linesCount = text.count / 35 + 1
        // Calculate new height with a cap for aesthetics.
        let newHeight = min(max(100, CGFloat(linesCount) * 20), 300)
        
        if editorHeight != newHeight {
            withAnimation(CraveTheme.Animations.smooth) {
                editorHeight = newHeight
            }
        }
    }
}
