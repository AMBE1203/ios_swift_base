//
//  PayBaymaxChallengeTests.swift
//  PayBaymaxChallengeTests
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import XCTest
@testable import PayBaymaxChallenge

class PayBaymaxChallengeTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCurrencyFormat() {
        XCTAssertEqual("10000000".currencyFormatted , "10,000,000.00", "Currency format is wrong")
        XCTAssertEqual("1500075".currencyFormatted , "1,500,075.00", "Currency format is wrong")
        XCTAssertEqual("869689".currencyFormatted , "869,689.00", "Currency format is wrong")
        XCTAssertEqual("6809088".currencyFormatted , "6,809,088.00", "Currency format is wrong")
        XCTAssertEqual("788833".currencyFormatted , "788,833.00", "Currency format is wrong")
        XCTAssertEqual("567889".currencyFormatted , "567,889.00", "Currency format is wrong")
        XCTAssertEqual("3456788".currencyFormatted , "3,456,788.00", "Currency format is wrong")
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
