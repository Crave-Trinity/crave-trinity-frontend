//
//  LogCravingView.swift
//  CravePhone
//
//  Description:
//    Main view for logging a new craving. Demonstrates Uncle Bob's
//    Single Responsibility by delegating sub-components (description, sliders, etc.)
//    to separate views.
//
//  Uncle Bob notes:
//    - Single Responsibility: This file orchestrates the "Log Craving" screen
//      without burying all details (like text editing) in the same file.
//    - Open/Closed: We can add new sections (like location tags, images, etc.)
//      without breaking the existing code.
//
//  Additional Info:
//    - If you don't have CravingSlidersSectionView or CravingEmotionChipsView
//      defined, comment those lines out or define them similarly.
//

import SwiftUI

public struct LogCravingView: View {
    
    // MARK: - Observed Object
    @ObservedObject var viewModel: LogCravingViewModel
    
    // MARK: - Initialization
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    public var body: some View {
        NavigationView {
            ZStack {
                // Subtle black/dark gradient background
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                // ScrollView to support smaller devices
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // (1) Header
                        headerSection
                        
                        // (2) Craving Description
                        CravingDescriptionSectionView(
                            text: $viewModel.cravingDescription,
                            isRecordingSpeech: viewModel.isRecordingSpeech,
                            onToggleSpeech: { viewModel.toggleSpeechRecognition() }
                        )
                        
                        // (3) Sliders (make sure you have this component)
                        CravingSlidersSectionView(
                            cravingStrength: $viewModel.cravingStrength,
                            resistance: $viewModel.confidenceToResist
                        )
                        
                        // (4) Emotion Chips (make sure you have this component)
                        CravingEmotionChipsView(
                            selectedEmotions: viewModel.selectedEmotions,
                            onToggleEmotion: { viewModel.toggleEmotion($0) }
                        )

                        // (5) “Record Craving” button
                        recordCravingButton
                    }
                    .padding(24)
                    .padding(.bottom, 40) // Extra spacing at the bottom
                }
            }
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
        VStack(alignment: .leading, spacing: 8) {
            Text("🦊 Track Your Craving")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Share what you're craving to gain insights.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
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
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.orange)
            .cornerRadius(10)
        }
        .padding(.top, 10)
    }
}
