//
//  CRAVETabView.swift
//  CravePhone
//
//  - Houses the TabView for Log, Cravings, Analytics, AI Chat.
//  - Respects safe area by default (tab bar sits above home indicator).
//

import SwiftUI

public struct CRAVETabView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var selectedTab: Tab = .log
    
    enum Tab: String, CaseIterable {
        case log       = "Log"
        case cravings  = "Cravings"
        case analytics = "Analytics"
        case aiChat    = "AI Chat"
        
        var iconName: String {
            switch self {
            case .log:       return "plus.circle.fill"
            case .cravings:  return "list.bullet"
            case .analytics: return "chart.bar.fill"
            case .aiChat:    return "bubble.left.and.bubble.right.fill"
            }
        }
    }
    
    public init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            coordinator.makeLogCravingView()
                .tag(Tab.log)
                .tabItem {
                    Image(systemName: Tab.log.iconName)
                    Text(Tab.log.rawValue)
                }
            
            coordinator.makeCravingListView()
                .tag(Tab.cravings)
                .tabItem {
                    Image(systemName: Tab.cravings.iconName)
                    Text(Tab.cravings.rawValue)
                }
            
            coordinator.makeAnalyticsDashboardView()
                .tag(Tab.analytics)
                .tabItem {
                    Image(systemName: Tab.analytics.iconName)
                    Text(Tab.analytics.rawValue)
                }
            
            coordinator.makeChatView()
                .tag(Tab.aiChat)
                .tabItem {
                    Image(systemName: Tab.aiChat.iconName)
                    Text(Tab.aiChat.rawValue)
                }
        }
        .accentColor(CraveTheme.Colors.accent)
    }
}
