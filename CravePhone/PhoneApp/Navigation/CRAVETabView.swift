//
//  CRAVETabView.swift
//  CravePhone
//
//  Description:
//    A TabView referencing the AppCoordinator's factory methods.
//    Sets the tab bar background to black for a stealthy look.
//
//  Uncle Bob notes:
//    - Single Responsibility: Main tab navigation, delegating view creation to coordinator.
//    - Inversion of Control: The coordinator creates the views.
//

import SwiftUI

public struct CRAVETabView: View {
    
    @ObservedObject var coordinator: AppCoordinator
    
    public init(coordinator: AppCoordinator) {
        // Configure tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        
        UITabBar.appearance().standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
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
        // Optionally force dark mode if you want everything to be black-based:
        // .preferredColorScheme(.dark)
    }
}

