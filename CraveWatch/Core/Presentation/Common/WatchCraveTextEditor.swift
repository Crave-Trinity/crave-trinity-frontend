//
//  WatchCraveTextEditor.swift
//  CraveWatch
//
//  Description:
//  A custom text editor for watchOS that displays placeholder text (with a bright gradient)
//  centered within a fixed-height gray box when no text is entered. Enforces a character limit
//  and provides optional haptic feedback.
//
//  Architecture & Principles:
//  - MVVM: Binds directly to a ViewModel property (`text`) for two-way data flow.
//  - Single Responsibility (SRP): Manages text input & placeholder rendering.
//  - Open/Closed (OCP): Easily extend to customize placeholders, haptics, or styling.
//  - Interface Segregation (ISP): Focuses solely on text editing concerns.
//  - Dependency Inversion (DIP): Relies on an external WatchHapticManager for haptic behavior.
//
//  Created with inspiration from Steve Jobs’s “focus on simplicity” and Uncle Bob’s Clean Code.
//

import SwiftUI

struct WatchCraveTextEditor: View {
    // MARK: - Properties
    
    /// Two-way binding for the text the user enters.
    @Binding var text: String
    
    /// The main placeholder text displayed in a bright gradient.
    let primaryPlaceholder: String
    
    /// A secondary line of placeholder text (e.g., a brief hint or character limit note).
    let secondaryPlaceholder: String
    
    /// Tracks whether the text field is currently focused.
    @FocusState.Binding var isFocused: Bool
    
    /// Maximum number of characters allowed in the text field.
    let characterLimit: Int
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .center) {
            
            // MARK: - Placeholder (centered)
            if text.isEmpty && !isFocused {
                VStack(alignment: .center, spacing: 4) {
                    
                    // Primary placeholder with bright gradient
                    Text(primaryPlaceholder)
                        .font(.body)
                        .foregroundColor(.clear)
                        .overlay {
                            brightGradient
                        }
                        .mask {
                            Text(primaryPlaceholder)
                                .font(.body)
                        }
                    
                    // Secondary placeholder
                    Text(secondaryPlaceholder)
                        .font(.footnote)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                // Tapping the placeholder focuses the field
                .onTapGesture {
                    isFocused = true
                }
            }
            
            // MARK: - Actual Text Field
            TextField("", text: $text, axis: .vertical)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                // Swift 5.9+ onChange that provides (oldValue, newValue)
                .onChange(of: text) { oldValue, newValue in
                    enforceCharacterLimit(oldValue: oldValue, newValue: newValue)
                }
                .focused($isFocused)
                .opacity(text.isEmpty && !isFocused ? 0 : 1)
        }
        // Fixed height ensures vertical centering works
        .frame(height: 80)
        // Gray box background
        .background(isFocused ? Color.gray.opacity(0.2) : Color.gray.opacity(0.15))
        .cornerRadius(8)
    }
    
    // MARK: - Private Helpers
    
    /// Enforces the character limit and provides haptic feedback as needed.
    private func enforceCharacterLimit(oldValue: String, newValue: String) {
        if newValue.count > characterLimit {
            // Truncate and optionally provide a haptic warning
            let truncated = String(newValue.prefix(characterLimit))
            if truncated != text {
                text = truncated
                WatchHapticManager.shared.play(.warning)
            }
        } else if newValue.count == 1 && oldValue.isEmpty {
            // Optional subtle feedback on the first typed character
            WatchHapticManager.shared.play(.selection)
        }
    }
}

// MARK: - Bright Gradient
fileprivate let brightGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.12, saturation: 1.0, brightness: 1.0), // Bright orange
        Color(hue: 0.08, saturation: 1.0, brightness: 1.0)  // Bright yellow
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
