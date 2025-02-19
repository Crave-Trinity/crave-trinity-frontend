//
//  WatchCraveTextEditor.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A specialized text editor for watch input.
//               Handles placeholder text, character limits, and fancy focus state.
//

import SwiftUI

struct WatchCraveTextEditor: View {
    @Binding var text: String
    var primaryPlaceholder: String
    var secondaryPlaceholder: String
    
    // FANCY FOCUS: Ties into parent's @FocusState for advanced focus management.
    @FocusState.Binding var isFocused: Bool
    
    var characterLimit: Int

    var body: some View {
        ZStack(alignment: .top) {
            // Show placeholder if the user hasn't typed anything AND it's not focused
            if text.isEmpty && !isFocused {
                VStack(alignment: .center) {
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
                // Limit the number of characters, play haptic feedback if limit is reached.
                .onChange(of: text) { _, newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                        WatchHapticManager.shared.play(.warning)
                    } else if !newValue.isEmpty && newValue.count == 1 {
                        WatchHapticManager.shared.play(.selection)
                    }
                }
                .frame(minHeight: 60)
                // Subtle background color only when user is typing or text is present
                .background(text.isEmpty && !isFocused ? .clear : Color.gray.opacity(0.2))
                .cornerRadius(8)
                // Let's actually focus the text field so the watch keyboard can pop up
                .focused($isFocused)
                // Optionally handle taps if you want to manually trigger focus:
                .onTapGesture {
                    isFocused = true
                    WatchHapticManager.shared.play(.selection)
                }
                .opacity(text.isEmpty && !isFocused ? 0.7 : 1)
        }
    }
}
