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

/// DependencyContainer manages all dependencies and exposes factories for creating ViewModels and UseCases.
@MainActor
public final class DependencyContainer: ObservableObject {
    
    @Published private(set) var modelContainer: ModelContainer
    
    // MARK: - Lazy Singletons (for managing services)
    
    private lazy var cravingManager: CravingManager = {
        CravingManager(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var cravingRepository: CravingRepository = {
        CravingRepositoryImpl(cravingManager: cravingManager)
    }()
    
    // MARK: - Initializer
    public init() {
        let schema = Schema([CravingEntity.self, AnalyticsMetadata.self])
        do {
            self.modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Use Case Factories
    private func makeAddCravingUseCase() -> AddCravingUseCaseProtocol {
        AddCravingUseCase(cravingRepository: cravingRepository)
    }
    private func makeFetchCravingsUseCase() -> FetchCravingsUseCaseProtocol {
        FetchCravingsUseCase(cravingRepository: cravingRepository)
    }
    
    // Add this missing factory for `archiveCravingUseCase`
    private func makeArchiveCravingUseCase() -> ArchiveCravingUseCaseProtocol {
        ArchiveCravingUseCase(cravingRepository: cravingRepository)
    }
    
    // MARK: - Public Factories (Exposing dependencies to the app)
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        LogCravingViewModel(addCravingUseCase: makeAddCravingUseCase())
    }
    public func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(
            fetchCravingsUseCase: makeFetchCravingsUseCase(),
            archiveCravingUseCase: makeArchiveCravingUseCase() // Add missing argument here
        )
    }
}
