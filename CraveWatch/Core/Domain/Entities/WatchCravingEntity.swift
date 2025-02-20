//
//  WatchCravingEntity.swift
//  CraveWatch
//
//  Description:
//  SwiftData model for storing a single craving.
//  Note: Currently SwiftData requires using a class and providing an initializer.
//
//  Created by [Your Name] on [Date].
//

import Foundation
import SwiftData

@Model
final class WatchCravingEntity {
    var text: String      // The craving text
    var intensity: Int    // E.g. 1...10
    var timestamp: Date   // The date/time when logged

    init(text: String, intensity: Int, timestamp: Date) {
        self.text = text
        self.intensity = intensity
        self.timestamp = timestamp
    }
}

