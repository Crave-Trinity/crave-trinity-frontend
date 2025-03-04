//
//  AnalyticsAggregatorProtocol.swift
//  CravePhone
//
//  Description:
//   Protocol for aggregating a list of CravingEvent objects into a BasicAnalyticsResult.
//   (Uncle Bob style: Define clear contracts for aggregation.)
//

import Foundation

public protocol AnalyticsAggregatorProtocol: AnyObject {
    func aggregate(events: [CravingEvent]) async throws -> BasicAnalyticsResult
}
