//==============================================================
//  File E: VerticalToggleBar.swift (Optional)
//  Description:
//    A single vertical bar that toggles between two "modes" (e.g. Intensity
//    and Resistance). Each mode has a separate 0..10 value. The user can
//    tap the label at the bottom to switch modes.
//
//  Usage:
//    - Insert <VerticalToggleBar> in your SwiftUI layout if you want a
//      quick toggle bar that can represent two distinct numeric values.
//    - If not needed, remove this file entirely.
//==============================================================

import SwiftUI
import WatchKit

struct VerticalToggleBar: View {
    
    // The bar can be in one of two modes
    enum Mode: String {
        case intensity = "Intensity"
        case resistance = "Resistance"
    }
    
    // Current mode
    @State private var mode: Mode = .intensity
    
    // Separate values for each mode
    @State private var intensityValue: Int = 5
    @State private var resistanceValue: Int = 5
    
    // For Digital Crown rotation (0..10)
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
                
                // Numeric label in the middle of the fill
                Text("\(currentValue())")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y: labelOffset())
                    .animation(.easeInOut, value: currentValue())
            }
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
            
            // Tap the label to toggle modes
            Text(mode.rawValue)
                .font(.caption2)
                .foregroundColor(.gray)
                .onTapGesture {
                    toggleMode()
                }
        }
        .onAppear {
            // Match crownValue to whichever mode is active
            crownValue = Double(currentValue())
        }
    }
    
    /// Returns the integer value of the currently active mode
    private func currentValue() -> Int {
        (mode == .intensity) ? intensityValue : resistanceValue
    }
    
    /// Fraction of fill from 0..1
    private func fillFraction() -> CGFloat {
        CGFloat(currentValue()) / 10.0
    }
    
    /// The fill height in points
    private func fillHeight() -> CGFloat {
        barHeight * fillFraction()
    }
    
    /// Position the label in the middle of the fill
    private func labelOffset() -> CGFloat {
        let halfFill = fillHeight() * 0.5
        // alignment is .bottom => offset=0 is the bottom
        return halfFill - (barHeight / 2)
    }
    
    /// Toggle between Intensity and Resistance
    private func toggleMode() {
        mode = (mode == .intensity) ? .resistance : .intensity
        crownValue = Double(currentValue())
        WatchHapticManager.shared.play(.selection)
    }
}


