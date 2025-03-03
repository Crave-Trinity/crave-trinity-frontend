//
//  SpeechToTextServiceProtocol.swift
//  CravePhone
//
//  Defines the contract for any speech-to-text service implementation.
//

import Foundation

/// Specialized errors for speech recognition
public enum SpeechRecognitionError: Error, LocalizedError {
    case notAuthorized
    case recognizerUnavailable
    case audioSessionFailed(String)
    case recognitionFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Speech recognition permission not granted."
        case .recognizerUnavailable:
            return "Speech recognizer is currently unavailable."
        case let .audioSessionFailed(message),
             let .recognitionFailed(message):
            return message
        }
    }
}

/// Protocol for any speech-to-text service implementation
public protocol SpeechToTextServiceProtocol: AnyObject {
    /// Callback invoked whenever partial/final text is recognized
    var onTextUpdated: ((String) -> Void)? { get set }
    
    /// Asks user for permission (returns true if granted)
    func requestAuthorization() async -> Bool
    
    /// Starts the mic capture and speech recognition
    @discardableResult
    func startRecording() throws -> Bool
    
    /// Stops recognition
    func stopRecording()
}
