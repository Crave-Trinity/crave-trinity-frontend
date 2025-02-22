//
// CravingAudioRepository.swift
// CraveWatch
// Implements audio recording logic

import Foundation
import AVFoundation

/// Implementation of the `CravingAudioRepositoryProtocol` that encapsulates audio recording logic.
/// This class acts as a wrapper around `AudioStorageManager` to handle the start, stop, and saving of audio recordings.
final class CravingAudioRepositoryImpl: CravingAudioRepositoryProtocol {
    
    /// Manages the actual audio recording and storage operations.
    private var audioStorage: AudioStorageManager
    
    /// Initializes a new instance of `CravingAudioRepositoryImpl`.
    ///
    /// - Parameter audioStorage: An instance of `AudioStorageManager` responsible for audio operations.
    ///                           Defaults to a new instance if not provided.
    init(audioStorage: AudioStorageManager = AudioStorageManager()) {
        self.audioStorage = audioStorage
    }
    
    /// Begins an audio recording session by delegating the task to `AudioStorageManager`.
    func startRecording() {
        audioStorage.startRecording()
    }
    
    /// Ends the current audio recording session by delegating the task to `AudioStorageManager`.
    func stopRecording() {
        audioStorage.stopRecording()
    }
    
    /// Persists the recorded audio data by delegating the save operation to `AudioStorageManager`.
    func saveRecording() {
        audioStorage.saveRecording()
    }
}
