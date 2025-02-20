//
//  CravingIntensityView.swift
//  CraveWatch
//
//  Description:
//    A minimal watchOS SwiftUI screen with two vertical sliders for "Intensity" and "Resistance."
//    There is NO navigation bar, NO "Done" button, and NO back button.
//    The user can simply swipe horizontally (via your TabView pages) to exit.
//
//  Created by [Your Name] on [Date]
//

import SwiftUI
import WatchKit

struct CravingIntensityView: View {
    // These bindings come from your ViewModel or parent container
    @Binding var intensity: Int
    @Binding var resistance: Int
    
    var body: some View {
        ZStack {
            // 1) Black background covering the entire watch screen
            Color.black.edgesIgnoringSafeArea(.all)
            
            // 2) Vertical sliders side by side
            HStack(spacing: 24) {
                
                // A) Left slider block
                VStack(spacing: 6) {
                    Text("Intensity")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    VerticalIntensityBar(value: $intensity,
                                         barWidth: 4,
                                         barHeight: 90)
                }
                
                // B) Right slider block
                VStack(spacing: 6) {
                    Text("Resistance")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    VerticalIntensityBar(value: $resistance,
                                         barWidth: 4,
                                         barHeight: 90)
                }
            }
        }
        // We do NOT embed this in a NavigationStack,
        // and we do NOT show a toolbar or a "Done" button.
    }
}

