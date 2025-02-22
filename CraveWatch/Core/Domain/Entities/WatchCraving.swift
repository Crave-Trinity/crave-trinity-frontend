//
//  WatchCraving.swift
//  CraveWatch
//
//  A domain-level model representing a craving on the watch side,
//  separate from the SwiftData persistence model.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation

/// Represents a craving in the domain layer of the watch application.
/// This model is used within business logic and UI layers, separate from the persistence model.
struct WatchCraving {
    /// Unique identifier for the craving.
    let id: UUID
    /// Text description of the craving.
    let text: String
    /// Intensity level of the craving (e.g., on a scale from 1 to 10).
    let intensity: Int
    /// Optional resistance metric associated with the craving.
    let resistance: Int?
    /// Timestamp indicating when the craving was recorded.
    let timestamp: Date
    /// Optional timestamp marking when the craving was soft-deleted.
    let deletedAt: Date?
}
