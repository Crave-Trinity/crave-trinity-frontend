// File: Core/Data/Repositories/AnalyticsRepositoryImpl.swift
// Description:
// This file implements the AnalyticsRepository interface using a storage that conforms to AnalyticsStorageProtocol.
// The duplicate protocol declaration has been removed since it should be defined in your domain interfaces.
// All public initializer parameters must be public types.

import Foundation
import SwiftData

// NOTE: Remove any duplicate declaration of the AnalyticsRepository protocol here.
// The protocol should be declared once (typically in Core/Domain/Interfaces/Repositories/AnalyticsRepository.swift).

// Public implementation of AnalyticsRepository.
public final class AnalyticsRepositoryImpl: AnalyticsRepository {
    // The storage dependency, which conforms to AnalyticsStorageProtocol.
    private let storage: AnalyticsStorageProtocol
    // The mapper used to convert DTOs to AnalyticsEvent instances.
    // Make sure that AnalyticsMapper is declared as public.
    public let mapper: AnalyticsMapper

    /// Public initializer that accepts any storage conforming to AnalyticsStorageProtocol and a public mapper.
    /// - Parameters:
    ///   - storage: An instance conforming to AnalyticsStorageProtocol.
    ///   - mapper: A public AnalyticsMapper instance.
    public init(storage: AnalyticsStorageProtocol, mapper: AnalyticsMapper) {
        self.storage = storage
        self.mapper = mapper
    }

    /// Fetches DTOs from storage, maps them to AnalyticsEvent instances, and returns them.
    /// - Parameters:
    ///   - startDate: The beginning of the time range.
    ///   - endDate: The end of the time range.
    /// - Returns: An array of objects conforming to AnalyticsEvent.
    public func fetchCravingEvents(from startDate: Date, to endDate: Date) async throws -> [any AnalyticsEvent] {
        let dtos = try await storage.fetchEvents(from: startDate, to: endDate)
        return dtos.map { mapper.mapToEntity($0) }
    }
}
