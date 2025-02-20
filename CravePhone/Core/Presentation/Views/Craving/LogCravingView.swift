//
//  LogCravingView.swift
//  CravePhone
//
//  Description:
//    An iOS phone view that mimics the watch layout. The only "Log Craving"
//    text now appears inside the text editor placeholder.
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today's date>.
//

import SwiftUI

@MainActor
public struct LogCravingView: View {
    
    // The ViewModel that holds user input and handles "log" action
    @ObservedObject var viewModel: LogCravingViewModel
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                // Main black background
                CRAVEDesignSystem.Colors.background
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: CRAVEDesignSystem.Layout.mediumSpacing) {
                    
                    // 1) TRIGGER Title at top
                    Text("TRIGGER")
                        .font(CRAVEDesignSystem.Typography.heading)
                        .foregroundColor(CRAVEDesignSystem.Colors.textPrimary)
                        .padding(.top, CRAVEDesignSystem.Layout.standardPadding)
                    
                    // 2) Top triggers: "Hungry" / "Angry"
                    HStack {
                        Text("Hungry")
                        Spacer()
                        Text("Angry")
                    }
                    .font(CRAVEDesignSystem.Typography.triggerLabel)
                    .foregroundColor(CRAVEDesignSystem.Colors.textPrimary.opacity(0.85))
                    .padding(.horizontal, CRAVEDesignSystem.Layout.standardPadding)
                    
                    // 3) Text block: CraveTextEditor with placeholders
                    ZStack {
                        CRAVEDesignSystem.Colors.cardBackground
                            .cornerRadius(CRAVEDesignSystem.Layout.cornerRadius)
                        
                        CraveTextEditor(
                            text: $viewModel.cravingText,
                            characterLimit: 280
                        )
                        .padding(CRAVEDesignSystem.Layout.smallSpacing)
                    }
                    .padding(.horizontal, CRAVEDesignSystem.Layout.standardPadding)
                    
                    // 4) Bottom triggers: "Lonely" / "Tired"
                    HStack {
                        Text("Lonely")
                        Spacer()
                        Text("Tired")
                    }
                    .font(CRAVEDesignSystem.Typography.triggerLabel)
                    .foregroundColor(CRAVEDesignSystem.Colors.textPrimary.opacity(0.85))
                    .padding(.horizontal, CRAVEDesignSystem.Layout.standardPadding)
                    
                    // 5) "Log" button
                    CraveButton(
                        title: "Log",
                        action: {
                            Task {
                                await viewModel.logCraving()
                            }
                        }
                    )
                    .frame(minHeight: 50)
                    .padding(.horizontal, CRAVEDesignSystem.Layout.standardPadding)
                    .disabled(viewModel.cravingText.isEmpty)
                    
                    Spacer()
                }
                .padding(.vertical, CRAVEDesignSystem.Layout.standardPadding)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            // Show alert if there's an error
            .alert("Error",
                   isPresented: $viewModel.showingAlert,
                   actions: {
                       Button("OK", role: .cancel) {}
                   },
                   message: {
                       Text(viewModel.alertMessage)
                   }
            )
        }
    }
}

// Example preview usage
struct LogCravingView_Previews: PreviewProvider {
    static var previews: some View {
        LogCravingView(
            viewModel: LogCravingViewModel(addCravingUseCase: DummyAddCravingUseCase())
        )
    }
}
