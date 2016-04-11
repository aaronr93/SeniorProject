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

    func testCorrectLogIn() {
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("thisisaaron")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("pass1234")
        
        let login = app.buttons["Login"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        expectationForPredicate(existsPredicate, evaluatedWithObject: login, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        login.tap()
        
        app.buttons.allElementsBoundByIndex[1].tap()
        XCTAssertNotNil(app.buttons["I want food"])
    }
    
    func testIncorrectLogIn(){
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("thisisaaron")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("thisisnotmypassword")
        app.buttons["Login"].tap()
        XCTAssertNotNil(app.buttons["Login"])
    }
    
    func testCorrectPasswordButNoLogin() {
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("pass1234")
        app.buttons["Login"].tap()
        XCTAssertNotNil(app.buttons["Login"])
    }
    
    func testForZombieAccounts() {
        app.buttons["Login"].tap()
        XCTAssertNotNil(app.buttons["Login"])
    }
    
    func testCreateAccountTap() {
        app.buttons["Create Account"].tap()
        XCTAssertNotNil(app.textFields["Phone number"])
    }

}
