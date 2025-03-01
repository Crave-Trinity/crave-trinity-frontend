//
//  CravingSlidersSectionView.swift
//  CravePhone
//
//  Uncle Bob & Clean Architecture:
//   - A simple view that shows two sliders for craving intensity
//     and confidence to resist.
//   - Avoids iOS 17 deprecation warnings by using
//     the new zero-parameter .onChange(of:) closure.
//

import SwiftUI

struct CravingSlidersSectionView: View {
    
    // Two Bindings for the user-selected values
    @Binding var cravingStrength: Double
    @Binding var resistance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: - Intensity Slider
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
                
                // iOS 17 solution: zero-parameter onChange closure
                Slider(value: $cravingStrength, in: 1...10, step: 1)
                    .accentColor(intensityColor)
                    .onChange(of: cravingStrength) {
                        // No parameters needed
                        // Just do your side effect
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
            
            // MARK: - Resistance Slider
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
                
                // Same zero-parameter approach for the second slider
                Slider(value: $resistance, in: 1...10, step: 1)
                    .accentColor(resistanceColor)
                    .onChange(of: resistance) {
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
        // Some vertical spacing to keep it clean
        .padding(.vertical, 8)
    }
    
    // MARK: - Computed Colors
    // Tweak these as you wish for your intensity color scheme
    private var intensityColor: Color {
        switch Int(cravingStrength) {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default:    return .red
        }
    }
    
    private var resistanceColor: Color {
        switch Int(resistance) {
        case 1...3: return .red
        case 4...6: return .orange
        case 7...8: return .yellow
        default:    return .green
        }
    }
}

// MARK: - Preview
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
