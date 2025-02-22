//
//  CravingLogResistancePageView.swift
//  CraveWatch
//
//  A dedicated subview for selecting the "Resistance" level of the craving.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogResistancePageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel

    // Callback to advance to the next tab
    let onNext: () -> Void

    // MARK: - Local State
    @State private var crownResistance: Double = 5.0

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 12) {
                ResistanceInputView(
                    resistance: $viewModel.resistance,
                    onChange: {
                        viewModel.resistanceChanged(viewModel.resistance)
                    }
                )

                Button(action: onNext) {
                    Text("Next")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 26)
                        .background(Color.green)
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 4)
        }
        .focusable()
        .digitalCrownRotation(
            $crownResistance,
            from: 0.0,
            through: 10.0,
            by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        // Updated for watchOS 10+:
        .onChange(of: crownResistance) { _, newVal in
            viewModel.resistance = Int(newVal)
        }
        .onAppear {
            crownResistance = Double(viewModel.resistance)
        }
    }
}

// MARK: - Example `ResistanceInputView`
struct ResistanceInputView: View {
    @Binding var resistance: Int
    let onChange: () -> Void

    var body: some View {
        VStack {
            Text("Resistance: \(resistance)")
                .font(.headline)
                .foregroundColor(.white)
            
            Slider(value: Binding(
                get: { Double(resistance) },
                set: { newVal in
                    resistance = Int(newVal)
                    onChange()
                }
            ), in: 0...10, step: 1)
        }
        .padding()
    }
}
