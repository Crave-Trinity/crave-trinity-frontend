//
//  CravingLogIntensityPageView.swift
//  CraveWatch
//
//  A dedicated subview for selecting the "Intensity" of the craving.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogIntensityPageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel

    // Callback to advance to the next tab
    let onNext: () -> Void

    // MARK: - Local State
    @State private var crownIntensity: Double = 5.0

    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            IntensityInputView(
                intensity: $viewModel.intensity,
                onChange: {
                    viewModel.intensityChanged(viewModel.intensity)
                }
            )

            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 26)
                    .background(premiumOrangeGradient)
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
        }
        // The digital crown rotation
        .focusable()
        .digitalCrownRotation(
            $crownIntensity,
            from: 1.0,
            through: 10.0,
            by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        // Updated for watchOS 10+:
        // Now using two-parameter closure: { oldValue, newValue in ... }
        .onChange(of: crownIntensity) { _, newVal in
            viewModel.intensity = Int(newVal)
        }
        .onAppear {
            crownIntensity = Double(viewModel.intensity)
        }
        .padding(.horizontal, 8)
        .padding(.top, 4)
    }
}

// MARK: - Example `IntensityInputView`
// For demonstration, assume this is a smaller subview. If you have an `IntensityInputViewModel` planned,
// you could move logic there. This is a basic placeholder to show how you might structure it.
struct IntensityInputView: View {
    @Binding var intensity: Int
    let onChange: () -> Void

    var body: some View {
        VStack {
            Text("Intensity: \(intensity)")
                .font(.headline)
                .foregroundColor(.white)

            Slider(value: Binding(
                get: { Double(intensity) },
                set: { newVal in
                    intensity = Int(newVal)
                    onChange()
                }
            ), in: 1...10, step: 1)

            // Additional UI or text can go here
        }
        .padding()
    }
}

// MARK: - Shared Gradient
fileprivate let premiumOrangeGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.10, saturation: 0.8, brightness: 1.0),
        Color(hue: 0.10, saturation: 0.9, brightness: 0.6)
    ]),
    startPoint: .top,
    endPoint: .bottom
)
