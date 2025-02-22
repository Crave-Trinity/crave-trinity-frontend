//
//  CravingLogViewModel.swift
//  CraveWatch
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import Combine
import SwiftData

/// ViewModel responsible for managing the state and business logic associated with logging a craving.
/// It handles inputs such as craving text, intensity, and resistance, as well as output states like loading and error messages.
@MainActor
class CravingLogViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    /// Service responsible for connectivity-related operations.
    private let connectivityService: WatchConnectivityService
    
    /// Use case that encapsulates the logic for logging a craving.
    private let logCravingUseCase: LogCravingUseCaseProtocol
    
    // MARK: - Combine Subscriptions
    
    /// A set to store Combine subscriptions for automatic cancellation.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Published UI State
    
    /// The text input representing the craving trigger or description.
    @Published var cravingText: String = ""
    
    /// The intensity level of the craving. Default value is set to 5.
    @Published var intensity: Int = 5
    
    /// The resistance level of the craving. Default value is set to 5.
    @Published var resistance: Int = 5
    
    /// Indicates whether a craving logging operation is in progress.
    @Published var isLoading: Bool = false
    
    /// Stores any error messages that occur during the logging process.
    @Published var errorMessage: String?
    
    /// Indicates whether a confirmation overlay should be shown after successful logging.
    @Published var showConfirmation: Bool = false
    
    // MARK: - Initialization
    
    /// Initializes a new instance of CravingLogViewModel.
    ///
    /// - Parameters:
    ///   - connectivityService: The service managing connectivity with the paired phone.
    ///   - logCravingUseCase: The use case for logging cravings.
    init(
        connectivityService: WatchConnectivityService,
        logCravingUseCase: LogCravingUseCaseProtocol
    ) {
        self.connectivityService = connectivityService
        self.logCravingUseCase = logCravingUseCase
    }
    
    // MARK: - Methods
    
    /// Logs the current craving by executing the logCravingUseCase.
    /// It updates the UI state to reflect loading, success, or error conditions.
    ///
    /// - Parameter context: The SwiftData model context used for local persistence.
    func logCraving(context: ModelContext) {
        // Start the loading state and reset any previous error or confirmation state.
        isLoading = true
        errorMessage = nil
        showConfirmation = false
        
        // Execute the log craving use case with the current inputs.
        logCravingUseCase.execute(
            text: cravingText,
            intensity: intensity,
            resistance: resistance,
            context: context
        )
        .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread.
        .sink { [weak self] completion in
            guard let self = self else { return }
            // Stop the loading indicator once the operation completes.
            self.isLoading = false
            
            switch completion {
            case .finished:
                // On success, show confirmation and clear the craving text.
                self.showConfirmation = true
                self.cravingText = ""
            case .failure(let error):
                // On failure, capture the error message.
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { _ in
            // No value is expected from the use case.
        }
        .store(in: &cancellables)
    }
    
    /// Clears any error messages.
    func dismissError() {
        errorMessage = nil
    }
    
    /// Updates the intensity value based on user input.
    ///
    /// - Parameter newValue: The new intensity value.
    func intensityChanged(_ newValue: Int) {
        intensity = newValue
    }
    
    /// Updates the resistance value based on user input.
    ///
    /// - Parameter newValue: The new resistance value.
    func resistanceChanged(_ newValue: Int) {
        resistance = newValue
    }
}
