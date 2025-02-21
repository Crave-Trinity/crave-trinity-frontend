//
//  CravingLogViewModel.swift
//  CraveWatch
//

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
        isLoading = true

        if connectivityService.phoneReachable {
            logCravingUseCase.execute(text: trimmedText,
                                      intensity: intensity,
                                      resistance: resistance)
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
                        self.resetForm()
                        self.showConfirmation = true
                        self.hapticManager.play(.success)
                    }
                } receiveValue: { _ in
                    // No output needed
                }
                .store(in: &cancellables)
        } else {
            Task {
                do {
                    self.localStore.setContext(context: context)
                    try await self.localStore.addCraving(cravingDescription: trimmedText,
                                                         intensity: self.intensity,
                                                         resistance: self.resistance)
                } catch {
                    print("🔴 Error adding craving offline: \(error)")
                }

                // Wrap up
                self.resetForm()
                self.showConfirmation = true
                self.hapticManager.play(.success)
                self.isLoading = false
            }
        }
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

    private func resetForm() {
        cravingText = ""
        intensity = 5
        resistance = 5
        errorMessage = nil
    }
}

