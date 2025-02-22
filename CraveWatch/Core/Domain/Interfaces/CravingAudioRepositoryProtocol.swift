//
//  CravingWatchRepositoryProtocol.swift
//  CraveWatch
//
//  Defines how the watch's domain layer interacts with craving data.
//  Renamed to avoid collisions with the phone side.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//
// MARK: - CravingAudioRepositoryProtocol.swift
// Defines the interface for handling audio recording data

import Foundation

/// Protocol defining the interface for handling audio recording operations.
/// Implementations of this protocol should encapsulate the logic to start, stop,
/// and persist audio recordings.
protocol CravingAudioRepositoryProtocol {
    
    /// Begins the audio recording process.
    func startRecording()
    
    /// Ends the current audio recording session.
    func stopRecording()
    
    /// Persists or finalizes the current audio recording.
    func saveRecording()
}
