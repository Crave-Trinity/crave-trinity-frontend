//==================================================
// File: LogCravingView.swift
// Directory: CravePhone/Presentation/Views/Craving/LogCravingView.swift
//
// Purpose:
//   Refactor the Log Craving screen so that the text input area
//   (dynamic, auto-sizing text editor) is decoupled from its ancillary controls.
//   This view now passes the speech recording state (isRecording) and
//   the speech toggle callback to the text editor, which internally uses
//   a dedicated accessory row for the character counter and mic button.
//==================================================
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
                    
                    // Description Section.
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isRecording: viewModel.isRecordingSpeech,
                        onToggle: {
                            viewModel.toggleSpeechRecognition()
                            CraveHaptics.shared.mediumImpact()
                        }
                    )
                    .focused($isDescriptionFocused)
                    
                    // (Removed inline speech toggle – now integrated in the accessory row)
                    
                    // Location Chips Section.
                    Text("Where are you?")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    CravingLocationChipsView(
                        selectedLocation: $viewModel.selectedLocation
                    )
                    
                    // People Chips Section.
                    Text("Who are you with?")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    CravingPeopleChipsView(
                        selectedPeople: $viewModel.selectedPeople
                    )
                    
                    // Trigger Field Section using the custom text editor.
                    Text("What triggered it?")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    CraveTextEditor(
                        text: $viewModel.triggerDescription,
                        isRecording: viewModel.isRecordingSpeech,
                        onToggle: {
                            viewModel.toggleSpeechRecognition()
                            CraveHaptics.shared.mediumImpact()
                        }
                    )
                    .focused($isTriggerFocused)
                    .frame(minHeight: 100)
                    
                    // Intensity and Resistance sliders.
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    // Mood (Emotions) chips.
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { emotion in
                            viewModel.toggleEmotion(emotion)
                            CraveHaptics.shared.selectionChanged()
                        }
                    )
                    
                    // Submit Button.
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
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: CraveTheme.Colors.buttonText)
                        )
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
