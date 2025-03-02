//
//  CravingSlidersSectionView.swift
//  CravePhone
//
//  RESPONSIBILITY: Lets user pick "Intensity" and "Resistance" with sliders.
//

import SwiftUI

struct CravingSlidersSectionView: View {
    @Binding var cravingStrength: Double
    @Binding var resistance: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Intensity
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
                    // FIXED: Updated deprecated onChange(of:perform:) to new API
                    // The new API takes two parameters (oldValue, newValue) or zero parameters
                    // Note: In this migration we don't need the values, so we use the empty closure variant
                    .onChange(of: cravingStrength) {
                        CraveHaptics.shared.selectionChanged()
                    }

                HStack {
                    Text("Mild").font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Spacer()
                    Text("Intense").font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }

            // Resistance
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Resistance")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    Spacer()
                    Text("\(Int(resistance))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(resistanceColor)
                }
                Slider(value: $resistance, in: 1...10, step: 1)
                    .accentColor(resistanceColor)
                    // FIXED: Updated deprecated onChange(of:perform:) to new API
                    // The new API takes two parameters (oldValue, newValue) or zero parameters
                    // Note: In this migration we don't need the values, so we use the empty closure variant
                    .onChange(of: resistance) {
                        CraveHaptics.shared.selectionChanged()
                    }

                HStack {
                    Text("Low").font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Spacer()
                    Text("High").font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }

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

// MIGRATION NOTES:
// 1. As of iOS 17.0, the older onChange(of:perform:) modifier was deprecated
// 2. The new onChange modifier has two forms:
//    - onChange(of:initial:_:) taking zero parameters in the closure
//    - onChange(of:initial:_:) taking two parameters (oldValue, newValue) in the closure
// 3. The new behavior is also different - in the old API, the closure captured the state BEFORE the change
//    while the new API captures values corresponding to the NEW state
// 4. Since our haptic feedback doesn't depend on the actual values, we've used the zero-parameter version
// 5. If you needed the old behavior, you'd need to use the two-parameter version and work with those values
