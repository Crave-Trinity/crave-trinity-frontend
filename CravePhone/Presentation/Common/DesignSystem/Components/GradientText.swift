//
//  GradientText.swift
//  CravePhone
//
//  Text component with gradient fill for vibrant UI elements.
//

import SwiftUI

public struct GradientText: View {
    private let text: String
    private let gradient: LinearGradient
    private let font: Font
    
    public init(text: String, font: Font, gradient: LinearGradient) {
        self.text = text
        self.font = font
        self.gradient = gradient
    }
    
    public var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(gradient)
    }
}

#Preview {
    GradientText(
        text: "Craving Chocolate",
        font: .system(size: 24, weight: .bold),
        gradient: LinearGradient(
            colors: [.orange, .red],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
    .padding()
    .background(Color.black)
}
