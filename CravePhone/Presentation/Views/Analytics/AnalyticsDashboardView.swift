//
//  AnalyticsDashboardView.swift
//  CravePhone
//
//  PURPOSE:
//    - Display analytics data for multiple time frames (week, month, quarter, year) + tabs (Overview, Trends, Triggers, Insights).
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Analytics UI only.
//    - Dependence on injected ViewModel (AnalyticsViewModel).
//
//  GANG OF FOUR:
//    - Strategy: switching tabs changes content strategy.
//    - Factory: coordinator constructs the VM.
//
//  “DESIGNED FOR STEVE JOBS”:
//    - Clear timeframe menu + tab selector. Minimal friction for user to glean insights.
//

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
        case trends   = "Trends"
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
                        case .overview:
                            Text("Overview Tab Content")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        case .trends:
                            Text("Trends Tab Content")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        case .triggers:
                            Text("Triggers Tab Content")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        case .insights:
                            Text("Insights Tab Content")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
            }
            .padding(.top, 44)
            .padding(.bottom, 34)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        #if swift(>=5.9)
        .onChange(of: selectedTimeFrame, initial: false) { oldVal, newVal in
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        #else
        .onChange(of: selectedTimeFrame) { _ in
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        #endif
    }
    
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
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(AnalyticsTab.allCases) { tab in
                Button {
                    withAnimation { selectedTab = tab }
                    CraveHaptics.shared.selectionChanged()
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
        .background(Color.black.opacity(0.2))
    }
}
