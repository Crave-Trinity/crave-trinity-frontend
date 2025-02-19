// File: CraveWatch/Core/Presentation/Common/WatchCraveTextEditor.swift
// Project: CraveTrinity
// Directory: ./CraveWatch/Core/Presentation/Common/

import SwiftUI

/// A reusable text editor component specifically designed for watchOS.
/// Provides a clean, minimalist input area with haptic feedback and character limits.
struct WatchCraveTextEditor: View {
    @Binding var text: String
    var placeholder: String
    @FocusState var isFocused: Bool // Changed to @FocusState
    var characterLimit: Int

    var body: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .focused($isFocused) // Correctly using $isFocused
            .onChange(of: text) { _, newValue in
                if newValue.count > characterLimit {
                    text = String(newValue.prefix(characterLimit))
                    WatchHapticManager.shared.play(.warning)
                } else if !newValue.isEmpty && newValue.count == 1 {
                     WatchHapticManager.shared.play(.selection)
                }
            }
            .frame(minHeight: 60)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .onTapGesture {
                isFocused = true
                WatchHapticManager.shared.play(.selection)
            }
    }
}
