// File: AnalyticsPredictionTests.swift
// Purpose: Test suite for prediction functionality

import XCTest
import CoreML
@testable import CRAVE

final class AnalyticsPredictionTests: XCTestCase {
    var predictionEngine: PredictionEngine!
    
    override func setUp() {
        super.setUp()
        predictionEngine = PredictionEngine(configuration: .default)
    }
    
    override func tearDown() {
        predictionEngine = nil
        super.tearDown()
    }
    
    // MARK: - Base Prediction Tests
    func testBasePredictionValidation() {
        let validPrediction = BasePrediction(
            type: .timeBasedCraving,
            confidence: 0.8,
            timeWindow: 3600
        )
        XCTAssertTrue(validPrediction.validate())
        
        let invalidPrediction = BasePrediction(
            type: .timeBasedCraving,
            confidence: 1.5, // Invalid confidence
            timeWindow: -1   // Invalid window
        )
        XCTAssertFalse(invalidPrediction.validate())
    }
    
    // MARK: - Time Prediction Tests
    func testTimePredictionAccuracy() {
        let prediction = TimePrediction(
            hour: 14,
            intensity: 7.0,
            triggers: ["stress", "boredom"],
            confidence: 0.8,
            windowMinutes: 60
        )
        
        // Test with matching actual data
        let matchingAnalytics = CravingAnalytics.mock(
            timestamp: Calendar.current.date(bySettingHour: 14, minute: 15, second: 0, of: Date())!,
            intensity: 7,
            triggers: ["stress"]
        )
        
        let accuracy = prediction.calculateAccuracy(against: matchingAnalytics)
        XCTAssertGreaterThan(accuracy, 0.7) // High accuracy expected
        
        // Test with non-matching actual data
        let nonMatchingAnalytics = CravingAnalytics.mock(
            timestamp: Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!,
            intensity: 3,
            triggers: ["hunger"]
        )
        
        let lowAccuracy = prediction.calculateAccuracy(against: nonMatchingAnalytics)
        XCTAssertLessThan(lowAccuracy, 0.5) // Low accuracy expected
    }
    
    // MARK: - Prediction Engine Tests
    func testPredictionGeneration() async throws {
        // Create historical data
        let historicalData = createHistoricalData()
        
        // Generate prediction
        let prediction = try predictionEngine.generatePrediction(from: historicalData)
        
        // Verify prediction
        XCTAssertTrue(prediction.validate())
        XCTAssertGreaterThanOrEqual(prediction.confidence, 0.0)
        XCTAssertLessThanOrEqual(prediction.confidence, 1.0)
    }
    
    func testInsufficientDataHandling() async {
        let emptyData: [CravingAnalytics] = []
        
        do {
            _ = try predictionEngine.generatePrediction(from: emptyData)
            XCTFail("Expected insufficient data error")
        } catch PredictionError.insufficientData {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Expiration Tests
    func testPredictionExpiration() {
        let prediction = TimePrediction(
            hour: Calendar.current.component(.hour, from: Date()) - 1, // Past hour
            intensity: 5.0,
            triggers: ["test"],
            confidence: 0.8,
            windowMinutes: 60
        )
        
        XCTAssertTrue(prediction.hasExpired())
    }
    
    // MARK: - Helper Methods
    private func createHistoricalData() -> [CravingAnalytics] {
        let today = Date()
        return (0..<10).map { offset in
            let date = Calendar.current.date(byAdding: .hour, value: -offset, to: today)!
            return CravingAnalytics.mock(
                timestamp: date,
                intensity: Double.random(in: 1...10),
                triggers: ["stress", "boredom", "hunger"].randomElement().map { [$0] } ?? []
            )
        }
    }
}

// MARK: - Test Helpers
extension CravingAnalytics {
    static func mock(
        timestamp: Date = Date(),
        intensity: Double = 5.0,
        triggers: Set<String> = ["test_trigger"]
    ) -> CravingAnalytics {
        CravingAnalytics(
            id: UUID(),
            timestamp: timestamp,
            intensity: intensity,
            triggers: triggers,
            metadata: [:]
        )
    }
}

