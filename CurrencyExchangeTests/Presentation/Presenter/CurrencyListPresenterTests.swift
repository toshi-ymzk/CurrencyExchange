//
//  CurrencyListPresenterTests.swift
//  CurrencyExchangeTests
//
//  Created by Toshihiro Nojima on 2019/03/26.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class CurrencyListPresenterTests: XCTestCase {
    
    let presenter = CurrencyListPresenter(
        view: nil,
        interactor: CurrencyListInteractor(api: RevolutAPIStub()),
        router: CurrencyListRouter(view: nil))
    
    func testGetCurrencyList() {
        let expect = XCTestExpectation(description: "getCurrencyList")
        presenter.getCurrencyList()
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: DispatchTime.now() + 0.5) {
            XCTAssertTrue(self.presenter.currencyList.count == 32)
            XCTAssertNotNil(self.presenter.timer)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1)
    }
    
    func testUpdateCurrencyRates() {
        presenter.selectedIndex = 0
        presenter.baseAmount = 1
        presenter.currencyList = [
            CurrencyModel(code: .EUR, rate: 1, amount: presenter.baseAmount),
            CurrencyModel(code: .AUD, rate: 1, amount: presenter.baseAmount),
            CurrencyModel(code: .USD, rate: 1, amount: presenter.baseAmount),
            CurrencyModel(code: .ZAR, rate: 1, amount: presenter.baseAmount)
        ]
        presenter.updateCurrencyRates(rates: [
            1,
            1.6234,
            1.1684,
            17.9
        ])
        let forecasts = [
            CurrencyModel(code: .EUR, rate: 1, amount: 1),
            CurrencyModel(code: .AUD, rate: 1.6234, amount: 1.623),
            CurrencyModel(code: .USD, rate: 1.1684, amount: 1.168),
            CurrencyModel(code: .ZAR, rate: 17.9, amount: 17.9)
        ]
        XCTAssertEqual(presenter.currencyList, forecasts)
    }
    
    func testSetBaseAmount() {
        presenter.selectedIndex = 0
        presenter.baseAmount = 1
        presenter.currencyList = [
            CurrencyModel(code: .EUR, rate: 1, amount: presenter.baseAmount),
            CurrencyModel(code: .AUD, rate: 1.6234, amount: 1.623),
            CurrencyModel(code: .USD, rate: 1.1684, amount: 1.168),
            CurrencyModel(code: .ZAR, rate: 17.9, amount: 17.9)
        ]
        presenter.setBaseAmount(amount: 100)
        let forecasts = [
            CurrencyModel(code: .EUR, rate: 1, amount: 100.0),
            CurrencyModel(code: .AUD, rate: 1.6234, amount: 162.34),
            CurrencyModel(code: .USD, rate: 1.1684, amount: 116.84),
            CurrencyModel(code: .ZAR, rate: 17.9, amount: 1789.999)
        ]
        XCTAssertEqual(presenter.currencyList, forecasts)
    }
    
    func testDidChangeText() {
        let cases: [String] = [
            "",
            "0",
            "01"
        ]
        let result = cases.map { c -> String in
            var text = c
            return presenter.didChangeText(&text)
        }
        let forecasts: [String] = [
            "0",
            "0",
            "1"
        ]
        XCTAssertEqual(result, forecasts)
    }
    
    func testShouldChangeText() {
        let cases: [(text: String, replacement: String)] = [
            // Success cases
            ("0", "."),
            ("0.01", "1"),
            ("1000000", "1"),
            
            // False cases
            ("0.1", "."),
            ("0.001", "1"),
            ("100000000", "1")
        ]
        let result = cases.map { presenter.shouldChangeText($0.text, replacement: $0.replacement) }
        let forecasts: [Bool] = [
            true,
            true,
            true,
            
            false,
            false,
            false
        ]
        XCTAssertEqual(result, forecasts)
    }
}
