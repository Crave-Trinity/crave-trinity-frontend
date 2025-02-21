//
//  WatchDependencyContainer.swift
//  CraveWatch
//

import SwiftUI

@MainActor
final class WatchDependencyContainer: ObservableObject {
    // Shared connectivity service
    @Published var connectivityService: WatchConnectivityService = WatchConnectivityService()
    
    // If you have a watch coordinator, set it up here
    lazy var watchCoordinator: WatchCoordinator = {
        WatchCoordinator(connectivityService: connectivityService)
    }()
    
    // Create the domain use case
    func makeLogCravingUseCase() -> LogCravingUseCase {
        return LogCravingUseCase(connectivityService: connectivityService)
    }
    
    // Create the CravingLogViewModel with matching init
    func makeCravingViewModel() -> CravingLogViewModel {
        let useCase = makeLogCravingUseCase()
        return CravingLogViewModel(
            connectivityService: connectivityService,
            logCravingUseCase: useCase
        )
    }
}
