//
//  HomeUITests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/22/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class HomeUITests: XCTestCase {
    
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
    
    func testNewOrder() {
        
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.tables.staticTexts["Select restaurant..."].tap()
        XCTAssertNotNil(app.tables.staticTexts["Select restaurant..."])
    }
    
    func testPickUpFood() {
        let app = XCUIApplication()
        app.buttons["I'm picking up food"].tap()
        app.navigationBars["UITabBar"].buttons["Home"].tap()
    XCTAssertNotNil(app.navigationBars["UITabBar"].buttons["Home"])
    }
    
    func testMyOrders() {
        let app = XCUIApplication()
        let homeNavigationBar = app.navigationBars["Home"]
        homeNavigationBar.buttons["My orders"].tap()
        app.navigationBars["My Orders"].buttons["Home"].tap()
        XCTAssertNotNil(app.navigationBars["My Orders"].buttons["Home"])
    }
    
    func testSettings() {
        let app = XCUIApplication()
        let homeNavigationBar = app.navigationBars["Home"]
        homeNavigationBar.buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Home"].tap()
    XCTAssertNotNil(app.navigationBars["Settings"].buttons["Home"])
    }

}
