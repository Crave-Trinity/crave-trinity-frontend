//
//  VerticalIntensityBar.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description:
//    - A vertical slider for values 1...10.
//    - Fills from the bottom, leaving a tiny margin between the fill and track.
//    - The numeric label moves up with the fill (like a "dot").
//    - Digital Crown increments/decrements the value in steps of 1.
//

import SwiftUI
import WatchKit

struct VerticalIntensityBar: View {
    @Binding var value: Int  // Range: 1...10
    
    // Crown value is stored as a Double for smooth rotation,
    // but we clamp it to 1...10 when assigning to 'value'.
    @State private var crownValue: Double
    
    let barWidth: CGFloat
    let barHeight: CGFloat
    
    // Define min/max so it's easy to adjust the range if needed.
    let minValue = 1
    let maxValue = 10
    
    init(value: Binding<Int>, barWidth: CGFloat = 8, barHeight: CGFloat = 70) {
        _value = value
        // Initialize crownValue from the current slider value
        _crownValue = State(initialValue: Double(value.wrappedValue))
        
        self.barWidth = barWidth
        self.barHeight = barHeight
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // 1) The background track (full width)
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(width: barWidth, height: barHeight)
            
            // 2) The filled portion (slightly narrower => small margin)
            //    We'll define fillWidth = barWidth - 2 to leave 1pt margin on each side.
            let fillWidth = barWidth - 2
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.blue)
                .frame(width: fillWidth, height: fillHeight())
                .animation(.easeInOut, value: value)
            
            // 3) Numeric label that moves with the fill
            Text("\(value)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .offset(y: labelOffset())
                .animation(.easeInOut, value: value)
        }
        .focusable(true)
        // 4) Digital Crown rotation from 1 through 10 in steps of 1
        .digitalCrownRotation(
            $crownValue,
            from: Double(minValue),
            through: Double(maxValue),
            by: 1,
            sensitivity: .low,
            isContinuous: false
        )
        .onChange(of: crownValue) { _, newVal in
            // Clamp to 1...10
            let newValue = max(minValue, min(maxValue, Int(newVal)))
            if newValue != value {
                value = newValue
                // Optional haptic feedback
                // WatchHapticManager.shared.play(.selection)
            }
        }
        .onAppear {
            // Keep crownValue in sync with 'value'
            crownValue = Double(value)
        }
    }
    
    // Fraction of fill => (value-minValue)/(maxValue-minValue)
    private func fillFraction() -> CGFloat {
        CGFloat(value - minValue) / CGFloat(maxValue - minValue)
    }
    
    // Actual fill height
    private func fillHeight() -> CGFloat {
        barHeight * fillFraction()
    }
    
    // Moves the label up with the fill
    private func labelOffset() -> CGFloat {
        // Fill is how tall the fill is from the bottom
        let fill = fillHeight()
        // We offset the label so it sits ~8pts above the fill
        let offset = -(fill - 8)
        // Keep label from going off the top if value=10
        return max(offset, -barHeight + 8)
    }
}
