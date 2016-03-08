//
//  HomeUITests.swift
//  SeniorProject
//
//  Created by Aaron Rosenberger on 2/22/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class HomeUITests: SeniorProjectUITests {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        //XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    func testNewOrder() {
        
        let app = XCUIApplication()
        app.buttons["I want food"].tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        
    }
    
    func testPickUpFood() {
        let app = XCUIApplication()
        app.buttons["I'm picking up food"].tap()
        app.navigationBars["UITabBar"].buttons["Home"].tap()
    }
    
    func testMyOrders() {
        let app = XCUIApplication()
        let homeNavigationBar = app.navigationBars["Home"]
        homeNavigationBar.buttons["My orders"].tap()
        app.navigationBars["My Orders"].buttons["Home"].tap()
    }
    
    func testSettings() {
        let app = XCUIApplication()
        let homeNavigationBar = app.navigationBars["Home"]
        homeNavigationBar.buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Home"].tap()
    }

}
