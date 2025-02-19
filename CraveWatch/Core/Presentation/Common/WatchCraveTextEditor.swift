//
//  WatchCraveTextEditor.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A specialized text editor for watch input.
//               Handles placeholder text, character limits, and fancy FocusState.
//

import SwiftUI

struct WatchCraveTextEditor: View {
    @Binding var text: String
    var primaryPlaceholder: String
    var secondaryPlaceholder: String
    
    // Ties into parent's @FocusState
    @FocusState.Binding var isFocused: Bool
    
    var characterLimit: Int

    var body: some View {
        ZStack(alignment: .top) {
            // Show placeholders only if user hasn't typed and it's not focused
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
                .lineLimit(3)
                // Use the new onChange with two parameters (oldValue, newValue)
                .onChange(of: text) { oldValue, newValue in
                    // Enforce character limit
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                        WatchHapticManager.shared.play(.warning)
                    }
                    // If user typed at least one character, do a "selection" haptic
                    else if !newValue.isEmpty && oldValue.isEmpty {
                        WatchHapticManager.shared.play(.selection)
                    }
                }
                .frame(minHeight: 60)
                // Subtle background color only when user is typing or text is present
                .background(text.isEmpty && !isFocused ? .clear : Color.gray.opacity(0.2))
                .cornerRadius(8)
                .focused($isFocused)
                .onTapGesture {
                    // Optionally force focus on tap
                    isFocused = true
                    WatchHapticManager.shared.play(.selection)
                }
                .opacity(text.isEmpty && !isFocused ? 0.7 : 1)
        }
    }
}
