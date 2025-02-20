//
//  DependencyContainer.swift
//  CravePhone
//
//  Description:
//    A dependency container that creates your domain/data layer objects
//    and injects them where needed. Refs to protocol types -> SOLID compliance.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
public final class DependencyContainer: ObservableObject {
    
    @Published private(set) var modelContainer: ModelContainer
    
    // MARK: - Lazy singletons (example)
    
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
        AnalyticsStorage(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var analyticsMapper: AnalyticsMapper = {
        AnalyticsMapper()
    }()
    
    // IMPORTANT: store as a protocol type
    private lazy var analyticsRepository: AnalyticsRepositoryProtocol = {
        AnalyticsRepositoryImpl(storage: analyticsStorage, mapper: analyticsMapper)
    }()
    
    private lazy var analyticsAggregator: AnalyticsAggregatorProtocol = {
        AnalyticsAggregatorImpl(storage: analyticsStorage)
    }()
    
    private lazy var patternDetectionService: PatternDetectionServiceProtocol = {
        PatternDetectionServiceImpl(storage: analyticsStorage,
                                   configuration: AnalyticsConfiguration.shared)
    }()
    
    private lazy var analyticsManager: AnalyticsManager = {
        // Here, AnalyticsManager expects those 3 protocol parameters
        AnalyticsManager(
            repository: analyticsRepository,
            aggregator: analyticsAggregator,
            patternDetection: patternDetectionService
        )
    }()
    
    // Craving
    private lazy var cravingManager: CravingManager = {
        CravingManager(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var cravingRepository: CravingRepository = {
        CravingRepositoryImpl(cravingManager: cravingManager)
    }()
    
    // MARK: - Init
    
    public init() {
        // Initialize ModelContainer with your domain's schema
        let schema = Schema([
            CravingEntity.self,
            AnalyticsMetadata.self
        ])
        do {
            self.modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Craving Use Cases
    
    private func makeAddCravingUseCase() -> AddCravingUseCaseProtocol {
        AddCravingUseCase(cravingRepository: cravingRepository)
    }
    
    private func makeFetchCravingsUseCase() -> FetchCravingsUseCaseProtocol {
        FetchCravingsUseCase(cravingRepository: cravingRepository)
    }
    
    private func makeArchiveCravingUseCase() -> ArchiveCravingUseCaseProtocol {
        ArchiveCravingUseCase(cravingRepository: cravingRepository)
    }
    
    // MARK: - Public ViewModel Factories
    
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
