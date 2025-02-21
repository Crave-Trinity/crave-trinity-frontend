//
//  VerticalIntensityBar.swift
//  CraveWatch
//
//  Description:
//  A vertical slider for values 1...10. The bar fills from the bottom and displays a numeric label
//  that moves along with the fill. The Digital Crown rotates in steps of 1.
//
//  Created by [Your Name] on [Date]
//
import SwiftUI
import WatchKit

struct VerticalIntensityBar: View {
    @Binding var value: Int  // Expected range: 1...10
    let barWidth: CGFloat
    let barHeight: CGFloat
    
    @State private var crownValue: Double
    let minValue = 1
    let maxValue = 10
    
    init(value: Binding<Int>, barWidth: CGFloat = 8, barHeight: CGFloat = 70) {
        self._value = value
        self._crownValue = State(initialValue: Double(value.wrappedValue))
        self.barWidth = barWidth
        self.barHeight = barHeight
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(width: barWidth, height: barHeight)
            
            let fillWidth = barWidth - 2
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.blue)
                .frame(width: fillWidth, height: fillHeight())
                .animation(.easeInOut, value: value)
            
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
            from: Double(minValue),
            through: Double(maxValue),
            by: 1,
            sensitivity: .low,
            isContinuous: false
        )
        .onChange(of: crownValue) { _, newVal in
            let newValue = max(minValue, min(maxValue, Int(newVal)))
            if newValue != value {
                value = newValue
            }
        }
        .onAppear {
            crownValue = Double(value)
        }
    }
    
    private func fillFraction() -> CGFloat {
        CGFloat(value - minValue) / CGFloat(maxValue - minValue)
    }
    
    private func fillHeight() -> CGFloat {
        barHeight * fillFraction()
    }
    
    private func labelOffset() -> CGFloat {
        let fill = fillHeight()
        let offset = -(fill - 8)
        return max(offset, -barHeight + 8)
    }
}

