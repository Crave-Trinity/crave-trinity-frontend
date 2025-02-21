//
//  CravingLogViewModel.swift
//  CraveWatch
//

import SwiftUI
import Combine
import SwiftData

@MainActor
class CravingLogViewModel: ObservableObject {
    // MARK: - Dependencies
    private let connectivityService: WatchConnectivityService
    private let logCravingUseCase: LogCravingUseCaseProtocol

    // Keep track of Combine subscriptions
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Published UI state
    @Published var cravingText: String = ""
    @Published var intensity: Int = 5
    @Published var resistance: Int = 5

    // Loading & error states
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showConfirmation: Bool = false

    // MARK: - Init that matches the container
    init(
        connectivityService: WatchConnectivityService,
        logCravingUseCase: LogCravingUseCaseProtocol
    ) {
        self.connectivityService = connectivityService
        self.logCravingUseCase = logCravingUseCase
    }

    // MARK: - Actions

    /// Called when the user taps "Log Craving" on the final watch page
    func logCraving(context: ModelContext) {
        isLoading = true
        errorMessage = nil
        showConfirmation = false

        // Use the domain use case to do local + phone sync
        logCravingUseCase.execute(
            text: cravingText,
            intensity: intensity,
            resistance: resistance,
            context: context
        )
        .receive(on: DispatchQueue.main)  // Ensure UI updates on main thread
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false

            switch completion {
            case .finished:
                // Successfully logged, show confirmation
                self.showConfirmation = true

            case .failure(let error):
                // Show an error
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { _ in
            // We don't need a success value, just an empty ()
        }
        .store(in: &cancellables)
    }

    /// Dismiss the current error
    func dismissError() {
        errorMessage = nil
    }

    /// Called when intensity changes
    func intensityChanged(_ newValue: Int) {
        intensity = newValue
        // Additional logic (analytics, validations, etc.) goes here
    }

    /// Called when resistance changes
    func resistanceChanged(_ newValue: Int) {
        resistance = newValue
        // Additional logic goes here
    }
}
