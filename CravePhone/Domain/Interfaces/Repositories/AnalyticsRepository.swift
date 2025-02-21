// Core/Domain/Interfaces/Repositories/AnalyticsRepository.swift
import Foundation
import Combine

// This is an INTERFACE, so it must be public
public protocol AnalyticsRepository {
    func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [any AnalyticsEvent]
    // Add other methods as needed (e.g., for fetching specific event types)
}

