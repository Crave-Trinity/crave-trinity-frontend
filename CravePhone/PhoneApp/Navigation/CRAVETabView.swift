//
//  CRAVETabView.swift
//  CravePhone
//
//  Directory: CravePhone/PhoneApp/Navigation/CRAVETabView.swift
//
//  Description:
//    A TabView that references the AppCoordinator's factory methods to create screens.
//    Demonstrates Inversion of Control: the coordinator handles building each view.
//    This adheres to MVVM + Coordinator pattern for navigation.
//
//  Created by <Your Name> on <date>.
//  Updated by ChatGPT on <today's date>.
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
            
            // If you have an Analytics tab, uncomment below:
            // coordinator.makeAnalyticsView()
            //     .tabItem {
            //         Label("Analytics", systemImage: "chart.bar")
            //     }
        }
    }
}
