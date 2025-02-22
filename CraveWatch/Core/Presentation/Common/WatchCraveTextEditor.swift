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
    
    /// Primary placeholder text shown when the editor is empty and not focused.
    let primaryPlaceholder: String
    
    /// Optional secondary placeholder text.
    let secondaryPlaceholder: String
    
    /// Controls whether this text editor is focused for input.
    @FocusState.Binding var isFocused: Bool
    
    /// Maximum number of characters allowed before truncation and haptic feedback.
    let characterLimit: Int
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .center) {
            // Background: A rounded rectangle with varying opacity based on focus.
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    isFocused
                    ? Color.gray.opacity(0.2)
                    : Color.gray.opacity(0.15)
                )
            
            // Placeholder: Visible only when text is empty and the editor is not focused.
            if text.isEmpty && !isFocused {
                VStack(alignment: .center, spacing: 4) {
                    // Primary placeholder with a bright gradient overlay.
                    Text(primaryPlaceholder)
                        .font(.body)
                        .foregroundColor(.clear)
                        .overlay {
                            brightGradient
                        }
                        .mask {
                            Text(primaryPlaceholder).font(.body)
                        }
                    
                    // Secondary placeholder text.
                    Text(secondaryPlaceholder)
                        .font(.footnote)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            
            // Actual text field for input.
            TextField("", text: $text, axis: .vertical)
                .multilineTextAlignment(.center)
                .focused($isFocused)
                .foregroundColor(.white)
                .onTapGesture {
                    // Ensure the text editor becomes focused when tapped.
                    isFocused = true
                }
        }
        .frame(height: 80)
        .onChange(of: text) { oldValue, newValue in
            enforceCharacterLimit(oldValue: oldValue, newValue: newValue)
        }
    }
    
    // MARK: - Character Limit Enforcement
    private func enforceCharacterLimit(oldValue: String, newValue: String) {
        if newValue.count > characterLimit {
            // Trim the text to the allowed character limit.
            text = String(newValue.prefix(characterLimit))
            // Trigger a haptic warning using the shared WatchHapticManager.
            WatchHapticManager.shared.play(.warning)
        }
    }
}

// MARK: - Bright Gradient for the Primary Placeholder
fileprivate let brightGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.12, saturation: 1.0, brightness: 1.0), // Bright orange
        Color(hue: 0.08, saturation: 1.0, brightness: 1.0)  // Bright yellow
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
