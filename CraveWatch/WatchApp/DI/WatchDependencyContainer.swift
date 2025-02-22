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
        WatchCoordinator(connectivityService: connectivityService)
    }()
    
    // The Use Case
    func makeLogCravingUseCase() -> LogCravingUseCase {
        LogCravingUseCase(connectivityService: connectivityService)
    }
    
    // The ViewModel
    func makeCravingViewModel() -> CravingLogViewModel {
        let useCase = makeLogCravingUseCase()
        return CravingLogViewModel(
            connectivityService: connectivityService,
            logCravingUseCase: useCase
        )
    }
}
