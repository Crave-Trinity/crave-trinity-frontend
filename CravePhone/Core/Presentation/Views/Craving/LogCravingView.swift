//
//  LogCravingView.swift
//  CravePhone
//
//  Description:
//    An iOS phone view that focuses on a minimal, futuristic approach,
//    with centered placeholders and a big gradient text highlight.
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
                
                // 1) A big, futuristic background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        .black,
                        .blue.opacity(0.8),
                        .purple.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // 2) A semi-translucent “glass” card to hold everything
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .padding(.horizontal, 16)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .edgesIgnoringSafeArea(.bottom)
                
                // 3) Main Content
                VStack(spacing: 24) {
                    
                    // (Optional) A minimal top label, or remove entirely if you want no title
                    Text("TRIGGER")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 50)
                    
                    // The big text editor area with placeholders
                    ZStack {
                        // Subtle background to make the editor’s text more readable
                        Color.black.opacity(0.2)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        
                        CraveTextEditor(
                            text: $viewModel.cravingText,
                            characterLimit: 280
                        )
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    // The "Log" button, gradient style
                    Button {
                        Task {
                            await viewModel.logCraving()
                        }
                    } label: {
                        Text("Log")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            // Gorgeous gradient background
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .red]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: .red.opacity(0.4), radius: 10, x: 0, y: 6)
                    }
                    .padding(.horizontal, 24)
                    .disabled(viewModel.cravingText.isEmpty)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
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

