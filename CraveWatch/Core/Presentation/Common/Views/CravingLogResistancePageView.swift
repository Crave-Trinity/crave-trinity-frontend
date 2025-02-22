//
//  CravingLogResistancePageView.swift
//  CraveWatch
//
//  A dedicated subview for selecting the "Resistance" level of the craving,
//  using a minus/plus bar inside a rounded rectangle, and a green color scheme.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogResistancePageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel

    // Callback to advance to the next page
    let onNext: () -> Void

    // MARK: - Local State
    @State private var crownResistance: Double = 5.0

    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Resistance: \(viewModel.resistance)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.green)
                .padding(.top, 4)

            // Minus/Plus Bar
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 50)

                HStack(spacing: 24) {
                    // Minus Button
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
                    .focusable(false)

                    // Bar of rectangles
                    HStack(spacing: 3) {
                        ForEach(0...10, id: \.self) { i in
                            Rectangle()
                                .fill(i <= viewModel.resistance ? Color.green : Color.gray.opacity(0.4))
                                .frame(width: 5, height: 8)
                                .cornerRadius(2)
                        }
                    }

                    // Plus Button
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
                }
            }
            .padding(.horizontal, 30)

            // Next button with a green gradient
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 18)
                    .background(premiumGreenGradient)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
            .focusable(false)
        }
        // Digital crown
        .focusable()
        .digitalCrownRotation(
            $crownResistance,
            from: 0.0, through: 10.0, by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onChange(of: crownResistance) { _, newVal in
            viewModel.resistance = Int(newVal)
            viewModel.resistanceChanged(viewModel.resistance)
        }
        .onAppear {
            crownResistance = Double(viewModel.resistance)
        }
        // Layout & background
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

// MARK: - Example Green Gradient
fileprivate let premiumGreenGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.33, saturation: 0.9, brightness: 0.7),
        Color(hue: 0.33, saturation: 1.0, brightness: 0.5)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
