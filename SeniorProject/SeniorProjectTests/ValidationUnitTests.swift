//
//  ValidationUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/11/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class ValidationUnitTests: XCTestCase {
    
    let testValidator = Validation()
    let testErrors = ["Not enough password", "username is offensive", "this is a test"]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testValidator.errors)
        XCTAssertFalse(testValidator.passed)
    }
    
    func testAddError(){
        //testing the addError function by adding several errors and testing that the error object contains them
        for i in 0..<testErrors.count{
            testValidator.addError(testErrors[i])
        }
        for i in 0..<testErrors.count{
            XCTAssert(testErrors[i] == testValidator.errors[i])
        }
        
    }
    
    func testCheck(){
        //TODO
    }
    
    func testValidatedPassword(){
        //test the validatedPassword function with positive and negative cases
        
        //test a valid password
        XCTAssertTrue(validatedPassword("1234567"))
        
        //test invalid passwords
        
        //less than 6
        XCTAssertFalse(validatedPassword("1234"))
        
        //more than 20
        XCTAssertFalse(validatedPassword("123456789012345678901"))
        
        //empty string
        XCTAssertFalse(validatedPassword(""))
        
    }
    
    func testValidatedPhoneNumber(){
        //test the validatedPhoneNumber function with positive and negative cases
        
        //test a valid phone number
        XCTAssertTrue(validatedPhoneNumber("6664206969"))
        
        //test invalid passwords
        
        //wrong length
        XCTAssertFalse(validatedPhoneNumber("420"))
        
        //non-number characters
        XCTAssertFalse(validatedPhoneNumber("66642TEST9"))
        
        //empty string
        XCTAssertFalse(validatedPhoneNumber(""))
    }
    
    func testValidatedEmail(){
        //we don't need this function... it's just running emailStringFilter and returning the result
    }
    
    func testEmailStringFilter(){
        //TODO - not sure how this is working
    }
    
    func testValidatedUsername(){
        //test the validatedUsername function with positive and negative cases
        
        //create a testUser based on the date/time so it's guaranteed not to exist in parse
        let date = NSDate() //get the time, in this case the time an object was created.
        //format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM:dd:yy:hh:mm" //format style. Browse online to get a format that fits your needs.
        let dateString = dateFormatter.stringFromDate(date)
        let testUsername = "TEST\(dateString)"
        
        //test a valid username
        XCTAssertTrue(validatedUsername(testUsername))
        
        //test invalid passwords
        
        //less than 4
        XCTAssertFalse(validatedUsername("123"))
        
        //more than 20
        XCTAssertFalse(validatedUsername("123456789012345678901"))
        
        //empty string
        XCTAssertFalse(validatedUsername(""))
    }
    
    func testUsernameExistsInParse(){
        //test the usernameExistsInParse function with positive and negative cases
        
        //create a testUser based on the date/time so it's guaranteed not to exist in parse
        let date = NSDate() //get the time, in this case the time an object was created.
        //format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM:dd:yy:hh:mm" //format style. Browse online to get a format that fits your needs.
        let dateString = dateFormatter.stringFromDate(date)
        let testUsername = "TEST\(dateString)"
        
        //non existent username
        XCTAssertFalse(usernameExistsInParse((testUsername)))
        
        //existing username
        XCTAssertTrue(usernameExistsInParse("kamsibler"))
        
        
    }
    
}
