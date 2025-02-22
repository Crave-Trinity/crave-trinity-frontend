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

/// A full-screen overlay that provides visual confirmation for an action, such as logging a craving.
/// This overlay does not include an explicit dismissal button; instead, it is dismissed when the user taps anywhere.
struct ConfirmationOverlay: View {
    
    // MARK: - Dependencies
    
    /// Binding that controls whether the overlay is currently presented.
    @Binding var isPresented: Bool
    
    // MARK: - View Body
    
    var body: some View {
        // Only render the overlay when isPresented is true.
        if isPresented {
            ZStack {
                // Background layer: a translucent, blurred background covering the entire screen.
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .background(.thinMaterial)
                
                // Foreground card: a minimal card providing confirmation details.
                VStack(spacing: 12) {
                    // A large checkmark icon to visually indicate success.
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.green)
                    
                    // Main confirmation text.
                    Text("Craving Logged!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Optional subtext for additional emphasis.
                    Text("AWESOME!")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                // Background styling for the confirmation card.
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                // Border styling for subtle emphasis.
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                // Shadow to add depth to the card.
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 6)
            }
            // Apply an opacity transition for smooth appearance/disappearance.
            .transition(.opacity.animation(.easeInOut))
            // Allow the user to dismiss the overlay by tapping anywhere on it.
            .onTapGesture {
                isPresented = false
            }
        }
    }
}
