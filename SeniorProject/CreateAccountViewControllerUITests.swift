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
        
        func testEnterUsername() {
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.textFields["Username"].tap()
            app.textFields["Username"]
            
        }
        
        func testEnterPhoneNumber() {
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.textFields["Phone number"].tap()
            app.textFields["Phone number"]
            
        }
        
        func testEnterEmail() {
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.textFields["Email address"].tap()
            app.textFields["Email address"]
            
        }
        
        func testEnterPassword() {
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.secureTextFields["Password"].tap()
            app.secureTextFields["Password"]
            
        }
        
        func testNextButtonFilledOutCorrectly() {

            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            let username = app.textFields["Username"]
            app.textFields["Username"].tap()
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
            
            app.buttons["Next"].tap()
            
            let switch2 = app.switches["0"]
            XCTAssertNotNil(switch2)
        }
        
        func testNextButtonNotFilledOutCorrectly() {
            
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.textFields["Username"].tap()
            app.textFields["Username"]
            app.textFields["Phone number"].tap()
            app.textFields["Phone number"]
            app.textFields["Email address"].tap()
            app.textFields["Email address"]
            app.secureTextFields["Password"].tap()
            app.secureTextFields["Password"]
            app.secureTextFields["Confirm Password"].tap()
            app.secureTextFields["Confirm Password"]
            app.buttons["Next"].tap()
            XCTAssertNotNil(app.buttons["Next"])
        }
        
        func testNextButtonIfThingsNotFilledOut() {
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.buttons["Next"].tap()
            XCTAssertNotNil(app.secureTextFields["Confirm Password"])
            
        }
        
        func testIAgreeCheckmark() {
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.textFields["Username"].tap()
            app.textFields["Username"]
            app.textFields["Phone number"].tap()
            app.textFields["Phone number"]
            app.textFields["Email address"].tap()
            app.textFields["Email address"]
            app.secureTextFields["Password"].tap()
            app.secureTextFields["Password"]
            app.secureTextFields["Confirm Password"].tap()
            app.secureTextFields["Confirm Password"]
            app.buttons["Next"].tap()
            
            
        }
        
        func testSendDataToGooeyCheckmark() {
            
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.textFields["Username"].tap()
            app.textFields["Username"]
            app.textFields["Phone number"].tap()
            app.textFields["Phone number"]
            app.textFields["Email address"].tap()
            app.textFields["Email address"]
            
            let passwordSecureTextField = app.secureTextFields["Password"]
            passwordSecureTextField.tap()
            app.secureTextFields["Password"]
            
            let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
            confirmPasswordSecureTextField.tap()
            app.secureTextFields["Confirm Password"]
            
            let nextButton = app.buttons["Next"]
            nextButton.tap()
            passwordSecureTextField.tap()
            passwordSecureTextField.tap()
            app.secureTextFields["Password"]
            confirmPasswordSecureTextField.tap()
            app.secureTextFields["Confirm Password"]
            nextButton.tap()
            nextButton.tap()
            nextButton.tap()
            passwordSecureTextField.tap()
            passwordSecureTextField.tap()
            app.secureTextFields["Password"]
            confirmPasswordSecureTextField.tap()
            app.secureTextFields["Confirm Password"]
            nextButton.tap()
            app.switches["1"].tap()
            app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Switch).matchingIdentifier("0").elementBoundByIndex(1).tap()
            XCTAssertNotNil(app.switches["1"])
        }
        
        func testFinishButtonWithUnCheckedTerms() {
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.textFields["Username"].tap()
            app.textFields["Username"]
            app.textFields["Phone number"].tap()
            app.textFields["Phone number"]
            app.textFields["Email address"].tap()
            app.textFields["Email address"]
            app.secureTextFields["Password"].tap()
            app.secureTextFields["Password"]
            app.secureTextFields["Confirm Password"].tap()
            app.secureTextFields["Confirm Password"]
            app.buttons["Next"].tap()
            app.buttons["Finish"].tap()
            XCTAssertNotNil(app.buttons["Finish"])
            
        }
        
        func testFinishButtonWithCheckedTerms() {
            
            let app = XCUIApplication()
            app.buttons["Create Account"].tap()
            app.textFields["Username"].tap()
            app.textFields["Username"]
            app.textFields["Phone number"].tap()
            app.textFields["Phone number"]
            app.textFields["Email address"].tap()
            app.textFields["Email address"]
            app.secureTextFields["Password"].tap()
            app.secureTextFields["Password"]
            app.secureTextFields["Confirm Password"].tap()
            app.secureTextFields["Confirm Password"]
            app.buttons["Next"].tap()
            app.switches["0"].tap()
            app.buttons["Finish"].tap()
            
        }
    
    func testFinishButtonUncheckedTermsCheckedData() {
        
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Username"].tap()
        let username = app.textFields["Username"]
        username.typeText("example")
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
        app.buttons["Next"].tap()
        app.buttons["Finish"].tap()
        XCTAssertNotNil(app.buttons["Finish"])
    }
    
    func testCheckedTermsUncheckedData(){
        let app = XCUIApplication()
        app.buttons["Create Account"].tap()
        app.textFields["Username"].tap()
        let username = app.textFields["Username"]
        username.typeText("example")
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
        app.buttons["Next"].tap()
        app.buttons["Finish"].tap()
        XCTAssertNotNil(app.buttons["Finish"])
    }
    
    
}
