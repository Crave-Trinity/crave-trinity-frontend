//
//  CRAVETabView.swift
//  CravePhone
//
//  A bottom-right anchored custom tab view
//  pinned with an overlay, never scrolling.
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
    }
    
    public init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationView {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .overlay(
                tabBar
                    .padding(.bottom, 20)
                    .padding(.trailing, 15),
                alignment: .bottomTrailing
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
    
    private var tabBar: some View {
        HStack(spacing: 20) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: iconName(for: tab))
                            .font(.title2)
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .foregroundColor(selectedTab == tab ? .accentColor : .gray)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.9))
                .shadow(color: .black.opacity(0.5), radius: 6)
        )
    }
    
    private func iconName(for tab: Tab) -> String {
        switch tab {
        case .log:       return "plus.circle"
        case .cravings:  return "list.bullet"
        case .analytics: return "chart.bar"
        case .aiChat:    return "bubble.left.and.bubble.right.fill"
        }
    }
}
