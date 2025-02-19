// File: Core/Presentation/ViewModels/Craving/LogCravingViewModel.swift

import Foundation
import SwiftUI
import Combine

@MainActor
public final class LogCravingViewModel: ObservableObject {
    private let addCravingUseCase: AddCravingUseCaseProtocol

    @Published public var cravingText: String = ""
    @Published public var showingAlert = false
    @Published public var alertMessage = ""
    
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
        } catch let error as CravingError {
            alertMessage = error.localizedDescription
            showingAlert = true
        } catch {
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
}
