//
//  LogCravingView.swift
//  CravePhone
//
//  Description:
//    Displays a dark background, gradient button, and “TRIGGER” style
//    to match the watch’s design. It uses LogCravingViewModel to handle
//    logging, and shows an alert if there's an error.
//

import SwiftUI

@MainActor
public struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                // Match the watch’s dark background
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    
                    // 1) TRIGGER Title
                    Text("TRIGGER")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    // 2) Top triggers: Hungry / Angry
                    HStack {
                        Text("Hungry")
                        Spacer()
                        Text("Angry")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, 16)
                    
                    // 3) Text editor
                    CraveTextEditor(
                        text: $viewModel.cravingText,
                        primaryPlaceholder: "Log Craving",
                        secondaryPlaceholder: "200 chars",  // Optional: replicate watch style
                        characterLimit: 280
                    )
                    .frame(minHeight: 120)
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    
                    // 4) Bottom triggers: Lonely / Tired
                    HStack {
                        Text("Lonely")
                        Spacer()
                        Text("Tired")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, 16)
                    
                    // 5) Gradient “Log” Button
                    Button(action: {
                        Task {
                            await viewModel.logCraving()
                        }
                    }) {
                        Text("Log")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(premiumBlueGradient)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                    .disabled(viewModel.cravingText.isEmpty)
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("")            // Hide default nav title
            .navigationBarHidden(true)      // So it’s more “watch-like”
            .alert("Error",
                   isPresented: $viewModel.showingAlert,
                   actions: { Button("OK", role: .cancel) {} },
                   message: { Text(viewModel.alertMessage) }
            )
        }
    }
}

// MARK: - Premium Blue Gradient
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

