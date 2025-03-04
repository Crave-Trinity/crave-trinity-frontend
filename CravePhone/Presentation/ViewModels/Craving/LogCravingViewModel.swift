//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Description:
//   When the user logs a new craving, this view model saves a CravingEntity
//   and also stores a corresponding analytics record. It handles speech-to-text,
//   form validation, and state updates.
//   (Uncle Bob: Keep responsibilities isolated and code DRY.)
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
    
    // UI state properties
    @Published public var isLoading: Bool = false
    @Published public var alertInfo: AlertInfo?
    
    // Speech recognition status
    @Published public var isRecordingSpeech: Bool = false

    public init(
        cravingRepo: CravingRepository,
        analyticsRepo: AnalyticsRepositoryProtocol,
        speechService: SpeechToTextServiceProtocol
    ) {
        self.cravingRepo = cravingRepo
        self.analyticsRepo = analyticsRepo
        self.speechService = speechService
        
        // Update the description as speech text is recognized.
        self.speechService.onTextUpdated = { [weak self] text in
            self?.cravingDescription = text
        }
    }
    
    /// Logs a new craving by saving it and storing an analytics record.
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
            try await cravingRepo.addCraving(entity)
            try await analyticsRepo.storeCravingEvent(from: entity)
            alertInfo = AlertInfo(title: "Success", message: "Craving logged successfully!")
            resetForm()
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    /// Toggles speech recognition.
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
    
    /// Toggles an emotion’s selection.
    public func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.remove(emotion)
        } else {
            selectedEmotions.insert(emotion)
        }
    }
    
    /// Resets form values.
    private func resetForm() {
        cravingDescription = ""
        cravingStrength = 5
        confidenceToResist = 5
        selectedEmotions.removeAll()
    }
    
    /// Form validation.
    public var isValid: Bool {
        !cravingDescription.isEmpty && cravingStrength > 0
    }
}
