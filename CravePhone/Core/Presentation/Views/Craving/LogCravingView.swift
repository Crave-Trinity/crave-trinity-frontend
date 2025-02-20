//
//  LogCravingView.swift
//  CravePhone
//
//  Created by John H Jung on <date>.
//  Updated by ChatGPT on <today's date>.
//
//  A futuristic “Log Craving” screen with animated gradient background,
//  glass-like card, confetti sparkles on success, and a big call-to-action
//  “Log” button. MVVM + SOLID in mind.
//

import SwiftUI

/// The main view for logging a craving.
@MainActor
public struct LogCravingView: View {
    
    // We inject a LogCravingViewModel from the outside
    @ObservedObject var viewModel: LogCravingViewModel
    
    // Whether to show confetti animation after success
    @State private var showConfetti: Bool = false
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                // 1) ANIMATED BACKGROUND
                AnimatedGradientBackground()
                    .edgesIgnoringSafeArea(.all)
                
                // 2) A GLASS CARD
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .padding(.horizontal, 16)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .edgesIgnoringSafeArea(.bottom)
                
                // 3) MAIN CONTENT
                VStack(spacing: 24) {
                    Text("LOG CRAVING")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.top, 50)
                    
                    // Subtext or motivational message
                    Text("Track your cravings and find patterns with AI insights!")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // The big text editor area for user input
                    ZStack {
                        Color.black.opacity(0.2)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        
                        CraveTextEditor(
                            text: $viewModel.cravingText,
                            characterLimit: 280
                        )
                        .padding()
                    }
                    .padding(.horizontal, 24)
                    
                    // 4) LOG BUTTON
                    Button(action: {
                        Task {
                            // Provide haptic feedback
                            CraveHaptics.shared.mediumImpact()
                            
                            // Attempt logging
                            await viewModel.logCraving()
                            
                            // If no error, show confetti
                            if viewModel.alertInfo == nil {
                                withAnimation {
                                    showConfetti = true
                                }
                                // Optionally hide confetti after 2 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showConfetti = false
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Log Now")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
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
                .padding(.bottom, 30)
                
                // 5) LOADING OVERLAY
                if viewModel.isLoading {
                    ProgressView("Logging...")
                        .padding(40)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                }
                
                // 6) CONFETTI EFFECT on success
                if showConfetti {
                    ConfettiView()
                        .transition(.scale)
                }
            }
            // 7) ALERT for errors
            .alert(item: $viewModel.alertInfo) { info in
                Alert(
                    title: Text(info.title),
                    message: Text(info.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // For iPad-friendly
    }
}

// MARK: - Preview
#if DEBUG
struct LogCravingView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUseCase = DummyAddCravingUseCase()
        let vm = LogCravingViewModel(addCravingUseCase: mockUseCase)
        return LogCravingView(viewModel: vm)
    }
}
#endif

// ===================================================
// MARK: - SUPPORTING COMPONENTS
// ===================================================

/// An animated gradient background that shifts hues over time.
fileprivate struct AnimatedGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple,
                    Color.blue,
                    Color.pink
                ]),
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear {
            animate = true
        }
    }
}

/// A simple confetti particle effect for celebration.
fileprivate struct ConfettiView: View {
    @State private var randomOffsets: [CGSize] = (0..<25).map { _ in
        CGSize(width: .random(in: -150...150), height: .random(in: -200...200))
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(randomOffsets.indices, id: \.self) { i in
                    let offset = randomOffsets[i]
                    Circle()
                        .fill(randomColor())
                        .frame(width: 8, height: 8)
                        .position(x: proxy.size.width/2, y: proxy.size.height/2)
                        .offset(offset)
                }
            }
        }
        .transition(.opacity)
    }
    
    private func randomColor() -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .pink, .purple]
        return colors.randomElement() ?? .white
    }
}
