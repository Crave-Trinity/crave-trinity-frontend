//
// 1) FILE: SpeechToTextServiceImpl.swift
//    DIRECTORY: CravePhone/Presentation/Utilities
//    DESCRIPTION: Concrete implementation of speech-to-text service.
//                 Conforms to SpeechToTextServiceProtocol (not shown here).
//

import SwiftUI
import AVFoundation
import Speech

class SpeechToTextServiceImpl: ObservableObject {
    
    @Published var isRecording: Bool = false
    
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    // MARK: - Start Recording
    func startRecording(onResult: @escaping (String) -> Void) {
        guard !isRecording else { return }
        isRecording = true
        
        // Request permission
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.recordSpeech(onResult: onResult)
                default:
                    self.isRecording = false
                    print("Speech recognition not authorized or denied.")
                }
            }
        }
    }
    
    // MARK: - Record Speech
    private func recordSpeech(onResult: @escaping (String) -> Void) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            request = SFSpeechAudioBufferRecognitionRequest()
            guard let request = request else {
                self.isRecording = false
                return
            }
            request.shouldReportPartialResults = true
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                request.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
                guard error == nil else {
                    print("Recognition error: \(error?.localizedDescription ?? "")")
                    self.stopRecording()
                    return
                }
                if let result = result {
                    // Return partial or final text
                    let recognizedText = result.bestTranscription.formattedString
                    onResult(recognizedText)
                }
            }
        } catch {
            print("Audio session error: \(error.localizedDescription)")
            stopRecording()
        }
    }
    
    // MARK: - Stop Recording
    func stopRecording() {
        guard isRecording else { return }
        isRecording = false
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
        request?.endAudio()
        request = nil
        
        // Optionally deactivate the session
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Could not deactivate audio session: \(error.localizedDescription)")
        }
    }
}
