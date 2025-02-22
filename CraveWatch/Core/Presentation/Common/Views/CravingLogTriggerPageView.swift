//
//  CravingLogTriggerPageView.swift
//  CraveWatch
//
//  A dedicated subview for logging the "Trigger" text. This view
//  uses a FocusState binding to control the text editor’s focus,
//  ensuring smooth user interaction.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

/// A view that allows users to log the trigger for their craving.
/// It provides a text editor with controlled focus, and a button to move to the next step.
struct CravingLogTriggerPageView: View {
    // MARK: - Dependencies
    
    /// The view model managing the state and logic for the craving log.
    @ObservedObject var viewModel: CravingLogViewModel

    /// A binding controlling whether the text editor is focused.
    /// This binding is provided by the parent view.
    @FocusState.Binding var isEditorFocused: Bool

    /// Callback invoked when the user taps the "Next" button to proceed.
    let onNext: () -> Void

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            // Section title indicating the purpose of the text editor.
            Text("Trigger")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
            
            // A custom text editor for logging the craving trigger.
            // It uses the provided focus binding and enforces a character limit.
            WatchCraveTextEditor(
                text: $viewModel.cravingText,
                primaryPlaceholder: "Log Craving",
                secondaryPlaceholder: "",
                isFocused: $isEditorFocused,
                characterLimit: 200
            )
            .frame(height: 80)
            
            // Button to proceed to the next step in the logging flow.
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 26)
                    .background(premiumBlueGradient)
                    .cornerRadius(6)
            }
            // Use plain style to remove extra styling.
            .buttonStyle(.plain)
            // Disable the button when the view model is in a loading state.
            .disabled(viewModel.isLoading)
        }
        // Apply horizontal padding and adjust vertical padding for visual balance.
        .padding(.horizontal)
        .padding(.top, -2)
        .padding(.bottom, 6)
    }
}

// MARK: - Shared Gradient
/// A shared blue gradient used for button backgrounds.
/// Consider moving this gradient definition to a shared file if it is used across multiple views.
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)
