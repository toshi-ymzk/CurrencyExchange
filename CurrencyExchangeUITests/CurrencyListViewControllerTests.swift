//
//  CurrencyListViewControllerTests.swift
//  CurrencyExchangeUITests
//
//  Created by Toshihiro Yamazaki on 2019/06/11.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import XCTest

class CurrencyListViewControllerTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAnimateCell() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        let headerImage = app.windows.containing(.any, identifier: "HeaderView").images.firstMatch
        XCTAssertTrue(headerImage.exists)
        
        let id = "CAD"
        app.tables.cells.containing(.image, identifier:id).children(matching: .textField).element.tap()
        let exp = expectation(description: "cell animation")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            exp.fulfill()
        }
        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        XCTAssertEqual(result, .completed)
        XCTAssertEqual(headerImage.identifier, id)
    }
    
}
