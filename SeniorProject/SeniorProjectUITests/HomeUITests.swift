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
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    func newOrder() {
        XCUIApplication().buttons["I want food"].tap()
        XCUIApplication().navigationBars["UITabBar"].buttons["Home"].tap()
    }
    
    func pickUpFood() {
        XCUIApplication().buttons["I'm picking up food"].tap()
        XCUIApplication().navigationBars["UITabBar"].buttons["Home"].tap()
    }
    
    func myOrders() {
        XCUIApplication().navigationBars["Home"].buttons["My orders"].tap()
        XCUIApplication().navigationBars["UITabBar"].buttons["Home"].tap()
    }
    
    func settings() {
        XCUIApplication().navigationBars["Home"].buttons["My orders"].tap()
        XCUIApplication().navigationBars["UITabBar"].buttons["Home"].tap()
    }

}
