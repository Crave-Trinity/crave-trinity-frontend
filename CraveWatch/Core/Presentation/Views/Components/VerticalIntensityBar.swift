//
//  VerticalIntensityBar.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A vertical slider (0–10) that fills from the bottom and
//               moves the numeric label upward as the value increases.
import SwiftUI

struct VerticalIntensityBar: View {
    @Binding var value: Int  // Expected range: 0...10
    @State private var crownValue: Double
    let barWidth: CGFloat
    let barHeight: CGFloat = 70

    init(value: Binding<Int>, barWidth: CGFloat = 8) {
        _value = value
        _crownValue = State(initialValue: Double(value.wrappedValue))
        self.barWidth = barWidth
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background track
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(width: barWidth, height: barHeight)
            // Filled portion
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.blue)
                .frame(width: barWidth, height: fillHeight())
                .animation(.easeInOut, value: value)
            // Numeric label that moves with the fill
            Text("\(value)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .offset(y: labelOffset())
                .animation(.easeInOut, value: value)
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
            if newValue != value {
                value = newValue
                WatchHapticManager.shared.play(.selection)
            }
        }
        .onAppear {
            crownValue = Double(value)
        }
    }
    
    private func fillFraction() -> CGFloat {
        CGFloat(value) / 10.0
    }
    
    private func fillHeight() -> CGFloat {
        barHeight * fillFraction()
    }
    
    private func labelOffset() -> CGFloat {
        // Adjust offset so that when value==10, label is near the top
        let fill = fillHeight()
        let offset = -(fill - 8)
        return max(offset, -barHeight + 8)
    }
}
