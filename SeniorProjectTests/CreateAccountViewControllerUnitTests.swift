//
//  CreateAccountViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class CreateAccountViewControllerUnitTests: XCTestCase {
    let testVC = CreateAccountViewController()
    override func setUp() {
        super.setUp()
        testVC.usernameField = UITextField()
        testVC.emailField = UITextField()
        testVC.phoneNumberField = UITextField()
        testVC.passwordField = UITextField()
        testVC.confirmPasswordField = UITextField()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testVC.usernameField)
        XCTAssertNotNil(testVC.emailField)
        XCTAssertNotNil(testVC.phoneNumberField)
        XCTAssertNotNil(testVC.passwordField)
        XCTAssertNotNil(testVC.confirmPasswordField)
        XCTAssertNotNil(testVC.newAccount)
    }
    
    //touchedInFieldResetHighlight calls another function that is already being unit tested
    
    func testUsernameChanged(){
        let testField = UITextField()
        testField.text = "testusername"
        testVC.usernameField.text = "testusername"
        testVC.usernameChanged(testField)
        XCTAssertEqual(testVC.newAccount.username, "testusername")
    }
    
    //usernameEditComplete calls another function
    
    func testPhoneNumberChanged(){
        let testField = UITextField()
        testField.text = "1231231234"
        testVC.phoneNumberField.text = "1231231234"
        testVC.phoneNumberChanged(testField)
        XCTAssertEqual(testVC.newAccount.phone, "1231231234")
    }
    
    //phoneNumberEditComplete calls another function
    
    func testEmailChanged(){
        let testField = UITextField()
        testField.text = "test@test.com"
        testVC.emailField.text = "test@test.com"
        testVC.emailChanged(testField)
        XCTAssertEqual(testVC.newAccount.email, "test@test.com")
    }
    
    //emailEditComplete calls another function
    
    func testPasswordChanged(){
        let testField = UITextField()
        testField.text = "testpass1234"
        testVC.passwordField.text = "testpass1234"
        testVC.passwordChanged(testField)
        XCTAssertEqual(testVC.newAccount.password, "testpass1234")
        XCTAssertEqual(testVC.confirmPasswordField.text, "")
        
    }
    
    //passwordEditComplete calls another function
    
    func testConfirmPasswordChanged(){
        let testField = UITextField()
        testField.text = "testpass1234"
        testVC.confirmPasswordField.text = "testpass1234"
        testVC.confirmPasswordChanged(testField)
        XCTAssertEqual(testVC.newAccount.passwordConfirm, "testpass1234")
    }
    
    //confirmPasswordEditComplete calls other functions
    
    //nextButtonPressed can't be unit tested
    
    func testValidate(){
        testUsernameChanged()
        testPhoneNumberChanged()
        testEmailChanged()
        testPasswordChanged()
        testConfirmPasswordChanged()
        testVC.validate()
        XCTAssertEqual(testVC.newAccount.isValidated, true)
    }
    
    //textFieldShouldReturn can't be unit tested
    
    func testCreateBorder(){
        let testLayer = CALayer()
        let testColor = UIColor.blackColor()
        let resultLayer = testVC.createBorder(testLayer, borderWidth: 1.0, color: testColor)
        let color = CGColorEqualToColor(resultLayer?.borderColor, testColor.CGColor)
        XCTAssertTrue(color)
        XCTAssertEqual(resultLayer?.borderWidth, 1.0)
        
        func createBorder(layer: CALayer,borderWidth: Double,color: UIColor) -> CALayer? {
            let borderWidthL = CGFloat(borderWidth)
            layer.borderColor = color.CGColor
            layer.borderWidth = borderWidthL
            
            return layer
        }
    }
    
    // no easy way to unit test addBorderToTextField
    
    //nothing that needs tested for viewDidLoad
    
    //touchesBegan can't be Unit Tested
    
    //prepareForSegue can't be unit tested
}
