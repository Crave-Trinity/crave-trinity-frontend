//
//  AnalyticsUseCases.swift
//  CravePhone
//
//  Baby mode: This version requires a time frame parameter
//  so we call getBasicStats(for:) with a chosen time frame.
//

import Foundation

public protocol GetBasicAnalyticsUseCaseProtocol {
    func execute(timeFrame: AnalyticsDashboardView.TimeFrame) async throws -> BasicAnalyticsResult
}

public final class GetBasicAnalyticsUseCase: GetBasicAnalyticsUseCaseProtocol {
    private let analyticsManager: AnalyticsManager

    public init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    public func execute(timeFrame: AnalyticsDashboardView.TimeFrame) async throws -> BasicAnalyticsResult {
        return try await analyticsManager.getBasicStats(for: timeFrame)
    }
}

