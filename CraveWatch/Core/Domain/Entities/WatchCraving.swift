//
//  WatchCraving.swift
//  CraveWatch
//
//  A domain-level model representing a craving on the watch side,
//  separate from the SwiftData model.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation

/// A simple domain-level struct for cravings on watch.
/// Uncle Bob: "Entities" in domain differ from database models for separation of concerns.
struct WatchCraving {
    let id: UUID
    let text: String
    let intensity: Int
    let resistance: Int?
    let timestamp: Date
    let deletedAt: Date?
}
