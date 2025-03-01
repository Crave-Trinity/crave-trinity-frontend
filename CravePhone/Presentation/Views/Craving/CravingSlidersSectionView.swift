/* -----------------------------------------
   CravingSlidersSectionView.swift
   ----------------------------------------- */
import SwiftUI

struct CravingSlidersSectionView: View {
    @Binding var cravingStrength: Double
    @Binding var resistance: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.10) {
                
                // Craving Intensity Slider
                VStack(alignment: .leading, spacing: geometry.size.height * 0.01) {
                    Text("Intensity: \(Int(cravingStrength))")
                        .foregroundColor(.white)
                        .font(.headline)
                    Slider(value: $cravingStrength, in: 1...10, step: 1)
                        .accentColor(.orange)
                }
                
                // Resistance Slider
                VStack(alignment: .leading, spacing: geometry.size.height * 0.01) {
                    Text("Resistance: \(Int(resistance))")
                        .foregroundColor(.white)
                        .font(.headline)
                    Slider(value: $resistance, in: 1...10, step: 1)
                        .accentColor(.orange)
                }
                
                Spacer(minLength: 0)
            }
        }
        .frame(minHeight: 120)
    }
}

