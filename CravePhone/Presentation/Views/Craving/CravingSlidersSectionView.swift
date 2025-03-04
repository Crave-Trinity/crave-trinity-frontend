//
//  CravingSlidersSectionView.swift
//  CravePhone
//
//  RESPONSIBILITY:
//    Lets users select "Intensity" and "Resistance" clearly without subtitle clutter.
//    UPDATED: Displays a shield icon for Resistance (similar to a flame or wave icon for Intensity).
//    "DESIGNED FOR STEVE JOBS, CODED LIKE UNCLE BOB":
//      - Clear, balanced UI with dynamic color coding.
//      - Single-responsibility component with clean, self-documenting code.
//
//  NOTE:
//    Updated to use the new onChange(of:initial:) syntax (recommended in iOS 17) which now requires a two-parameter closure.
//
import SwiftUI

struct CravingSlidersSectionView: View {
    @Binding var cravingStrength: Double
    @Binding var resistance: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // MARK: - Intensity Slider Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    // Wave emoji for intensity
                    Text("🌊 Intensity")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    Spacer()
                    // Display numeric intensity with a dynamic color
                    Text("\(Int(cravingStrength))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(intensityColor)
                }
                Slider(value: $cravingStrength, in: 1...10, step: 1)
                    .accentColor(intensityColor)
                    .onChange(of: cravingStrength, initial: false) { newValue, oldValue in
                        // Trigger haptic feedback on change
                        CraveHaptics.shared.selectionChanged()
                    }
            }

            // MARK: - Resistance Slider Section with Shield Icon
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    // Shield icon represents resistance visually
                    Image(systemName: "shield.fill")
                        .font(.subheadline)
                        .foregroundColor(resistanceColor)
                    Text("Resistance")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    Spacer()
                    // Display numeric resistance with a dynamic color
                    Text("\(Int(resistance))")
                        .font(CraveTheme.Typography.subheading.weight(.semibold))
                        .foregroundColor(resistanceColor)
                }
                Slider(value: $resistance, in: 1...10, step: 1)
                    .accentColor(resistanceColor)
                    .onChange(of: resistance, initial: false) { newValue, oldValue in
                        // Trigger haptic feedback on change
                        CraveHaptics.shared.selectionChanged()
                    }
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Private Helpers for Dynamic Colors

    /// Determines the intensity color based on the current value.
    private var intensityColor: Color {
        switch Int(cravingStrength) {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default:    return .red
        }
    }

    /// Determines the resistance color based on the current value.
    private var resistanceColor: Color {
        switch Int(resistance) {
        case 1...3: return .red
        case 4...6: return .orange
        case 7...8: return .yellow
        default:    return .green
        }
    }
}

