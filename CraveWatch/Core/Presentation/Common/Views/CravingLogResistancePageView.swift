//
//  CravingLogResistancePageView.swift
//  CraveWatch
//
//  A dedicated subview for selecting the "Resistance" level of the craving,
//  using minus/plus controls within a rounded rectangle, accompanied by a green color scheme.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

/// A view for adjusting the "Resistance" level associated with a craving.
/// This view utilizes both button controls and digital crown input to update the view model.
struct CravingLogResistancePageView: View {
    // MARK: - Dependencies
    
    /// The view model that holds and manages the resistance value.
    @ObservedObject var viewModel: CravingLogViewModel
    
    /// Callback invoked when the user taps the "Next" button to proceed.
    let onNext: () -> Void
    
    // MARK: - Local State
    
    /// A local state variable that captures the resistance value controlled by the digital crown.
    @State private var crownResistance: Double = 5.0
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            // Display the current resistance value.
            Text("Resistance: \(viewModel.resistance)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.green)
                .padding(.top, 4)
            
            // A container for the minus/plus controls with a rounded rectangle background.
            ZStack {
                // Background for the control bar.
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 50)
                
                // Horizontal stack containing the minus button, visual indicator, and plus button.
                HStack(spacing: 24) {
                    // Minus Button: decreases resistance by 1, if above the minimum.
                    Button {
                        if viewModel.resistance > 0 {
                            viewModel.resistance -= 1
                            viewModel.resistanceChanged(viewModel.resistance)
                            crownResistance = Double(viewModel.resistance)
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    // Prevent watchOS default focus ring and styling.
                    .focusable(false)
                    .buttonStyle(.plain)
                    
                    // Visual indicator: a row of rectangles representing resistance levels 0 to 10.
                    HStack(spacing: 3) {
                        ForEach(0...10, id: \.self) { i in
                            Rectangle()
                                .fill(i <= viewModel.resistance ? Color.green : Color.gray.opacity(0.4))
                                .frame(width: 5, height: 8)
                                .cornerRadius(2)
                        }
                    }
                    
                    // Plus Button: increases resistance by 1, if below the maximum.
                    Button {
                        if viewModel.resistance < 10 {
                            viewModel.resistance += 1
                            viewModel.resistanceChanged(viewModel.resistance)
                            crownResistance = Double(viewModel.resistance)
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .focusable(false)
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 30)
            
            // "Next" button to advance to the subsequent screen.
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 18)
                    .background(premiumGreenGradient)
                    .cornerRadius(8)
            }
            // Remove default focus styling and disable when loading.
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
            .focusable(false)
        }
        // Make the entire VStack focusable to capture digital crown input.
        .focusable()
        // Configure the digital crown to adjust crownResistance within the range 0 to 10.
        .digitalCrownRotation(
            $crownResistance,
            from: 0.0, through: 10.0, by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        // Update the view model whenever the digital crown value changes.
        .onChange(of: crownResistance) { _, newVal in
            viewModel.resistance = Int(newVal)
            viewModel.resistanceChanged(viewModel.resistance)
        }
        // Initialize crownResistance with the view model's resistance when the view appears.
        .onAppear {
            crownResistance = Double(viewModel.resistance)
        }
        // Apply padding and set a full-screen black background.
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

// MARK: - Premium Green Gradient
/// A custom linear gradient used as the background for the "Next" button.
fileprivate let premiumGreenGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.33, saturation: 0.9, brightness: 0.7),
        Color(hue: 0.33, saturation: 1.0, brightness: 0.5)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
