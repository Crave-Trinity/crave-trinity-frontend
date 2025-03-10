//
//  AnalyticsDashboardView.swift
//  CravePhone
//
//  FINAL FIX:
//  Displays real analytics from AnalyticsViewModel and updates when the selected time frame changes.
//  (Uncle Bob & Steve Jobs: Clean UI code with reactive updates.)
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
            CraveTheme.Colors.primaryGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with title and time frame menu.
                VStack(spacing: 8) {
                    HStack {
                        Text("📊 Analytics")
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
                                Image(systemName: "chevron.down")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.3)))
                            .foregroundColor(.white)
                        }
                    }
                    Text("Find patterns and gain insights")
                        .font(CraveTheme.Typography.subheading)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(CraveTheme.Colors.primaryGradient)
                
                // Tab selector.
                HStack(spacing: 0) {
                    ForEach(AnalyticsTab.allCases) { tab in
                        Button {
                            withAnimation { selectedTab = tab }
                            CraveHaptics.shared.selectionChanged()
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
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Main content area.
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case .overview:
                            overviewTab
                        case .trends:
                            trendsTab
                        case .triggers:
                            triggersTab
                        case .insights:
                            insightsTab
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame.toAnalyticsManagerTimeFrame) }
        }
        .onChange(of: selectedTimeFrame, initial: true) { _, newValue in
            Task { await viewModel.fetchAnalytics(timeFrame: newValue.toAnalyticsManagerTimeFrame) }
        }
    }
    
    // MARK: - Tab Content Views
    
    private var overviewTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Total Cravings: \(viewModel.totalCravings)").foregroundColor(.white)
            Text("Avg Intensity: \(String(format: "%.1f", viewModel.averageIntensity))").foregroundColor(.white)
            Text("Avg Resistance: \(String(format: "%.1f", viewModel.averageResistance))").foregroundColor(.white)
            Text("Success Rate: \(String(format: "%.1f", viewModel.successRate))%").foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var trendsTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cravings by Date: \(viewModel.cravingsByDate.count) unique days").foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var triggersTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detected Patterns: \(viewModel.detectedPatterns.isEmpty ? "None" : viewModel.detectedPatterns.joined(separator: ", "))")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var insightsTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights Tab Content - Add your logic here!")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
