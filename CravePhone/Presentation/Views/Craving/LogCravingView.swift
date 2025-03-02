//
//  LogCravingView.swift
//  CravePhone
//
//  RESPONSIBILITY: Displays the Log Craving screen with sections for:
//  - Description
//  - Speech Toggle
//  - Sliders (Intensity, Resistance)
//  - Emotions
//  - Submit Button
//

import SwiftUI

public struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    @State private var isSubmitting: Bool = false

    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            // Full-bleed gradient, ignoring safe areas
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea(.all)
                .ignoresSafeArea(.keyboard, edges: .bottom)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Textual description
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription
                    )

                    // Speech Toggle Button (now a separate view)
                    CraveSpeechToggleButton(
                        isRecording: viewModel.isRecordingSpeech,
                        onToggle: {
                            viewModel.toggleSpeechRecognition()
                            CraveHaptics.shared.mediumImpact()
                        }
                    )

                    // Intensity / Resistance Sliders
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )

                    // Emotion Chips
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { emotion in
                            viewModel.toggleEmotion(emotion)
                            CraveHaptics.shared.selectionChanged()
                        }
                    )

                    // Submit Button
                    submitButton
                        .padding(.top, 12)
                }
                .padding(.horizontal, CraveTheme.Spacing.medium)
            }
        }
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
                        .padding(.trailing, 8)
                }
                Text(isSubmitting ? "Saving..." : "Record Craving")
                    .font(CraveTheme.Typography.subheading.weight(.bold))
                    .foregroundColor(CraveTheme.Colors.buttonText)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: CraveTheme.Layout.cornerRadius)
                    .fill(
                        buttonIsEnabled
                            ? CraveTheme.Colors.accent
                            : CraveTheme.Colors.accent.opacity(0.5)
                    )
                    .shadow(
                        color: buttonIsEnabled
                            ? CraveTheme.Colors.accent.opacity(0.3)
                            : .clear,
                        radius: 8, y: 4
                    )
            )
        }
        .disabled(isSubmitting || !viewModel.isValid)
        .animation(CraveTheme.Animations.smooth, value: isSubmitting)
        .animation(CraveTheme.Animations.smooth, value: viewModel.isValid)
    }

    private var buttonIsEnabled: Bool {
        !isSubmitting && viewModel.isValid
    }

    // MARK: - Submit Craving Logic
    private func submitCraving() {
        guard buttonIsEnabled else { return }
        withAnimation { isSubmitting = true }
        CraveHaptics.shared.notification(type: .success)

        Task {
            await viewModel.logCraving()
            try? await Task.sleep(nanoseconds: 300_000_000)
            await MainActor.run {
                withAnimation { isSubmitting = false }
            }
        }
    }
}
