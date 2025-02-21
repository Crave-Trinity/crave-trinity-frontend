//
//  GradientText.swift
//  CravePhone
//
//  Description:
//    Simple gradient text overlay.
//  Uncle Bob notes:
//    - Single Responsibility: Just draws text with a mask gradient.
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
                gradient.mask(Text(text).font(font))
            }
    }
}

