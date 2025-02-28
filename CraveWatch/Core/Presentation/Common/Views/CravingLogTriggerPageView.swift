//
//  CravingLogTriggerPageView.swift
//  CraveWatch
//
//  A dedicated subview for logging the craving details,
//  featuring a subtle blue accent and more vertical space
//  for the text editor.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogTriggerPageView: View {
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: CravingLogViewModel

    /// Binding controlling whether the text editor is focused.
    @FocusState.Binding var isEditorFocused: Bool

    /// Callback invoked when the user taps the "Next" button.
    let onNext: () -> Void

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Title near the top
            Text("Log Your Craving")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(blueAccent)
                // Align title to the leading edge if desired
                .frame(maxWidth: .infinity, alignment: .leading)
                // Add some top padding to give it breathing room
                .padding(.horizontal, 12)
                .padding(.top, 8)
            
            // The text editor with a slightly larger frame
            MinimalWatchCraveTextEditor(
                text: $viewModel.cravingText,
                placeholder: "What triggered it?",
                isFocused: $isEditorFocused,
                characterLimit: 200
            )
            .modifier(BlueFocusModifier(isFocused: isEditorFocused))
            // Increased height from ~80 to 100 for more typing space
            .frame(height: 100)
            .padding(.horizontal, 12)
            
            // "Next" Button with a gentle blue gradient
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(blueGradient)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
            .padding(.horizontal, 12)
            .padding(.top, 6)
            
            Spacer(minLength: 0)
        }
        // Overall vertical padding at the bottom if needed
        .padding(.bottom, 8)
    }
    
    // MARK: - Accent Colors & Gradients
    
    /// A simple, deep-blue accent color reminiscent of classic Apple Aqua
    private let blueAccent = Color(hue: 0.58, saturation: 0.7, brightness: 0.85)
    
    /// Subtle gradient from a slightly lighter blue to a deeper one
    private var blueGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: 0.58, saturation: 0.6, brightness: 0.88),
                Color(hue: 0.58, saturation: 0.8, brightness: 0.65)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

/// A small view modifier that gives the text editor
/// a faint blue overlay when focused, further unifying
/// the color scheme for this screen only.
private struct BlueFocusModifier: ViewModifier {
    let isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        Color(hue: 0.58, saturation: 0.7, brightness: 0.85)
                            .opacity(isFocused ? 0.4 : 0),
                        lineWidth: 1
                    )
            )
    }
}

