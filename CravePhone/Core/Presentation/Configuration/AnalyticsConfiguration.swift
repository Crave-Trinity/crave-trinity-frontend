//AnalyticsConfiguration.swift

import Foundation
import Combine

public final class AnalyticsConfiguration: ObservableObject {
    public static let shared = AnalyticsConfiguration()
    
    @Published public private(set) var currentEnvironment: AppEnvironment = .development
    @Published public private(set) var featureFlags: FeatureFlags = .development
    @Published public private(set) var processingRules: ProcessingRules = ProcessingRules()
    @Published public private(set) var storagePolicy: StoragePolicy = StoragePolicy()
    @Published public private(set) var privacySettings: PrivacySettings = PrivacySettings()
    
    public let performanceConfig: PerformanceConfiguration = PerformanceConfiguration()
    public let networkConfig: NetworkConfiguration = NetworkConfiguration()
    public let mlConfig: MLConfiguration = MLConfiguration()
    
    private init() {}
    
    public func updateEnvironment(_ environment: AppEnvironment) {
        currentEnvironment = environment
        featureFlags = (environment == .production) ? .production : .development
        NotificationCenter.default.post(name: .analyticsConfigurationUpdated, object: nil)
    }
    
    public func updateFeatureFlags(_ flags: FeatureFlags) {
        featureFlags = flags
        NotificationCenter.default.post(name: .analyticsConfigurationUpdated, object: nil)
    }
    
    public func updatePrivacySettings(_ settings: PrivacySettings) async throws {
        guard settings.validate() else {
            throw ConfigurationError.invalidPrivacySettings
        }
        privacySettings = settings
    }
}

public struct FeatureFlags: Codable {
    public var isMLEnabled: Bool
    public var isRealtimeProcessingEnabled: Bool
    public var isBackgroundProcessingEnabled: Bool
    public var isCloudSyncEnabled: Bool
    public var isDebugLoggingEnabled: Bool
    public var isAnalyticsEnabled: Bool
    public var isAutoProcessingEnabled: Bool
    
    public static let development = FeatureFlags(
        isMLEnabled: true,
        isRealtimeProcessingEnabled: true,
        isBackgroundProcessingEnabled: true,
        isCloudSyncEnabled: false,
        isDebugLoggingEnabled: true,
        isAnalyticsEnabled: true,
        isAutoProcessingEnabled: true
    )
    
    public static let production = FeatureFlags(
        isMLEnabled: true,
        isRealtimeProcessingEnabled: true,
        isBackgroundProcessingEnabled: true,
        isCloudSyncEnabled: true,
        isDebugLoggingEnabled: false,
        isAnalyticsEnabled: true,
        isAutoProcessingEnabled: true
    )
}

public struct ProcessingRules: Codable {
    public var batchSize: Int = 100
    public var processingInterval: TimeInterval = 300
    public var maxRetryAttempts: Int = 3
    public var timeoutInterval: TimeInterval = 30
    public var priorityThreshold: Double = 0.7
    
    public func validate() -> Bool {
        return batchSize > 0
    }
}

public struct StoragePolicy: Codable {
    public var retentionPeriod: TimeInterval = 30 * 24 * 3600
    public var maxStorageSize: Int64 = 100 * 1024 * 1024
    public var compressionEnabled: Bool = true
    public var encryptionEnabled: Bool = true
    public var autoCleanupEnabled: Bool = true
    
    public func validate() -> Bool {
        return retentionPeriod > 0
    }
}

public struct PrivacySettings: Codable {
    public var dataCollectionEnabled: Bool = true
    public var locationTrackingEnabled: Bool = false
    public var healthKitEnabled: Bool = false
    public var analyticsEnabled: Bool = true
    public var dataSharingEnabled: Bool = false
    
    public func validate() -> Bool { true }
}

public struct PerformanceConfiguration {
    public let maxConcurrentOperations: Int = 4
    public let maxMemoryUsage: Int64 = 50 * 1024 * 1024
    public let backgroundTaskTimeout: TimeInterval = 180
    public let minimumBatteryLevel: Float = 0.2
}

public struct NetworkConfiguration {
    public let maxRetries: Int = 3
    public let timeout: TimeInterval = 30
    public let batchSize: Int = 50
    public let compressionThreshold: Int = 1024 * 10
}

public struct MLConfiguration {
    public let modelUpdateInterval: TimeInterval = 24 * 3600
    public let minimumConfidence: Double = 0.7
    public let maxPredictionWindow: TimeInterval = 7 * 24 * 3600
    public let trainingDataLimit: Int = 1000
}

public enum AppEnvironment: String, Codable {
    case development, staging, production
}

public enum ConfigurationError: Error {
    case invalidConfiguration, invalidPrivacySettings, invalidProcessingRules, invalidStoragePolicy
}

extension Notification.Name {
    public static let analyticsConfigurationUpdated = Notification.Name("analyticsConfigurationUpdated")
}

public extension AnalyticsConfiguration {
    static var preview: AnalyticsConfiguration {
        let config = AnalyticsConfiguration.shared
        config.updateFeatureFlags(.development)
        return config
    }
}

