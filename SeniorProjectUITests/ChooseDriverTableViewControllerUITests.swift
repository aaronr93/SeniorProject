//
//  ChooseDriverTableViewControllerUITests.swift
//  Foodini
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
        XCUIApplication().launch()
        

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }


    func testSelectDriver() {
        app.buttons["I want food"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Select restaurant..."].tap()
        tablesQuery.staticTexts.elementBoundByIndex(0).tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        app.sheets["Cancel"].buttons["No"].tap()
        tablesQuery.staticTexts["Select a driver..."].tap()
        tablesQuery.staticTexts["Any driver"].tap()
        tablesQuery.cells.elementBoundByIndex(2).tap()
        XCUIApplication().tables.cells.elementBoundByIndex(1).tap()
        app.navigationBars["New Order"].buttons["Cancel"].tap()
        app.sheets["Cancel"].buttons["Yes"].tap()
        
    }
}
