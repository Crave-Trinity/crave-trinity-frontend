//
// LogCravingView.swift
// /CravePhone/Presentation/Views/Craving/LogCravingView.swift
//
// Revised for consistent styling and typography.
// Uses CraveTheme's global design system for spacing, fonts, and corner radii.
import SwiftUI

public struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    @FocusState private var isDescriptionFocused: Bool
    @State private var isSubmitting = false
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background gradient that dismisses the keyboard on tap.
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
                .onTapGesture { isDescriptionFocused = false }
            
            ScrollView {
                VStack(alignment: .leading, spacing: CraveTheme.Spacing.large) {
                    // Description section.
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isFocused: $isDescriptionFocused
                    )
                    
                    // Speech toggle button.
                    CraveSpeechToggleButton(
                        isRecording: viewModel.isRecordingSpeech,
                        onToggle: {
                            viewModel.toggleSpeechRecognition()
                            CraveHaptics.shared.mediumImpact()
                        }
                    )
                    
                    // Intensity and resistance sliders.
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    // Emotion chips view.
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { emotion in
                            viewModel.toggleEmotion(emotion)
                            CraveHaptics.shared.selectionChanged()
                        }
                    )
                    
                    // Submit button.
                    submitButton
                }
                .padding(CraveTheme.Spacing.medium)
            }
        }
        .toolbar {
            // Keyboard toolbar with a "Done" button.
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isDescriptionFocused = false }
            }
        }
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title).font(CraveTheme.Typography.heading),
                message: Text(info.message).font(CraveTheme.Typography.body),
                dismissButton: .default(Text("OK").font(CraveTheme.Typography.subheading))
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
                        .progressViewStyle(CircularProgressViewStyle(tint: CraveTheme.Colors.buttonText))
                        .padding(.trailing, CraveTheme.Spacing.small)
                }
                Text(isSubmitting ? "Saving..." : "Log Craving")
                    .font(CraveTheme.Typography.heading)
            }
            .frame(maxWidth: .infinity)
            .padding(CraveTheme.Spacing.medium)
            .background(Color.blue.cornerRadius(CraveTheme.Layout.cornerRadius))
            .foregroundColor(CraveTheme.Colors.buttonText)
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
