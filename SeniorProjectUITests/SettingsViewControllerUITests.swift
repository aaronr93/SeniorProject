//
//  SettingsViewControllerUITests.swift
//  Foodini
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

    func testAChangePasswordTap() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Change password"].tap()
        XCTAssertNotNil(app.buttons.elementBoundByIndex(0))
    }
    
    func testBTapSignOut() {
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
    
    func testCUserNameField() {
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.textFields.elementBoundByIndex(0).tap()
    }
    
    func testDPhoneNumberField() {
        
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
    
    func testFCancelConfirmDeleteAccount() {
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Delete account"].tap()
        app.sheets["Confirm Account Removal"].buttons["No"].tap()
        XCTAssertNotNil(app.buttons["Delete account"])
    }
    
    func testGDeleteAccount() {
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Delete account"].tap()
        XCTAssertNotNil(app.sheets["Confirm Account Removal"].buttons["No"])
    }
    
    func testHConfirmDeleteAccount() {
        //Can be tested automatically, but commented out because it's difficult to automate undeleting it, and can't run tests consecutively otherwise
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Delete account"].tap()
        //app.sheets["Confirm Account Removal"].buttons["Yes"].tap()
        //XCTAssertNotNil(app.buttons["Log In"])
       

    }
    
}
