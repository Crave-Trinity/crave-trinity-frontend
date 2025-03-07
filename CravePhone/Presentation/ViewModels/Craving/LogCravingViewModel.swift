//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Uncle Bob: A ViewModel should contain presentation logic and mediate
//  between the View and the Domain/UseCase layers.
//
import SwiftUI
import Foundation

@MainActor
public final class LogCravingViewModel: ObservableObject {
    // MARK: - Dependencies
    private let cravingRepo: CravingRepository
    private let analyticsRepo: AnalyticsRepository
    private let speechService: SpeechToTextServiceProtocol
    
    // MARK: - User Input Properties
    @Published public var cravingDescription: String = ""
    @Published public var cravingStrength: Double = 5
    @Published public var confidenceToResist: Double = 5
    @Published public var selectedEmotions: Set<String> = []
    
    // NEW fields for location, people, trigger
    @Published public var selectedLocation: String? = nil
    @Published public var selectedPeople: [String] = []
    @Published public var triggerDescription: String = ""
    
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
    
    // MARK: - Logging
    public func logCraving() async {
        isLoading = true
        
        let entity = CravingEntity(
            id: UUID(),
            cravingDescription: cravingDescription,
            cravingStrength: cravingStrength,
            confidenceToResist: confidenceToResist,
            emotions: Array(selectedEmotions),
            timestamp: Date(),
            isArchived: false,
            // NEW
            location: selectedLocation,
            people: selectedPeople,
            trigger: triggerDescription
        )
        
        do {
            // Save the new craving
            try await cravingRepo.addCraving(entity)
            
            // Save analytics event
            try await analyticsRepo.storeCravingEvent(from: entity)
            
            // Success feedback
            alertInfo = AlertInfo(title: "Success", message: "Craving logged successfully!")
            resetForm()
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    // MARK: - Speech
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
    
    // MARK: - Emotions/Moods
    public func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.remove(emotion)
        } else {
            selectedEmotions.insert(emotion)
        }
    }
    
    // MARK: - Validation
    public var isValid: Bool {
        !cravingDescription.isEmpty && cravingStrength > 0
    }
    
    // MARK: - Private Helpers
    private func resetForm() {
        cravingDescription = ""
        cravingStrength = 5
        confidenceToResist = 5
        selectedEmotions.removeAll()
        // New fields
        selectedLocation = nil
        selectedPeople.removeAll()
        triggerDescription = ""
    }
}
