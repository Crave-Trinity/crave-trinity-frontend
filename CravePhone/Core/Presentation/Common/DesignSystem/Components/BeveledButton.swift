
// BeveledButton.swift
// Core/Presentation/Common/DesignSystem/Components

import SwiftUI

/// A 3D beveled button for better UI interaction.
public struct BeveledButton: View { // Made public for external access
    let title: String
    let action: () -> Void
    
    public init(title: String, action: @escaping () -> Void) { // Public initializer
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        Color(white: 0.2) // base color
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 2)
                            .stroke(Color(white: 0.4), lineWidth: 4) // outer highlight
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                    }
                )
                .cornerRadius(8)
        }
    }
}
