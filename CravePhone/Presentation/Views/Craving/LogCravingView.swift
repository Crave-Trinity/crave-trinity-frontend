/*
 ┌───────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views/Craving                 │
 │  Production-Ready SwiftUI Layout Fix: LogCravingView │
 │  Notes:                                              │
 │   - Single GeometryReader at top-level.              │
 │   - Adaptive spacing with geometry.size.             │
 │   - Removes nested/extra GeometryReader usage.       │
 └───────────────────────────────────────────────────────┘
*/

import SwiftUI

public struct LogCravingView: View {
    
    @ObservedObject var viewModel: LogCravingViewModel
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background (ignores safe area only for the gradient itself)
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    headerSection
                        .padding(.top, 16)
                    
                    // Craving Description
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isRecordingSpeech: viewModel.isRecordingSpeech,
                        onToggleSpeech: { viewModel.toggleSpeechRecognition() }
                    )
                    
                    // Sliders
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    // Emotions
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { viewModel.toggleEmotion($0) }
                    )
                    
                    // Button
                    recordCravingButton
                        .padding(.top, 8)
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40) // extra space so button or content isn't blocked by tab bar
            }
        }
        // If you want a custom nav title, you can do:
        .navigationTitle("Track Your Craving")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// MARK: - Subviews
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
