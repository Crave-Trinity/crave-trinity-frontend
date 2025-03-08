//
// LogCravingView.swift
// /CravePhone/Presentation/Views/Craving/LogCravingView.swift
//
// Revised for consistent styling, adding Location/People chips and a Trigger field.
//
import SwiftUI

public struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    @FocusState private var isDescriptionFocused: Bool
    @FocusState private var isTriggerFocused: Bool
    @State private var isSubmitting = false
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background gradient that dismisses the keyboard on tap.
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
                .onTapGesture {
                    isDescriptionFocused = false
                    isTriggerFocused = false
                }
            
            ScrollView {
                VStack(alignment: .leading, spacing: CraveTheme.Spacing.large) {
                    
                    // Description Section: Pass only the text binding, then attach focus modifier.
                    CravingDescriptionSectionView(text: $viewModel.cravingDescription)
                        .focused($isDescriptionFocused)
                    
                    // Speech Toggle Button (Optional Microphone for dictation).
                    CraveSpeechToggleButton(
                        isRecording: viewModel.isRecordingSpeech,
                        onToggle: {
                            viewModel.toggleSpeechRecognition()
                            CraveHaptics.shared.mediumImpact()
                        }
                    )
                    
                    // Location Chips
                    Text("Where are you?")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    CravingLocationChipsView(
                        selectedLocation: $viewModel.selectedLocation
                    )
                    
                    // People Chips
                    Text("Who are you with?")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    CravingPeopleChipsView(
                        selectedPeople: $viewModel.selectedPeople
                    )
                    
                    // (Optional) Trigger text field.
                    Text("What triggered it?")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    // Use your custom text editor here:
                    CraveTextEditor(text: $viewModel.triggerDescription)
                        .focused($isTriggerFocused)
                        .frame(minHeight: 100) // ensures some initial height
                    
                    // Intensity and Resistance sliders.
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    // Mood (Emotions) chips
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { emotion in
                            viewModel.toggleEmotion(emotion)
                            CraveHaptics.shared.selectionChanged()
                        }
                    )
                    
                    // Submit Button
                    submitButton
                }
                .padding(CraveTheme.Spacing.medium)
            }
        }
        .toolbar {
            // Keyboard toolbar with a "Done" button.
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isDescriptionFocused = false
                    isTriggerFocused = false
                }
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
            viewModel.alertInfo = AlertInfo(
                title: "Invalid Entry",
                message: "Please enter a valid craving description and intensity."
            )
            return
        }
        isSubmitting = true
        Task {
            await viewModel.logCraving()
            isSubmitting = false
            isDescriptionFocused = false
            isTriggerFocused = false
        }
    }
}
