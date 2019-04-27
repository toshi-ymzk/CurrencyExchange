//
//  NumberFormatterTests.swift
//  CurrencyExchangeTests
//
//  Created by Toshihiro Nojima on 2019/04/27.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation

import XCTest
@testable import CurrencyExchange

class NumberFormatterTests: XCTestCase {
    
    func testAddDecimalComma() {
        let formatter = NumberFormatter()
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
        let result = cases.map { formatter.addDecimalComma(str: $0) }
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
