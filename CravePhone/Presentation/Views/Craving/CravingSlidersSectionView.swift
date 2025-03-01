//
//  CravingSlidersSectionView.swift
//  CravePhone
//
//  Description:
//    Displays two sliders: craving intensity & resistance.
//
//  Uncle Bob notes:
//    - Single Responsibility: Binds slider values, no other logic.
//
import SwiftUI

struct CravingSlidersSectionView: View {
    @Binding var cravingStrength: Double
    @Binding var resistance: Double
    
    var body: some View {
        VStack(spacing: 24) {
            // Craving Intensity Slider
            VStack(alignment: .leading, spacing: 6) {
                Text("Intensity: \(Int(cravingStrength))")
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
