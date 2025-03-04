//
//  CraveTextEditor.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    - A custom TextEditor with placeholder logic & character-limit control.
//    - Manages its own dynamic height so user text can expand gracefully.
//
//  "DESIGNED FOR STEVE JOBS":
//    - Subtle spacing adjustments for the placeholder
//      so it's visually balanced.
//    - Slightly larger default text box for a more comfortable experience.
//
//  NOTE:
//    - We raised the minimum editorHeight to 150 (was 120).
//    - Increased spacing/padding in the placeholder for a more elegant layout.
//

import SwiftUI

struct CraveTextEditor: View {
    @Binding var text: String
    
    /// Maximum number of characters allowed.
    let characterLimit: Int = 300
    
    /// Tracks the dynamic height of the TextEditor. We start at 150 for a bigger box.
    @State private var editorHeight: CGFloat = 150

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // 1) If no user text, show the placeholder.
            if text.isEmpty {
                placeholderContent
                    .allowsHitTesting(false) // Let taps pass through to the TextEditor behind.
            }

            // 2) Main TextEditor
            TextEditor(text: $text)
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.primaryText)
                .frame(height: max(editorHeight, 150)) // Use the updated dynamic height.
                .padding(.trailing, 8)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                // Clears the background behind the text for older iOS versions.
                .modifier(ScrollBackgroundClearModifier())
                // When the text changes, recalc the height and enforce character limit.
                .onChangeBackport(of: text, initial: false) { _, newVal in
                    if newVal.count > characterLimit {
                        text = String(newVal.prefix(characterLimit))
                        CraveHaptics.shared.notification(type: .warning)
                    }
                    recalcHeight()
                }
        }
    }

    // MARK: - Placeholder Content
    private var placeholderContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Trigger?")
            Text("Location?")
            Text("Activity?")
            Text("People?")
        }
        .font(CraveTheme.Typography.body.weight(.medium))
        .foregroundColor(CraveTheme.Colors.placeholderSecondary)
        .padding(.leading, 8)
        .padding(.top, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Dynamic Height Calculation
    private func recalcHeight() {
        // Approximate lines of text by dividing character count by 35.
        let linesCount = text.count / 35 + 1
        // Let the editor expand but cap it at 300 for aesthetics.
        let newHeight = min(max(150, CGFloat(linesCount) * 20), 300)
        
        if editorHeight != newHeight {
            withAnimation(.easeOut(duration: 0.2)) {
                editorHeight = newHeight
            }
        }
    }
}

