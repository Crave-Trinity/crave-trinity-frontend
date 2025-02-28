//
//  SimpleSpeechToText.swift
//  CravePhone
//
//  Path: /Users/jj/Desktop/IOS Applications/crave-trinity-frontend/CravePhone/Utilities/SimpleSpeechToText.swift
//

import Foundation
import Speech
import AVFoundation
import UIKit

class SimpleSpeechToText {
    // MARK: - Properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private(set) var isRecording = false
    var onTextUpdated: ((String) -> Void)?
    
    // MARK: - Public Methods
    
    /// Request permission to use speech recognition
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    
    /// Start recording and transcribing
    func startRecording() -> Bool {
        // Return false if already recording
        guard !isRecording else { return false }
        
        // Check for authorization
        guard speechRecognizer?.isAvailable == true else { return false }
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error)")
            return false
        }
        
        // Create request and install tap
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        // Prepare audio engine
        audioEngine.prepare()
        
        // Start recording
        do {
            try audioEngine.start()
        } catch {
            print("Could not start audio engine: \(error)")
            return false
        }
        
        // Set up recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in
            if let result = result {
                // Call handler with transcribed text
                self.onTextUpdated?(result.bestTranscription.formattedString)
            }
            
            if error != nil || result?.isFinal == true {
                self.stopRecording()
            }
        }
        
        isRecording = true
        return true
    }
    
    /// Stop recording and transcribing
    func stopRecording() {
        // Stop audio engine and remove tap
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        // End recognition request
        recognitionRequest?.endAudio()
        
        // Cancel task
        recognitionTask?.cancel()
        
        // Reset
        isRecording = false
        recognitionRequest = nil
        recognitionTask = nil
        
        // Reset audio session
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
