
//
//  CRAVETabView.swift
//  CravePhone
//
//  Description:
//    A TabView that references the AppCoordinator's factory methods.
//
//  Created by ...
//  Updated by ChatGPT on ...
//

import SwiftUI

public struct CRAVETabView: View {
    
    @ObservedObject var coordinator: AppCoordinator
    
    public init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        TabView {
            coordinator.makeLogCravingView()
                .tabItem {
                    Label("Log", systemImage: "plus.circle")
                }
            
            coordinator.makeCravingListView()
                .tabItem {
                    Label("Cravings", systemImage: "list.bullet")
                }
            
            // Possibly a 3rd tab for analytics:
            // coordinator.makeAnalyticsView()
            //     .tabItem { Label("Analytics", systemImage: "chart.bar") }
        }
    }
}
