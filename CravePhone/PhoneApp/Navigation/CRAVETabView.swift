
// File: CRAVETabView.swift

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
            
            // 2) Middle tab: Cravings List
            CravingListView(viewModel: container.makeCravingListViewModel())
                .tabItem {
                    Label("Cravings", systemImage: "list.bullet")
                }
                .tag(1)

            // 3) Right-most tab: Analytics
            AnalyticsDashboardView(viewModel: container.makeAnalyticsDashboardViewModel())
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
                .tag(2)
        }
    }
}
