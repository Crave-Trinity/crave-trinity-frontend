//
//  CraveTextEditor.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    - A custom TextEditor with placeholder logic & character-limit control.
//    - We’ve removed any .focused() calls here, because we now manage focus in the parent.
//
import SwiftUI

struct CraveTextEditor: View {
    @Binding var text: String
    let characterLimit: Int = 300

    @State private var editorHeight: CGFloat = 120

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                placeholderContent
                    .allowsHitTesting(false)
            }

            TextEditor(text: $text)
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.primaryText)
                .frame(height: max(editorHeight, 120))
                .padding(.trailing, 8)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .modifier(ScrollBackgroundClearModifier())
                .onChangeBackport(of: text, initial: false) { _, newVal in
                    if newVal.count > characterLimit {
                        text = String(newVal.prefix(characterLimit))
                        CraveHaptics.shared.notification(type: .warning)
                    }
                    recalcHeight()
                }
        }
    }

    // MARK: - Placeholder
    private var placeholderContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Trigger?")
            Text("Location?")
            Text("Activity?")
            Text("People?")
        }
        .font(CraveTheme.Typography.body.weight(.medium))
        .foregroundColor(CraveTheme.Colors.placeholderSecondary)
        .padding(.leading, 4)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Height Calculation
    private func recalcHeight() {
        let linesCount = text.count / 35 + 1
        let newHeight = min(max(120, CGFloat(linesCount) * 20), 300)
        if editorHeight != newHeight {
            withAnimation(.easeOut(duration: 0.2)) {
                editorHeight = newHeight
            }
        }
    }
}
