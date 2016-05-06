//
//  eventbriteSearcherSwiftTests.swift
//  eventbriteSearcherSwiftTests
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import XCTest
@testable import eventbriteSearcherSwift

class eventbriteSearcherSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAsyncApiSearch() {
        
        let expectation = self.expectationWithDescription("Search Results")
        
        ApiClient.sharedInstance.searchEvents("", sinceDate: NSDate(), latitude: nil, longitude: nil, pageNumber: 0) { result in
            
            switch result {
                
            case .Failure( _):
                XCTFail()
                break
                
            case .Success(let data):
                XCTAssertNotNil(data)
                break
            }
            
            expectation.fulfill()
        }
    
        waitForExpectationsWithTimeout(100.0) { error in
            if let error = error {
                print("Timeout Error: %@", error)
            }
        }
    }
    
}
