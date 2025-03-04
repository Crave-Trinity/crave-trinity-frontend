//
//  AnalyticsStorageProtocol.swift
//  CravePhone
//
//  Description:
//    Abstraction for storing/fetching analytics data (AnalyticsDTO).
//
import Foundation

public protocol AnalyticsStorageProtocol {
    func store(_ dto: AnalyticsDTO) async throws
    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [AnalyticsDTO]
}
