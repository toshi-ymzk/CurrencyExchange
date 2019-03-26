//
//  CurrencyListInteractorTests.swift
//  CurrencyExchangeTests
//
//  Created by Toshihiro Nojima on 2019/03/26.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class CurrencyListInteractorTests: XCTestCase {
    
    let interactor = CurrencyListInteractor(api: RevolutAPIStub())
    
    func testGetCurrencyList() {
        interactor.getCurrencyList(baseAmount: 1, success: { res in
            XCTAssertTrue(res.count == 33)
            let result = [
                res[0],
                res[1],
                res[res.count - 2],
                res[res.count - 1]
            ]
            let forecasts = [
                CurrencyModel(code: .EUR, rate: 1, amount: 1),
                CurrencyModel(code: .AUD, rate: 1.6234, amount: 1.623),
                CurrencyModel(code: .USD, rate: 1.1684, amount: 1.168),
                CurrencyModel(code: .ZAR, rate: 17.9, amount: 17.9)
            ]
            XCTAssertEqual(result, forecasts)
        }) { err in
            XCTFail()
        }
    }
    
    func testGetCurrencyRates() {
        interactor.getCurrencyRates(success: { res in
            XCTAssertTrue(res.count == 33)
            let result = [
                res[0],
                res[1],
                res[res.count - 2],
                res[res.count - 1]
            ]
            let forecasts = [
                1,
                1.6234,
                1.1684,
                17.9,
            ]
            XCTAssertEqual(result, forecasts)
        }) { err in
            XCTFail()
        }
    }
}
