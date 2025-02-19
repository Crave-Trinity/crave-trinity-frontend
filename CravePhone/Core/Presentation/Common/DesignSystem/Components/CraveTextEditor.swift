// File: CravePhone/Core/Presentation/Common/DesignSystem/Components/CraveTextEditor.swift
// Project: CraveTrinity
// Directory: ./CravePhone/Core/Presentation/Common/DesignSystem/Components/

import SwiftUI

public struct CraveTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let characterLimit: Int
    
    public init(text: Binding<String>, placeholder: String, characterLimit: Int) {
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .frame(minHeight: 40)
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > characterLimit {
                    text = String(newValue.prefix(characterLimit))
                }
            }
    }
}

// MARK: - Preview
#Preview {
    CraveTextEditor(
        text: .constant(""),
        placeholder: "Enter text...",
        characterLimit: 280
    )
    .padding()
}
