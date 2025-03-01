//
//  LogCravingView.swift
//  CravePhone
//
//  Description:
//    Main view for logging a new craving.
//
//  Uncle Bob notes:
//    - Single Responsibility: Orchestrates subviews, holds no domain logic itself.
//    - Open/Closed: Additional sections (location, mood, triggers) can be added as separate subviews.
//  GoF & SOLID:
//    - Compositional approach for subviews, each has a single focus (sliders, description).
//    - The 'ViewModel' is injected, not created here (Dependency Inversion).
//

import SwiftUI

public struct LogCravingView: View {
    
    @ObservedObject var viewModel: LogCravingViewModel
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: CraveTheme.Spacing.large) {
                        
                        // (1) Header
                        headerSection
                        
                        // (2) Craving Description
                        CravingDescriptionSectionView(
                            text: $viewModel.cravingDescription,
                            isRecordingSpeech: viewModel.isRecordingSpeech,
                            onToggleSpeech: { viewModel.toggleSpeechRecognition() }
                        )
                        
                        // (3) Sliders
                        CravingSlidersSectionView(
                            cravingStrength: $viewModel.cravingStrength,
                            resistance: $viewModel.confidenceToResist
                        )
                        
                        // (4) Emotions
                        CravingEmotionChipsView(
                            selectedEmotions: viewModel.selectedEmotions,
                            onToggleEmotion: { viewModel.toggleEmotion($0) }
                        )

                        // (5) Button
                        recordCravingButton
                    }
                    .padding(CraveTheme.Spacing.large)
                    .padding(.bottom, 40)
                }
            }
            // Force full screen usage
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $viewModel.alertInfo) { info in
                Alert(
                    title: Text(info.title),
                    message: Text(info.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Subviews
extension LogCravingView {
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.small) {
            Text("🦊 Track Your Craving")
                .font(CraveTheme.Typography.heading)
                .foregroundColor(CraveTheme.Colors.primaryText)
            
            Text("Share what you're craving to gain insights.")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
        .padding(.top, 10)
    }
}
