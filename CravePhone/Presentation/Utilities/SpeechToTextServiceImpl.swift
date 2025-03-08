//
//  SpeechToTextServiceImpl.swift
//  CravePhone
//
//  A production-ready implementation of SpeechToTextServiceProtocol.
//

import Foundation
import AVFoundation
import Speech

/// Concrete production-ready implementation of SpeechToTextServiceProtocol
public final class SpeechToTextServiceImpl: NSObject, SpeechToTextServiceProtocol {
    
    private let speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    public var onTextUpdated: ((String) -> Void)?
    private(set) var isRecording: Bool = false
    
    public override init() {
        // Using US English. Localize as needed.
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        super.init()
    }
    
    public func requestAuthorization() async -> Bool {
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    @discardableResult
    public func startRecording() throws -> Bool {
        // Prevent re-entrancy
        guard !isRecording else { return false }
        
        guard speechRecognizer?.isAvailable == true else {
            throw SpeechRecognitionError.recognizerUnavailable
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            throw SpeechRecognitionError.audioSessionFailed(
                "Failed to configure audio session: \(error.localizedDescription)"
            )
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        // Install mic tap
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            throw SpeechRecognitionError.audioSessionFailed(
                "Could not start audio engine: \(error.localizedDescription)"
            )
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                self.onTextUpdated?(result.bestTranscription.formattedString)
            }
            // Stop if final or if there's an error
            if error != nil || (result?.isFinal == true) {
                self.stopRecording()
            }
        }
        
        isRecording = true
        return true
    }
    
    public func stopRecording() {
        guard isRecording else { return }
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            // Typically non-fatal
            print("Audio session deactivation failed: \(error.localizedDescription)")
        }
    }
}
