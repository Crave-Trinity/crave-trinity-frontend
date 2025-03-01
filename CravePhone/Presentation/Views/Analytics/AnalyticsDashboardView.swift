// ---------------------------------------------------
// FILE: AnalyticsDashboardView.swift
// DESCRIPTION:
// 1) Shows analytics data over various time frames (week, month, quarter, year).
// 2) Demonstrates SOLID & Clean Architecture best practices:
//    - Single Responsibility: This View is only responsible for presenting analytics UI.
//    - Open/Closed: Additional tabs or time frames can be extended without modifying existing code structure.
//    - Liskov Substitution: The ViewModel is an AnalyticsViewModel, but a protocol-based VM could substitute seamlessly.
//    - Interface Segregation: This View depends only on the ViewModel’s analytics calls, not other domain concerns.
//    - Dependency Inversion: The ViewModel is injected from outside (AppCoordinator/Container).
//
// 3) Applies a few "Gang of Four" patterns lightly:
//    - Factory (in the coordinator) for instantiating the correct ViewModel.
//    - Strategy (through different tabs) to display different analytics content.
//
// 4) "Designing for Steve Jobs" means minimal UI friction, direct metaphors, intuitive navigation, and fluid transitions.
//    - The user can easily pick a timeframe, select a tab, and see all relevant data with minimal clutter.
//
// 5) This code is consistent with the rest of the app’s gradient background + .frame usage for full-screen coverage
//    while using safe-area best practices.
//
// LAST UPDATED: 2025-03-01
// ---------------------------------------------------

import SwiftUI
import Charts

public struct AnalyticsDashboardView: View {
    
    // MARK: - Clean Architecture: Dependencies injected from outside
    @ObservedObject public var viewModel: AnalyticsViewModel
    
    // MARK: - Local State
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedTab: AnalyticsTab = .overview
    
    // MARK: - Init
    // The VM is provided externally, fulfilling Dependency Inversion
    public init(viewModel: AnalyticsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - TimeFrame + AnalyticsTab
    // Each `enum` is minimal, fulfilling Single Responsibility: describing a user-chosen range or tab
    public enum TimeFrame: String, CaseIterable, Identifiable {
        case week = "1 Week"
        case month = "1 Month"
        case quarter = "3 Months"
        case year = "1 Year"
        
        public var id: String { rawValue }
    }
    
    public enum AnalyticsTab: String, CaseIterable, Identifiable {
        case overview = "Overview"
        case trends   = "Trends"
        case triggers = "Triggers"
        case insights = "Insights"
        
        public var id: String { rawValue }
    }
    
    // MARK: - Body
    public var body: some View {
        ZStack {
            // Full-screen gradient background
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea() // Only the background truly needs to fill screen edges
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Tab-like selection (Strategy pattern for each tab content)
                tabSelector
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Tab content area
                ScrollView {
                    VStack(spacing: 20) {
                        // Switch among the different strategies (tabs)
                        switch selectedTab {
                        case .overview:
                            overviewContent
                        case .trends:
                            trendsContent
                        case .triggers:
                            triggersContent
                        case .insights:
                            insightsContent
                        }
                    }
                    .padding()
                    // Let the main container fill available space
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Start with the default timeframe’s analytics data
        .onAppear {
            Task {
                await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame)
            }
        }
        // Swift 5.9+ Deprecation-safe .onChange
        #if swift(>=5.9)
        .onChange(of: selectedTimeFrame, initial: false) {
            // No oldValue/newValue needed for simple triggers
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        #else
        // Fallback for older iOS
        .onChange(of: selectedTimeFrame) { _ in
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        #endif
    }
    
    // MARK: - Header
    // Summaries and timeframe picker
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Analytics Dashboard")
                    .font(CraveTheme.Typography.heading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                Spacer()
                
                // Timeframe dropdown
                Menu {
                    ForEach(TimeFrame.allCases) { frame in
                        Button(frame.rawValue) {
                            selectedTimeFrame = frame
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedTimeFrame.rawValue)
                            .font(CraveTheme.Typography.body)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.3))
                    )
                    .foregroundColor(.white)
                }
            }
            
            Text("Understand your patterns and gain insights")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        // Keep the header background consistent with the top-level gradient
        .background(CraveTheme.Colors.primaryGradient)
    }
    
    // MARK: - Tab Selector
    // Horizontal row of 4 tabs: Overview, Trends, Triggers, Insights
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(AnalyticsTab.allCases) { tab in
                Button {
                    withAnimation {
                        selectedTab = tab
                        CraveHaptics.shared.selectionChanged()
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text(tab.rawValue)
                            .font(
                                .system(
                                    size: 14,
                                    weight: selectedTab == tab ? .semibold : .regular
                                )
                            )
                            .foregroundColor(
                                selectedTab == tab
                                ? CraveTheme.Colors.accent
                                : CraveTheme.Colors.secondaryText
                            )
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                        
                        Rectangle()
                            .fill(
                                selectedTab == tab
                                ? CraveTheme.Colors.accent
                                : Color.clear
                            )
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        // Light overlay behind the tab labels
        .background(Color.black.opacity(0.2))
    }
    
    // MARK: - Tab Content (Overview, Trends, Triggers, Insights)
    // Each subview is minimal and can be expanded
    private var overviewContent: some View {
        VStack(spacing: 20) {
            Text("Overview Tab Content")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            // Additional Overview charts or summaries can go here
        }
    }
    
    private var trendsContent: some View {
        VStack(spacing: 20) {
            Text("Trends Tab Content")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            // Insert Chart views from Swift Charts if needed
        }
    }
    
    private var triggersContent: some View {
        VStack(spacing: 20) {
            Text("Triggers Tab Content")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            // Possibly show top triggers or a bar chart
        }
    }
    
    private var insightsContent: some View {
        VStack(spacing: 20) {
            Text("Insights Tab Content")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            // Provide actionable feedback or patterns discovered
        }
    }
}
