//
//  StringTests.swift
//  CurrencyExchangeTests
//
//  Created by Toshihiro Nojima on 2019/03/26.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class StringTests: XCTestCase {
    
    func testAddDecimalComma() {
        let cases: [String?] = [
            "0",
            "0.",
            "0.0",
            "0.00",
            "0.000",
            "1000",
            "1000.",
            "1,000",
            "a"
        ]
        let result = cases.map { $0?.addDecimalComma() }
        let forecasts: [String?] = [
            "0",
            "0.",
            "0.0",
            "0.00",
            "0.000",
            "1,000",
            "1,000.",
            nil,
            nil
        ]
        XCTAssertEqual(result, forecasts)
    }
}
