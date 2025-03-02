//
//  LogCravingView.swift
//  CravePhone
//
//  - Logging form for cravings (description, sliders, emotions).
//  - Full-bleed background ignoring safe area.
//  - Manual .padding(...) for top/bottom if needed.
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
            // Background behind notch/home
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Sections:
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isRecordingSpeech: viewModel.isRecordingSpeech,
                        onToggleSpeech: {
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
                        onToggleEmotion: { emotion in
                            viewModel.toggleEmotion(emotion)
                            CraveHaptics.shared.selectionChanged()
                        }
                    )
                    
                    submitButton
                        .padding(.top, 12)
                }
                .padding(.horizontal, CraveTheme.Spacing.medium)
                // Manual offsets if you want extra spacing
                .padding(.top, 44)
                .padding(.bottom, 34)
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
