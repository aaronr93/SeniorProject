//
//  LoginViewControllerUITests.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/31/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class LoginViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func signOut(){
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Sign out"].tap()
    }
    
    func signIn(){
        let app = XCUIApplication()
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Testman")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("testpass")
        app.buttons["Go"].tap()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Home"].tap()
        
    }

    func testCorrectLogIn() {
        signOut()
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Testman")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("testpass")
        app.buttons["Go"].tap()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Home"].tap()
    }
    
    func testIncorrectLogIn(){
        signOut()
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Testman")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("thisisnotmypassword")
        app.buttons["Go"].tap()
        app.buttons["Create Account"].tap()
        app.navigationBars["Create Account"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        signIn()
    }
    
    func testCorrectPasswordButNoLogin() {
        signOut()
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("pass1234")
        app.buttons["Go"].tap()
        signIn()
    }
    
    func testForZombieAccounts() {
        signOut()
        XCUIApplication().buttons["Login"].tap()        
        app.buttons["Create Account"].tap()
        app.navigationBars["Create Account"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()

        signIn()
    }
    
    func testCreateAccountTap() {
        signOut()
        app.buttons["Create Account"].tap()
        XCTAssertNotNil(app.textFields["Phone number"])
        app.navigationBars["Create Account"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
        signIn()
    }

}
