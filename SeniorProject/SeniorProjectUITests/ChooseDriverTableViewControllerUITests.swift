//
//  ChooseDriverTableViewControllerUITests.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/29/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class ChooseDriverTableViewControllerUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Restaurant Name").childrenMatchingType(.Button).element.tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
    }

    func testSelectAnyDriverWithNoDriverPreselected() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Restaurant Name").childrenMatchingType(.Button).element.tap()
        XCTAssertNil(app.textFields["Restaurant Name"])
    }

    func testSelectAnyDriverWithDriverPreselected() {
        let app = XCUIApplication()
        
        app.launch()
        app.buttons["I want food"].tap()
        app.tables.otherElements.containingType(.StaticText, identifier:"Restaurant Name").childrenMatchingType(.Button).element.tap()
        XCTAssertNil(app.textFields["Restaurant Name"])
    }
}
