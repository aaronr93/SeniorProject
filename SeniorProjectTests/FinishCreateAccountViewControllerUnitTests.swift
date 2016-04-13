//
//  FinishCreateAccountViewControllerUnitTests.swift
//  Foodini
//
//  Created by Zach Nafziger on 4/3/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class FinishCreateAccountViewControllerUnitTests: XCTestCase {
    let testVC = FinishCreateAccountViewController()
    let testAccount = CreateAccount()
    let date = NSDate()
    let formatter = NSDateFormatter()
    var now:String = ""
    
    override func setUp() {
        super.setUp()
        now = formatter.stringFromDate(date)
        testAccount.username = "testUser\(now)"
        testAccount.password = "pass1234"
        testAccount.passwordConfirm = "pass1234"
        testAccount.email = "\(testAccount.username)@email.com"
        testAccount.phone = "1231234123"
        testAccount.isValidated = true
        testVC.newAccount = testAccount
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNil(testVC.terms)
        XCTAssertNil(testVC.data)
        XCTAssertNotNil(testVC.newAccount)
    }
    
    //no results to be unit tested from finishButtonPressed
    
    //create Account just calls addNewUser and sendToParse
    
    func testAddNewUser(){
        let testUser = PFUser()
        testVC.addNewUser(testUser)
        XCTAssert(testUser.username == "testUser\(now)")
        XCTAssert(testUser.password == "pass1234")
        XCTAssert(testUser.email == "\(testAccount.username)@email.com")
        XCTAssert(testUser["phone"] as! String == "1231234123")
    }
    
    //send to parse should be tested manually
    
    
}
