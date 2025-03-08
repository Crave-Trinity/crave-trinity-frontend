//
// CravingSlidersSectionView.swift
// /CravePhone/Presentation/Views/Craving/CravingSlidersSectionView.swift
//
// Revised for consistent typography and spacing.
// Updated to use CraveTheme's spacing and typography for slider labels.
import SwiftUI

struct CravingSlidersSectionView: View {
    @Binding var cravingStrength: Double
    @Binding var resistance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: CraveTheme.Spacing.medium) {
            // MARK: - Intensity Slider Section
            VStack(alignment: .leading, spacing: CraveTheme.Spacing.small) {
                HStack {
                    Text("🌊 Intensity")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    Spacer()
                    Text("\(Int(cravingStrength))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(intensityColor)
                }
                Slider(value: $cravingStrength, in: 0...10, step: 1)
                    .accentColor(intensityColor)
                    .onChange(of: cravingStrength, initial: false) { newValue, _ in
                        CraveHaptics.shared.selectionChanged()
                    }
            }
            // MARK: - Resistance Slider Section
            VStack(alignment: .leading, spacing: CraveTheme.Spacing.small) {
                HStack {
                    Image(systemName: "shield.fill")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(resistanceColor)
                    Text("Resistance")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    Spacer()
                    Text("\(Int(resistance))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(resistanceColor)
                }
                Slider(value: $resistance, in: 0...10, step: 1)
                    .accentColor(resistanceColor)
                    .onChange(of: resistance, initial: false) { newValue, _ in
                        CraveHaptics.shared.selectionChanged()
                    }
            }
        }
        .padding(.vertical, CraveTheme.Spacing.medium)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Private Helpers for Dynamic Colors
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
