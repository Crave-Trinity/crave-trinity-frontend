//
//  PatternDetectionServiceProtocol.swift
//  CravePhone
//
//  Description:
//    Domain interface that detects usage patterns within a set
//    of craving events (e.g., times of day, triggers, etc.).
//

import Foundation

public protocol PatternDetectionServiceProtocol: AnyObject {
    func detectPatterns(in events: [CravingEvent]) async throws -> [String]
}
