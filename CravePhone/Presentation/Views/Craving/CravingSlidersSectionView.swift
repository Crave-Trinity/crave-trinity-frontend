/*
 ┌───────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views/Craving                 │
 │  Production-Ready SwiftUI Layout Fix:                │
 │  CravingSlidersSectionView                           │
 │  Notes:                                              │
 │   - GeometryReader removed.                          │
 │   - Smaller, consistent spacing in VStack.           │
 └───────────────────────────────────────────────────────┘
*/

import SwiftUI

struct CravingSlidersSectionView: View {
    @Binding var cravingStrength: Double
    @Binding var resistance: Double
    
    var body: some View {
        VStack(spacing: 16) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Intensity: \(Int(cravingStrength))")
                    .foregroundColor(.white)
                    .font(.headline)
                Slider(value: $cravingStrength, in: 1...10, step: 1)
                    .accentColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Resistance: \(Int(resistance))")
                    .foregroundColor(.white)
                    .font(.headline)
                Slider(value: $resistance, in: 1...10, step: 1)
                    .accentColor(.orange)
            }
        }
        .padding(.vertical, 8)
        .frame(minHeight: 120)
    }
}

