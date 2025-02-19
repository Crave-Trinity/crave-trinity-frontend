//
//  HorizontalResistanceBar.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A horizontal slider from 0 to 10 using the Digital Crown.
//               Tap to focus, then rotate the crown to adjust the value.
import SwiftUI

struct HorizontalResistanceBar: View {
    @Binding var value: Int  // Expected range: 0...10
    
    // Local variable to track crown rotation
    @State private var crownValue: Double
    
    // Bar dimensions
    private let barWidth: CGFloat = 120
    private let barHeight: CGFloat = 8
    
    init(value: Binding<Int>) {
        _value = value
        _crownValue = State(initialValue: Double(value.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Label above the bar
            Text("Resistance")
                .font(.caption2)
                .foregroundColor(.gray)
            
            HStack {
                // "0" on the left
                Text("0")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(width: barWidth, height: barHeight)
                    
                    // Filled portion based on value
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.blue)
                        .frame(width: fillWidth(), height: barHeight)
                        .animation(.easeInOut, value: value)
                }
                
                // "10" on the right
                Text("10")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        // Make the bar focusable so it can receive Digital Crown input
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
    }
    
    /// Calculate fill width based on current value
    private func fillWidth() -> CGFloat {
        let fraction = CGFloat(value) / 10.0
        return fraction * barWidth
    }
}
