//
//  CravingLogIntensityPageView.swift
//  CraveWatch
//
//  A dedicated subview for selecting "Intensity" using minus/plus controls and digital crown input.
//  This view removes default watchOS focus crosshairs by limiting focus to the parent view.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

/// A view for adjusting the intensity of a craving using both buttons and digital crown rotation.
/// It updates the associated view model and provides a "Next" action callback to advance the workflow.
struct CravingLogIntensityPageView: View {
    // MARK: - Dependencies
    
    /// The view model that holds and manages the intensity value.
    @ObservedObject var viewModel: CravingLogViewModel

    /// Callback invoked when the user taps "Next" to proceed.
    let onNext: () -> Void

    // MARK: - Local State
    
    /// A local state value representing the intensity controlled by the digital crown.
    /// This value is kept in sync with the view model's intensity.
    @State private var crownIntensity: Double = 5.0

    // MARK: - View Body
    
    var body: some View {
        VStack(spacing: 16) {
            // Display the current intensity value from the view model.
            Text("Intensity: \(viewModel.intensity)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.orange)
                .padding(.top, 4)

            // Container for the minus/plus controls, presented over a rounded rectangle background.
            ZStack {
                // Background rectangle with subtle opacity.
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 50)
                
                // Horizontal stack holding the minus button, visual intensity indicators, and plus button.
                HStack(spacing: 24) {
                    // Minus button: decreases intensity by 1, if above the minimum.
                    Button {
                        if viewModel.intensity > 1 {
                            viewModel.intensity -= 1
                            viewModel.intensityChanged(viewModel.intensity)
                            crownIntensity = Double(viewModel.intensity)
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    // Remove focus ring and default styling for a cleaner watchOS appearance.
                    .focusable(false)
                    .buttonStyle(.plain)
                    
                    // Visual intensity indicator: a row of rectangles representing intensity levels 1 to 10.
                    HStack(spacing: 3) {
                        ForEach(1...10, id: \.self) { i in
                            Rectangle()
                                .fill(i <= viewModel.intensity ? Color.orange : Color.gray.opacity(0.4))
                                .frame(width: 5, height: 8)
                                .cornerRadius(2)
                        }
                    }
                    
                    // Plus button: increases intensity by 1, if below the maximum.
                    Button {
                        if viewModel.intensity < 10 {
                            viewModel.intensity += 1
                            viewModel.intensityChanged(viewModel.intensity)
                            crownIntensity = Double(viewModel.intensity)
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    // Remove focus and default style for consistency.
                    .focusable(false)
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 30)
            
            // "Next" button to signal moving to the next step in the workflow.
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 18)
                    .background(premiumOrangeGradient)
                    .cornerRadius(8)
            }
            // Remove focus styling to avoid unwanted watchOS UI artifacts.
            .buttonStyle(.plain)
            .focusable(false)
        }
        // Make the entire VStack focusable to capture Digital Crown input.
        .focusable(true)
        // Map the digital crown rotation to the crownIntensity value (range 1 to 10).
        .digitalCrownRotation(
            $crownIntensity,
            from: 1.0, through: 10.0, by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        // Synchronize the view model whenever the crown value changes.
        .onChange(of: crownIntensity) { _, newVal in
            viewModel.intensity = Int(newVal)
            viewModel.intensityChanged(viewModel.intensity)
        }
        // Initialize crownIntensity based on the view model when the view appears.
        .onAppear {
            crownIntensity = Double(viewModel.intensity)
        }
        // Apply padding and ensure the view fills the available space with a black background.
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

// MARK: - Premium Orange Gradient
/// A custom linear gradient used for the "Next" button background.
fileprivate let premiumOrangeGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.08, saturation: 0.85, brightness: 1.0),
        Color(hue: 0.10, saturation: 0.95, brightness: 0.7)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
