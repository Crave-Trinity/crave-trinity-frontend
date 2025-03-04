//
//  LogCravingView.swift
//  CravePhone
//
//  RESPONSIBILITY:
//   - Presents the "Log Craving" screen with description, sliders, and emotion chips.
//   - Allows toggling speech recognition via a button.
//   - Validates inputs and shows alerts as needed.
//

import SwiftUI

public struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    
    // Control keyboard focus on the description field
    @FocusState private var isDescriptionFocused: Bool
    
    // Track submission state
    @State private var isSubmitting = false

    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            // Background gradient that dismisses keyboard on tap
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
                .onTapGesture { isDescriptionFocused = false }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Description text area
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isFocused: $isDescriptionFocused
                    )
                    
                    // Speech toggle button – uses view model’s isRecordingSpeech and toggleSpeechRecognition()
                    CraveSpeechToggleButton(
                        isRecording: viewModel.isRecordingSpeech,
                        onToggle: {
                            viewModel.toggleSpeechRecognition()
                            CraveHaptics.shared.mediumImpact()
                        }
                    )
                    
                    // Sliders for intensity & resistance
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    // Emotion chips view – now calls toggleEmotion(_:)
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { emotion in
                            viewModel.toggleEmotion(emotion)
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
            // Keyboard toolbar with a "Done" button
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isDescriptionFocused = false }
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
        .disabled(isSubmitting || !viewModel.isValid)
    }

    // MARK: - Submit Logic
    private func submitCraving() {
        guard !isSubmitting else { return }
        guard viewModel.isValid else {
            viewModel.alertInfo = AlertInfo(title: "Invalid Entry", message: "Please enter a valid craving description and intensity.")
            return
        }
        isSubmitting = true
        Task {
            await viewModel.logCraving()
            isSubmitting = false
            isDescriptionFocused = false
        }
    }
}
