//==============================================================
//  File F: CravingIntensityView.swift
//  Description:
//    A watchOS SwiftUI screen for adjusting two values, "Intensity"
//    and "Resistance," each with a vertical slider. The user can
//    tap "Done" to dismiss.
//
//  Usage:
//    - This is navigated to from CravingLogView if showAdjustScreen == true.
//    - Binds to @State ints in the parent, so changes persist.
//
//==============================================================

import SwiftUI
import WatchKit

struct CravingIntensityView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Bound properties from CravingLogView
    @Binding var intensity: Int
    @Binding var resistance: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1) Black background
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                // 2) Basic watch layout constants
                let watchWidth = WKInterfaceDevice.current().screenBounds.width
                let contentWidth = watchWidth * 0.80
                let sliderHeight: CGFloat = 90
                let buttonHeight: CGFloat = 28
                
                VStack(spacing: 10) {
                    
                    // A) Two vertical sliders side by side
                    HStack(spacing: 24) {
                        
                        // Left slider block
                        VStack(spacing: 6) {
                            Text("Intensity")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            VerticalIntensityBar(value: $intensity,
                                                 barWidth: 4,
                                                 barHeight: sliderHeight)
                        }
                        
                        // Right slider block
                        VStack(spacing: 6) {
                            Text("Resistance")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            VerticalIntensityBar(value: $resistance,
                                                 barWidth: 4,
                                                 barHeight: sliderHeight)
                        }
                    }
                    
                    // B) Done button to dismiss
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: contentWidth, height: buttonHeight)
                            .background(premiumBlueGradient)
                            .cornerRadius(6)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 2)
                }
                .padding(.top, 4)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            // C) Smaller custom back button top-left
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        ZStack {
                            premiumBlueGradient
                                .frame(width: 24, height: 24)
                                .cornerRadius(4)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                            
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 8, height: 12)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Shared gradient for the Done button
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        // Tweak to your brand colors if desired
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7), // top
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)  // bottom
    ]),
    startPoint: .top,
    endPoint: .bottom
)

