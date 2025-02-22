//
//  CravingLogViewModel.swift
//  CraveWatch
//
//  (C) 2030
//

import SwiftUI
import Combine
import SwiftData

@MainActor
class CravingLogViewModel: ObservableObject {
    // MARK: - Dependencies
    private let connectivityService: WatchConnectivityService
    private let logCravingUseCase: LogCravingUseCaseProtocol

    // Combine subscriptions
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Published UI
    @Published var cravingText: String = ""
    @Published var intensity: Int = 5
    @Published var resistance: Int = 5

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showConfirmation: Bool = false

    // MARK: - Init
    init(
        connectivityService: WatchConnectivityService,
        logCravingUseCase: LogCravingUseCaseProtocol
    ) {
        self.connectivityService = connectivityService
        self.logCravingUseCase = logCravingUseCase
    }

    // MARK: - Methods
    func logCraving(context: ModelContext) {
        isLoading = true
        errorMessage = nil
        showConfirmation = false

        logCravingUseCase.execute(
            text: cravingText,
            intensity: intensity,
            resistance: resistance,
            context: context
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false
            
            switch completion {
            case .finished:
                // Successful logging => show confirmation and clear text
                self.showConfirmation = true
                self.cravingText = ""   // <-- Clears the text input
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { _ in
            // No returned data needed
        }
        .store(in: &cancellables)
    }

    func dismissError() {
        errorMessage = nil
    }

    func intensityChanged(_ newValue: Int) {
        intensity = newValue
    }

    func resistanceChanged(_ newValue: Int) {
        resistance = newValue
    }
}
