//
//  AnalyticsStorage.swift
//  CravePhone
//
//  Uncle Bob & SOLID: This is the local data source for analytics.
//  It directly interacts with SwiftData to store/fetch `AnalyticsDTO`.
//
import SwiftData
import Foundation
public final class AnalyticsStorage: AnalyticsStorageProtocol {
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Public Methods
    
    /// Stores a single AnalyticsDTO.
    /// Make sure you're on the correct actor (e.g. MainActor) if needed.
    public func store(_ dto: AnalyticsDTO) async throws {
        modelContext.insert(dto)
        try modelContext.save()
    }
    
    /// Fetches AnalyticsDTO objects within [startDate ... endDate].
    /// Sorts them by timestamp ascending.
    public func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [AnalyticsDTO] {
        // 1) Construct a SwiftData predicate
        let predicate = #Predicate<AnalyticsDTO> {
            $0.timestamp >= startDate && $0.timestamp <= endDate
        }
        
        // 2) Sort by ascending timestamp
        let fetchDescriptor = FetchDescriptor<AnalyticsDTO>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        
        // 3) Perform the fetch
        let dtos = try modelContext.fetch(fetchDescriptor)
        
        // DEBUG (optional):
        // print("Fetched \(dtos.count) analytics events from \(startDate) to \(endDate)")
        
        return dtos
    }
}

