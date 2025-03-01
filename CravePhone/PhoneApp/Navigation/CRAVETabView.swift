//
//  CRAVETabView.swift
//  CravePhone
//
//  Description:
//    A bottom-right anchored, tab-based container for CRAVE Phone App.
//
//  Key Fix:
//    The tab bar is overlaid on top of the main content (in a ZStack/overlay)
//    rather than placed alongside scrollable content. This ensures it
//    remains fixed at the bottom, never scrolling.
//
//  Uncle Bob & GoF Notes:
//    - Single Responsibility: Manage ONLY the tab UI appearance & interactions.
//    - Open/Closed: Add new tabs easily.
//    - Clean Code: Clear separation of concerns (tab bar vs. main content).
//    - Separation of Layers: The content is one layer, tab bar is another.
//    - SwiftUI best practice: Use .overlay() or ZStack with alignment to keep
//      navigation fixed at the bottom.
//
//  Steve Jobs' Ideal:
//    - Matches Apple's native home screen: main area scrolls/swipes, bottom dock
//      (tabs) remains anchored for intuitive user experience.
//

import SwiftUI

public struct CRAVETabView: View {
    
    @ObservedObject var coordinator: AppCoordinator
    @State private var selectedTab: Tab = .log
    
    enum Tab: String, CaseIterable {
        case log = "Log"
        case cravings = "Cravings"
        case analytics = "Analytics"
        case aiChat = "AI Chat"
    }
    
    public init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationView {
            // MAIN CONTENT LAYER
            ZStack {
                // Switch among the four main screens
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
            // TAB BAR OVERLAY
            .overlay(
                tabBar
                    .padding(.bottom, 20)
                    .padding(.trailing, 15),
                alignment: .bottomTrailing
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        // If you prefer the old “StackNavigationViewStyle”, keep it:
        .navigationViewStyle(StackNavigationViewStyle())
        // (Optional) .preferredColorScheme(.dark) if you want forced dark mode
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
    
    // MARK: - Custom “Tab Bar” Overlaid at the Bottom-Right
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
        case .log: return "plus.circle"
        case .cravings: return "list.bullet"
        case .analytics: return "chart.bar"
        case .aiChat: return "bubble.left.and.bubble.right.fill"
        }
    }
}
