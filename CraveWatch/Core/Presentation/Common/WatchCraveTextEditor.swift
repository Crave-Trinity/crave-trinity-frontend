//
//  WatchCraveTextEditor.swift
//  CraveWatch
//
//  A custom watchOS text editor that displays placeholder text (with a bright gradient)
//  centered within a fixed-height gray box when no text is entered. Enforces a character limit
//  and provides optional haptic feedback.
//
//  NOTE: We have removed the duplicate WatchHapticManager to avoid redeclarations.
//  This file now relies on your existing WatchHapticManager in Services/WatchHapticManager.swift.
//

import SwiftUI

struct WatchCraveTextEditor: View {
    // MARK: - Properties
    @Binding var text: String
    
    /// Shown when the text editor is empty and not focused (larger colorful text).
    let primaryPlaceholder: String
    
    /// Optional smaller text under the main placeholder.
    let secondaryPlaceholder: String
    
    /// Controls if this text editor is focused for input (Scribble or on-screen keyboard).
    @FocusState.Binding var isFocused: Bool
    
    /// Maximum number of characters allowed before truncation + haptic warning.
    let characterLimit: Int
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .center) {
            // MARK: - Background
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    isFocused
                    ? Color.gray.opacity(0.2)
                    : Color.gray.opacity(0.15)
                )
            
            // MARK: - Placeholder (only visible if empty + not focused)
            if text.isEmpty && !isFocused {
                VStack(alignment: .center, spacing: 4) {
                    
                    // Bright gradient "primary" placeholder
                    Text(primaryPlaceholder)
                        .font(.body)
                        .foregroundColor(.clear) // We'll overlay a gradient below
                        .overlay {
                            brightGradient
                        }
                        .mask {
                            Text(primaryPlaceholder).font(.body)
                        }
                    
                    // Secondary placeholder text
                    Text(secondaryPlaceholder)
                        .font(.footnote)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            
            // MARK: - Actual TextField
            // Keep this visible enough that watchOS recognizes it as a text input.
            TextField("", text: $text, axis: .vertical)
                .multilineTextAlignment(.center)
                .focused($isFocused)
                // If you truly want typed text hidden behind placeholders, do:
                // .foregroundColor(.clear)
                // ...but keep .opacity(1.0) so the system sees it for input.
                .foregroundColor(.white)
                .onTapGesture {
                    // Force focus when tapped
                    isFocused = true
                }
        }
        .frame(height: 80)
        .onChange(of: text) { oldValue, newValue in
            enforceCharacterLimit(oldValue: oldValue, newValue: newValue)
        }
    }
    
    // MARK: - Character Limit
    private func enforceCharacterLimit(oldValue: String, newValue: String) {
        if newValue.count > characterLimit {
            // Trim text to character limit, then use your existing WatchHapticManager
            text = String(newValue.prefix(characterLimit))
            WatchHapticManager.shared.play(.warning)
        }
    }
}

// MARK: - Bright Gradient for the primary placeholder
fileprivate let brightGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.12, saturation: 1.0, brightness: 1.0), // Bright orange
        Color(hue: 0.08, saturation: 1.0, brightness: 1.0)  // Bright yellow
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
