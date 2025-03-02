//
//  CRAVETabView_Debug.swift
//  CravePhone
//
//  PURPOSE:
//    - A debug-friendly CRAVETabView that uses color-coded backgrounds
//      to spot any “empty space” or default tab bar spacing.
//
//  HOW TO USE:
//    1. Rename this file back to "CRAVETabView.swift" (or temporarily replace your existing one).
//    2. Run the app.
//    3. Observe the color-coded layout to see which region is truly blank.
//
//  “DESIGNED FOR STEVE JOBS” (debug mode!):
//    - Minimal friction, but bright colors to reveal layout bounds.
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
        ZStack {
            // Color #1: Full-bleed background behind everything
            // Make it BRIGHT so you can see if any region is just “background”
            Color.yellow
                .ignoresSafeArea(.all)
                .opacity(0.3)  // reduce alpha if it’s too intense
            
            TabView(selection: $selectedTab) {
                
                // TAB #1 - LOG
                coordinator.makeLogCravingView()
                    // Debug background color #2 for the entire log view
                    .background(Color.green.opacity(0.4))
                    .tag(Tab.log)
                    .tabItem {
                        Image(systemName: Tab.log.iconName)
                        Text(Tab.log.rawValue)
                    }
                
                // TAB #2 - CRAVINGS LIST
                coordinator.makeCravingListView()
                    .background(Color.blue.opacity(0.4))
                    .tag(Tab.cravings)
                    .tabItem {
                        Image(systemName: Tab.cravings.iconName)
                        Text(Tab.cravings.rawValue)
                    }
                
                // TAB #3 - ANALYTICS
                coordinator.makeAnalyticsDashboardView()
                    .background(Color.red.opacity(0.4))
                    .tag(Tab.analytics)
                    .tabItem {
                        Image(systemName: Tab.analytics.iconName)
                        Text(Tab.analytics.rawValue)
                    }
                
                // TAB #4 - AI CHAT
                coordinator.makeChatView()
                    .background(Color.orange.opacity(0.4))
                    .tag(Tab.aiChat)
                    .tabItem {
                        Image(systemName: Tab.aiChat.iconName)
                        Text(Tab.aiChat.rawValue)
                    }
            }
            // Color #3: a background behind the tab bar itself
            // so you can tell if the tab bar region is black, translucent, etc.
            .background(Color.purple.opacity(0.5))
            .onAppear {
                // Force the UITabBar to a bright color so you can see its area
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.backgroundColor = UIColor.magenta.withAlphaComponent(0.4)
                
                // You can also try making it translucent or not
                tabBarAppearance.backgroundEffect = nil
                UITabBar.appearance().standardAppearance = tabBarAppearance
                
                // If you’re on iOS 15+, also set the scrollEdgeAppearance
                if #available(iOS 15.0, *) {
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                }
            }
        }
    }
}
