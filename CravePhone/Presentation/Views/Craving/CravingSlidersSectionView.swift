//
//  CravingSlidersSectionView.swift
//  CravePhone
//
//  Section with sliders for intensity and resistance metrics.
//

import SwiftUI

struct CravingSlidersSectionView: View {
    @Binding var cravingStrength: Double
    @Binding var resistance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Intensity")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    Spacer()
                    
                    Text("\(Int(cravingStrength))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(intensityColor)
                }
                
                Slider(value: $cravingStrength, in: 1...10, step: 1)
                    .accentColor(intensityColor)
                    .onChange(of: cravingStrength) { _ in
                        CraveHaptics.shared.selectionChanged()
                    }
                
                HStack {
                    Text("Mild")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("Intense")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Confidence to Resist")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    
                    Spacer()
                    
                    Text("\(Int(resistance))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(resistanceColor)
                }
                
                Slider(value: $resistance, in: 1...10, step: 1)
                    .accentColor(resistanceColor)
                    .onChange(of: resistance) { _ in
                        CraveHaptics.shared.selectionChanged()
                    }
                
                HStack {
                    Text("Low")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    
                    Spacer()
                    
                    Text("High")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var intensityColor: Color {
        switch Int(cravingStrength) {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default: return .red
        }
    }
    
    private var resistanceColor: Color {
        switch Int(resistance) {
        case 1...3: return .red
        case 4...6: return .orange
        case 7...8: return .yellow
        default: return .green
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        CravingSlidersSectionView(
            cravingStrength: .constant(7),
            resistance: .constant(4)
        )
        .padding()
    }
}
