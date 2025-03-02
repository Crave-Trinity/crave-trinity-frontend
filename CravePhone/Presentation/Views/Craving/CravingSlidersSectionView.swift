//
//  CravingSlidersSectionView.swift
//  CravePhone
//
//  RESPONSIBILITY: Lets users select "Intensity" and "Resistance" clearly, without subtitle clutter.
//

import SwiftUI

struct CravingSlidersSectionView: View {
    @Binding var cravingStrength: Double
    @Binding var resistance: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Intensity Slider
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("🌊 Intensity")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    Spacer()
                    Text("\(Int(cravingStrength))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(intensityColor)
                }

                Slider(value: $cravingStrength, in: 1...10, step: 1)
                    .accentColor(intensityColor)
                    .onChange(of: cravingStrength) {
                        CraveHaptics.shared.selectionChanged()
                    }
            }

            // Resistance Slider
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("🏋️‍♂️ Resistance")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    Spacer()
                    Text("\(Int(resistance))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(resistanceColor)
                }

                Slider(value: $resistance, in: 1...10, step: 1)
                    .accentColor(resistanceColor)
                    .onChange(of: resistance) {
                        CraveHaptics.shared.selectionChanged()
                    }
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Private Helpers for Colors
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
