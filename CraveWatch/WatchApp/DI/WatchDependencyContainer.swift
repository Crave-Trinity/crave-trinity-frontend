//
//  WatchDependencyContainer.swift
//  CraveWatch
//
//  A simple container for shared watch dependencies.
//  (C) 2030
//

import SwiftUI

/// The WatchDependencyContainer centralizes shared dependencies for the watch application.
/// It manages the creation and injection of services, use cases, and view models.
@MainActor
final class WatchDependencyContainer: ObservableObject {
    
    // MARK: - Shared Services
    
    /// Connectivity service for data exchange with the paired iOS device.
    @Published var connectivityService: WatchConnectivityService = WatchConnectivityService()
    
    // MARK: - Coordinators
    
    /// Lazy initialized WatchCoordinator that uses the connectivity service.
    lazy var watchCoordinator: WatchCoordinator = {
        WatchCoordinator(connectivityService: connectivityService, dependencyContainer: self)
    }()
    
    // MARK: - Use Case Factory Methods
    
    /// Creates an instance of the LogCravingUseCase.
    /// - Returns: A fully configured `LogCravingUseCase`.
    func makeLogCravingUseCase() -> LogCravingUseCase {
        LogCravingUseCase(connectivityService: connectivityService)
    }
    
    // MARK: - ViewModel Factory Methods
    
    /// Creates and configures the view model responsible for logging cravings.
    /// - Returns: A `CravingLogViewModel` ready to be used by the UI.
    func makeCravingViewModel() -> CravingLogViewModel {
        let useCase = makeLogCravingUseCase()
        return CravingLogViewModel(
            connectivityService: connectivityService,
            logCravingUseCase: useCase
        )
    }
    
    // MARK: - Audio Recording Dependencies
    
    /// Lazy repository for managing audio data operations.
    lazy var cravingAudioRepository: CravingAudioRepositoryProtocol = CravingAudioRepositoryImpl()
    
    /// Lazy use case for handling audio recordings.
    lazy var cravingAudioUseCase: CravingAudioRecordingUseCase = CravingAudioRecordingUseCase(repository: cravingAudioRepository)
    
    /// Creates and configures the view model for the audio recording screen.
    /// - Returns: A `CravingAudioRecordingViewModel` instance.
    func makeCravingAudioRecordingViewModel() -> CravingAudioRecordingViewModel {
        CravingAudioRecordingViewModel(useCase: cravingAudioUseCase)
    }
}
