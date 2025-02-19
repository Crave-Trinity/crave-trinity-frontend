//
//  WatchCraveTextEditor.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A specialized text editor for watch input.
//               Shows placeholder text if empty, with a character limit,
//               and integrates with FocusState for the watch keyboard.
//

import SwiftUI

struct WatchCraveTextEditor: View {
    /// The text bound to this editor (e.g., the user’s craving description).
    @Binding var text: String
    
    /// The main placeholder text (top line).
    var primaryPlaceholder: String
    
    /// A secondary placeholder text (bottom line), often used for hints or examples.
    var secondaryPlaceholder: String
    
    /// A binding to the parent’s FocusState for controlling the watch keyboard.
    @FocusState.Binding var isFocused: Bool
    
    /// The maximum number of characters allowed in the text.
    var characterLimit: Int

    var body: some View {
        ZStack(alignment: .top) {
            // If there's no text and it's not focused, show placeholder text.
            if text.isEmpty && !isFocused {
                VStack(alignment: .center, spacing: 8) {
                    Text(primaryPlaceholder)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Text(secondaryPlaceholder)
                        .font(.footnote)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
            }

            // The actual text field
            TextField("", text: $text, axis: .vertical)
                .multilineTextAlignment(.center)
                .lineLimit(3) // watch-friendly limit
                // Use the new two-parameter onChange to avoid watchOS 10 deprecation
                .onChange(of: text) { oldValue, newValue in
                    // Enforce character limit
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                        // Provide a haptic if user hits the limit
                        WatchHapticManager.shared.play(.warning)
                    }
                    // Optionally provide a haptic when user starts typing
                    else if oldValue.isEmpty && !newValue.isEmpty {
                        WatchHapticManager.shared.play(.selection)
                    }
                }
                .frame(minHeight: 60)
                // Give a subtle background if user is typing or there's text
                .background(text.isEmpty && !isFocused ? .clear : Color.gray.opacity(0.2))
                .cornerRadius(8)
                // Tie the field to the watch's focus system
                .focused($isFocused)
                // Tapping the text field triggers focus (which should bring up the watch keyboard)
                .onTapGesture {
                    isFocused = true
                    WatchHapticManager.shared.play(.selection)
                }
                // If empty & not focused, fade it slightly
                .opacity(text.isEmpty && !isFocused ? 0.7 : 1)
        }
    }
}
