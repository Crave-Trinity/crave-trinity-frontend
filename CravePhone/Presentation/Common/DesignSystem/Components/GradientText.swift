//
//  GradientText.swift
//  CravePhone
//
//  Description:
//    Simple gradient text overlay for a bold, modern style.
//
//  Uncle Bob notes:
//    - Single Responsibility: Draws text with a mask gradient.
//

import SwiftUI

public struct GradientText: View {
    let text: String
    let font: Font
    let gradient: LinearGradient
    
    public var body: some View {
        Text(text)
            .font(font)
            .overlay {
                gradient
                    .mask(Text(text).font(font))
            }
    }
}

