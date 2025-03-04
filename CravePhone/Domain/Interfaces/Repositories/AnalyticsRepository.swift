//
//  AnalyticsRepository.swift
//  CravePhone
//
//  Description:
//    Domain-level interface for retrieving analytics events
//    and storing new ones (if your design calls for that).
//
import Foundation
public protocol AnalyticsRepository {
    func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [CravingEvent]
    func storeCravingEvent(from craving: CravingEntity) async throws
}
