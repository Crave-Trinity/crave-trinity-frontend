//
//  CravingLogIntensityPageView.swift
//  CraveWatch
//
//  A dedicated subview for selecting the "Intensity" of the craving.
//  Combines minus/plus controls in a sleek rounded-rectangle container
//  with an orange title and an orange gradient "Next" button.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogIntensityPageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel

    // Callback to go to the next page
    let onNext: () -> Void

    // MARK: - Local State
    @State private var crownIntensity: Double = 5.0

    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Intensity: \(viewModel.intensity)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.orange)
                .padding(.top, 4)

            // Minus/Plus Bar in a Rounded Rectangle
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

                    // Simple bar of rectangles or partial slider
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
                }
            }
            .padding(.horizontal, 30)

            // "Next" button with an orange gradient
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 18)
                    .background(premiumOrangeGradient)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
        }
        // Digital Crown for watch
        .focusable()
        .digitalCrownRotation(
            $crownIntensity,
            from: 1.0, through: 10.0, by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onChange(of: crownIntensity) { _, newVal in
            // keep code in sync
            viewModel.intensity = Int(newVal)
            viewModel.intensityChanged(viewModel.intensity)
        }
        .onAppear {
            crownIntensity = Double(viewModel.intensity)
        }
        // Layout & background
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
