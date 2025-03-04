//
//  AnalyticsDashboardView+TimeFrameConversion.swift
//  CravePhone
//
//  Description:
//   Extension to convert the dashboard view’s TimeFrame to the manager’s TimeFrame.
//   (Uncle Bob: Keep conversion logic centralized.)
//

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
