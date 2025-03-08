//
// CraveTextEditor.swift
// /CravePhone/Presentation/Common/DesignSystem/Components/CraveTextEditor.swift
//
// Revised for consistent font, spacing, and styling in the Log Craving view.
// Uses CraveTheme values for fonts, colors, corner radius, and spacing.
// Now with:
//  - Smaller default min height (100 instead of 150).
//  - A character count indicator (e.g. 0/300) displayed at the bottom-right.
//
import SwiftUI

struct CraveTextEditor: View {
    @Binding var text: String
    
    // Maximum number of characters allowed.
    let characterLimit: Int = 300
    
    // Tracks the dynamic height of the TextEditor; starting at a smaller box height.
    @State private var editorHeight: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            
            // The main TextEditor wrapped in a ZStack for placeholder handling.
            ZStack(alignment: .topLeading) {
                
                // Show a placeholder only when text is empty. Currently empty, so no visible text.
                if text.isEmpty {
                    EmptyView()
                        .allowsHitTesting(false) // Let taps go through to the editor.
                }
                
                // Main TextEditor with consistent styling.
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
                        // Enforce character limit and update height.
                        if newVal.count > characterLimit {
                            text = String(newVal.prefix(characterLimit))
                            CraveHaptics.shared.notification(type: .warning)
                        }
                        recalcHeight()
                    }
            }
            
            // Character count (e.g. "0/300"), aligned to the trailing edge.
            Text("\(text.count)/\(characterLimit)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.trailing, 4)
        }
    }
    
    // MARK: - Dynamic Height Calculation
    private func recalcHeight() {
        // Estimate lines based on character count (about 35 chars per line).
        let linesCount = text.count / 35 + 1
        
        // Calculate new height, capping at 300 for aesthetics.
        let newHeight = min(max(100, CGFloat(linesCount) * 20), 300)
        
        if editorHeight != newHeight {
            withAnimation(CraveTheme.Animations.smooth) {
                editorHeight = newHeight
            }
        }
    }
}
