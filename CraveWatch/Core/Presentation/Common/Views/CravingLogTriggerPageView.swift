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

struct CravingLogTriggerPageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel

    // The FocusState binding provided by the parent (CravingLogView)
    // to manage whether the text editor is focused.
    @FocusState.Binding var isEditorFocused: Bool

    // A callback to move to the next step in the logging flow.
    let onNext: () -> Void

    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            Text("Trigger")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))

            // The text editor where the user logs the craving trigger.
            // The focus is controlled by the binding passed from the parent.
            WatchCraveTextEditor(
                text: $viewModel.cravingText,
                primaryPlaceholder: "Log Craving",
                secondaryPlaceholder: "",
                isFocused: $isEditorFocused, // Binding passed to the editor
                characterLimit: 200
            )
            .frame(height: 80)

            // Button to proceed to the next page in the flow.
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 26)
                    .background(premiumBlueGradient)
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal)
        .padding(.top, -2)
        .padding(.bottom, 6)
    }
}

// MARK: - Shared Gradient
// A shared blue gradient used for button backgrounds.
// Consider placing this in a shared file if used across multiple views.
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)
