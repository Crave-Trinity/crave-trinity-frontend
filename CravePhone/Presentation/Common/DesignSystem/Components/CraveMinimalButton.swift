//
//  CraveMinimalButton.swift
//  CravePhone
//
//  Description:
//    A modern, minimal SwiftUI button for CRAVE.
//    Adheres to the Single Responsibility Principle by focusing
//    solely on rendering a minimal style button with an action.
//    Also references the unified CraveTheme for styling.
//
//  Created by <Your Name> on <date>.
//  Updated by ChatGPT on <today's date>.
//

import SwiftUI

struct CraveMinimalButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    
    var body: some View {
        Button(action: action) {
            label()
                .padding()
                .frame(maxWidth: .infinity)
                .background(CraveTheme.Colors.accent)
                .foregroundColor(CraveTheme.Colors.buttonText)
                .cornerRadius(12)
        }
        // Using .plain style to avoid default SwiftUI button styling
        .buttonStyle(.plain)
    }
}
