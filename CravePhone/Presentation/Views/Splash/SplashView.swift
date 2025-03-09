// File: SplashView.swift
// PURPOSE: Provides a simple splash screen.
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
        .onAppear { viewModel.onAppear() }
    }
}
