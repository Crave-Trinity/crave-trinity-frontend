//
//  VerticalIntensityBar.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A single vertical slider from 0..10 that fills from bottom,
//               but places the numeric label near the top of the fill if it's high.
//
//               - No 0 or 10 markers (minimal).
//               - The user taps the bar to focus, then rotates the Digital Crown.
//               - The numeric label moves up with the fill so that at 10,
//                 the label is near the top.
//

import SwiftUI

struct VerticalIntensityBar: View {
    @Binding var value: Int  // 0..10
    
    // For Digital Crown
    @State private var crownValue: Double
    
    // Bar dimensions
    private let barWidth: CGFloat = 8
    private let barHeight: CGFloat = 70

    init(value: Binding<Int>) {
        _value = value
        _crownValue = State(initialValue: Double(value.wrappedValue))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background track
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(width: barWidth, height: barHeight)
            
            // Filled portion from bottom up
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.blue)
                .frame(width: barWidth, height: fillHeight())
                .animation(.easeInOut, value: value)
            
            // The numeric label that moves with the fill
            Text("\(value)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                // We'll offset the label so it travels up with the fill
                .offset(y: labelOffset())
                .animation(.easeInOut, value: value)
        }
        // Make the bar focusable
        .focusable(true)
        .digitalCrownRotation(
            $crownValue,
            from: 0, through: 10, by: 1,
            sensitivity: .low,
            isContinuous: false
        )
        // Update 'value' when the crown changes
        .onChange(of: crownValue) { _, newVal in
            let newValue = min(10, max(0, Int(newVal)))
            if newValue != value {
                value = newValue
                WatchHapticManager.shared.play(.selection)
            }
        }
        // Initialize crownValue on appear
        .onAppear {
            crownValue = Double(value)
        }
    }
    
    // 0..1 fraction
    private func fillFraction() -> CGFloat {
        CGFloat(value) / 10.0
    }
    
    // Actual fill height
    private func fillHeight() -> CGFloat {
        barHeight * fillFraction()
    }
    
    // Moves the label up as the fill grows
    private func labelOffset() -> CGFloat {
        // If value=0 => fillHeight=0 => label near bottom => offset=0
        // If value=10 => fillHeight=barHeight => offset negative => near top
        // Let's keep ~8 points from the top if it's fully filled
        // So offset = - ( fillHeight - 8 ), but clamp if fill < 8
        let fill = fillHeight()
        let offset = -(fill - 8)
        
        // If fill < 8 => offset is positive => label might dip below bar
        // We can clamp offset so the label doesn't float too far outside
        return max(offset, -barHeight + 8)
    }
}
