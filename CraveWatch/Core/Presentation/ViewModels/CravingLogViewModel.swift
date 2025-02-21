// CraveWatch/Core/Presentation/ViewModels/CravingLogViewModel.swift
import Foundation
import SwiftData
import Combine
import SwiftUI

@MainActor
final class CravingLogViewModel: ObservableObject {

    @Published var cravingText: String = ""
    @Published var intensity: Int = 5
    @Published var resistance: Int = 5
    @Published var showConfirmation: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isResistanceViewActive: Bool = false
    @Published var isLoading = false

    private let connectivityService: WatchConnectivityService
    private let logCravingUseCase: LogCravingUseCase
    private var cancellables = Set<AnyCancellable>()
    private let hapticManager = WatchHapticManager()
    private let localStore = LocalCravingStore()

    init(connectivityService: WatchConnectivityService, logCravingUseCase: LogCravingUseCase) {
        self.connectivityService = connectivityService
        self.logCravingUseCase = logCravingUseCase
    }

    func logCraving(context: ModelContext) {
        let trimmedText = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            errorMessage = "Please enter a craving."
            return
        }
        
        self.isLoading = true

        if connectivityService.phoneReachable {
            logCravingUseCase.execute(text: trimmedText, intensity: intensity, resistance: resistance)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoading = false
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        print("Error logging craving: \(error)")
                    case .finished:
                        print("Craving logged successfully.")
                        self.resetForm() // Use a helper function
                        self.showConfirmation = true
                        self.isResistanceViewActive = false
                        self.hapticManager.play(.success)
                    }
                } receiveValue: { _ in
                    // Void output from the publisher; no further action needed.
                }
                .store(in: &cancellables)
        } else {
            Task { // Use Task for async operation
                self.localStore.setContext(context: context) // self was missing
                await self.addCravingOffline(cravingDescription: trimmedText, intensity: self.intensity, resistance: self.resistance) // self was missing
                self.resetForm() // Use helper function, self was missing
                self.showConfirmation = true //self was missing
                self.isResistanceViewActive = false // self was missing
                self.hapticManager.play(.success) // self was missing
                self.isLoading = false // self was missing
            }
        }
    }
    
    private func resetForm() {
        self.cravingText = ""
        self.intensity = 5
        self.resistance = 5
        self.errorMessage = nil
    }

    func dismissError() {
        errorMessage = nil
    }

    func intensityChanged() {
        hapticManager.play(.selection)
    }

    func resistanceChanged() {
        hapticManager.play(.selection)
    }

    func nextAction() {
        if isResistanceViewActive {
            // context is passed as function argument
        } else {
            isResistanceViewActive = true
            hapticManager.play(.notification) // Consider a different haptic here, maybe .start
        }
    }

    func addCravingOffline(cravingDescription: String, intensity: Int, resistance: Int) async {
        do {
            try await localStore.addCraving(cravingDescription: cravingDescription,
                                             intensity: intensity, resistance: resistance)
        } catch {
            print("🔴 Error adding craving offline: \(error)")
        }
    }
}
