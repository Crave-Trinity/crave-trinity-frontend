// MARK: - CravingAudioRecordingUseCase.swift
// Business logic for handling craving audio recording

import Foundation

class CravingAudioRecordingUseCase {
    private let repository: CravingAudioRepositoryProtocol
    
    init(repository: CravingAudioRepositoryProtocol = CravingAudioRepositoryImpl()) {
        self.repository = repository
    }
    
    func startRecording() {
        repository.startRecording()
    }
    
    func stopRecording() {
        repository.stopRecording()
    }
    
    func saveRecording() {
        repository.saveRecording()
    }
}
