//
// CraveTextEditor.swift
// /CravePhone/Presentation/Common/DesignSystem/Components/CraveTextEditor.swift
//
// Revised for consistent font, spacing, and styling in the Log Craving view.
// Uses CraveTheme values for fonts, colors, corner radius, and spacing.
import SwiftUI

struct CraveTextEditor: View {
    @Binding var text: String
    
    // Maximum number of characters allowed.
    let characterLimit: Int = 300
    
    // Tracks the dynamic height of the TextEditor; starting at a larger box height.
    @State private var editorHeight: CGFloat = 150
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Show placeholder when text is empty.
            if text.isEmpty {
                placeholderContent
                    .allowsHitTesting(false) // Allow taps to pass through.
            }
            // Main TextEditor with consistent styling.
            TextEditor(text: $text)
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.primaryText)
                .frame(height: max(editorHeight, 150))
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
    }
    
    // MARK: - Placeholder Content
    private var placeholderContent: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.small) {
            Text("Trigger?")
            Text("Location?")
            Text("Activity?")
            Text("People?")
        }
        .font(CraveTheme.Typography.body.weight(.medium))
        .foregroundColor(CraveTheme.Colors.placeholderSecondary)
        .padding(.leading, CraveTheme.Spacing.small)
        .padding(.top, CraveTheme.Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Dynamic Height Calculation
    private func recalcHeight() {
        // Estimate lines based on character count.
        let linesCount = text.count / 35 + 1
        // Calculate new height while capping at 300 for aesthetics.
        let newHeight = min(max(150, CGFloat(linesCount) * 20), 300)
        if editorHeight != newHeight {
            withAnimation(CraveTheme.Animations.smooth) {
                editorHeight = newHeight
            }
        }
    }
}
