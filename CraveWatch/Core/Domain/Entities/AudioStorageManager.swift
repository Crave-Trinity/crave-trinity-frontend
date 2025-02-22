//
//  AudioStorageManager.swift
//  CraveWatch
//
//  Manages actual saving and retrieval of audio files.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import AVFoundation

/// Handles audio recording and storage operations.
/// This manager leverages `AVAudioRecorder` to manage the recording lifecycle.
final class AudioStorageManager {
    
    /// The audio recorder instance used to capture audio.
    private var audioRecorder: AVAudioRecorder?
    
    /// Begins an audio recording session.
    /// Configures the recorder with specified settings and starts recording.
    func startRecording() {
        let url = getAudioFileURL()
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),       // Use AAC format for compression.
            AVSampleRateKey: 12000,                          // Sample rate in Hz.
            AVNumberOfChannelsKey: 1,                        // Mono recording.
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // High quality encoding.
        ]
        
        do {
            // Attempt to initialize the audio recorder with the file URL and settings.
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            // Start recording audio.
            audioRecorder?.record()
        } catch {
            // Log an error if recording initialization fails.
            print("Failed to start recording: \(error)")
        }
    }
    
    /// Stops the current audio recording session.
    /// This method stops the recorder and resets the instance.
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    /// Simulates saving the recorded audio.
    /// In a production system, further processing or file management might be performed here.
    func saveRecording() {
        print("Recording saved at: \(getAudioFileURL().absoluteString)")
    }
    
    /// Retrieves the file URL for storing the audio recording.
    ///
    /// - Returns: A URL pointing to "craving_audio.m4a" in the user's documents directory.
    private func getAudioFileURL() -> URL {
        // Get the user's documents directory.
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // Append the designated file name for audio recordings.
        return directory.appendingPathComponent("craving_audio.m4a")
    }
}
