//
//  UIColorTests.swift
//  CurrencyExchangeTests
//
//  Created by Toshihiro Nojima on 2019/03/26.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class UIColorTests: XCTestCase {
    
    func testHexColor() {
        let cases: [UInt32] = [
            0x000000,
            0xFF0000,
            0x00FF00,
            0x0000FF,
            0xFFFFFF
        ]
        let result = cases.map { UIColor.hexColor($0) }
        let forecasts: [UIColor] = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1),
            UIColor(red: 1, green: 0, blue: 0, alpha: 1),
            UIColor(red: 0, green: 1, blue: 0, alpha: 1),
            UIColor(red: 0, green: 0, blue: 1, alpha: 1),
            UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        ]
        XCTAssertEqual(result, forecasts)
    }
}
