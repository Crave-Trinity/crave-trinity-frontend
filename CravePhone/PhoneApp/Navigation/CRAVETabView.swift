// CRAVETabView.swift
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
            
            coordinator.makeAnalyticsDashboardView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
            
            coordinator.makeChatView()
                .tabItem {
                    Label("AI Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }
        }
        .preferredColorScheme(.dark)
    }
}
