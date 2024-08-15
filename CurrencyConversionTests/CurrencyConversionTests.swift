//
//  CurrencyConversionTests.swift
//  CurrencyConversionTests
//
//  Created by Shashi Gupta on 14/08/24.
//

import XCTest
@testable import CurrencyConversion

final class CurrencyConversionTests: XCTestCase {
    
    var currencyService: CurrencyService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        currencyService = CurrencyService()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        currencyService = nil
        super.tearDown()
    }
    
    func testFetchCurrenciesSuccess() throws {
        let expectation = self.expectation(description: "Fetch currencies successful")
        
        currencyService.fetchCurrencies { result in
            switch result {
            case .success(let currencies):
                XCTAssertFalse(currencies.isEmpty, "Currencies should not be empty")
                XCTAssertNotNil(currencies["USD"], "USD currency should be present")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch currencies failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
