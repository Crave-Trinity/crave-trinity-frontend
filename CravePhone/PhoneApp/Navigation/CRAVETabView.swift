//=========================================
//  CRAVETabView.swift
//  CravePhone
//
//  PURPOSE:
//    - Houses the main TabView for Log, Cravings, Analytics, AI Chat.
//    - Entire screen ignores safe areas + keyboard edges.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Provide tabbed navigation.
//
//  "DESIGNED FOR STEVE JOBS":
//    - Minimal friction, default tab bar at physical bottom.
//
//  LAST UPDATED: <today's date>
//=========================================
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
        ZStack {
            // Full-bleed gradient + keyboard safe-area fix
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea(.all)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
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
}
