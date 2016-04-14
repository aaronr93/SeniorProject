//
//  ChangePasswordViewControllerUnitTests.swift
//  Foodini
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class ChangePasswordViewControllerUnitTests: XCTestCase {
    let testVC = ChangePasswordViewController()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testVC.currentPasswordField = UITextField()
        testVC.newPasswordField = UITextField()
        testVC.confirmPassword = UITextField()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testVC.currentPasswordField)
        XCTAssertNotNil(testVC.newPasswordField)
        XCTAssertNotNil(testVC.confirmPassword)
    }
    
    func testViewDidLoad(){
        testVC.viewDidLoad()
        XCTAssertTrue(testVC.currentPasswordField.borderStyle == .None)
        XCTAssertTrue(testVC.newPasswordField.borderStyle == .None)
        XCTAssertTrue(testVC.confirmPassword.borderStyle == .None)
    }
    
    //from the research I've done, it looks like testing first responder may not be possible, thus the currentPasswordEdit, etc. functions can't be tested through unit testing
    
}
