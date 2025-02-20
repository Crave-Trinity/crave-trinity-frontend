// LogCravingView.swift
// Core/Presentation/Views/Craving
// Description: Displays UI for logging cravings, including a marquee text at the top.
// Updated by ChatGPT

import SwiftUI

/// LogCravingView displays the UI for logging cravings, including a marquee text at the top.
struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: CRAVEDesignSystem.Layout.mediumSpacing) {
            // Infinite scrolling marquee text
            InfiniteMarqueeTextView(lines: ["Welcome to Crave!", "Stay strong!", "Keep going!"])
                .padding(.top, 10)

            // TextField for craving input with custom placeholder
            ZStack(alignment: .leading) {
                // Placeholder Text
                if viewModel.cravingText.isEmpty {
                    Text("Enter craving details...")
                        .foregroundColor(CRAVEDesignSystem.Colors.placeholderPrimary)
                        .font(CRAVEDesignSystem.Typography.body)
                        .padding(.horizontal, CRAVEDesignSystem.Layout.standardPadding)
                        .padding(.top, 10)
                }
                
                // Actual TextField
                TextField("", text: $viewModel.cravingText)
                    .focused($isFocused)
                    .padding()
                    .background(CRAVEDesignSystem.Colors.cardBackground)
                    .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius)
                    .foregroundColor(CRAVEDesignSystem.Colors.textPrimary)
                    .font(CRAVEDesignSystem.Typography.body)
                    .padding(.horizontal, CRAVEDesignSystem.Layout.standardPadding)
            }

            // Log Craving Button
            Button(action: {
                Task {
                    await viewModel.logCraving()
                }
            }) {
                Text("Log Craving")
                    .font(CRAVEDesignSystem.Typography.buttonLarge)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(CRAVEDesignSystem.Colors.cravingOrangeGradient)
                    .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius)
                    .foregroundColor(CRAVEDesignSystem.Colors.textOnPrimary)
            }

            // Displaying loading state or error message
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(.top, CRAVEDesignSystem.Layout.smallSpacing)
            }

            if let alertInfo = viewModel.alertInfo {
                Text(alertInfo.message)
                    .foregroundColor(CRAVEDesignSystem.Colors.danger)
                    .font(CRAVEDesignSystem.Typography.body)
            }

            Spacer()
        }
        .padding(CRAVEDesignSystem.Layout.standardPadding)
        .background(CRAVEDesignSystem.Colors.background)
        .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius)
        .shadow(radius: 10)
    }
}
