//  AnalyticsAggregatorProtocol.swift
//  CravePhone
//
//  Description:
//    The one aggregator protocol that returns BasicAnalyticsResult.

import Foundation

public protocol AnalyticsAggregatorProtocol: AnyObject {
    /// Aggregates a list of CravingEvent and returns a BasicAnalyticsResult.
    func aggregate(events: [CravingEvent]) async throws -> BasicAnalyticsResult
}
