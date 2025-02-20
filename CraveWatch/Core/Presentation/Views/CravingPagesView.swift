//
//  CravingPagesView.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description:
//    A TabView that lets the user horizontally swipe between the craving logging screen
//    and the intensity/resistance adjustment screen. Dots indicate the pages.
//
//  Usage:
//    Set CravingPagesView as the root view in your WatchApp.
import SwiftUI
import SwiftData

struct CravingPagesView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var connectivityService: WatchConnectivityService
    
    // Create the shared ViewModel that handles logging.
    @StateObject private var viewModel: CravingLogViewModel
    
    init(connectivityService: WatchConnectivityService) {
        self.connectivityService = connectivityService
        _viewModel = StateObject(wrappedValue: CravingLogViewModel(connectivityService: connectivityService))
    }
    
    var body: some View {
        TabView {
            // Page 1: Log Craving screen
            CravingLogView(viewModel: viewModel)
                .tag(0)
            
            // Page 2: Intensity/Resistance screen
            CravingIntensityView(intensity: $viewModel.intensity, resistance: $viewModel.resistance)
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

