//
//  CraveButton.swift
//  CravePhone
//
//  Description:
//    A minimal, watch-inspired button. Uses a larger font for the button text.
//    Defaults to the brand (blue) gradient, but can accept a custom gradient.
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today’s date>.
//

import SwiftUI

public struct CraveButton: View {
    // MARK: - Properties
    public let title: String
    public let action: () -> Void
    public let gradient: LinearGradient
    
    // Optional customization
    private var cornerRadius: CGFloat = CRAVEDesignSystem.Layout.cornerRadius
    private var buttonHeight: CGFloat = CRAVEDesignSystem.Layout.buttonHeight
    
    // MARK: - Initializers
    public init(
        title: String,
        action: @escaping () -> Void,
        gradient: LinearGradient
    ) {
        self.title = title
        self.action = action
        self.gradient = gradient
    }
    
    // Convenience: brand default
    public init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.init(
            title: title,
            action: action,
            gradient: CRAVEDesignSystem.Colors.brandGradient
        )
    }
    
    // MARK: - Body
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(CRAVEDesignSystem.Typography.buttonLarge)
                .foregroundColor(CRAVEDesignSystem.Colors.textOnPrimary)
                .frame(maxWidth: .infinity, minHeight: buttonHeight)
                .background(gradient)
                .cornerRadius(cornerRadius)
        }
    }
}
