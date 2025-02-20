//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Description:
//    The ViewModel for logging cravings, responsible for handling UI logic, state management, and interfacing with the use cases.
//    Follows MVVM and SOLID principles: Single Responsibility Principle (SRP) and Dependency Injection (DI).
//

import SwiftUI
import Combine

/// ViewModel for logging cravings. Manages user input and interacts with the use case for business logic.
@MainActor
public final class LogCravingViewModel: ObservableObject {

    // Dependency Injection for use case
    private let addCravingUseCase: AddCravingUseCaseProtocol
    
    // MARK: - Published Properties (Bind to View)
    @Published public var cravingText: String = ""     // The user input text
    @Published public var alertInfo: AlertInfo?         // For displaying error/success messages
    @Published public var isLoading: Bool = false       // Show loading state during the craving log operation

    // MARK: - Initializer (DI for UseCase)
    public init(addCravingUseCase: AddCravingUseCaseProtocol) {
        self.addCravingUseCase = addCravingUseCase
    }

    // MARK: - Business Logic (Action Methods)
    /// Handles the craving logging process, including validation and interaction with the use case.
    public func logCraving() async {
        // Trim the craving text to avoid extra spaces
        let trimmed = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)

        // Validation: Ensure the craving text is long enough
        guard trimmed.count >= 3 else {
            alertInfo = AlertInfo(title: "Validation Error",
                                  message: "Craving text must be at least 3 characters.")
            return
        }

        // Log craving asynchronously, handling success or error responses
        do {
            isLoading = true
            _ = try await addCravingUseCase.execute(cravingText: trimmed)
            cravingText = "" // Clear text after successful log
        } catch let error as PhoneCravingError {
            alertInfo = AlertInfo(title: "Error", message: error.errorDescription ?? error.localizedDescription)
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false // Stop loading indicator
    }
}
