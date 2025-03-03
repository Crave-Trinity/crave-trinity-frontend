//
//  CravingModelTests.swift
//  CRAVE
//


import XCTest
@testable import CRAVE

final class CravingModelTests: XCTestCase {
    var sut: CravingModel!
    
    override func setUp() {
        super.setUp()
        sut = CravingModel(cravingText: "Test Craving")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testInitialization() {
        XCTAssertNotNil(sut)
        XCTAssertFalse(sut.isArchived)
        XCTAssertFalse(sut.analyticsProcessed)
    }
    
    // MARK: - Validation Tests
    func testValidation_EmptyText() {
        sut.cravingText = ""
        XCTAssertThrowsError(try sut.validate()) { error in
            XCTAssertEqual(error as? CravingModelError, .emptyText)
        }
    }
    
    // Add more tests...
}

