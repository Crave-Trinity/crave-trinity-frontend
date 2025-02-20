//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Description:
//    Manages the craving log flow on the phone side.
//    Uses the AddCravingUseCase to validate and log a new craving,
//    and handles errors by showing alerts.
//

import SwiftUI
import Combine

@MainActor
public final class LogCravingViewModel: ObservableObject {
    private let addCravingUseCase: AddCravingUseCaseProtocol

    @Published public var cravingText: String = ""
    @Published public var showingAlert: Bool = false
    @Published public var alertMessage: String = ""
    
    public init(addCravingUseCase: AddCravingUseCaseProtocol) {
        self.addCravingUseCase = addCravingUseCase
    }
    
    public func logCraving() async {
        let trimmed = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3 else {
            alertMessage = "Craving text must be at least 3 characters."
            showingAlert = true
            return
        }
        do {
            _ = try await addCravingUseCase.execute(cravingText: trimmed)
            cravingText = ""
        } catch let error as PhoneCravingError {
            alertMessage = error.errorDescription ?? error.localizedDescription
            showingAlert = true
        } catch {
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
}
