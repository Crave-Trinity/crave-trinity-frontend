//
//  ConfirmationOverlay.swift
//  CraveWatch
//
//  A translucent overlay that appears upon successful craving logging,
//  or any other "confirmation" scenario.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI

struct ConfirmationOverlay: View {
    /// Controls whether the overlay is shown or hidden.
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            ZStack {
                // Semi-transparent black background
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                // Foreground card
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)

                    Text("Craving Logged!")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("AWESOME.\n\nKeep going—you’ve got this!")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)

                    Button(action: {
                        // Dismiss overlay
                        isPresented = false
                    }) {
                        Text("OK")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .cornerRadius(6)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .shadow(radius: 10)
            }
            .transition(.opacity.animation(.easeInOut))
        }
    }
}
