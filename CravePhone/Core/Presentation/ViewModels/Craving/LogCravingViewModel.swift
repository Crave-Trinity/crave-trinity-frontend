// File: Core/Presentation/ViewModels/Craving/LogCravingViewModel.swift
// Description:
// This ViewModel manages the craving log flow on the phone side.
// It uses the AddCravingUseCase to validate and log a new craving,
// and handles errors by showing alerts. This version now catches
// PhoneCravingError (the phone-specific error type) instead of CravingError.

import Foundation
import SwiftUI
import Combine

@MainActor
public final class LogCravingViewModel: ObservableObject {
    private let addCravingUseCase: AddCravingUseCaseProtocol

    @Published public var cravingText: String = ""
    @Published public var showingAlert: Bool = false
    @Published public var alertMessage: String = ""
    
    // Optional error message (if you want to use it elsewhere)
    @Published public private(set) var errorMessage: String?

    public init(addCravingUseCase: AddCravingUseCaseProtocol) {
        self.addCravingUseCase = addCravingUseCase
    }
    
    public func logCraving() async {
        let trimmed = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3 else {
            self.alertMessage = "Craving text must be at least 3 characters."
            self.showingAlert = true
            return
        }
        do {
            _ = try await addCravingUseCase.execute(cravingText: trimmed)
            cravingText = ""
        } catch let error as PhoneCravingError {
            // Use the error's localized description (or custom errorDescription)
            alertMessage = error.errorDescription ?? error.localizedDescription
            showingAlert = true
        } catch {
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
}
