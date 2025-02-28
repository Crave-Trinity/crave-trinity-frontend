//
//  MinimalWatchCraveTextEditor.swift
//  CraveWatch
//
//  A refined watchOS text editor that embodies quiet luxury:
//    - Uses subdued grayscale hues.
//    - Removes bright gradients in favor of subtle focus states.
//    - Clean, center-aligned text with a simple placeholder.
//
//  Uncle Bob notes:
//    - Single Responsibility: Provide a watch-friendly TextEditor with character limit.
//    - Clean Code: Well-structured, easy to maintain.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI

struct MinimalWatchCraveTextEditor: View {
    // MARK: - Properties
    
    @Binding var text: String
    
    /// Single placeholder line to keep things minimal.
    let placeholder: String
    
    /// Controls whether this text editor is focused for input.
    @FocusState.Binding var isFocused: Bool
    
    /// Maximum number of characters allowed.
    let characterLimit: Int
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .center) {
            
            // Background: Subtle rectangle with an even more subtle highlight if focused
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
            
            // Placeholder text—shown only when empty and not focused
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.4))
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
            }
            
            // Actual input field
            TextField("", text: $text, axis: .vertical)
                .focused($isFocused)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .onTapGesture {
                    isFocused = true
                }
        }
        // Fixed height so it doesn’t expand uncontrollably.
        .frame(height: 70)
        .onChange(of: text) { oldValue, newValue in
            enforceCharacterLimit(oldValue: oldValue, newValue: newValue)
        }
        // A subtle animation whenever focus changes
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    // MARK: - Private Helpers
    
    private var backgroundColor: Color {
        // Lighten slightly when focused, remain dark when not.
        isFocused
        ? Color(white: 0.20) // slightly lighter background
        : Color(white: 0.15) // subtle dark
    }
    
    private func enforceCharacterLimit(oldValue: String, newValue: String) {
        if newValue.count > characterLimit {
            text = String(newValue.prefix(characterLimit))
            // Optional: Vibrate a small haptic to warn about limit
            WatchHapticManager.shared.play(.warning)
        }
    }
}

