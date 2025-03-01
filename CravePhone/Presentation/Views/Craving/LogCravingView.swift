/*
 ┌───────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views/Craving                 │
 │  Production-Ready SwiftUI Layout Fix: LogCravingView │

*/

import SwiftUI

public struct LogCravingView: View {
    
    @ObservedObject var viewModel: LogCravingViewModel
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // 1) Full-screen gradient background ignoring the TOP safe area
            //    but NOT ignoring the bottom. We only specify .top, ensuring
            //    we still respect the home indicator area at the bottom.
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea(edges: .top)
            
            ScrollView {
                // 2) Now your content can sit “under” the status bar,
                //    so we’ll manually add top padding to keep the heading
                //    from clashing with the clock/battery area.
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Your custom heading
                    headerSection
                        .padding(.top, 30)  // Enough so it’s visible below status bar.
                    
                    // (1) Craving Description
                    CravingDescriptionSectionView(
                        text: $viewModel.cravingDescription,
                        isRecordingSpeech: viewModel.isRecordingSpeech,
                        onToggleSpeech: { viewModel.toggleSpeechRecognition() }
                    )
                    
                    // (2) Sliders
                    CravingSlidersSectionView(
                        cravingStrength: $viewModel.cravingStrength,
                        resistance: $viewModel.confidenceToResist
                    )
                    
                    // (3) Emotions
                    CravingEmotionChipsView(
                        selectedEmotions: viewModel.selectedEmotions,
                        onToggleEmotion: { viewModel.toggleEmotion($0) }
                    )
                    
                    // (4) Button
                    recordCravingButton
                        .padding(.top, 8)
                    
                    // Add extra space so the final content doesn’t hide
                    // under the custom bottom tab bar:
                    Spacer(minLength: 40)
                }
                // Horizontal padding on sides
                .padding(.horizontal, 16)
                // Don’t .ignoresSafeArea here; we keep normal scroll insets at the bottom.
            }
        }
        // 3) Hide the system nav bar, so only your custom 🦊 heading shows
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
