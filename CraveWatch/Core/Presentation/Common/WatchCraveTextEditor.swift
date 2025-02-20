//
//  WatchCraveTextEditor.swift
//  CraveWatch
//
//  Description: A custom text editor for the watch with placeholder text,
//               a character limit, and focus state handling. It displays a bright gradient
//               on the primary placeholder when no text is entered.
//
import SwiftUI

struct WatchCraveTextEditor: View {
    @Binding var text: String
    /// The main placeholder text (e.g., "Tap to log craving")
    var primaryPlaceholder: String
    /// A secondary prompt (e.g., "200 chars")
    var secondaryPlaceholder: String
    @FocusState.Binding var isFocused: Bool
    /// Maximum number of characters allowed
    var characterLimit: Int

    var body: some View {
        ZStack(alignment: .top) {
            // Placeholder view: appears only when text is empty and not focused.
            if text.isEmpty && !isFocused {
                VStack(alignment: .center, spacing: 8) {
                    Text(primaryPlaceholder)
                        .font(.body)
                        .foregroundColor(.clear) // hide actual text
                        .overlay {
                            brightGradient // overlay the bright gradient
                        }
                        .mask {
                            Text(primaryPlaceholder)
                                .font(.body)
                        }
                    
                    Text(secondaryPlaceholder)
                        .font(.footnote)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
                .onTapGesture {
                    isFocused = true
                }
            }
            
            // The actual text editor.
            TextField("", text: $text, axis: .vertical)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .onChange(of: text) { oldValue, newValue in
                    // Enforce character limit
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                        WatchHapticManager.shared.play(.warning)
                    }
                    // Provide haptic feedback when the user starts typing
                    else if oldValue.isEmpty && !newValue.isEmpty {
                        WatchHapticManager.shared.play(.selection)
                    }
                }
                .frame(minHeight: 60)
                .background(text.isEmpty && !isFocused ? .clear : Color.gray.opacity(0.2))
                .cornerRadius(8)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                    WatchHapticManager.shared.play(.selection)
                }
                .opacity(text.isEmpty && !isFocused ? 0.7 : 1)
        }
    }
}

// MARK: - Bright Gradient
/// A bright orange-to-yellow gradient for the primary placeholder text.
fileprivate let brightGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.12, saturation: 1.0, brightness: 1.0), // bright orange
        Color(hue: 0.08, saturation: 1.0, brightness: 1.0)  // bright yellow
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

