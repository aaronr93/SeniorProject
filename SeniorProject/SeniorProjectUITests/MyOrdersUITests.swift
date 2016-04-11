//
//  MyOrdersUITests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 2/26/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
import Parse

class MyOrdersUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGoToMyOrders(){
        //go to the my orders screen and back
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["My orders"].tap()
        app.navigationBars["My Orders"].buttons["Home"].tap()
    }
    
    func testGoToRequests(){
        //go to every order and back
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["My orders"].tap()
        let myOrdersButton = app.navigationBars["Order Info"].buttons["My Orders"]
        for i in 0..<app.tables.cells.count{
            app.tables.cells.elementBoundByIndex(i).tap()
            myOrdersButton.tap()
        }
        app.navigationBars["My Orders"].buttons["Home"].tap()
        
    }
    
    func testSelectSentRequest(){
        
    }
    
    
}
