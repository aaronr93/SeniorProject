//
//  SettingsViewControllerUITests.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/29/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class SettingsViewControllerUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testChangePasswordTap() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Change password"].tap()
        XCTAssertNotNil(app.buttons.elementBoundByIndex(0))
    }
    
    func testTapSignOut() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Sign out"].tap()
        XCTAssertNotNil(app.buttons["Login"])
    }

    func testUserNameField() {
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.textFields["add name here"].tap()
        XCTAssertNotNil(app.textFields["add name here."])
    }
    
    func testPhoneNumberField() {
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.textFields["add phone number here"].tap()
        XCTAssertNotNil(app.textFields["add phone number here"])
    }
    
    func testEmailAddressField() {
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.textFields["add email address here"].tap()
        XCTAssertNotNil(app.textFields["add email address here"])
    }
}
