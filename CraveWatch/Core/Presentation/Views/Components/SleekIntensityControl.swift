//
//  SleekIntensityControl.swift
//  CraveWatch
//
//  Directory: CraveWatch/Core/Presentation/Views/Components
//
//  Description:
//  A minimalist intensity slider for watchOS, designed for elegance and
//  subtle haptic feedback.  Prioritizes Digital Crown input, with optional
//  subtle +/- buttons.
//

import SwiftUI

struct SleekIntensityControl: View {
    @Binding var intensity: Int

    // Option to disable +/- buttons if Digital Crown is the sole input method.
    var showButtons: Bool = false

    var body: some View {
        VStack(spacing: 2) {
            Text("Intensity: \(intensity)")
                .font(.footnote)
                .foregroundColor(.gray)

            HStack(spacing: 4) {
                if showButtons {
                    Button(action: {
                        decrementIntensity()
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }

                Slider(
                    value: Binding(
                        get: { Double(intensity) },
                        set: { intensity = Int($0) }
                    ),
                    in: 1...10,
                    step: 1
                )
                .tint(.blue)
                .frame(height: 14)
                .onChange(of: intensity) { _, newValue in
                    // Subtle haptic feedback on intensity change.
                    WatchHapticManager.shared.play(.intensity(level: newValue))
                }

                if showButtons {
                    Button(action: {
                        incrementIntensity()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func incrementIntensity(){
        intensity = min(intensity + 1, 10)
        WatchHapticManager.shared.play(.selection) // Changed to .selection
    }

    private func decrementIntensity(){
        intensity = max(intensity - 1, 1)
        WatchHapticManager.shared.play(.selection) // Changed to .selection
    }
}

