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
    // MARK: - Bindings and Properties

    /// The text entered by the user.
    @Binding var text: String
    /// The main placeholder text (e.g., "Tap to log craving")
    var primaryPlaceholder: String
    /// A secondary prompt (e.g., "200 chars")
    var secondaryPlaceholder: String
    /// Binding to track the focus state of the text editor.
    @FocusState.Binding var isFocused: Bool
    /// Maximum number of characters allowed.
    var characterLimit: Int

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            // MARK: Placeholder View
            if text.isEmpty && !isFocused {
                VStack(alignment: .center, spacing: 4) {
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
            
            // MARK: Actual Text Editor
            TextField("", text: $text, axis: .vertical)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .onChange(of: text, perform: { newValue in
                    if newValue.count > characterLimit {
                        let truncated = String(newValue.prefix(characterLimit))
                        if text != truncated {
                            text = truncated
                            WatchHapticManager.shared.play(.warning)
                        }
                    } else if newValue.count == 1 {
                        // Updated to `.selection` instead of `.click`
                        WatchHapticManager.shared.play(.selection)
                    }
                })
                .frame(minHeight: 60)
                .background(isFocused ? Color.gray.opacity(0.2) : .clear)
                .cornerRadius(8)
                .focused($isFocused)
        }
    }
}

// MARK: - Bright Gradient
fileprivate let brightGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.12, saturation: 1.0, brightness: 1.0), // bright orange
        Color(hue: 0.08, saturation: 1.0, brightness: 1.0)  // bright yellow
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

