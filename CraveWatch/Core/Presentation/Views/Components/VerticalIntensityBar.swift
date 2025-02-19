//
//  VerticalIntensityBar.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A vertical slider from 0 to 10 using the Digital Crown.
//               Tap to focus, then rotate the crown to adjust the value.
//               The text "Intensity" is rotated vertically.
import SwiftUI

struct VerticalIntensityBar: View {
    @Binding var value: Int  // Expected range: 0...10
    
    // Local variable for crown tracking
    @State private var crownValue: Double
    
    // Bar dimensions
    private let barHeight: CGFloat = 60
    private let barWidth: CGFloat = 8
    
    init(value: Binding<Int>) {
        _value = value
        _crownValue = State(initialValue: Double(value.wrappedValue))
    }
    
    var body: some View {
        HStack(spacing: 4) {
            // Vertical slider bar
            ZStack(alignment: .bottom) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: barWidth, height: barHeight)
                
                // Filled portion based on current value
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.blue)
                    .frame(width: barWidth, height: fillHeight())
                    .animation(.easeInOut, value: value)
            }
            .focusable(true)
            .digitalCrownRotation(
                $crownValue,
                from: 0, through: 10, by: 1,
                sensitivity: .low,
                isContinuous: false
            )
            .onChange(of: crownValue) { oldVal, newVal in
                let newValue = min(10, max(0, Int(newVal)))
                if newValue != value {
                    value = newValue
                    WatchHapticManager.shared.play(.selection)
                }
            }
            
            // Rotated text label for vertical orientation
            Text("Intensity")
                .font(.caption2)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(-90))
                .frame(width: 0, height: barHeight)  // Align with the bar height
        }
    }
    
    /// Calculate fill height based on current value
    private func fillHeight() -> CGFloat {
        let fraction = CGFloat(value) / 10.0
        return fraction * barHeight
    }
}
