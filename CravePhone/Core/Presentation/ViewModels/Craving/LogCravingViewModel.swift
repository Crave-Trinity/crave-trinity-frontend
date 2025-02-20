//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Directory: CravePhone/Core/Presentation/ViewModels/Craving/LogCravingViewModel.swift
//
//  Description:
//    The ViewModel for logging cravings, responsible for handling UI logic, state management,
//    and interfacing with the use cases. Adheres to MVVM, SOLID (SRP, DI), and clean architecture.
//    Updated to match UI property bindings (cravingDescription, cravingTrigger, and cravingIntensity).
//

import SwiftUI
import Combine

@MainActor
public final class LogCravingViewModel: ObservableObject {

    // Dependency Injection for the use case.
    private let addCravingUseCase: AddCravingUseCaseProtocol
    
    // MARK: - Published Properties (Bound to the View)
    @Published public var cravingDescription: String = ""     // The main input text for the craving.
    @Published public var cravingTrigger: String = ""           // Optional text for any associated trigger.
    @Published public var cravingIntensity: Double = 5.0        // Craving intensity (default is mid-level).
    @Published public var alertInfo: AlertInfo?                 // For displaying error/success messages.
    @Published public var isLoading: Bool = false               // Loading state during the log operation.

    // MARK: - Initializer (Dependency Injection)
    public init(addCravingUseCase: AddCravingUseCaseProtocol) {
        self.addCravingUseCase = addCravingUseCase
    }

    // MARK: - Business Logic (Action Methods)
    public func logCraving() async {
        // Trim the craving description to avoid extra spaces.
        let trimmed = cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines)

        // Validation: Ensure the craving description is long enough.
        guard trimmed.count >= 3 else {
            alertInfo = AlertInfo(title: "Validation Error",
                                  message: "Craving text must be at least 3 characters.")
            return
        }

        // Log the craving asynchronously, handling success or error responses.
        do {
            isLoading = true
            // Optionally, you could incorporate 'cravingIntensity' and 'cravingTrigger' in the future.
            _ = try await addCravingUseCase.execute(cravingText: trimmed)
            // Clear fields after successful logging.
            cravingDescription = ""
            cravingTrigger = ""
        } catch let error as PhoneCravingError {
            alertInfo = AlertInfo(title: "Error", message: error.errorDescription ?? error.localizedDescription)
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false // Stop the loading indicator.
    }
}
