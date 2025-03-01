//
//  LogCravingView.swift
//  CravePhone
//
//  A scrollable form to log cravings,
//  custom 🦊 heading, no system nav bar.
//

import SwiftUI

public struct LogCravingView: View {
    
    @ObservedObject var viewModel: LogCravingViewModel
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background behind status bar
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea(edges: .top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                        .padding(.top, 30)
                    
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isRecordingSpeech: viewModel.isRecordingSpeech,
                        onToggleSpeech: { viewModel.toggleSpeechRecognition() }
                    )
                    
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { viewModel.toggleEmotion($0) }
                    )
                    
                    recordCravingButton
                        .padding(.top, 8)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
            }
        }
        // Hide system bar to show your custom heading
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

extension LogCravingView {
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🦊 Track Your Craving")
                .font(CraveTheme.Typography.heading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            Text("Share what you're craving to gain insights.")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText.opacity(0.8))
        }
    }
    
    private var recordCravingButton: some View {
        Button {
            Task {
                await viewModel.logCraving()
            }
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Record Craving")
                        .font(CraveTheme.Typography.subheading)
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(CraveTheme.Colors.buttonText)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(CraveTheme.Colors.accent)
            .cornerRadius(CraveTheme.Layout.cornerRadius)
        }
    }
}
