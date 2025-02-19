//
//  CravingAdjustView.swift
//  CraveWatch
//

import SwiftUI

struct CravingAdjustView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Bindings from CravingLogView
    @Binding var intensity: Int
    @Binding var resistance: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Adjust Sliders")
                .font(.headline)
            
            // Vertical slider for Intensity
            Text("Intensity: \(intensity)")
                .font(.subheadline)
            VerticalIntensityBar(value: $intensity, barWidth: 6)
                .frame(height: 100)
            
            // Vertical slider for Resistance
            Text("Resistance: \(resistance)")
                .font(.subheadline)
            VerticalIntensityBar(value: $resistance, barWidth: 6)
                .frame(height: 100)
            
            // Done button
            Button("Done") {
                dismiss()
            }
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(4)
        }
        .padding(.top, 8)
    }
}
