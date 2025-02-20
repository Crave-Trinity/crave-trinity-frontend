//
//  CraveButton.swift
//  CravePhone
//
//  Description:
//    A minimal, watch-inspired button. Uses a larger font for the button text.
//    Defaults to the brand (blue) gradient, but you can pass in the orange gradient.
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today’s date>.
//

import SwiftUI

public struct CraveButton: View {
    public let title: String
    public let action: () -> Void
    public let gradient: LinearGradient

    // Primary initializer that requires a gradient
    public init(
        title: String,
        action: @escaping () -> Void,
        gradient: LinearGradient
    ) {
        self.title = title
        self.action = action
        self.gradient = gradient
    }
    
    // Convenience init: defaults to the brand gradient (blue)
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
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(CRAVEDesignSystem.Typography.buttonLarge) // bigger text
                .foregroundColor(CRAVEDesignSystem.Colors.textOnPrimary)
                .frame(maxWidth: .infinity, minHeight: CRAVEDesignSystem.Layout.buttonHeight)
                .background(gradient)
                .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius)
        }
    }
}

