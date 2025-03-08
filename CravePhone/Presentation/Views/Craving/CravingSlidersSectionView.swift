//
//  CravingSlidersSectionView.swift
//  CravePhone
//
//  This file defines the UI for the Intensity and Resistance sliders
//  in the CravePhone app. It demonstrates a clean, SOLID-aligned approach
//  to structuring SwiftUI views, following best practices from Uncle Bob
//  and the Gang of Four.
//
//  Responsibilities are clearly separated:
//   - This view is solely responsible for layout and user interaction
//   - Color logic is handled by small, focused computed properties
//   - Slider values remain bound to external @State or @Binding variables
//
//  The code below centers each slider horizontally and keeps the
//  value range from 1 to 10 with integer steps.
//

import SwiftUI

/// The main view for displaying and editing the user’s craving intensity and resistance.
/// - Parameters:
///   - cravingStrength: A binding to the user’s current craving strength (1–10).
///   - resistance: A binding to the user’s current resistance (1–10).
struct CravingSlidersSectionView: View {
    // MARK: - Properties

    /// Craving strength from 1 to 10.
    @Binding var cravingStrength: Double
    
    /// Resistance from 1 to 10.
    @Binding var resistance: Double
    
    // MARK: - View Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // MARK: - Intensity Slider Section
            VStack(alignment: .leading, spacing: 8) {
                // Header row: label on the left, numeric value on the right
                HStack {
                    Text("🌊 Intensity")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    // Display the integer version of cravingStrength
                    Text("\(Int(cravingStrength))")
                        .font(.headline)
                        .foregroundColor(intensityColor)
                }
                
                // Center the slider horizontally with an HStack + Spacer approach
                HStack {
                    Spacer()
                    Slider(
                        value: $cravingStrength,
                        in: 0...10,
                        step: 1
                    ) {
                        // Accessibility label for screen readers
                        Text("Intensity")
                    }
                    // Use accentColor to match the slider’s track/knob color
                    .accentColor(intensityColor)
                    // Constrain the slider width so it doesn't span the entire screen
                    .frame(maxWidth: 300)
                    Spacer()
                }
            }
            
            // MARK: - Resistance Slider Section
            VStack(alignment: .leading, spacing: 8) {
                // Header row: icon + label on the left, numeric value on the right
                HStack {
                    Image(systemName: "shield.fill")
                        .foregroundColor(resistanceColor)
                    Text("Resistance")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    // Display the integer version of resistance
                    Text("\(Int(resistance))")
                        .font(.headline)
                        .foregroundColor(resistanceColor)
                }
                
                // Center the slider horizontally with an HStack + Spacer approach
                HStack {
                    Spacer()
                    Slider(
                        value: $resistance,
                        in: 0...10,
                        step: 1
                    ) {
                        // Accessibility label for screen readers
                        Text("Resistance")
                    }
                    .accentColor(resistanceColor)
                    .frame(maxWidth: 300)
                    Spacer()
                }
            }
        }
        // Overall padding to give the stack some breathing room
        .padding()
    }
    
    // MARK: - Computed Properties
    
    /// Dynamically choose a color based on the current craving strength.
    /// Adjust thresholds and colors to match your design guidelines.
    private var intensityColor: Color {
        switch cravingStrength {
        case 7...10: return .red
        case 4..<7:  return .orange
        default:     return .green
        }
    }
    
    /// Dynamically choose a color based on the current resistance level.
    /// Adjust thresholds and colors to match your design guidelines.
    private var resistanceColor: Color {
        switch resistance {
        case 7...10: return .blue
        case 4..<7:  return .yellow
        default:     return .gray
        }
    }
}


