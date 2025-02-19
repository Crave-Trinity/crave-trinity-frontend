//
//  VerticalToggleBar.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A single vertical bar that toggles between "Intensity" and "Resistance" modes.
//               - No 0 or 10 labels (minimal design).
//               - The current value (0..10) appears in the middle of the fill, starting at 5.
//               - Tap the bar to focus for Digital Crown input.
//               - Tap the label at the bottom to toggle the mode.
//

import SwiftUI

struct VerticalToggleBar: View {
    
    // The bar can be in one of two modes:
    enum Mode: String {
        case intensity = "Intensity"
        case resistance = "Resistance"
    }
    
    // Current mode
    @State private var mode: Mode = .intensity
    
    // We store separate values for each mode (0..10)
    @State private var intensityValue: Int = 5
    @State private var resistanceValue: Int = 5
    
    // For Digital Crown rotation
    @State private var crownValue: Double = 5
    
    // Dimensions
    private let barWidth: CGFloat = 8
    private let barHeight: CGFloat = 70

    var body: some View {
        VStack(spacing: 2) {
            ZStack(alignment: .bottom) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: barWidth, height: barHeight)
                
                // Filled portion
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.blue)
                    .frame(width: barWidth, height: fillHeight())
                    .animation(.easeInOut, value: currentValue())
                
                // The current numeric value in the middle of the fill
                Text("\(currentValue())")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y: labelOffset())
                    .animation(.easeInOut, value: currentValue())
            }
            // Make the bar focusable for Digital Crown
            .focusable(true)
            .digitalCrownRotation(
                $crownValue,
                from: 0, through: 10, by: 1,
                sensitivity: .low,
                isContinuous: false
            )
            .onChange(of: crownValue) { _, newVal in
                let newValue = min(10, max(0, Int(newVal)))
                if mode == .intensity {
                    if newValue != intensityValue {
                        intensityValue = newValue
                        WatchHapticManager.shared.play(.selection)
                    }
                } else {
                    if newValue != resistanceValue {
                        resistanceValue = newValue
                        WatchHapticManager.shared.play(.selection)
                    }
                }
            }
            
            // Tap the label at the bottom to toggle modes
            Text(mode.rawValue)
                .font(.caption2)
                .foregroundColor(.gray)
                .onTapGesture {
                    toggleMode()
                }
        }
        .onAppear {
            // Ensure the crownValue matches the starting mode's value
            crownValue = Double(currentValue())
        }
    }
    
    /// Returns the integer value of the currently active mode
    private func currentValue() -> Int {
        mode == .intensity ? intensityValue : resistanceValue
    }
    
    /// The fraction of fill from 0..1
    private func fillFraction() -> CGFloat {
        CGFloat(currentValue()) / 10.0
    }
    
    /// The fill height (0..barHeight)
    private func fillHeight() -> CGFloat {
        fillFraction() * barHeight
    }
    
    /// Position the numeric label in the middle of the fill
    private func labelOffset() -> CGFloat {
        let halfFill = fillHeight() * 0.5
        // alignment is .bottom => offset=0 is the bottom
        return halfFill - (barHeight / 2)
    }
    
    /// Toggle between Intensity and Resistance modes
    private func toggleMode() {
        if mode == .intensity {
            mode = .resistance
        } else {
            mode = .intensity
        }
        crownValue = Double(currentValue())
        WatchHapticManager.shared.play(.selection)
    }
}
