//
//  SpeechToTextServiceImpl.swift
//  CravePhone
//
//  A production-ready implementation of SpeechToTextServiceProtocol.
//

import Foundation
import AVFoundation
import Speech

public final class SpeechToTextServiceImpl: NSObject, SpeechToTextServiceProtocol {
    
    // MARK: - Properties
    
    private let speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // The view model (or any consumer) can set this closure to handle recognized text updates.
    public var onTextUpdated: ((String) -> Void)?
    
    // Track whether we are currently recording to prevent multiple sessions from overlapping.
    private(set) var isRecording: Bool = false
    
    // MARK: - Initialization
    
    public override init() {
        // Using US English, but you can localize for other languages if desired.
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        super.init()
    }
    
    // MARK: - Authorization
    
    public func requestAuthorization() async -> Bool {
        // Apple’s API is callback-based, so we bridge it into an async call via withCheckedContinuation.
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    // MARK: - Start Recording
    
    @discardableResult
    public func startRecording() throws -> Bool {
        // If we’re already in a recording session, no need to start again.
        guard !isRecording else { return false }
        
        // Check if speech recognizer is available on this device/locale at the moment.
        guard speechRecognizer?.isAvailable == true else {
            throw SpeechRecognitionError.recognizerUnavailable
        }
        
        // Configure the audio session for recording voice input.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            throw SpeechRecognitionError.audioSessionFailed(
                "Failed to configure audio session: \(error.localizedDescription)"
            )
        }
        
        // Prepare a recognition request to stream audio buffers.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        // Install a tap on the audio engine’s input node so we can grab microphone data.
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        // Start up the audio engine so we can begin streaming audio.
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            throw SpeechRecognitionError.audioSessionFailed(
                "Could not start audio engine: \(error.localizedDescription)"
            )
        }
        
        // Now create and start the recognition task.
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { [weak self] result, error in
            guard let self = self else { return }
            
            // Whenever we get a partial or final result, invoke the callback.
            if let result = result {
                self.onTextUpdated?(result.bestTranscription.formattedString)
            }
            
            // If there's an error, or the result is final, we should tear down.
            if error != nil || (result?.isFinal == true) {
                self.stopRecording()
            }
        }
        
        // Mark that we are in fact recording now.
        isRecording = true
        return true
    }
    
    // MARK: - Stop Recording
    
    public func stopRecording() {
        // If we’re not recording, no need to do anything.
        guard isRecording else { return }
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        // Reset everything.
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
        
        // Deactivate audio session—nonfatal if it fails here.
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session deactivation failed: \(error.localizedDescription)")
        }
    }
}
