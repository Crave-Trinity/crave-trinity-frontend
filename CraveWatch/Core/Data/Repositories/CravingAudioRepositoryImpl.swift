// MARK: - CravingAudioRepositoryImpl.swift
// Implements audio recording logic

import Foundation
import AVFoundation

class CravingAudioRepositoryImpl: CravingAudioRepositoryProtocol {
    private var audioStorage: AudioStorageManager
    
    init(audioStorage: AudioStorageManager = AudioStorageManager()) {
        self.audioStorage = audioStorage
    }
    
    func startRecording() {
        audioStorage.startRecording()
    }
    
    func stopRecording() {
        audioStorage.stopRecording()
    }
    
    func saveRecording() {
        audioStorage.saveRecording()
    }
}
