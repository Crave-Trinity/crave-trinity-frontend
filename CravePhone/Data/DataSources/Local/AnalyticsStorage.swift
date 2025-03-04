//
//  AnalyticsStorage.swift
//  CravePhone
//
//  Description:
//   Implements AnalyticsStorageProtocol using SwiftData to persist AnalyticsDTO objects.
//   (Uncle Bob style: Isolate persistence details in one class.)
//

import Foundation
import SwiftData

public final class AnalyticsStorage: AnalyticsStorageProtocol {
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func store(_ dto: AnalyticsDTO) async throws {
        modelContext.insert(dto)
        try modelContext.save()
    }
    
    public func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [AnalyticsDTO] {
        let predicate = #Predicate<AnalyticsDTO> {
            $0.timestamp >= startDate && $0.timestamp <= endDate
        }
        let descriptor = FetchDescriptor<AnalyticsDTO>(predicate: predicate, sortBy: [SortDescriptor(\.timestamp)])
        return try modelContext.fetch(descriptor)
    }
}
