//
//  VerticalIntensityBar.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A vertical bar on the right, labeled with "Resistance" at the top,
//               going from 10 at the top to 0 at the bottom. The user turns the Digital Crown
//               to adjust intensity from 0..10.
//

import SwiftUI

struct VerticalIntensityBar: View {
    @Binding var intensity: Int  // The current value 0..10
    
    @State private var crownValue: Double  // Local double for the digital crown
    
    init(intensity: Binding<Int>) {
        _intensity = intensity
        // Initialize the crownValue to the incoming intensity
        _crownValue = State(initialValue: Double(intensity.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 2) {
            // A small "Resistance" label
            Text("Resistance")
                .font(.caption2) // tiny watch font
                .foregroundColor(.gray)
            
            // The "10" label near top
            Text("10")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .bottom) {
                // The background track (light gray)
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color.gray.opacity(0.3))
                
                // The fill portion, scaled by fraction
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.blue)
                    .frame(height: fillHeight())
            }
            .frame(width: 8, height: 70) // Adjust to your watch layout
            .padding(.vertical, 4)
            
            // The "0" label near bottom
            Text("0")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        // Let the user rotate the digital crown
        .focusable(true)
        .digitalCrownRotation(
            $crownValue,
            from: 0, through: 10, by: 1,
            sensitivity: .low,
            isContinuous: false
        )
        // Use new two-parameter onChange for watchOS 10+
        .onChange(of: crownValue) { oldVal, newVal in
            // clamp 0..10
            intensity = min(10, max(0, Int(newVal)))
        }
    }
    
    /// Fill the bar from bottom up. If intensity=10 => 100% fill, intensity=0 => 0% fill
    private func fillHeight() -> CGFloat {
        // Our total bar is 70 px tall.
        let maxHeight: CGFloat = 70
        let fraction = CGFloat(intensity) / 10.0
        return maxHeight * fraction
    }
}
