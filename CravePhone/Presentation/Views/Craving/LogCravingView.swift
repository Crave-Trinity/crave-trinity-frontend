//
//  LogCravingView.swift
//  CravePhone
//
//  Description:
//    A modern logging view for cravings. Emphasizes minimal but sleek UI,
//    advanced SwiftUI transitions, and a card-based approach.
//
//  Uncle Bob notes:
//    - Single Responsibility: Renders the logging screen & binds to the VM.
//    - Separation of Concerns: Data transformations in the VM, UI logic here.
//

import SwiftUI

struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    
    // This toggles a success overlay on successful log
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Subtle black/dark gradient background
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: CraveTheme.Spacing.large) {
                        
                        VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
                            Text("🦊 Log Your Craving")
                                .font(CraveTheme.Typography.heading)
                                .foregroundColor(CraveTheme.Colors.primaryText)
                            
                            Text("Share what you're craving and track triggers for better insights.")
                                .font(CraveTheme.Typography.body)
                                .foregroundColor(CraveTheme.Colors.secondaryText)
                                .multilineTextAlignment(.leading)
                            
                            Divider()
                                .background(CraveTheme.Colors.secondaryText.opacity(0.3))
                            
                            // Description field
                            CraveTextEditor(
                                text: $viewModel.cravingDescription,
                                characterLimit: 300
                            )
                            .background(CraveTheme.Colors.textFieldBackground)
                            .cornerRadius(CraveTheme.Layout.cornerRadius)
                            
                            // Craving Intensity
                            HStack {
                                Text("Intensity: \(Int(viewModel.cravingIntensity))")
                                    .foregroundColor(CraveTheme.Colors.secondaryText)
                                Spacer()
                            }
                            CravingIntensitySlider(value: $viewModel.cravingIntensity)
                            
                            // Triggers
                            Text("Triggers")
                                .font(CraveTheme.Typography.subheading)
                                .foregroundColor(CraveTheme.Colors.primaryText)
                            
                            CraveTextEditor(
                                text: $viewModel.cravingTrigger,
                                characterLimit: 150,
                                placeholderLines: [.plain("e.g. stress, social setting, etc.")]
                            )
                            .background(CraveTheme.Colors.textFieldBackground)
                            .cornerRadius(CraveTheme.Layout.cornerRadius)
                            .frame(minHeight: 120)
                            
                            // Log Button
                            CraveMinimalButton(action: {
                                Task {
                                    await viewModel.logCraving()
                                    if viewModel.alertInfo == nil {
                                        withAnimation(CraveTheme.Animations.smooth) {
                                            showConfirmation = true
                                        }
                                    }
                                }
                            }) {
                                Text("Log Craving")
                                    .font(CraveTheme.Typography.body.weight(.semibold))
                            }
                            .padding(.top, CraveTheme.Spacing.small)
                        }
                        .padding(CraveTheme.Layout.cardPadding)
                        .background(CraveTheme.Colors.cardBackground)
                        .cornerRadius(CraveTheme.Layout.cardCornerRadius)
                        .shadow(color: Color.black.opacity(0.3), radius: 16, x: 0, y: 8)
                        .padding(.horizontal, CraveTheme.Spacing.medium)
                        
                        Spacer(minLength: 50)
                    }
                }
                
                // Success overlay
                if showConfirmation {
                    confirmationOverlay
                }
            }
            .navigationBarHidden(true)
            .alert(item: $viewModel.alertInfo) { info in
                Alert(title: Text(info.title), message: Text(info.message), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Confirmation overlay displayed upon successful logging
    private var confirmationOverlay: some View {
        VStack(spacing: CraveTheme.Spacing.small) {
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundStyle(.green.gradient)
            
            Text("Logged!")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(.white)
            
            Text("Keep going—every log builds awareness.")
                .font(CraveTheme.Typography.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Button {
                withAnimation(CraveTheme.Animations.smooth) {
                    showConfirmation = false
                }
            } label: {
                Text("AWESOME")
                    .foregroundColor(CraveTheme.Colors.buttonText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(CraveTheme.Colors.accent)
                    .cornerRadius(CraveTheme.Layout.cornerRadius)
            }
            .padding(.top, CraveTheme.Spacing.small)
        }
        .padding()
        .background(Color.black.opacity(0.85))
        .cornerRadius(16)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
        .transition(.scale.combined(with: .opacity))
    }
}

