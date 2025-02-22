//
//  WatchDependencyContainer.swift
//  CraveWatch
//
//  A simple container for shared watch dependencies.
//  (C) 2030
//

import SwiftUI

@MainActor
final class WatchDependencyContainer: ObservableObject {
    // Shared connectivity service
    @Published var connectivityService: WatchConnectivityService = WatchConnectivityService()
    
    // Lazy coordinator with the connectivity service
    lazy var watchCoordinator: WatchCoordinator = {
        WatchCoordinator(connectivityService: connectivityService, dependencyContainer: self)
    }()
    
    // The Use Case
    func makeLogCravingUseCase() -> LogCravingUseCase {
        LogCravingUseCase(connectivityService: connectivityService)
    }

    // The ViewModel for logging cravings
    func makeCravingViewModel() -> CravingLogViewModel {
        let useCase = makeLogCravingUseCase()
        return CravingLogViewModel(
            connectivityService: connectivityService,
            logCravingUseCase: useCase
        )
    }
    
    // === NEW AUDIO RECORDING DEPENDENCIES ===
    
    // Repository for handling audio data
    lazy var cravingAudioRepository: CravingAudioRepositoryProtocol = CravingAudioRepositoryImpl()
    
    // Use case to manage audio recordings
    lazy var cravingAudioUseCase: CravingAudioRecordingUseCase = CravingAudioRecordingUseCase(repository: cravingAudioRepository)

    // ViewModel for the audio recording screen
    func makeCravingAudioRecordingViewModel() -> CravingAudioRecordingViewModel {
        return CravingAudioRecordingViewModel(useCase: cravingAudioUseCase)
    }
}
