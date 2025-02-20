//
//  WatchCraveTextEditor.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A custom text editor for the watch with placeholder text,
//               a character limit, and focus state handling. Now includes
//               a bright gradient on the primary placeholder text.
//

import SwiftUI

struct WatchCraveTextEditor: View {
    @Binding var text: String
    
    // The main "Tap to log craving" placeholder
    var primaryPlaceholder: String
    
    // The secondary "Max 50 chars" placeholder
    var secondaryPlaceholder: String
    
    // Whether the field is currently focused
    @FocusState.Binding var isFocused: Bool
    
    // Max characters allowed
    var characterLimit: Int

    var body: some View {
        ZStack(alignment: .top) {
            
            // Show placeholder text if empty & not focused
            if text.isEmpty && !isFocused {
                VStack(alignment: .center, spacing: 8) {
                    
                    // A) Bright gradient for the primary placeholder
                    Text(primaryPlaceholder)
                        .font(.body)
                        .foregroundColor(.clear)   // make actual text invisible
                        .overlay {
                            brightGradient          // overlay the gradient
                        }
                        .mask {
                            Text(primaryPlaceholder) // mask gradient to the text shape
                                .font(.body)
                        }
                    
                    // B) Secondary placeholder in normal gray
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
                .onChange(of: text) { oldValue, newValue in
                    // Enforce character limit
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                        WatchHapticManager.shared.play(.warning)
                    }
                    // Haptic feedback when user first starts typing
                    else if oldValue.isEmpty && !newValue.isEmpty {
                        WatchHapticManager.shared.play(.selection)
                    }
                }
                // Slight styling for the editor
                .frame(minHeight: 60)
                .background(text.isEmpty && !isFocused ? .clear : Color.gray.opacity(0.2))
                .cornerRadius(8)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                    WatchHapticManager.shared.play(.selection)
                }
                // If empty and not focused, reduce opacity
                .opacity(text.isEmpty && !isFocused ? 0.7 : 1)
        }
    }
}

// MARK: - Bright Gradient
/// A bright orange/yellow gradient for the primary placeholder text
fileprivate let brightGradient = LinearGradient(
    gradient: Gradient(colors: [
        // Feel free to tweak these for even more brightness/saturation
        Color(hue: 0.12, saturation: 1.0, brightness: 1.0), // bright orange
        Color(hue: 0.08, saturation: 1.0, brightness: 1.0)  // bright yellow
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

