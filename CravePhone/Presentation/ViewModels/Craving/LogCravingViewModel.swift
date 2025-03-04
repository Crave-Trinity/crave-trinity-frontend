//
//  LogCravingViewModel.swift
//  CravePhone
//
//  When the user logs a new craving, we save the CravingEntity (via CravingRepository)
//  and also store a matching analytics record (via AnalyticsRepository). This view model
//  also handles speech-to-text functionality.
//
//  Designed for clarity and scalability (Uncle Bob + Steve Jobs style).
//

import SwiftUI
import Foundation

@MainActor
public final class LogCravingViewModel: ObservableObject {
    private let cravingRepo: CravingRepository
    private let analyticsRepo: AnalyticsRepositoryProtocol
    private let speechService: SpeechToTextServiceProtocol

    // User-entered properties
    @Published public var cravingDescription: String = ""
    @Published public var cravingStrength: Double = 5
    @Published public var confidenceToResist: Double = 5
    @Published public var selectedEmotions: Set<String> = []
    
    // For showing a spinner and alerts
    @Published public var isLoading: Bool = false
    @Published public var alertInfo: AlertInfo?
    
    // Property for speech recording status
    @Published public var isRecordingSpeech: Bool = false

    public init(
        cravingRepo: CravingRepository,
        analyticsRepo: AnalyticsRepositoryProtocol,
        speechService: SpeechToTextServiceProtocol
    ) {
        self.cravingRepo = cravingRepo
        self.analyticsRepo = analyticsRepo
        self.speechService = speechService
        
        // Wire speech service updates to update the craving description
        self.speechService.onTextUpdated = { [weak self] text in
            self?.cravingDescription = text
        }
    }
    
    /// Logs a new craving by saving it and recording analytics.
    public func logCraving() async {
        isLoading = true
        
        let entity = CravingEntity(
            cravingDescription: cravingDescription,
            cravingStrength: cravingStrength,
            confidenceToResist: confidenceToResist,
            emotions: Array(selectedEmotions),
            timestamp: Date(),
            isArchived: false
        )
        
        do {
            // Save the craving
            try await cravingRepo.addCraving(entity)
            // Save the analytics record
            try await analyticsRepo.storeCravingEvent(from: entity)
            alertInfo = AlertInfo(title: "Success", message: "Craving logged successfully!")
            resetForm()
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    /// Toggles the speech recognition state.
    public func toggleSpeechRecognition() {
        if isRecordingSpeech {
            speechService.stopRecording()
            isRecordingSpeech = false
        } else {
            do {
                let started = try speechService.startRecording()
                isRecordingSpeech = started
            } catch {
                alertInfo = AlertInfo(title: "Speech Error", message: error.localizedDescription)
            }
        }
    }
    
    /// Toggles the selection of a given emotion.
    public func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.remove(emotion)
        } else {
            selectedEmotions.insert(emotion)
        }
    }
    
    /// Resets the form after submission.
    private func resetForm() {
        cravingDescription = ""
        cravingStrength = 5
        confidenceToResist = 5
        selectedEmotions.removeAll()
    }
    
    /// Computed property for basic form validation.
    public var isValid: Bool {
        !cravingDescription.isEmpty && cravingStrength > 0
    }
}
