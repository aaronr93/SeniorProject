//
//  CreateAccountViewControllerUITests.swift
//  SeniorProject
//
//  Created by Seth Loew on 4/10/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest

class CreateAccountViewControllerUITests: XCTestCase {
        
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
        
    func testAEnterUsername() {
        
        
        let app = XCUIApplication()
        app.navigationBars["Home"].buttons["Settings"].tap()
        app.buttons["Sign out"].tap()
        app.buttons["Create Account"].tap()
        app.textFields["Name"].tap()
        let name = app.textFields["Name"]
        name.typeText("Test")
        
    }
    
    func testBEnterPhoneNumber() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Phone number"].tap()
        let phone = app.textFields["Phone number"]
        phone.typeText("6102233234")
    }
    
    func testCEnterEmail() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Email address"].tap()
        let email = app.textFields["Email address"]
        email.typeText("test@gmail.com")
    }
    
    func testDEnterPassword() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.secureTextFields["Password"].tap()
        let password = app.secureTextFields["Password"]
        password.typeText("testpassword")
    }
    
    func testENextButtonFilledOutCorrectly() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        let username = app.textFields["Name"]
        app.textFields["Name"].tap()
        username.typeText("example4")
        let phone_number = app.textFields["Phone number"]
        app.textFields["Phone number"].tap()
        phone_number.typeText("6102233322")
        app.textFields["Email address"].tap()
        let email = app.textFields["Email address"]
        email.typeText("example4@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("January")
        
        let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("January")
        app.typeText("\n")
        app.buttons["Next"].tap()
        
        let switch2 = app.switches["0"]
        XCTAssertNotNil(switch2)
    }
    
    func testFNextButtonNotFilledOutCorrectly() {
        
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        let username = app.textFields["Name"]
        app.textFields["Name"].tap()
        username.typeText("example4")
        let phone_number = app.textFields["Phone number"]
        app.textFields["Phone number"].tap()
        phone_number.typeText("6102233322")
        app.textFields["Email address"].tap()
        let email = app.textFields["Email address"]
        email.typeText("example4@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("January")
        
        let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("Januar")
        app.typeText("\n")
        app.buttons["Next"].tap()
        XCTAssertNotNil(app.buttons["Next"])
    }
    
    func testGNextButtonIfThingsNotFilledOut() {
        
        
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        
        let returnButton = app.buttons["Return"]
        returnButton.tap()
        app.textFields["Phone number"]
        
        let deleteKey = app.keys["Delete"]
        deleteKey.tap()
        deleteKey.tap()
        app.secureTextFields["Confirm Password"].tap()
        returnButton.tap()
        app.secureTextFields["Confirm Password"]
        app.buttons["Next"].tap()
        XCTAssertNotNil(app.buttons["Next"])
        
    }
    
    func testHIAgreeCheckmark() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Name"].tap()
        let username = app.textFields["Name"]
        username.typeText("example5")
        app.textFields["Phone number"].tap()
        let phone = app.textFields["Phone number"]
        phone.typeText("6192233432")
        app.textFields["Email address"].tap()
        let email = app.textFields["Email address"]
        email.typeText("example@gmail.com")
        app.secureTextFields["Password"].tap()
        let password = app.secureTextFields["Password"]
        password.typeText("january")
        app.secureTextFields["Confirm Password"].tap()
        let confirm = app.secureTextFields["Confirm Password"]
        confirm.typeText("january")
        app.typeText("\n")
        app.buttons["Next"].tap()
        app.switches["0"].tap()
        app.buttons["Finish"].tap()
        XCTAssertNotNil(app.buttons["Login"])
        
        
    }
    
    func testISendDataToGooeyCheckmark() {
        
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Name"].tap()
        let username = app.textFields["Name"]
        username.typeText("example2")
        app.textFields["Phone number"].tap()
        let phone = app.textFields["Phone number"]
        phone.typeText("6192233432")
        app.textFields["Email address"].tap()
        let email = app.textFields["Email address"]
        email.typeText("example@gmail.com")
        app.secureTextFields["Password"].tap()
        let password = app.secureTextFields["Password"]
        password.typeText("january")
        app.secureTextFields["Confirm Password"].tap()
        let confirm = app.secureTextFields["Confirm Password"]
        confirm.typeText("january")
        app.typeText("\n")
        app.buttons["Next"].tap()
        app.switches["1"].tap()
        XCTAssertNotNil(app.switches["1"])
    }
    
    
    func testJFinishButtonWithCheckedTerms() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Name"].tap()
        let username = app.textFields["Name"]
        username.typeText("example3")
        app.textFields["Phone number"].tap()
        let phone = app.textFields["Phone number"]
        phone.typeText("6192233432")
        app.textFields["Email address"].tap()
        let email = app.textFields["Email address"]
        email.typeText("example@gmail.com")
        app.secureTextFields["Password"].tap()
        let password = app.secureTextFields["Password"]
        password.typeText("january")
        app.secureTextFields["Confirm Password"].tap()
        let confirm = app.secureTextFields["Confirm Password"]
        confirm.typeText("january")
        app.typeText("\n")
        app.buttons["Next"].tap()
        app.switches["0"].tap()
        app.buttons["Finish"].tap()
        XCTAssertNotNil(app.buttons["Login"])
        
        
    }
    
    func testKFinishButtonUncheckedTermsCheckedData() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Name"].tap()
        let username = app.textFields["Name"]
        username.typeText("example4")
        app.textFields["Phone number"].tap()
        let phone = app.textFields["Phone number"]
        phone.typeText("6192233432")
        app.textFields["Email address"].tap()
        let email = app.textFields["Email address"]
        email.typeText("example@gmail.com")
        app.secureTextFields["Password"].tap()
        let password = app.secureTextFields["Password"]
        password.typeText("january")
        app.secureTextFields["Confirm Password"].tap()
        let confirm = app.secureTextFields["Confirm Password"]
        confirm.typeText("january")
        app.typeText("\n")
        app.buttons["Next"].tap()
        app.buttons["Finish"].tap()
        XCTAssertNotNil(app.buttons["Finish"])
        
    }
    
    func testLCheckedTermsUncheckedData(){
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Name"].tap()
        let username = app.textFields["Name"]
        username.typeText("example4")
        app.textFields["Phone number"].tap()
        let phone = app.textFields["Phone number"]
        phone.typeText("6192233432")
        app.textFields["Email address"].tap()
        let email = app.textFields["Email address"]
        email.typeText("example@gmail.com")
        app.secureTextFields["Password"].tap()
        let password = app.secureTextFields["Password"]
        password.typeText("january")
        app.secureTextFields["Confirm Password"].tap()
        let confirm = app.secureTextFields["Confirm Password"]
        confirm.typeText("january")
        app.typeText("\n")
        app.buttons["Next"].tap()
        app.buttons["Finish"].tap()
        XCTAssertNotNil(app.buttons["Log In"])
    }
    
    
}
