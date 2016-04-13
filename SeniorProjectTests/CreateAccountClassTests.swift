//
//  CreateAccountClassTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/6/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class CreateAccountClassTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateAccountFieldsSet(){
        //create an instance and check that the fields have been properly set
        let testAccount = CreateAccount()
        testAccount.username = "test"
        testAccount.password = "pass1234"
        testAccount.passwordConfirm = "pass1234"
        testAccount.phone = "1234567890"
        testAccount.isValidated = false
        XCTAssertNotNil(testAccount.username)
        XCTAssertNotNil(testAccount.password)
        XCTAssertNotNil(testAccount.passwordConfirm)
        XCTAssertNotNil(testAccount.phone)
        XCTAssertNotNil(testAccount.isValidated)
        
    }
    
    func testCheckPasswordIsNotHorrible(){
        //test the checkPasswordIsNotHorrible function with positive and negative cases
        let testAccount = CreateAccount()
        testAccount.username = "test"
        testAccount.password = "pass1234"
        testAccount.passwordConfirm = "pass1234"
        testAccount.phone = "1234567890"
        testAccount.isValidated = false
        XCTAssertTrue(testAccount.checkPasswordIsNotHorrible())
        testAccount.password = testAccount.username
        XCTAssertFalse(testAccount.checkPasswordIsNotHorrible())
        testAccount.password = "password"
        XCTAssertFalse(testAccount.checkPasswordIsNotHorrible())
        
    }
    
    func testConfirmPasswordEqualsPassword(){
        //test the confirmPasswordEqualsPassword function with positive and negative cases
        let testAccount = CreateAccount()
        testAccount.username = "test"
        testAccount.password = "pass1234"
        testAccount.passwordConfirm = "pass1234"
        testAccount.phone = "1234567890"
        testAccount.isValidated = false
        XCTAssertTrue(testAccount.confirmPasswordEqualsPassword())
        testAccount.password = "1234"
        XCTAssertFalse(testAccount.confirmPasswordEqualsPassword())
    }
    
    
    
}
