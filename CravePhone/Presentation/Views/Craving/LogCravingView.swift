//
//  LogCravingView.swift
//  CravePhone
//
//  A refined craving logging form with smooth animations,
//  improved visual hierarchy, and haptic feedback.
//  Clean architecture with clear separation of UI components.
//

import SwiftUI

public struct LogCravingView: View {
    
    @ObservedObject var viewModel: LogCravingViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var isSubmitting: Bool = false
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                // Main scrolling content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Spacer to push content down for header overlay
                        Color.clear.frame(height: 80)
                        
                        // Sections
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
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 80)
                    }
                    .padding(.horizontal, CraveTheme.Spacing.medium)
                    .frame(minHeight: geometry.size.height + geometry.safeAreaInsets.top)
                }
                .coordinateSpace(name: "scroll")
                
                // Fixed, floating header
                VStack {
                    floatingHeader
                        .background(
                            CraveTheme.Colors.primaryGradient
                                .shadow(color: .black.opacity(0.3), radius: 8, y: 5)
                        )
                        .opacity(1.0 - min(1.0, max(0.0, scrollOffset / 120)))
                    
                    Spacer()
                }
                .ignoresSafeArea(edges: .top)
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
    
    // MARK: - Component Views
    
    private var floatingHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text("🦊 Track Your Craving")
                    .font(CraveTheme.Typography.heading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                Spacer()
                
                // Info button
                Button {
                    // Show info about cravings
                } label: {
                    Image(systemName: "info.circle")
                        .font(.system(size: 20))
                        .foregroundColor(CraveTheme.Colors.primaryText.opacity(0.7))
                }
            }
            
            Text("Share what you're craving to gain insights.")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText.opacity(0.8))
        }
        .padding(.horizontal, CraveTheme.Spacing.medium)
        .padding(.top, 60) // Space for status bar
        .padding(.bottom, 16)
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
                        buttonIsEnabled ?
                            CraveTheme.Colors.accent :
                            CraveTheme.Colors.accent.opacity(0.5)
                    )
                    .shadow(color: buttonIsEnabled ?
                           CraveTheme.Colors.accent.opacity(0.3) : .clear,
                           radius: 8, y: 4)
            )
        }
        .disabled(isSubmitting || !viewModel.isValid)
        .animation(CraveTheme.Animations.smooth, value: isSubmitting)
        .animation(CraveTheme.Animations.smooth, value: viewModel.isValid)
    }
    
    // MARK: - Helper Properties & Methods
    
    private var buttonIsEnabled: Bool {
        return !isSubmitting && viewModel.isValid
    }
    
    private func submitCraving() {
        guard !isSubmitting, viewModel.isValid else { return }
        
        withAnimation {
            isSubmitting = true
        }
        
        // Haptic feedback for submission
        CraveHaptics.shared.notification(type: .success)
        
        Task {
            await viewModel.logCraving()
            
            // Slight delay to prevent flickering of button states
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            
            await MainActor.run {
                withAnimation {
                    isSubmitting = false
                }
            }
        }
    }
}

// MARK: - Preview
struct LogCravingView_Previews: PreviewProvider {
    static var previews: some View {
        // Using mock view model for preview
        let mockViewModel = LogCravingViewModel(cravingRepository: PreviewCravingRepository())
        LogCravingView(viewModel: mockViewModel)
            .preferredColorScheme(.dark)
    }
}

// MARK: - Mock for Preview
private class PreviewCravingRepository: CravingRepository {
    func addCraving(_ craving: CravingEntity) async throws {
        // No-op for preview
    }
    
    func fetchActiveCravings() async throws -> [CravingEntity] {
        return []
    }
    
    func archiveCraving(_ craving: CravingEntity) async throws {
        // No-op for preview
    }
    
    func deleteCraving(_ craving: CravingEntity) async throws {
        // No-op for preview
    }
}
