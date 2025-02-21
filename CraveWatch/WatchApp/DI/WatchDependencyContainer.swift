// CraveWatch/WatchApp/DI/WatchDependencyContainer.swift
import SwiftUI

@MainActor // This is crucial
final class WatchDependencyContainer: ObservableObject {
    // Shared connectivity service
    @Published var connectivityService: WatchConnectivityService = WatchConnectivityService()

    // Coordinator -- no longer lazy
    lazy var watchCoordinator: WatchCoordinator = {
        WatchCoordinator(connectivityService: connectivityService)
    }()

    // Use Cases
    func makeLogCravingUseCase() -> LogCravingUseCase {
        return LogCravingUseCase(connectivityService: connectivityService)
    }

    // ViewModels
    func makeCravingViewModel() -> CravingLogViewModel {
        let logCravingUseCase = makeLogCravingUseCase()
        return CravingLogViewModel(connectivityService: connectivityService, logCravingUseCase: logCravingUseCase)
    }

    func makeEmergencyTriggerViewModel() -> EmergencyTriggerViewModel {
        return EmergencyTriggerViewModel(watchConnectivityService: connectivityService)
    }
}
