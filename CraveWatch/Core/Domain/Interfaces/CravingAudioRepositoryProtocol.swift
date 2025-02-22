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

protocol CravingAudioRepositoryProtocol {
    func startRecording()
    func stopRecording()
    func saveRecording()
}
