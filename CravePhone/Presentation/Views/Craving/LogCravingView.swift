//  LogCravingView.swift
//  CravePhone
//
//  RESPONSIBILITY:
//   - Presents the "Log Craving" screen with description, sliders, and emotions.
//   - Validates form inputs before allowing submission.
//

import SwiftUI

public struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    
    // Control keyboard focus on the description field
    @FocusState private var isDescriptionFocused: Bool
    
    // Track submission to show a spinner and disable repeated taps
    @State private var isSubmitting = false

    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            // Background gradient; tapping it dismisses the keyboard
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
                .onTapGesture {
                    isDescriptionFocused = false
                }

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Description text area
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isFocused: $isDescriptionFocused
                    )
                    
                    // Speech toggle button
                    CraveSpeechToggleButton(
                        isRecording: viewModel.isRecordingSpeech,
                        onToggle: {
                            viewModel.toggleSpeechRecognition()
                            CraveHaptics.shared.mediumImpact()
                        }
                    )
                    
                    // Two sliders: intensity & resistance
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    // Emotion chips
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { e in
                            viewModel.toggleEmotion(e)
                            CraveHaptics.shared.selectionChanged()
                        }
                    )

                    // Submit button
                    submitButton
                }
                .padding()
            }
        }
        .toolbar {
            // Keyboard toolbar with a "Done" button to dismiss
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isDescriptionFocused = false
                }
            }
        }
        // Alert for success/error messages
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: - Submit Button

    private var submitButton: some View {
        Button {
            submitCraving()
        } label: {
            HStack {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.trailing, 6)
                }
                Text(isSubmitting ? "Saving..." : "Log Craving")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.cornerRadius(8))
            .foregroundColor(.white)
        }
        // NEW: Disable if submitting OR invalid form
        .disabled(isSubmitting || !viewModel.isValid)
    }

    // MARK: - Submit Logic

    private func submitCraving() {
        guard !isSubmitting else { return }
        
        // Optional extra guard to catch forced submissions
        guard viewModel.isValid else {
            viewModel.alertInfo = AlertInfo(
                title: "Invalid Entry",
                message: "Please provide a description and an intensity above 0."
            )
            return
        }
        
        isSubmitting = true
        Task {
            await viewModel.logCraving()
            isSubmitting = false
            // Dismiss keyboard
            isDescriptionFocused = false
        }
    }
}
