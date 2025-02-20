//
//  CRAVETabView.swift
//  CravePhone
//
//  Description:
//    The main tab view for the phone app, showing Log, Cravings, and Analytics.
//

import SwiftUI

struct CRAVETabView: View {
    @EnvironmentObject private var container: DependencyContainer
    @StateObject private var coordinator: AppCoordinator

    init(container: DependencyContainer) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            
            // 1) Left-most tab: Log Craving
            LogCravingView(viewModel: container.makeLogCravingViewModel())
                .tabItem {
                    Label("Log", systemImage: "plus.circle")
                }
                .tag(0)
            
            // 2) Middle tab: Cravings List (stub or real)
            // Replace with actual CravingListView code if you want it to compile
            Text("Cravings List View")
                .tabItem {
                    Label("Cravings", systemImage: "list.bullet")
                }
                .tag(1)

            // 3) Right-most tab: Analytics (stub or real)
            // Replace with actual AnalyticsDashboardView code if you want it to compile
            Text("Analytics Dashboard View")
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
                .tag(2)
        }
    }
}
