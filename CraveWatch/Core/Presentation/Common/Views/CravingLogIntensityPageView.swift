//
//  CravingLogIntensityPageView.swift
//  CraveWatch
//
//  A dedicated subview for selecting "Intensity" with minus/plus controls,
//  removing watchOS focus crosshairs by only focusing the parent.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogIntensityPageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel

    // Callback to advance to the next page
    let onNext: () -> Void

    // MARK: - Local State
    // The crownIntensity property is used to manage the digital crown input,
    // controlling the displayed intensity in a seamless watchOS-friendly way.
    @State private var crownIntensity: Double = 5.0

    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            // Display the current intensity value
            Text("Intensity: \(viewModel.intensity)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.orange)
                .padding(.top, 4)

            // A ZStack to hold the minus/plus bar inside a rounded background
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 50)

                HStack(spacing: 24) {
                    // Minus Button
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
                    // Prevent watchOS from drawing a focus ring here
                    .focusable(false)
                    // Remove default button style to avoid crosshairs or outlines
                    .buttonStyle(.plain)

                    // Row of rectangles to visualize intensity 1 to 10
                    HStack(spacing: 3) {
                        ForEach(1...10, id: \.self) { i in
                            Rectangle()
                                .fill(i <= viewModel.intensity ? Color.orange : Color.gray.opacity(0.4))
                                .frame(width: 5, height: 8)
                                .cornerRadius(2)
                        }
                    }

                    // Plus Button
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
                    // Same no-focus, plain style to remove watchOS crosshairs
                    .focusable(false)
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 30)

            // "Next" button to advance to the next page
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 18)
                    .background(premiumOrangeGradient)
                    .cornerRadius(8)
            }
            // Also remove focus ring from the Next button
            .buttonStyle(.plain)
            .focusable(false)
        }
        // Let the **entire** VStack be focusable to capture the Digital Crown rotation
        .focusable(true)
        // Map crown rotation to intensity from 1 to 10
        .digitalCrownRotation(
            $crownIntensity,
            from: 1.0, through: 10.0, by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        // Update the ViewModel whenever the digital crown value changes
        .onChange(of: crownIntensity) { _, newVal in
            viewModel.intensity = Int(newVal)
            viewModel.intensityChanged(viewModel.intensity)
        }
        // Make sure crownIntensity is in sync with the initial intensity
        .onAppear {
            crownIntensity = Double(viewModel.intensity)
        }
        // Fill the available space with a black background
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

// MARK: - Example Orange Gradient
fileprivate let premiumOrangeGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.08, saturation: 0.85, brightness: 1.0),
        Color(hue: 0.10, saturation: 0.95, brightness: 0.7)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
