//
//  CravingIntensityView.swift
//  CraveWatch
//

import SwiftUI
import WatchKit

struct CravingIntensityView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var intensity: Int
    @Binding var resistance: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                let watchWidth = WKInterfaceDevice.current().screenBounds.width
                let contentWidth = watchWidth * 0.80
                let sliderHeight: CGFloat = 90
                let buttonHeight: CGFloat = 28
                
                VStack(spacing: 10) {
                    // Two sliders side by side
                    HStack(spacing: 24) {
                        VStack(spacing: 6) {
                            Text("Intensity")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            VerticalIntensityBar(value: $intensity, barWidth: 4, barHeight: sliderHeight)
                        }
                        
                        VStack(spacing: 6) {
                            Text("Resistance")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            VerticalIntensityBar(value: $resistance, barWidth: 4, barHeight: sliderHeight)
                        }
                    }
                    
                    // “Done” button with same 2-stop “premium” gradient
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
            // Smaller custom back button top-left
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

// Reuse the same gradient
fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7), // top
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)  // bottom
    ]),
    startPoint: .top,
    endPoint: .bottom
)
