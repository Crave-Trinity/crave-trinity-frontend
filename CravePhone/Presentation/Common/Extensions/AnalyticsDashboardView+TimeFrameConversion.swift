// AnalyticsDashboardView+TimeFrameConversion.swift
// Converts the dashboard view’s TimeFrame to AnalyticsManager.TimeFrame.
import Foundation

extension AnalyticsDashboardView.TimeFrame {
    var toAnalyticsManagerTimeFrame: AnalyticsManager.TimeFrame {
        switch self {
        case .week: return .week
        case .month: return .month
        case .quarter: return .quarter
        case .year: return .year
        }
    }
}
