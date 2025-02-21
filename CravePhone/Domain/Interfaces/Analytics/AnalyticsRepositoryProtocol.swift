//
//  AnalyticsRepositoryProtocol.swift
//  CravePhone
//
//  Description:
//    The domain interface for fetching analytics-related events
//    from local or remote sources.
//
//  You previously had "public protocol AnalyticsRepository" –
//  we rename it to `AnalyticsRepositoryProtocol` to avoid confusion
//  with a potential class named AnalyticsRepository.
//

import Foundation

public protocol AnalyticsRepositoryProtocol: AnyObject {
    func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent]
    // Add other methods as needed
}
