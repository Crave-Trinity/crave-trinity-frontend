//
// FILE: LogCravingViewModel.swift
// DIRECTORY: CravePhone/Presentation/ViewModels/Craving
// PURPOSE: MVVM ViewModel for logging a craving.
//

import SwiftUI
import Combine

class LogCravingViewModel: ObservableObject {
    
    // Dependencies
    private let cravingRepo: CravingRepository
    private let analyticsRepo: AnalyticsRepository
    private let speechService: SpeechToTextServiceImpl
    
    // Published fields for UI
    @Published var cravingDescription: String = ""
    @Published var location: String = ""
    @Published var people: String = ""
    @Published var trigger: String = ""
    @Published var intensity: Double = 5
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        cravingRepo: CravingRepository,
        analyticsRepo: AnalyticsRepository,
        speechService: SpeechToTextServiceImpl
    ) {
        self.cravingRepo = cravingRepo
        self.analyticsRepo = analyticsRepo
        self.speechService = speechService
        
        // Example: observe changes for analytics or validations
        $cravingDescription
            .sink { [weak self] newText in
                guard let self = self else { return }
                // Possibly clamp to 300 chars, etc.
                if newText.count > 300 {
                    self.cravingDescription = String(newText.prefix(300))
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    /// Called to log the craving. You might incorporate analytics logic here.
    func logCraving() {
        // For example, create a CravingEntity from the data and save:
        // cravingRepo.saveCraving(description: cravingDescription, ...)
        print("Craving logged: \(cravingDescription)")
    }
    
    /// Example: Start speech recognition. You could expand this logic.
    func startSpeechRecognition() {
        speechService.startRecording { [weak self] recognizedText in
            guard let self = self else { return }
            // Decide if you want to append or replace
            self.cravingDescription = recognizedText
        }
    }
    
    func stopSpeechRecognition() {
        speechService.stopRecording()
    }
}
