//
//  NewOrderUITests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/22/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class NewOrderUITests: SeniorProjectUITests {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    func testRestaurantTap() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.staticTexts["Select a Restaurant"].tap()
        app.navigationBars["Select Restaurant"].buttons["New Order"].tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
    }
    
    func testRestaurantDrag() {
        // Unsupported - should do nothing
    }
    
    func testAddFoodItemTap() {
        // Should segue to new screen
    }
    
    func testAddFoodItemDrag() {
        // Unsupported - should do nothing
    }
    
    func testCancelNewOrder() {
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }

}
