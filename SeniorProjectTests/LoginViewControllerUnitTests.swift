//
//  LoginViewControllerUnitTests.swift
//  Foodini
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class LoginViewControllerUnitTests: XCTestCase {
    let testVC = LogInViewController()
    override func setUp() {
        super.setUp()
        testVC.usernameField = UITextField()
        testVC.passwordField = UITextField()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantation(){
        XCTAssertNotNil(testVC.usernameField)
        XCTAssertNotNil(testVC.passwordField)
    }
    
    func testShowBadInputWarning(){
        let testField = UITextField()
        showBadInputWarningInField(testField)
        XCTAssertNotNil(testField)
    }
    
    func testShowGoodInput(){
        let testField = UITextField()
        showGoodInputInField(testField)
        XCTAssertNotNil(testField)
    }
    
    func testViewDidLoad(){
        testVC.viewDidLoad()
        XCTAssertEqual(testVC.usernameField.borderStyle, UITextBorderStyle.None)
        XCTAssertEqual(testVC.passwordField.borderStyle, UITextBorderStyle.None)
    }
    
    //login can't easily be unit tested since it calls asynchronous functions and doesn't return anything, but the functions it calls are tested and it is tested through UI testing
    
    
}
