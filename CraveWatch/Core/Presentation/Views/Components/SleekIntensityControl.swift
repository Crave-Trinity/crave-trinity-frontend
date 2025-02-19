//
//  SleekIntensityControl.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A custom watch component to adjust intensity (e.g., 1–10) with a simple UI.
//

import SwiftUI

struct SleekIntensityControl: View {
    @Binding var intensity: Int
    var showButtons: Bool = true
    
    var body: some View {
        HStack {
            if showButtons {
                Button("-") {
                    if intensity > 1 { intensity -= 1 }
                }
                .buttonStyle(.borderedProminent)
            }
            
            Text("Intensity: \(intensity)")
                .font(.headline)
            
            if showButtons {
                Button("+") {
                    if intensity < 10 { intensity += 1 }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
