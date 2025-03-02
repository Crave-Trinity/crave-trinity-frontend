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

    // MARK: - Private Dependencies
    private let speechToText = SimpleSpeechToText()
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
    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
        
        // Listen for speech updates
        speechToText.onTextUpdated = { [weak self] text in
            self?.cravingDescription = text
        }
        
        // Request permissions
        speechToText.requestAuthorization { success in
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
        guard speechToText.startRecording() else {
            alertInfo = AlertInfo(
                title: "Recording Error",
                message: "Unable to start recording. Check permissions."
            )
            return
        }
        isRecordingSpeech = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    private func stopSpeechRecognition() {
        speechToText.stopRecording()
        isRecordingSpeech = false
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    private func resetForm() {
        cravingDescription = ""
        cravingStrength = 5
        confidenceToResist = 5
        selectedEmotions = []
    }
}
