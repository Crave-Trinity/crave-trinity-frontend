//
//  LogCravingViewModel.swift
//  CravePhone
//
//  RESPONSIBILITY: Holds form data & handles speech recognition and saving logic.
//
import SwiftUI
import Combine
import Foundation
import UIKit

@MainActor
public class LogCravingViewModel: ObservableObject {

    // MARK: - Dependencies
    
    /// This is our new injection of a SpeechToTextServiceProtocol
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
    
    /// We now inject `speechService` so that the ViewModel depends on an abstraction, not a concrete class.
    public init(cravingRepository: CravingRepository,
                speechService: SpeechToTextServiceProtocol) {
        
        self.cravingRepository = cravingRepository
        self.speechService = speechService
        
        // Listen for speech updates. Whenever the service recognizes new text,
        // update `cravingDescription`.
        speechService.onTextUpdated = { [weak self] recognizedText in
            self?.cravingDescription = recognizedText
        }
        
        // Request permissions (asynchronously).
        Task {
            let success = await speechService.requestAuthorization()
            print("Speech recognition authorization: \(success ? "granted" : "denied")")
        }
    }
    
    // MARK: - Public Methods
    
    /// Logs the current craving data asynchronously via the CravingRepository.
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
    
    /// Toggles an emotion chip in the UI
    public func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.remove(emotion)
        } else {
            selectedEmotions.insert(emotion)
        }
    }
    
    /// Called when a user taps the microphone icon to start/stop recording
    public func toggleSpeechRecognition() {
        isRecordingSpeech ? stopSpeechRecognition() : startSpeechRecognition()
    }
    
    // MARK: - Private Helpers
    
    /// Starts the microphone capture & recognition
    private func startSpeechRecognition() {
        do {
            // Attempt to start the speech service
            let started = try speechService.startRecording()
            if started {
                isRecordingSpeech = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } else {
                alertInfo = AlertInfo(
                    title: "Recording Error",
                    message: "Another recording session is already in progress."
                )
            }
        } catch {
            // Catch any thrown SpeechRecognitionError
            if let speechError = error as? SpeechRecognitionError {
                alertInfo = AlertInfo(
                    title: "Speech Error",
                    message: speechError.localizedDescription
                )
            } else {
                alertInfo = AlertInfo(
                    title: "Speech Error",
                    message: error.localizedDescription
                )
            }
        }
    }
    
    /// Stops the microphone capture & recognition
    private func stopSpeechRecognition() {
        speechService.stopRecording()
        isRecordingSpeech = false
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    /// Clears the form after a successful log
    private func resetForm() {
        cravingDescription = ""
        cravingStrength = 5
        confidenceToResist = 5
        selectedEmotions = []
    }
}
