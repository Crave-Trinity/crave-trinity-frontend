//=================================================================
// File: CravePhone/Presentation/Views/Splash/SplashView.swift
// PURPOSE:
//  - Minimal splash screen before navigating to LoginView or CRAVETabView.
//
// UNCLE BOB + STEVE JOBS STYLE – COMPLETE PASTE & RUN
//=================================================================

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel: SplashViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("CRAVE")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
