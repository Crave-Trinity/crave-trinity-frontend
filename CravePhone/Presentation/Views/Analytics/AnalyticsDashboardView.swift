//
//  AnalyticsDashboardView.swift
//  CravePhone
//
//  A comprehensive analytics dashboard with interactive charts,
//  insights, and time-based filtering.
//

import SwiftUI
import Charts

struct AnalyticsDashboardView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedTab: AnalyticsTab = .overview
    
    enum TimeFrame: String, CaseIterable, Identifiable {
        case week = "1 Week"
        case month = "1 Month"
        case quarter = "3 Months"
        case year = "1 Year"
        
        var id: String { self.rawValue }
    }
    
    enum AnalyticsTab: String, CaseIterable, Identifiable {
        case overview = "Overview"
        case trends = "Trends"
        case triggers = "Triggers"
        case insights = "Insights"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
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
                }
            }
        }
        .onAppear {
            Task { await viewModel.fetchAnalytics(timeFrame: selectedTimeFrame) }
        }
        .onChange(of: selectedTimeFrame) { newValue in
            Task { await viewModel.fetchAnalytics(timeFrame: newValue) }
        }
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
    
    private var tabSelector: some View {
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
    }
    
    // MARK: - Tab Content
    
    private var overviewContent: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                SummaryCard(title: "Total Cravings", value: "\(viewModel.totalCravings)", icon: "list.bullet", color: .blue)
                SummaryCard(title: "Avg. Intensity", value: String(format: "%.1f", viewModel.averageIntensity), icon: "flame.fill", color: .orange)
            }
            
            HStack(spacing: 12) {
                SummaryCard(title: "Avg. Resistance", value: String(format: "%.1f", viewModel.averageResistance), icon: "shield.fill", color: .green)
                SummaryCard(title: "Success Rate", value: "\(Int(viewModel.successRate))%", icon: "checkmark.circle.fill", color: .purple)
            }
            
            ChartCard(title: "Cravings by Day") {
                LineChartView(data: viewModel.weeklyData, title: "Intensity")
            }
            ChartCard(title: "Time Distribution") {
                BarChartView(data: viewModel.hourlyData, title: "Count")
            }
            InsightsCard(title: "Recent Insights", insights: viewModel.recentInsights)
        }
    }
    
    private var trendsContent: some View {
        VStack(spacing: 20) {
            ChartCard(title: "Intensity Over Time") {
                LineChartView(data: viewModel.intensityTrend, title: "Intensity")
            }
            ChartCard(title: "Resistance Over Time") {
                LineChartView(data: viewModel.resistanceTrend, title: "Resistance")
            }
            ChartCard(title: "Weekly Patterns") {
                HeatMapView(data: viewModel.weekdayHourHeatmap)
            }
            ChartCard(title: "Monthly Trends") {
                BarChartView(data: viewModel.monthlyTrend, title: "Count")
            }
        }
    }
    
    private var triggersContent: some View {
        VStack(spacing: 20) {
            ChartCard(title: "Top Triggers") {
                HorizontalBarChartView(data: viewModel.topTriggers)
            }
            ChartCard(title: "Emotional States") {
                PieChartView(data: viewModel.emotionDistribution)
            }
            ChartCard(title: "Trigger by Time of Day") {
                GroupedBarChartView(data: viewModel.triggersByTimeOfDay)
            }
            Text("Trigger Analysis")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            ForEach(viewModel.triggerAnalysis, id: \.trigger) { analysis in
                TriggerAnalysisRow(analysis: analysis)
            }
        }
    }
    
    private var insightsContent: some View {
        VStack(spacing: 20) {
            InsightsCard(title: "Key Insights", insights: viewModel.keyInsights)
            PredictionCard(title: "Craving Prediction", prediction: viewModel.cravingPrediction)
            PatternCard(title: "Detected Patterns", patterns: viewModel.detectedPatterns)
            RecommendationsCard(title: "Recommendations", recommendations: viewModel.recommendations)
        }
    }
    
    // MARK: - Helper Views
    
    struct SummaryCard: View {
        let title: String
        let value: String
        let icon: String
        let color: Color
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 16))
                    Text(title)
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(CraveTheme.Colors.primaryText)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    struct ChartCard<Content: View>: View {
        let title: String
        let content: Content
        init(title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                content
                    .frame(height: 200)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    struct InsightsCard: View {
        let title: String
        let insights: [String]
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                if insights.isEmpty {
                    Text("No insights available for this period")
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(insights, id: \.self) { insight in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 16))
                            Text(insight)
                                .font(CraveTheme.Typography.body)
                                .foregroundColor(CraveTheme.Colors.primaryText)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    struct PredictionCard: View {
        let title: String
        let prediction: String
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(CraveTheme.Colors.accent)
                        .font(.system(size: 24))
                    Text(prediction)
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(CraveTheme.Colors.primaryText)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(CraveTheme.Colors.accent.opacity(0.1))
                )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    struct PatternCard: View {
        let title: String
        let patterns: [String]
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                if patterns.isEmpty {
                    Text("No patterns detected yet")
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(patterns, id: \.self) { pattern in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "repeat")
                                .foregroundColor(.blue)
                                .font(.system(size: 16))
                            Text(pattern)
                                .font(CraveTheme.Typography.body)
                                .foregroundColor(CraveTheme.Colors.primaryText)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    struct RecommendationsCard: View {
        let title: String
        let recommendations: [String]
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(CraveTheme.Typography.subheading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                if recommendations.isEmpty {
                    Text("No recommendations available yet")
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(recommendations, id: \.self) { recommendation in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                            Text(recommendation)
                                .font(CraveTheme.Typography.body)
                                .foregroundColor(CraveTheme.Colors.primaryText)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    struct TriggerAnalysisRow: View {
        let analysis: TriggerAnalysis
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(analysis.trigger)
                    .font(CraveTheme.Typography.body.weight(.semibold))
                    .foregroundColor(CraveTheme.Colors.primaryText)
                HStack {
                    Text("Avg. Intensity:")
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Text(String(format: "%.1f", analysis.averageIntensity))
                        .font(CraveTheme.Typography.body.weight(.medium))
                        .foregroundColor(CraveTheme.Colors.primaryText)
                    Spacer()
                    Text("Frequency:")
                        .font(CraveTheme.Typography.body)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Text("\(analysis.frequency)x")
                        .font(CraveTheme.Typography.body.weight(.medium))
                        .foregroundColor(CraveTheme.Colors.primaryText)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    // MARK: - Chart Placeholders
    
    struct LineChartView: View {
        let data: [DataPoint]
        let title: String
        var body: some View {
            ZStack {
                VStack {
                    Text("Line Chart")
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Text("\(data.count) data points")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
    }
    
    struct BarChartView: View {
        let data: [DataPoint]
        let title: String
        var body: some View {
            ZStack {
                VStack {
                    Text("Bar Chart")
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Text("\(data.count) data points")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
    }
    
    struct PieChartView: View {
        let data: [DataPoint]
        var body: some View {
            ZStack {
                VStack {
                    Text("Pie Chart")
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Text("\(data.count) data points")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
    }
    
    struct HeatMapView: View {
        let data: [[Double]]
        var body: some View {
            ZStack {
                VStack {
                    Text("Heat Map")
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Text("\(data.count) rows of data")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
    }
    
    struct HorizontalBarChartView: View {
        let data: [DataPoint]
        var body: some View {
            ZStack {
                VStack {
                    Text("Horizontal Bar Chart")
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Text("\(data.count) data points")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
    }
    
    struct GroupedBarChartView: View {
        let data: [[DataPoint]]
        var body: some View {
            ZStack {
                VStack {
                    Text("Grouped Bar Chart")
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                    Text("\(data.count) groups")
                        .font(.caption)
                        .foregroundColor(CraveTheme.Colors.secondaryText)
                }
            }
        }
    }
}

// MARK: - Supporting Types

struct DataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
}

struct TriggerAnalysis: Identifiable {
    let id = UUID()
    let trigger: String
    let averageIntensity: Double
    let frequency: Int
}

// MARK: - Preview

struct AnalyticsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AnalyticsViewModel(manager: createMockManager())
        return AnalyticsDashboardView(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
    
    static func createMockManager() -> AnalyticsManager {
        AnalyticsManager(
            repository: MockAnalyticsRepository(),
            aggregator: MockAnalyticsAggregator(),
            patternDetection: MockPatternDetectionService()
        )
    }
}
