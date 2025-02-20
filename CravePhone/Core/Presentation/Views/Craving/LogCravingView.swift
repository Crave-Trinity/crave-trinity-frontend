//
//  LogCravingView.swift
//  CravePhone
//
//  Directory: CravePhone/Core/Presentation/Views/Craving/LogCravingView.swift
//
//  Description:
//    An ultra‑minimal SwiftUI view for logging cravings. Binds to LogCravingViewModel and uses our
//    unified CraveTheme for consistency. The async call is wrapped in a Task to ensure proper concurrency.
//

import SwiftUI

struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                CraveTheme.Colors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
                    Text("What's on your mind?")
                        .font(CraveTheme.Typography.heading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    // Custom text editor for the craving description.
                    CraveTextEditor(text: $viewModel.cravingDescription)
                        .frame(height: 120)
                        .background(CraveTheme.Colors.textFieldBackground)
                        .cornerRadius(8)
                    
                    Text("Craving Intensity: \(Int(viewModel.cravingIntensity))")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    
                    // Minimal slider for intensity.
                    CravingIntensitySlider(value: $viewModel.cravingIntensity)
                    
                    Text("Any triggers?")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    // Custom text editor for triggers.
                    CraveTextEditor(text: $viewModel.cravingTrigger)
                        .frame(height: 80)
                        .background(CraveTheme.Colors.textFieldBackground)
                        .cornerRadius(8)
                    
                    // Minimal button wrapped in a Task to support async calls.
                    CraveMinimalButton(action: {
                        Task {
                            await viewModel.logCraving()
                        }
                    }) {
                        Text("Log Craving")
                            .font(CraveTheme.Typography.body)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Log Your Craving", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
