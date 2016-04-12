//
//  DriversOrdersUITests.swift
//  SeniorProject
//
//  Created by Michael Kytka on 2/29/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class DriversOrdersUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testrequestsForMeTap() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["My orders"].tap()
        
    }
}
