//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Uncle Bob: A ViewModel should contain presentation logic and mediate
//  between the View (UI) and the Domain/UseCase layers. It does not handle
//  direct data persistence; it delegates to repositories or use cases.
//  Keep responsibilities clear and minimal.
//
import SwiftUI
import Foundation
@MainActor
public final class LogCravingViewModel: ObservableObject {
    // MARK: - Dependencies
    private let cravingRepo: CravingRepository
    
    // Changed from AnalyticsRepositoryProtocol to AnalyticsRepository
    private let analyticsRepo: AnalyticsRepository
    
    private let speechService: SpeechToTextServiceProtocol
    
    // MARK: - User Input Properties
    @Published public var cravingDescription: String = ""
    @Published public var cravingStrength: Double = 5
    @Published public var confidenceToResist: Double = 5
    @Published public var selectedEmotions: Set<String> = []
    
    // MARK: - UI State
    @Published public var isLoading: Bool = false
    @Published public var alertInfo: AlertInfo?
    @Published public var isRecordingSpeech: Bool = false
    
    // MARK: - Initialization
    public init(
        cravingRepo: CravingRepository,
        analyticsRepo: AnalyticsRepository,
        speechService: SpeechToTextServiceProtocol
    ) {
        self.cravingRepo = cravingRepo
        self.analyticsRepo = analyticsRepo
        self.speechService = speechService
        
        // On speech-to-text updates, automatically update the craving description.
        self.speechService.onTextUpdated = { [weak self] text in
            self?.cravingDescription = text
        }
    }
    
    // MARK: - Public Methods
    
    /// Logs a new craving by:
    /// 1) Persisting a CravingEntity to the local repository,
    /// 2) Persisting an Analytics event for that craving,
    /// 3) Providing user feedback via an alert,
    /// 4) Resetting the form fields.
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
            // Save the new craving
            try await cravingRepo.addCraving(entity)
            
            // Save an analytics event capturing this craving log
            try await analyticsRepo.storeCravingEvent(from: entity)
            
            // Provide success feedback
            alertInfo = AlertInfo(title: "Success", message: "Craving logged successfully!")
            
            // Reset for next input
            resetForm()
        } catch {
            // Display any errors
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    /// Toggles speech recognition on/off using the injected speech service.
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
    
    /// Toggle a specific emotion in the selectedEmotions set.
    public func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.remove(emotion)
        } else {
            selectedEmotions.insert(emotion)
        }
    }
    
    /// A convenient property to validate whether the form can be submitted.
    public var isValid: Bool {
        !cravingDescription.isEmpty && cravingStrength > 0
    }
    
    // MARK: - Private Helpers
    
    /// Clears input fields after a successful submission.
    private func resetForm() {
        cravingDescription = ""
        cravingStrength = 5
        confidenceToResist = 5
        selectedEmotions.removeAll()
    }
}

