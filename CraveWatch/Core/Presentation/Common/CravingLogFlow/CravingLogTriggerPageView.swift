//
//  CravingLogTriggerPageView.swift
//  CraveWatch
//
//  A dedicated subview for logging the "Trigger" text.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogTriggerPageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel

    // We control the text editor’s focus from here
    @FocusState.Binding var isEditorFocused: Bool

    // A callback to move to the next step in the flow
    let onNext: () -> Void

    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            Text("Trigger")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))

            WatchCraveTextEditor(
                text: $viewModel.cravingText,
                primaryPlaceholder: "Log Craving",
                secondaryPlaceholder: "",
                isFocused: $isEditorFocused,
                characterLimit: 200
            )
            .frame(height: 80)

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

// MARK: - Shared Gradient (Optionally put this in a shared file if used often)
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)
