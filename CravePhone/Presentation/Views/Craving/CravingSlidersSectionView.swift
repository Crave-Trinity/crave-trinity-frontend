//
//  CravingSlidersSectionView.swift
//  CravePhone
//
//  Description:
//    A SwiftUI view that displays two sliders: one for craving intensity and one for resistance.
//    Each slider is presented with a label and custom styling.
//
//  Uncle Bob notes:
//    - Single Responsibility: Only displays and binds slider values.
//    - Open for extension: Easily add haptics or additional styling if needed.
//

import SwiftUI

struct CravingSlidersSectionView: View {
    // Bindings for the slider values.
    @Binding var cravingStrength: Double
    @Binding var resistance: Double
    
    var body: some View {
        VStack(spacing: 24) {
            // Craving Intensity Slider
            VStack(alignment: .leading, spacing: 6) {
                Text("Craving Intensity: \(Int(cravingStrength))")
                    .foregroundColor(.white)
                    .font(.headline)
                Slider(value: $cravingStrength, in: 1...10, step: 1)
                    .accentColor(.orange)
            }
            
            // Resistance Slider
            VStack(alignment: .leading, spacing: 6) {
                Text("Resistance: \(Int(resistance))")
                    .foregroundColor(.white)
                    .font(.headline)
                Slider(value: $resistance, in: 1...10, step: 1)
                    .accentColor(.orange)
            }
        }
    }
}
