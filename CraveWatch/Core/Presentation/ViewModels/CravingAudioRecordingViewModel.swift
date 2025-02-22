//
//  CravingAudioRecordingViewModel.swift
//  CraveWatch
//
//  Handles the logic for recording and managing audio cravings.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import Combine

/// ViewModel responsible for managing audio recording state and actions.
/// It communicates with the underlying use case to start, stop, and save audio recordings.
class CravingAudioRecordingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Indicates whether audio recording is currently in progress.
    @Published var isRecording = false
    
    /// Indicates whether a recording has been completed and is available to save.
    @Published var hasRecording = false
    
    // MARK: - Dependencies
    
    /// The use case that encapsulates the audio recording operations.
    private let useCase: CravingAudioRecordingUseCase
    
    // MARK: - Initialization
    
    /// Initializes a new instance of CravingAudioRecordingViewModel.
    /// - Parameter useCase: The audio recording use case. Defaults to a new instance if not provided.
    init(useCase: CravingAudioRecordingUseCase = CravingAudioRecordingUseCase()) {
        self.useCase = useCase
    }
    
    // MARK: - Actions
    
    /// Toggles the audio recording state.
    /// If currently recording, it stops the recording and flags that a recording exists.
    /// Otherwise, it starts a new recording.
    func toggleRecording() {
        if isRecording {
            // Stop the recording and mark that a recording has been captured.
            useCase.stopRecording()
            hasRecording = true
        } else {
            // Start a new recording.
            useCase.startRecording()
        }
        // Toggle the recording state.
        isRecording.toggle()
    }
    
    /// Saves the current recording using the use case.
    /// After saving, it resets the hasRecording flag.
    func saveRecording() {
        useCase.saveRecording()
        hasRecording = false
    }
}
