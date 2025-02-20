//
//  CraveButton.swift
//  CravePhone
//
//  Description:
//    A UI component representing a button styled using CRAVEDesignSystem.
//    Created by John H Jung on 2/12/25.
//    Updated by ChatGPT on <today’s date> to remove duplicate declarations.
//

import SwiftUI

public struct CraveButton: View {
    // Title to display on the button.
    public let title: String
    // Action to perform when the button is tapped.
    public let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(CRAVEDesignSystem.Typography.body)
                .foregroundColor(CRAVEDesignSystem.Colors.textOnPrimary)
                .frame(maxWidth: .infinity, minHeight: CRAVEDesignSystem.Layout.buttonHeight)
                .background(CRAVEDesignSystem.Colors.brandGradient)
                .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius)
        }
    }
}

