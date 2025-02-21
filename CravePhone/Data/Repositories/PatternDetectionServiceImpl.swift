//
//  PatternDetectionServiceImpl.swift
//  CravePhone
//
//  Description:
//    Detects patterns in craving events, possibly referencing some config.
//

import Foundation

public final class PatternDetectionServiceImpl: PatternDetectionServiceProtocol {
    
    private let storage: AnalyticsStorageProtocol
    private let configuration: AnalyticsConfiguration
    
    // The container calls `PatternDetectionServiceImpl(storage:..., configuration:...)`
    public init(storage: AnalyticsStorageProtocol, configuration: AnalyticsConfiguration) {
        self.storage = storage
        self.configuration = configuration
    }
    
    public func detectPatterns(in events: [CravingEvent]) async throws -> [String] {
        // Use `storage` or `configuration` if needed
        return ["No advanced patterns – implement me!"]
    }
}
