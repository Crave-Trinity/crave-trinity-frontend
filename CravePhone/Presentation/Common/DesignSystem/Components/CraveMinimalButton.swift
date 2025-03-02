//
//  CraveMinimalButton.swift
//  CravePhone
//
//  PURPOSE:
//    - A minimal SwiftUI button that uses CraveTheme styling.
//
//  ARCHITECTURE:
//    - Single Responsibility: Simple stylized button, no side effects.
//    - Could reference an external theme or layout config.
//
//  GANG OF FOUR:
//    - "Decorator" pattern (somewhat) if you wrap the label further.
//
//  CREATED: <date>.
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
        .buttonStyle(.plain)
    }
}

