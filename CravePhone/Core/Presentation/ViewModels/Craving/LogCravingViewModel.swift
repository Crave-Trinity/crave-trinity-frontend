//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Created by John H Jung on 2/12/25.
//  Updated by ChatGPT on ...
//

import SwiftUI
import Combine

@MainActor
public final class LogCravingViewModel: ObservableObject {
    
    // Dependencies
    private let addCravingUseCase: AddCravingUseCaseProtocol
    
    // Published Properties
    @Published public var cravingText: String = ""
    @Published public var alertInfo: AlertInfo?
    @Published public var isLoading: Bool = false

    public init(addCravingUseCase: AddCravingUseCaseProtocol) {
        self.addCravingUseCase = addCravingUseCase
    }
    
    public func logCraving() async {
        let trimmed = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3 else {
            alertInfo = AlertInfo(title: "Validation Error",
                                  message: "Craving text must be at least 3 characters.")
            return
        }
        
        do {
            isLoading = true
            _ = try await addCravingUseCase.execute(cravingText: trimmed)
            cravingText = ""
        } catch let error as PhoneCravingError {
            alertInfo = AlertInfo(title: "Error", message: error.errorDescription ?? error.localizedDescription)
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }
}
