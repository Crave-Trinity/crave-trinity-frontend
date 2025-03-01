
// ---------------------------------------------------
// FILE: AnalyticsDashboardView.swift
// DESCRIPTION: Single, unique definition (no duplicates).
// ---------------------------------------------------

import SwiftUI
import Charts

public struct AnalyticsDashboardView: View {
    
    @ObservedObject public var viewModel: AnalyticsViewModel
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedTab: AnalyticsTab = .overview
    
    public init(viewModel: AnalyticsViewModel) {
        self.viewModel = viewModel
    }
    
    public enum TimeFrame: String, CaseIterable, Identifiable {
        case week = "1 Week"
        case month = "1 Month"
        case quarter = "3 Months"
        case year = "1 Year"
        
        public var id: String { rawValue }
    }
    
    public enum AnalyticsTab: String, CaseIterable, Identifiable {
        case overview = "Overview"
        case trends = "Trends"
        case triggers = "Triggers"
        case insights = "Insights"
        
        public var id: String { rawValue }
    }
    
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
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case .overview:  overviewContent
                        case .trends:    trendsContent
                        case .triggers:  triggersContent
                        case .insights:  insightsContent
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            Task {
                await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame)
            }
        }
        #if swift(>=5.9)
        .onChange(of: selectedTimeFrame, initial: false) {
            // Zero-parameter closure for iOS 17+
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        #else
        .onChange(of: selectedTimeFrame) { _ in
            // Old signature for iOS <17
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        #endif
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Analytics Dashboard")
                    .font(CraveTheme.Typography.heading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                Spacer()
                
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
        .background(CraveTheme.Colors.primaryGradient)
    }
    
    // MARK: - Tab Selector
    
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
        .background(Color.black.opacity(0.2))
    }
    
    // MARK: - Tab Content
    
    private var overviewContent: some View {
        VStack(spacing: 20) {
            Text("Overview Tab Content")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var trendsContent: some View {
        VStack(spacing: 20) {
            Text("Trends Tab Content")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var triggersContent: some View {
        VStack(spacing: 20) {
            Text("Triggers Tab Content")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var insightsContent: some View {
        VStack(spacing: 20) {
            Text("Insights Tab Content")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
}
