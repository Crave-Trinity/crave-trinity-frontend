//
//  CRAVETabView.swift
//  CravePhone
//
//  PURPOSE:
//   - A production-ready tab view with normal iOS tab styling
//     (removes the bright debug colors).
//
//  "DESIGNED FOR STEVE JOBS":
//   - Clean, minimal friction, respects iOS safe areas.
//
//  LAST UPDATED: <today’s date>
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
        .onAppear {
            // If you want a custom tab bar color, do so here:
            let tabBarAppearance = UITabBarAppearance()
            
            // Example: make it slightly translucent black
            tabBarAppearance.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            tabBarAppearance.backgroundEffect = UIBlurEffect(style: .dark)
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
            // For iOS 15+:
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}
