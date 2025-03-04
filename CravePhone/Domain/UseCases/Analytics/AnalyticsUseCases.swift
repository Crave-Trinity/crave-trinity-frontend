//
//  AnalyticsUseCases.swift
//  CravePhone
//
//  Baby mode: This version requires a time frame parameter
//  so we call getBasicStats(for:) with a chosen time frame.
//  This final fix maps the AnalyticsDashboardView.TimeFrame to
//  AnalyticsManager.TimeFrame to eliminate ambiguity.

import Foundation

// Use our unified result type.
public protocol GetBasicAnalyticsUseCaseProtocol {
    func execute(timeFrame: AnalyticsDashboardView.TimeFrame) async throws -> BasicAnalyticsResult
}

public final class GetBasicAnalyticsUseCase: GetBasicAnalyticsUseCaseProtocol {
    private let analyticsManager: AnalyticsManager

    public init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    public func execute(timeFrame: AnalyticsDashboardView.TimeFrame) async throws -> BasicAnalyticsResult {
        // Map the view's time frame to the manager's time frame.
        let managerTimeFrame: AnalyticsManager.TimeFrame
        switch timeFrame {
        case .week:
            managerTimeFrame = .week
        case .month:
            managerTimeFrame = .month
        case .quarter:
            managerTimeFrame = .quarter
        case .year:
            managerTimeFrame = .year
        }
        // Call the AnalyticsManager using the converted time frame.
        return try await analyticsManager.getBasicStats(for: managerTimeFrame)
    }
}
