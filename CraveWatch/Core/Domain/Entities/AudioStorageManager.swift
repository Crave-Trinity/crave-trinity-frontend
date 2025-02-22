// MARK: - AudioStorageManager.swift
// Manages actual saving and retrieval of audio files

import Foundation
import AVFoundation

class AudioStorageManager {
    private var audioRecorder: AVAudioRecorder?
    
    func startRecording() {
        let url = getAudioFileURL()
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.record()
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func saveRecording() {
        print("Recording saved at: \(getAudioFileURL().absoluteString)")
    }
    
    private func getAudioFileURL() -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent("craving_audio.m4a")
    }
}
