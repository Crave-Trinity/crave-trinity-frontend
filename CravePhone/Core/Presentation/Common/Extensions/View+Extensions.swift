//
//  View+Extensions.swift
//  CravePhone
//
//  Created by John H Jung on ...
//  Updated by ChatGPT on ...
//

import SwiftUI

public extension View {
    /// Adds a stroke border with a custom color and corner radius.
    /// Defaults to gray, 8pt corner radius if not specified.
    func roundedBorder(
        color: Color = .gray,
        cornerRadius: CGFloat = 8,
        lineWidth: CGFloat = 1
    ) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}
