//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Uncle Bob & Steve Jobs Style:
//   - Removed ternary to avoid mismatched return types.
//   - Uses a clear if-else block for toggling emotions.
//

import SwiftUI
import Combine
import Foundation
import UIKit

@MainActor
public class LogCravingViewModel: ObservableObject {
    
    private let speechToText = SimpleSpeechToText()
    private let cravingRepository: CravingRepository
    
    @Published var cravingDescription: String = ""
    @Published var cravingStrength: Double = 5
    @Published var confidenceToResist: Double = 5
    @Published var selectedEmotions: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var alertInfo: AlertInfo?
    @Published var isRecordingSpeech: Bool = false
    
    public init(cravingRepository: CravingRepository) {
        self.cravingRepository = cravingRepository
        
        speechToText.onTextUpdated = { [weak self] text in
            self?.cravingDescription = text
        }
        
        speechToText.requestAuthorization { success in
            print("Speech recognition authorization: \(success ? "granted" : "denied")")
        }
    }
    
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

