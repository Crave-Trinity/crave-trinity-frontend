//
//  LogCravingViewModel.swift
//  CravePhone
//
//  Path: /Users/jj/Desktop/IOS Applications/crave-trinity-frontend/CravePhone/Presentation/ViewModels/Craving/LogCravingViewModel.swift
//

import SwiftUI
import Combine
// Add imports for your domain entities
import Foundation
import UIKit

public class LogCravingViewModel: ObservableObject {
    // MARK: - Dependencies
    
    // For speech recognition
    private let speechToText = SimpleSpeechToText()
    
    // Your existing dependencies - keep whatever you had in your original file
    private let cravingUseCase: Any // Change this to match your actual type
    
    // MARK: - Published Properties
    
    // Basic craving data
    @Published var cravingDescription: String = ""
    @Published var cravingStrength: Double = 5
    @Published var confidenceToResist: Double = 5
    @Published var selectedEmotions: Set<String> = []
    
    // UI state
    @Published var isLoading: Bool = false
    @Published var alertInfo: AlertInfo?
    
    // Speech recognition state
    @Published var isRecordingSpeech: Bool = false
    
    // MARK: - Initialization
    
    // Keep your original init parameters here
    public init(cravingUseCase: Any) { // Change the type to match your actual type
        self.cravingUseCase = cravingUseCase
        
        // Set up speech recognition
        speechToText.onTextUpdated = { [weak self] text in
            self?.cravingDescription = text
        }
        
        speechToText.requestAuthorization { success in
            print("Speech recognition authorization: \(success ? "granted" : "denied")")
        }
    }
    
    // MARK: - Public Methods
    
    /// Logs a craving with the current input values
    public func logCraving() async {
        // Keep your original implementation here
        await MainActor.run {
            self.isLoading = true
        }
        
        // This is a placeholder - keep your original implementation
        self.alertInfo = AlertInfo(
            title: "Success",
            message: "Your craving has been recorded."
        )
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    /// Toggles an emotion in the selected set
    public func toggleEmotion(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.remove(emotion)
        } else {
            selectedEmotions.insert(emotion)
        }
    }
    
    // MARK: - Speech Recognition Methods
    
    /// Toggles speech recognition mode
    public func toggleSpeechRecognition() {
        if isRecordingSpeech {
            stopSpeechRecognition()
        } else {
            startSpeechRecognition()
        }
    }
    
    /// Starts speech recognition
    private func startSpeechRecognition() {
        let success = speechToText.startRecording()
        
        if success {
            isRecordingSpeech = true
            // Add haptic feedback for recording start
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } else {
            alertInfo = AlertInfo(
                title: "Recording Error",
                message: "Unable to start voice recording. Please check microphone permissions."
            )
        }
    }
    
    /// Stops speech recognition
    private func stopSpeechRecognition() {
        speechToText.stopRecording()
        isRecordingSpeech = false
        
        // Add haptic feedback for recording stop
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Resets the form after successful submission
    private func resetForm() {
        cravingDescription = ""
        cravingStrength = 5
        confidenceToResist = 5
        selectedEmotions = []
    }
}
