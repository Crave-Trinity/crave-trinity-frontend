
// File: DependencyContainer.swift
// Description:
// This dependency container creates and wires together all the dependencies for your app.
// Note how all public methods return view models that depend only on public types.
// The AnalyticsRepositoryImpl now accepts an AnalyticsStorageProtocol, so we can pass in a concrete
// AnalyticsStorage (which conforms to that protocol) without exposing its internals.


import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
public final class DependencyContainer: ObservableObject {
    @Published private(set) var modelContainer: ModelContainer
    
    public init() {
        // Initialize the ModelContainer with a schema including all persistent models.
        let schema = Schema([
            CravingEntity.self,
            AnalyticsMetadata.self  // Ensure all persistent models are included.
        ])
        do {
            self.modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Analytics Dependencies
    
    /// Returns an instance conforming to AnalyticsStorageProtocol.
    private func makeAnalyticsStorage() -> AnalyticsStorageProtocol {
        return AnalyticsStorage(modelContext: modelContainer.mainContext)
    }
    
    /// Returns a new AnalyticsMapper.
    private func makeAnalyticsMapper() -> AnalyticsMapper {
        return AnalyticsMapper()
    }
    
    /// Returns an AnalyticsRepository built from storage and mapper.
    private func makeAnalyticsRepository() -> AnalyticsRepository {
        return AnalyticsRepositoryImpl(storage: makeAnalyticsStorage(), mapper: makeAnalyticsMapper())
    }
    
    /// Returns an AnalyticsAggregator built using the storage.
    private func makeAnalyticsAggregator() -> AnalyticsAggregator {
        return AnalyticsAggregator(storage: makeAnalyticsStorage())
    }
    
    /// Returns a PatternDetectionService using storage and the shared configuration.
    private func makePatternDetectionService() -> PatternDetectionService {
        return PatternDetectionService(storage: makeAnalyticsStorage(), configuration: AnalyticsConfiguration.shared)
    }
    
    /// Returns an AnalyticsManager built from its dependencies.
    private func makeAnalyticsManager() -> AnalyticsManager {
        return AnalyticsManager(
            repository: makeAnalyticsRepository(),
            aggregator: makeAnalyticsAggregator(),
            patternDetection: makePatternDetectionService()
        )
    }
    
    // MARK: - Craving Dependencies
    
    private func makeCravingManager() -> CravingManager {
        return CravingManager(modelContext: modelContainer.mainContext)
    }
    
    private func makeCravingRepository() -> CravingRepository {
        return CravingRepositoryImpl(cravingManager: makeCravingManager())
    }
    
    private func makeAddCravingUseCase() -> AddCravingUseCaseProtocol {
        return AddCravingUseCase(cravingRepository: makeCravingRepository())
    }
    
    private func makeFetchCravingsUseCase() -> FetchCravingsUseCaseProtocol {
        return FetchCravingsUseCase(cravingRepository: makeCravingRepository())
    }
    
    private func makeArchiveCravingUseCase() -> ArchiveCravingUseCaseProtocol {
        return ArchiveCravingUseCase(cravingRepository: makeCravingRepository())
    }
    
    // MARK: - View Models
    
    /// Returns a public AnalyticsDashboardViewModel.
    public func makeAnalyticsDashboardViewModel() -> AnalyticsDashboardViewModel {
        return AnalyticsDashboardViewModel(manager: makeAnalyticsManager())
    }
    
    public func makeCravingListViewModel() -> CravingListViewModel {
        return CravingListViewModel(
            fetchCravingsUseCase: makeFetchCravingsUseCase(),
            archiveCravingUseCase: makeArchiveCravingUseCase()
        )
    }
    
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        return LogCravingViewModel(addCravingUseCase: makeAddCravingUseCase())
    }
}

