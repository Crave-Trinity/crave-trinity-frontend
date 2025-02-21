//
//  CravingIntensitySlider.swift
//  CravePhone
//
//  Description:
//    A refined slider with a subtle glow effect for the selected intensity.
//
//  Uncle Bob notes:
//    - Single Responsibility: Only displays and binds craving intensity.
//    - Open for extension: Could add haptics or custom styling easily.
//

import SwiftUI

struct CravingIntensitySlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    init(value: Binding<Double>, in range: ClosedRange<Double> = 1...10, step: Double = 1) {
        self._value = value
        self.range = range
        self.step = step
    }
    
    var body: some View {
        Slider(
            value: $value,
            in: range,
            step: step
        )
        .accentColor(CraveTheme.Colors.accent)
        .shadow(color: CraveTheme.Colors.accent.opacity(0.4),
                radius: 4, x: 0, y: 2)
        .padding(.horizontal, CraveTheme.Spacing.small)
    }
}
