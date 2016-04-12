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
        
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Testman")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("testpass")
        app.buttons["Go"].tap()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Home"].tap()
    }
    
    func testUserNameField() {
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.textFields.elementBoundByIndex(0).tap()
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
