//
//  AnalyticsDashboardView.swift
//  CravePhone
//
//  Description:
//    A comprehensive analytics dashboard with interactive charts,
//    insights, and time-based filtering, referencing the
//    newly extracted DataPoint and TriggerAnalysis structs.
//

import SwiftUI
import Charts

/// Make it public if you're accessing it from another module.
/// If everything is in the same app target, 'internal' is often enough.
public struct AnalyticsDashboardView: View {
    
    // MARK: - Observed Object
    @ObservedObject public var viewModel: AnalyticsViewModel
    
    // MARK: - State
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedTab: AnalyticsTab = .overview
    
    // MARK: - Init
    // Make the initializer public or internal so AppCoordinator can use it.
    public init(viewModel: AnalyticsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Enums
    public enum TimeFrame: String, CaseIterable, Identifiable {
        case week = "1 Week"
        case month = "1 Month"
        case quarter = "3 Months"
        case year = "1 Year"
        
        public var id: String { self.rawValue }
    }
    
    public enum AnalyticsTab: String, CaseIterable, Identifiable {
        case overview = "Overview"
        case trends = "Trends"
        case triggers = "Triggers"
        case insights = "Insights"
        
        public var id: String { self.rawValue }
    }
    
    // MARK: - Body
    public var body: some View {
        ZStack {
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                tabSelector
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                ScrollView {
                    // We'll show different content depending on selectedTab
                    VStack(spacing: 20) {
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
                }
            }
        }
        .onAppear {
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        // Use the updated onChangeBackport to reload when timeframe changes
        .onChangeBackport(of: selectedTimeFrame) { oldValue, newValue in
            Task { await viewModel.fetchAnalytics(timeFrame: newValue) }
        }
    }
    
    // MARK: - Header
    /// Example subview for the "Analytics Dashboard" title and timeframe menu
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Analytics Dashboard")
                    .font(CraveTheme.Typography.heading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                Spacer()
                
                Menu {
                    ForEach(TimeFrame.allCases) { timeFrame in
                        Button {
                            selectedTimeFrame = timeFrame
                        } label: {
                            HStack {
                                Text(timeFrame.rawValue)
                                if selectedTimeFrame == timeFrame {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedTimeFrame.rawValue)
                            .font(CraveTheme.Typography.body)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(CraveTheme.Colors.primaryText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.3))
                    )
                }
            }
            
            Text("Understand your patterns and gain insights")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(CraveTheme.Colors.primaryGradient)
    }
    
    // MARK: - Tab Selector
    /// A simple horizontal set of buttons to switch between tabs
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
                            .font(.system(size: 14, weight: selectedTab == tab ? .semibold : .regular))
                            .foregroundColor(selectedTab == tab ? CraveTheme.Colors.accent : CraveTheme.Colors.secondaryText)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                        Rectangle()
                            .fill(selectedTab == tab ? CraveTheme.Colors.accent : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color.black.opacity(0.2))
    }
    
    // MARK: - Tab Content
    /// Each of these is a computed property returning `some View`.
    
    private var overviewContent: some View {
        // Provide an actual view. E.g.:
        VStack(spacing: 20) {
            Text("Overview Tab Content")
                .foregroundColor(.white)
            // ...
            // e.g., add your SummaryCards, ChartCards, etc.
        }
    }
    
    private var trendsContent: some View {
        VStack(spacing: 20) {
            Text("Trends Tab Content")
                .foregroundColor(.white)
            // ...
        }
    }
    
    private var triggersContent: some View {
        VStack(spacing: 20) {
            Text("Triggers Tab Content")
                .foregroundColor(.white)
            // ...
        }
    }
    
    private var insightsContent: some View {
        VStack(spacing: 20) {
            Text("Insights Tab Content")
                .foregroundColor(.white)
            // ...
        }
    }
}
