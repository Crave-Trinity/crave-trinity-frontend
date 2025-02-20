//
//  DependencyContainer.swift
//  CravePhone
//
//  Description:
//    This dependency container creates and wires together all the dependencies for your app.
//    It uses SwiftData's ModelContainer for persistent models, and returns ViewModels that
//    depend on public types only. Repeated dependencies (e.g., AnalyticsStorage) are lazily
//    instantiated to avoid recreating them multiple times.
//
//  Notes on improvements:
//    1) Use lazy properties for single-instance dependencies (e.g., AnalyticsStorage).
//       This prevents re-initializing the same object every time a method is called.
//    2) Keep internal "makeX" methods private, and expose only what's needed publicly
//       (the final ViewModels).
//    3) If you need truly ephemeral instances, remove the lazy property approach
//       and revert to the original "make" methods.
//    4) If you plan on using multiple "profiles" or "environments" (e.g., mocks vs real),
//       you can unify them here or set up separate containers.
//
//  Created by [Your Name] on [Date].
//

import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
public final class DependencyContainer: ObservableObject {
    
    // MARK: - Stored Properties
    
    @Published private(set) var modelContainer: ModelContainer
    
    // We store singletons/lazy dependencies here.
    // Adjust as needed if you want ephemeral vs. shared instances.
    
    // Analytics
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
        AnalyticsStorage(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var analyticsMapper: AnalyticsMapper = {
        AnalyticsMapper()
    }()
    
    private lazy var analyticsRepository: AnalyticsRepository = {
        AnalyticsRepositoryImpl(storage: analyticsStorage, mapper: analyticsMapper)
    }()
    
    private lazy var analyticsAggregator: AnalyticsAggregator = {
        AnalyticsAggregator(storage: analyticsStorage)
    }()
    
    private lazy var patternDetectionService: PatternDetectionService = {
        PatternDetectionService(storage: analyticsStorage,
                               configuration: AnalyticsConfiguration.shared)
    }()
    
    private lazy var analyticsManager: AnalyticsManager = {
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
    
    // MARK: - Initialization
    
    public init() {
        // Initialize the ModelContainer with a schema that includes all persistent models.
        let schema = Schema([
            CravingEntity.self,
            AnalyticsMetadata.self  // Add more if needed
        ])
        do {
            self.modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Craving Use Cases
    
    private func makeAddCravingUseCase() -> AddCravingUseCaseProtocol {
        // In a lazy approach, the cravingRepository is only initialized once.
        return AddCravingUseCase(cravingRepository: cravingRepository)
    }
    
    private func makeFetchCravingsUseCase() -> FetchCravingsUseCaseProtocol {
        return FetchCravingsUseCase(cravingRepository: cravingRepository)
    }
    
    private func makeArchiveCravingUseCase() -> ArchiveCravingUseCaseProtocol {
        return ArchiveCravingUseCase(cravingRepository: cravingRepository)
    }
    
    // MARK: - View Models (Public)
    
    public func makeAnalyticsDashboardViewModel() -> AnalyticsDashboardViewModel {
        AnalyticsDashboardViewModel(manager: analyticsManager)
    }
    
    public func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(
            fetchCravingsUseCase: makeFetchCravingsUseCase(),
            archiveCravingUseCase: makeArchiveCravingUseCase()
        )
    }
    
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        LogCravingViewModel(addCravingUseCase: makeAddCravingUseCase())
    }
}

