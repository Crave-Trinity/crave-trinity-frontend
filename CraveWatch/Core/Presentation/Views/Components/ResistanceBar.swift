//
//  ResistanceBar.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A "radical" intensity bar from 0 to 10.
//               Left emoji = weak/tired, right emoji = strong/lightning.
//               Updates intensity by using the Digital Crown.
//

import SwiftUI

struct ResistanceBar: View {
    @Binding var intensity: Int  // 0..10 range
    
    // We'll store a local double for the crown
    @State private var crownValue: Double
    
    // Initialize crownValue from the initial intensity
    init(intensity: Binding<Int>) {
        _intensity = intensity
        _crownValue = State(initialValue: Double(intensity.wrappedValue))
    }
    
    var body: some View {
        HStack {
            // "Weak" / "Tired" emoji on left
            Text("😫")
                .font(.system(size: 20))
            
            ZStack(alignment: .leading) {
                // Gray background track
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(height: 8)
                
                // Blue fill portion
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.blue)
                    .frame(width: fillWidth(), height: 8)
            }
            .frame(width: 100)
            .padding(.horizontal, 4)
            
            // "Strong" / "Lightning" on right
            Text("⚡️")
                .font(.system(size: 20))
        }
        .focusable(true)
        // Use the new two-parameter onChange for crownValue:
        .onChange(of: crownValue) { oldVal, newVal in
            // Force 0..10
            intensity = min(10, max(0, Int(newVal)))
        }
        .digitalCrownRotation(
            $crownValue,
            from: 0, through: 10, by: 1,
            sensitivity: .low,
            isContinuous: false
        )
    }
    
    /// Scale 0..10 to 0..100 for the fill
    private func fillWidth() -> CGFloat {
        let maxWidth: CGFloat = 100
        let fraction = CGFloat(intensity) / 10.0
        return maxWidth * fraction
    }
}
