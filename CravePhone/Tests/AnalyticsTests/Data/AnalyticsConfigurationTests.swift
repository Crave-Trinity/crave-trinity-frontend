// Associated Test File: AnalyticsConfigurationTests.swift

import XCTest
@testable import CRAVE

final class AnalyticsConfigurationTests: XCTestCase {
    var sut: AnalyticsConfiguration!
    
    override func setUp() {
        super.setUp()
        sut = AnalyticsConfiguration.preview
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Environment Tests
    func testEnvironmentUpdate() {
        sut.updateEnvironment(.production)
        XCTAssertEqual(sut.currentEnvironment, .production)
    }
    
    // MARK: - Feature Flags Tests
    func testFeatureFlagsUpdate() {
        let newFlags = FeatureFlags(
            isMLEnabled: false,
            isRealtimeProcessingEnabled: true,
            isBackgroundProcessingEnabled: false,
            isCloudSyncEnabled: true,
            isDebugLoggingEnabled: false
        )
        
        sut.updateFeatureFlags(newFlags)
        XCTAssertEqual(sut.featureFlags.isMLEnabled, false)
        XCTAssertEqual(sut.featureFlags.isCloudSyncEnabled, true)
    }
    
    // MARK: - Processing Rules Tests
    func testProcessingRulesValidation() {
        var rules = ProcessingRules()
        XCTAssertTrue(rules.validate())
        
        rules.batchSize = 0
        XCTAssertFalse(rules.validate())
    }
    
    // MARK: - Storage Policy Tests
    func testStoragePolicyValidation() {
        var policy = StoragePolicy()
        XCTAssertTrue(policy.validate())
        
        policy.retentionPeriod = -1
        XCTAssertFalse(policy.validate())
    }
    
    // MARK: - Privacy Settings Tests
    func testPrivacySettingsUpdate() async {
        let newSettings = PrivacySettings(
            dataCollectionEnabled: true,
            locationTrackingEnabled: false,
            healthKitEnabled: true,
            analyticsEnabled: true,
            dataSharingEnabled: false
        )
        
        do {
            try await sut.updatePrivacySettings(newSettings)
            XCTAssertEqual(sut.privacySettings.healthKitEnabled, true)
            XCTAssertEqual(sut.privacySettings.locationTrackingEnabled, false)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Performance Tests
    func testConfigurationPerformance() {
        measure {
            for _ in 0..<100 {
                sut.updateEnvironment(.development)
                sut.updateFeatureFlags(.development)
            }
        }
    }
}

