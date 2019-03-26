//
//  DoubleTests.swift
//  CurrencyExchangeTests
//
//  Created by Toshihiro Nojima on 2019/03/26.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class DoubleTests: XCTestCase {
    
    func testTruncate() {
        let cases: [Double] = [
            0,
            0.01,
            10.012,
            100.0123456789
        ]
        let result = cases.map { $0.truncate(2) }
        let forecasts: [Double] = [
            0,
            0.01,
            10.01,
            100.01
        ]
        XCTAssertEqual(result, forecasts)
    }
}
