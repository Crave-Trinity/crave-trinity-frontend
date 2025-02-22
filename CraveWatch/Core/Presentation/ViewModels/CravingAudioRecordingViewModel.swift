// MARK: - CravingAudioRecordingViewModel.swift
// Handles logic for recording and managing audio cravings

import Foundation
import Combine

class CravingAudioRecordingViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var hasRecording = false
    
    private let useCase: CravingAudioRecordingUseCase
    
    init(useCase: CravingAudioRecordingUseCase = CravingAudioRecordingUseCase()) {
        self.useCase = useCase
    }
    
    func toggleRecording() {
        if isRecording {
            useCase.stopRecording()
            hasRecording = true
        } else {
            useCase.startRecording()
        }
        isRecording.toggle()
    }
    
    func saveRecording() {
        useCase.saveRecording()
        hasRecording = false
    }
}
