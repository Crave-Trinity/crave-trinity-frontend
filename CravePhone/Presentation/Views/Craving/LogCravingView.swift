//
//  LogCravingView.swift
//  CravePhone
//
import SwiftUI

public struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel

    // Declare a FocusState for controlling keyboard focus
    @FocusState private var isDescriptionFocused: Bool
    
    @State private var isSubmitting = false

    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            // Dismiss keyboard if user taps outside the text area
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
                .onTapGesture {
                    isDescriptionFocused = false
                }

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Pass the parent's focus binding to the child
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isFocused: $isDescriptionFocused
                    )
                    
                    CraveSpeechToggleButton(
                        isRecording: viewModel.isRecordingSpeech,
                        onToggle: {
                            viewModel.toggleSpeechRecognition()
                            CraveHaptics.shared.mediumImpact()
                        }
                    )
                    
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { e in
                            viewModel.toggleEmotion(e)
                            CraveHaptics.shared.selectionChanged()
                        }
                    )

                    submitButton
                }
                .padding()
            }
        }
        // Keyboard toolbar with "Done"
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isDescriptionFocused = false
                }
            }
        }
        // Example Alert usage
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }

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
        .disabled(isSubmitting)
    }

    private func submitCraving() {
        guard !isSubmitting else { return }
        isSubmitting = true
        
        Task {
            await viewModel.logCraving()
            isSubmitting = false
            // Also dismiss keyboard after submitting
            isDescriptionFocused = false
        }
    }
}
