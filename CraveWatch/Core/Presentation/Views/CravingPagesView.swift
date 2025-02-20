//
//  CravingPagesView.swift
//  CraveWatch
//
//  Description:
//    A TabView with PageTabViewStyle that shows two pages side by side:
//      1) CravingLogView (for text-based logging)
//      2) CravingIntensityView (for adjusting intensity/resistance)
//
//  Usage:
//    1. Provide a WatchConnectivityService and SwiftData model container
//       in your @main app or Scene.
//    2. Initialize CravingLogViewModel and pass it here if desired,
//       or create it inside this view.
//
//  Created by [Your Name] on [Date]
//

import SwiftUI
import SwiftData

struct CravingPagesView: View {
    @Environment(\.modelContext) private var context
    
    // Provide connectivity from outside
    @ObservedObject var connectivityService: WatchConnectivityService
    
    // Create or inject the CravingLogViewModel
    @StateObject private var viewModel: CravingLogViewModel
    
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
        _viewModel = StateObject(wrappedValue: CravingLogViewModel(connectivityService: connectivityService))
    }
    
    var body: some View {
        TabView {
            // PAGE 1: CravingLogView
            CravingLogView(viewModel: viewModel)
                .tag(0)
            
            // PAGE 2: CravingIntensityView
            CravingIntensityView(intensity: $viewModel.intensity, resistance: .constant(5))
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}
