
//
//  LogCravingView.swift
//  CravePhone
//
//  Description:
//    A brand-new, modern logging view for cravings. Emphasizes minimal but sleek UI,
//    advanced SwiftUI transitions, and builds on a card-based approach.
//
//  Uncle Bob notes:
//    - Single Responsibility: Renders the logging screen & binds to the LogCravingViewModel.
//    - Separation of Concerns: All data transformations happen in the VM, this is just UI.

import SwiftUI

struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gorgeous gradient background
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                // Main Card
                VStack(spacing: CraveTheme.Spacing.medium) {
                    
                    // Card container for a refined pop effect
                    VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
                        
                        // Title
                        Text("Log Your Craving")
                            .font(CraveTheme.Typography.heading)
                            .foregroundColor(CraveTheme.Colors.primaryText)
                            .padding(.bottom, 4)
                        
                        // Body / instructions
                        Text("Share what you're craving and track triggers for better insights.")
                            .font(CraveTheme.Typography.body)
                            .foregroundColor(CraveTheme.Colors.secondaryText)
                            .multilineTextAlignment(.leading)
                        
                        Divider()
                            .background(CraveTheme.Colors.secondaryText.opacity(0.3))
                        
                        // Description input
                        CraveTextEditor(text: $viewModel.cravingDescription)
                            .frame(height: 120)
                            .background(CraveTheme.Colors.textFieldBackground)
                            .cornerRadius(CraveTheme.Layout.cornerRadius)
                        
                        // Intensity
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
                        CraveTextEditor(text: $viewModel.cravingTrigger,
                                        characterLimit: 150,
                                        placeholderLines: [.plain("e.g. stress, social setting, etc.")])
                            .frame(height: 80)
                            .background(CraveTheme.Colors.textFieldBackground)
                            .cornerRadius(CraveTheme.Layout.cornerRadius)
                        
                        // Button
                        CraveMinimalButton(action: {
                            Task {
                                await viewModel.logCraving()
                                if viewModel.alertInfo == nil {
                                    // Only show confirmation on success
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
                    .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 16,
                            x: 0, y: 8)
                    
                    // Spacer to push the card up slightly
                    Spacer()
                }
                
                // Confirmation overlay
                if showConfirmation {
                    successOverlay
                }
            }
            .navigationBarHidden(true)
            .alert(item: $viewModel.alertInfo) { info in
                Alert(title: Text(info.title), message: Text(info.message), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// A custom overlay that shows when a craving is successfully logged.
    @ViewBuilder
    private var successOverlay: some View {
        VStack(spacing: CraveTheme.Spacing.small) {
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(.green.gradient)
            
            Text("Craving Logged!")
                .font(.title2.weight(.bold))
                .foregroundColor(.white)
            
            Text("Keep going—every log helps you build awareness.")
                .font(CraveTheme.Typography.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Button {
                // Hide the overlay
                withAnimation(CraveTheme.Animations.smooth) {
                    showConfirmation = false
                }
            } label: {
                Text("Cool")
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.buttonText)
                    .padding(.horizontal, 24)
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


