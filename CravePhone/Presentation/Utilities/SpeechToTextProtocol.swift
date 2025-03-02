//
//  SpeechToTextServiceProtocol.swift
//  CravePhone
//
//  Defines the contract for any speech-to-text service implementation.
//
import Foundation

/// Custom speech recognition errors to make error handling more explicit.
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

/// Protocol defining the core functionality of speech-to-text.
public protocol SpeechToTextServiceProtocol: AnyObject {
    
    /// Callback invoked whenever new text is recognized (partial or final).
    var onTextUpdated: ((String) -> Void)? { get set }
    
    /// Requests speech recognition authorization asynchronously.
    /// - Returns: `true` if the user granted authorization; otherwise, `false`.
    func requestAuthorization() async -> Bool
    
    /// Starts a new speech recognition session.
    /// - Returns: `true` if successfully started, `false` otherwise.
    /// - Throws: `SpeechRecognitionError` if there's an issue setting up recognition.
    @discardableResult
    func startRecording() throws -> Bool
    
    /// Stops the current speech recognition session, if any.
    func stopRecording()
}
