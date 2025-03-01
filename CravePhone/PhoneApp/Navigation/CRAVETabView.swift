
// FILE: CRAVETabView.swift
// DESCRIPTION:
//  - Full-screen TabView with safe area adjustments.
//  - Custom tab bar pinned at bottom.

import SwiftUI

public struct CRAVETabView: View {
    
    @ObservedObject var coordinator: AppCoordinator
    @State private var selectedTab: Tab = .log
    
    enum Tab: String, CaseIterable {
        case log       = "Log"
        case cravings  = "Cravings"
        case analytics = "Analytics"
        case aiChat    = "AI Chat"
    }
    
    public init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .log:
                    coordinator.makeLogCravingView()
                case .cravings:
                    coordinator.makeCravingListView()
                case .analytics:
                    coordinator.makeAnalyticsDashboardView()
                case .aiChat:
                    coordinator.makeChatView()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom bottom bar pinned at bottom
            VStack(spacing: 0) {
                Spacer()
                tabBar
                    .padding(.bottom, 20)
            }
        }
        // Full-screen background + safe area usage
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CraveTheme.Colors.primaryGradient)
        .ignoresSafeArea(edges: .all)
        .preferredColorScheme(.dark)
    }
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(CraveTheme.Animations.snappy) {
                        selectedTab = tab
                        CraveHaptics.shared.selectionChanged()
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: iconName(for: tab))
                            .font(.system(size: 22, weight: selectedTab == tab ? .semibold : .regular))
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: selectedTab == tab ? .medium : .regular))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(selectedTab == tab ? CraveTheme.Colors.accent : Color.gray.opacity(0.8))
                }
                .accessibilityLabel("\(tab.rawValue) Tab")
            }
        }
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.85))
                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 3)
        )
        .padding(.horizontal, 16)
    }
    
    private func iconName(for tab: Tab) -> String {
        switch tab {
        case .log:       return "plus.circle.fill"
        case .cravings:  return "list.bullet"
        case .analytics: return "chart.bar.fill"
        case .aiChat:    return "bubble.left.and.bubble.right.fill"
        }
    }
}
