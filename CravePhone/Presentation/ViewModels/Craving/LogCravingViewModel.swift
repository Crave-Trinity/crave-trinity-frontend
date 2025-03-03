//
//  LogCravingViewModel.swift
//  CravePhone
//
//  RESPONSIBILITY: Holds form data & handles speech recognition and saving logic.
//

import SwiftUI
import Combine
import Foundation

@MainActor
public class LogCravingViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let speechService: SpeechToTextServiceProtocol
    private let cravingRepository: CravingRepository
    
    // MARK: - Published Properties
    
    @Published var cravingDescription: String = ""
    @Published var cravingStrength: Double = 5
    @Published var confidenceToResist: Double = 5
    @Published var selectedEmotions: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var alertInfo: AlertInfo?
    @Published var isRecordingSpeech: Bool = false
    
    // MARK: - Initialization
    
    public init(cravingRepository: CravingRepository,
                speechService: SpeechToTextServiceProtocol) {
        self.cravingRepository = cravingRepository
        self.speechService = speechService
        
        // Bind recognized text to local property
        speechService.onTextUpdated = { [weak self] recognizedText in
            self?.cravingDescription = recognizedText
        }
        
        // Request speech permissions
        Task {
            let success = await speechService.requestAuthorization()
            print("Speech recognition authorization: \(success ? "granted" : "denied")")
        }
    }
    
    // MARK: - Public Methods
    
    public func logCraving() async {
        isLoading = true
        let newCraving = CravingEntity(
            cravingDescription: cravingDescription,
            cravingStrength: cravingStrength,
            confidenceToResist: confidenceToResist,
            emotions: Array(selectedEmotions),
            timestamp: Date(),
            isArchived: false
        )
        
        do {
            try await cravingRepository.addCraving(newCraving)
            alertInfo = AlertInfo(title: "Success", message: "Craving logged.")
            resetForm()
        } catch {
            alertInfo = AlertInfo(title: "Error", message: error.localizedDescription)
        }
        isLoading = false
    }
    
    public func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.remove(emotion)
        } else {
            selectedEmotions.insert(emotion)
        }
    }
    
    public func toggleSpeechRecognition() {
        isRecordingSpeech ? stopSpeechRecognition() : startSpeechRecognition()
    }
    
    // MARK: - Private Helpers
    
    private func startSpeechRecognition() {
        do {
            let started = try speechService.startRecording()
            if started {
                isRecordingSpeech = true
                // e.g., Provide a small haptic
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } else {
                alertInfo = AlertInfo(
                    title: "Recording Error",
                    message: "Another recording session is already in progress."
                )
            }
        } catch {
            if let speechError = error as? SpeechRecognitionError {
                alertInfo = AlertInfo(title: "Speech Error", message: speechError.localizedDescription)
            } else {
                alertInfo = AlertInfo(title: "Speech Error", message: error.localizedDescription)
            }
        }
    }
    
    private func stopSpeechRecognition() {
        speechService.stopRecording()
        isRecordingSpeech = false
        // e.g., Provide a small haptic
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    private func resetForm() {
        cravingDescription = ""
        cravingStrength = 5
        confidenceToResist = 5
        selectedEmotions = []
    }
}
