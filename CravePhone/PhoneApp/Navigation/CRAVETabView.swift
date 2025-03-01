//
//  CRAVETabView.swift
//  CravePhone
//
//  A refined TabView with fluid animations, proper scaling,
//  and accessibility improvements. Clean SwiftUI implementation
//  following SOLID principles.
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
            
            // Bottom Tab Bar
            VStack {
                Spacer()
                tabBar
                    .padding(.bottom, 20)
            }
        }
        .background(CraveTheme.Colors.primaryGradient)
        .ignoresSafeArea(edges: .bottom)
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
                            .imageScale(.large)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: selectedTab == tab ? .medium : .regular))
                    }
                    .foregroundColor(selectedTab == tab ? CraveTheme.Colors.accent : Color.gray.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
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

// MARK: - Preview
struct CRAVETabView_Previews: PreviewProvider {
    static var previews: some View {
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container)
        CRAVETabView(coordinator: coordinator)
    }
}
