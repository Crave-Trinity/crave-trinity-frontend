/*
 ┌───────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views                          │
 │  Production-Ready SwiftUI Layout Fixes                │
 │  Notes:                                               │
 │   - Implements Uncle Bob, GoF, SOLID principles.      │
 │   - Uses GeometryReader for adaptive layouts.         │
 │   - Minimizes fixed spacing; inserts spacers.         │
 │   - Ensures dynamic scaling across all devices.       │
 └───────────────────────────────────────────────────────┘
*/

/* -----------------------------------------
   LogCravingView.swift
   ----------------------------------------- */
import SwiftUI

public struct LogCravingView: View {
    
    @ObservedObject var viewModel: LogCravingViewModel
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    CraveTheme.Colors.primaryGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: geometry.size.height * 0.03) {
                            
                            // (1) Header
                            headerSection
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // (2) Craving Description
                            CravingDescriptionSectionView(
                                text: $viewModel.cravingDescription,
                                isRecordingSpeech: viewModel.isRecordingSpeech,
                                onToggleSpeech: { viewModel.toggleSpeechRecognition() }
                            )
                            .frame(maxWidth: .infinity)
                            
                            // (3) Sliders
                            CravingSlidersSectionView(
                                cravingStrength: $viewModel.cravingStrength,
                                resistance: $viewModel.confidenceToResist
                            )
                            .frame(maxWidth: .infinity)
                            
                            // (4) Emotions
                            CravingEmotionChipsView(
                                selectedEmotions: viewModel.selectedEmotions,
                                onToggleEmotion: { viewModel.toggleEmotion($0) }
                            )
                            .frame(maxWidth: .infinity)
                            
                            // (5) Button
                            recordCravingButton
                            
                            Spacer(minLength: geometry.size.height * 0.02)
                        }
                        .padding(.horizontal, geometry.size.width * 0.05)
                        .padding(.top, geometry.size.height * 0.02)
                        .padding(.bottom, geometry.size.height * 0.05)
                    }
                }
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

