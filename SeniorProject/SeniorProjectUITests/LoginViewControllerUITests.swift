//
//  LoginViewControllerUITests.swift
//  SeniorProject
//
//  Created by Seth Loew on 3/31/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class LoginViewControllerUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCorrectLogIn() {
        
        let app = XCUIApplication()
        app.textFields["Username"].tap()
        app.textFields["Username"]
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"]
        app.buttons["Login"].tap()
        XCTAssertNotNil(app.buttons["I want food"])
    }
    
    func testIncorrectLogIn(){
        
        let app = XCUIApplication()
        app.textFields["Username"].tap()
        app.textFields["Username"]
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"]
        app.buttons["Login"].tap()
        XCTAssertNotNil(app.buttons["Login"])
    }
    
    func testCorrectPasswordButNoLogin() {
        
        let app = XCUIApplication()
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"]
        app.buttons["Login"].tap()
        XCTAssertNotNil(app.buttons["Login"])
    }
    
    func testForZombieAccounts() {
        
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        XCTAssertNotNil(app.buttons["Login"])
    }
    
    func testCreateAccountTap() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        XCTAssertNotNil(app.textFields["Phone number"])
    }

}
