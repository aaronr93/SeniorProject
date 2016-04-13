//
//  CreateAccountUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse
class CreateAccountUnitTests: XCTestCase {
    let testObject = CreateAccount()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNil(testObject.username)
        XCTAssertNil(testObject.password)
        XCTAssertNil(testObject.passwordConfirm)
        XCTAssertNil(testObject.email)
        XCTAssertNil(testObject.phone)
        XCTAssertEqual(testObject.isValidated, false)
    }
    
    func testConfirmPasswordEqualsPassword(){
        let testPasswords:[String?] = ["testpass", "test", nil]
        for pass in testPasswords{
            for confirm in testPasswords{
                testObject.password = pass
                testObject.passwordConfirm = confirm
                let result = testObject.confirmPasswordEqualsPassword()
                if(pass == confirm && pass != nil){
                    XCTAssertTrue(result)
                } else {
                    XCTAssertFalse(result, "confirm = \(confirm), pass = \(pass)")
                }
            }
        }
    }
    
    func testCheckPasswordIsNotHorrible(){
        let testpasswords:[String?] = ["testpass123", "passwordtest", nil]
        let usernames:[String?] = ["testusername", nil]
        for pass in testpasswords{
            for username in usernames{
                testObject.password = pass
                testObject.username = username
                let result = testObject.checkPasswordIsNotHorrible()
                if(pass != nil && username != nil){
                    if(pass == "testpass123"){
                        XCTAssertTrue(result)
                    } else{
                        XCTAssertFalse(result)
                    }
                    
                } else {
                    XCTAssertFalse(result, "pass = \(pass)")
                }
            }
        }
    }
    
}
