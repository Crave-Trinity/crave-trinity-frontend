//
//  CravingIntensitySlider.swift
//  A minimal SwiftUI slider for craving intensity.
//
//  - Single Responsibility Principle: only handles the display and
//    binding of the intensity slider.
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
    }
}
