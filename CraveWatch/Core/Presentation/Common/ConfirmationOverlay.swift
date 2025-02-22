//
//  ConfirmationOverlay.swift
//  CraveWatch
//
//  An ultra-minimal, full-screen overlay for confirming "Craving Logged!"
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//
//  Usage Example:
//    @State private var showConfirmation = false
//
//    var body: some View {
//        ZStack {
//            // ... main content
//            ConfirmationOverlay(isPresented: $showConfirmation)
//        }
//    }
//
//    // After logging a craving successfully:
//    showConfirmation = true
//

import SwiftUI

/// A full-screen overlay that confirms an action (e.g. craving logging).
/// No dismissal button—user taps anywhere to dismiss.
struct ConfirmationOverlay: View {
    
    /// Controls whether the overlay is shown or hidden.
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                // A translucent/blurred background:
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .background(.thinMaterial)
                
                // Foreground card with minimal content
                VStack(spacing: 12) {
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("Craving Logged!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Optional sub‐text
                    Text("AWESOME!")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 6)
            }
            .transition(.opacity.animation(.easeInOut))
            // Taps anywhere on the overlay to dismiss
            .onTapGesture {
                isPresented = false
            }
        }
    }
}
