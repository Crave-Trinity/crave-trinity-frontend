// File: CraveWatch/Core/Presentation/Common/WatchCraveTextEditor.swift
// Project: CraveTrinity
// Directory: ./CraveWatch/Core/Presentation/Common/

import SwiftUI

struct WatchCraveTextEditor: View {
    // MARK: - Properties
    @Binding var text: String
    let placeholder: String
    let characterLimit: Int
    
    // MARK: - State
    @State private var isFocused: Bool = false
    
    // MARK: - Initialization
    init(text: Binding<String>, placeholder: String, characterLimit: Int) {
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            TextField("", text: $text)
                .textFieldStyle(.plain)
                .onChange(of: text) { oldValue, newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                        WatchHapticManager.shared.play(.warning)
                    } else if !newValue.isEmpty && oldValue.isEmpty {
                        WatchHapticManager.shared.play(.selection)
                    }
                }
        }
        .frame(height: 60)
        .background(Color.gray.opacity(0.2))  // Watch-appropriate background
        .cornerRadius(8)
        .onTapGesture {
            isFocused = true
            WatchHapticManager.shared.play(.selection)
        }
    }
}

// MARK: - Preview
#Preview {
    WatchCraveTextEditor(
        text: .constant(""),
        placeholder: "Tap to describe...",
        characterLimit: 280
    )
    .padding()
}
