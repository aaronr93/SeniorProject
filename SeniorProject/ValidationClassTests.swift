//
//  ValidationClassTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/6/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class ValidationClassTests: XCTestCase {
    
    let testValidator = Validation()
    let testErrors = ["Not enough password", "username is offensive", "this is a test"]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testCheckNoValuesForItems(){
        //TODO
        let textFields = [String: String]()
        
        let items = [String : [String : AnyObject]]()
        
        testValidator.check(textFields, items: items)
        
        XCTAssert(testValidator.errors.count == 0)
        
    }
    
    func testCheckEachRuleNoErrors(){
        //TODO
        let rules = ["required", "min", "max", "lengthEqualTo", "doesNotContain", "stringNotEqualTo"]
        
        let fieldName = "password"
        
        let ruleValues = [true, 6, 20, 6, "pass", "password"]
        
        let textFields = [fieldName : "grover"]
        
        var items : [String : [String : AnyObject]] = [fieldName : [String : AnyObject]()]
        
        var rulesWithValues = [String : AnyObject]()
        
        for (index, _) in rules.enumerate() {
            rulesWithValues[rules[index]] = ruleValues[index]
        }
        
        items[fieldName] = rulesWithValues
        
        testValidator.check(textFields, items: items)

        
        XCTAssert(testValidator.errors.count == 0 && testValidator.passed)
        
    }
    
    func testCheckEachRuleAllErrors(){
        //TODO
        let rules = ["min", "max", "lengthEqualTo", "doesNotContain", "stringNotEqualTo"]
        
        let fieldName = "password"
        
        let ruleValues : [AnyObject] = [9, 7, 6, "pass", "password"]
        
        let textFields = [fieldName : "password"]
        
        var items : [String : [String : AnyObject]] = [fieldName : [String : AnyObject]()]
        
        var rulesWithValues = [String : AnyObject]()
        
        for (index, _) in rules.enumerate() {
            rulesWithValues[rules[index]] = ruleValues[index]
        }
        
        items[fieldName] = rulesWithValues
        
        testValidator.check(textFields, items: items)
        
        XCTAssert(testValidator.errors.count == 5 && !testValidator.passed)
        
    }
    
    func testCheckEachRuleForErrorsIndividually(){
        //TODO
        let rules = ["min", "max", "lengthEqualTo", "doesNotContain", "stringNotEqualTo"]
        
        let fieldName = "password"
        
        let ruleValues : [[AnyObject]] = [
            [7, 20, 6, "pass", "password"],
            [2, 5, 6, "pass", "password"],
            [6, 20, 5, "pass", "password"],
            [6, 20, 6, "gro", "password"],
            [6, 20, 6, "pass", "grover"],
        ]
        
        let textFields = [
                [fieldName : "grover"],
                [fieldName : "grover"],
                [fieldName : "grover"],
                [fieldName : "grover"],
                [fieldName : "grover"]
            ]
        
        let errorContainsKeyTerms = ["min", "max", "characters long", "must not contain", "must not equal"]
        
        var items : [String : [String : AnyObject]] = [fieldName : [String : AnyObject]()]
        
        var rulesWithValues = [String : AnyObject]()
        
        for (index, _) in rules.enumerate() {
            for (i, _) in rules.enumerate() {
                rulesWithValues[rules[i]] = ruleValues[index][i]
            }
            items[fieldName] = rulesWithValues
            testValidator.check(textFields[index], items: items)
            
            let doesContainErrorKeyTerm = testValidator.errors.first!.rangeOfString(errorContainsKeyTerms[index]) != nil
            
            XCTAssert(doesContainErrorKeyTerm && !testValidator.passed)
            
            items.removeAll()
            rulesWithValues.removeAll()
            testValidator.errors.removeAll()
        }
        
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
        
        let emailsThatShouldWork = ["nice@gmail.com", "test@test.com", "somethings@j.net"]
        
        let emailsThatShouldNotWork = ["", "@gmail.com", "nice", "@", "gmail.com", "sean @ hon.com"]
        
        for item in emailsThatShouldWork {
            XCTAssertTrue(emailStringFilter(item))
        }
        
        for item in emailsThatShouldNotWork {
            XCTAssertFalse(emailStringFilter(item))
        }
       
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
        XCTAssertTrue(usernameExistsInParse("znafz"))
        
        
    }
    
    
}
