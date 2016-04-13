//
//  SettingsViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/5/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class SettingsViewControllerUnitTests: XCTestCase {
    let testObject = SettingsViewController()
    override func setUp() {
        super.setUp()
        testObject.phoneField = UITextField()
        testObject.emailField = UITextField()
        testObject.userNameField = UITextField()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssert(testObject.originalUserName == "username not loaded...this is here to fail validation")
        XCTAssert(testObject.originalPhone == "phone num not loaded")
        XCTAssert(testObject.originalEmail == "email addr not loaded")
        XCTAssert(testObject.currentUser == PFUser.currentUser()!)
    }
    
    func testViewDidLoad(){
        testObject.viewDidLoad()
        XCTAssert(testObject.phoneField.text == testObject.currentUser.valueForKey("phone") as? String)
        XCTAssert(testObject.emailField.text == testObject.currentUser.email)
        XCTAssert(testObject.userNameField.text == testObject.currentUser.username)
        
    }
    
    //Other functionality is tested via UI testing
    
    
}
