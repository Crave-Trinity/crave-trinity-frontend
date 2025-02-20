//
//  DependencyContainer.swift
//  CravePhone
//
//  Description:
//    Builds your domain/data layers, exposes factories for your ViewModels
//    that the Coordinator calls.
//
//  Created by ...
//  Updated by ChatGPT on ...
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
public final class DependencyContainer: ObservableObject {
    
    @Published private(set) var modelContainer: ModelContainer
    
    // MARK: - Lazy Singletons
    
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
        AnalyticsStorage(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var analyticsMapper: AnalyticsMapper = {
        AnalyticsMapper()
    }()
    
    private lazy var analyticsRepository: AnalyticsRepositoryProtocol = {
        AnalyticsRepositoryImpl(storage: analyticsStorage, mapper: analyticsMapper)
    }()
    
    private lazy var analyticsAggregator: AnalyticsAggregatorProtocol = {
        AnalyticsAggregatorImpl(storage: analyticsStorage)
    }()
    
    private lazy var patternDetectionService: PatternDetectionServiceProtocol = {
        PatternDetectionServiceImpl(
            storage: analyticsStorage,
            configuration: AnalyticsConfiguration.shared
        )
    }()
    
    private lazy var analyticsManager: AnalyticsManager = {
        AnalyticsManager(
            repository: analyticsRepository,
            aggregator: analyticsAggregator,
            patternDetection: patternDetectionService
        )
    }()
    
    // For cravings
    private lazy var cravingManager: CravingManager = {
        CravingManager(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var cravingRepository: CravingRepository = {
        CravingRepositoryImpl(cravingManager: cravingManager)
    }()
    
    // MARK: - Init
    
    public init() {
        let schema = Schema([CravingEntity.self, AnalyticsMetadata.self])
        do {
            self.modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Use Cases
    
    private func makeAddCravingUseCase() -> AddCravingUseCaseProtocol {
        AddCravingUseCase(cravingRepository: cravingRepository)
    }
    private func makeFetchCravingsUseCase() -> FetchCravingsUseCaseProtocol {
        FetchCravingsUseCase(cravingRepository: cravingRepository)
    }
    private func makeArchiveCravingUseCase() -> ArchiveCravingUseCaseProtocol {
        ArchiveCravingUseCase(cravingRepository: cravingRepository)
    }
    
    // MARK: - Public Factories
    public func makeAnalyticsDashboardViewModel() -> AnalyticsDashboardViewModel {
        AnalyticsDashboardViewModel(manager: analyticsManager)
    }
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        LogCravingViewModel(addCravingUseCase: makeAddCravingUseCase())
    }
    public func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(
            fetchCravingsUseCase: makeFetchCravingsUseCase(),
            archiveCravingUseCase: makeArchiveCravingUseCase()
        )
    }
}
