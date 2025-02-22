//
//  CravingAudioRecordingUseCase.swift
//  CraveWatch
//
//  Business logic for handling craving audio recording.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation

/// A use case that encapsulates the business logic for audio recording operations.
/// It abstracts away the underlying repository details, providing a simple interface
/// for starting, stopping, and saving audio recordings.
final class CravingAudioRecordingUseCase {
    
    // MARK: - Properties
    
    /// The repository responsible for performing the actual audio recording operations.
    private let repository: CravingAudioRepositoryProtocol
    
    // MARK: - Initialization
    
    /// Initializes the audio recording use case with a repository.
    ///
    /// - Parameter repository: An instance conforming to `CravingAudioRepositoryProtocol`.
    ///                         Defaults to `CravingAudioRepositoryImpl` if not provided.
    init(repository: CravingAudioRepositoryProtocol = CravingAudioRepositoryImpl()) {
        self.repository = repository
    }
    
    // MARK: - Audio Recording Operations
    
    /// Starts the audio recording session by delegating the task to the repository.
    func startRecording() {
        repository.startRecording()
    }
    
    /// Stops the audio recording session by delegating the task to the repository.
    func stopRecording() {
        repository.stopRecording()
    }
    
    /// Saves the recorded audio by delegating the task to the repository.
    func saveRecording() {
        repository.saveRecording()
    }
}
