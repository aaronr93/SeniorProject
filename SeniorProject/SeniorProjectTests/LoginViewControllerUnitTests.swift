//
//  LoginViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 4/9/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
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
        let badColor: UIColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 0.3 )
        showBadInputWarningInField(testField)
        let result = CGColorEqualToColor(testField.layer.backgroundColor, badColor.CGColor)
        XCTAssertTrue(result)
    }
    
    func testShowGoodInput(){
        let testField = UITextField()
        let goodColor: UIColor = UIColor(red: 0, green: 0.9, blue: 0, alpha: 0.3 )
        showGoodInputInField(testField)
        let result = CGColorEqualToColor(testField.layer.backgroundColor, goodColor.CGColor)
        XCTAssertTrue(result)
    }
    
    func testRemoveInputHighlight(){
        let testField = UITextField()
        let goodColor: UIColor = UIColor.whiteColor()
        removeInputHighlightInField(testField)
        let result = CGColorEqualToColor(testField.layer.backgroundColor, goodColor.CGColor)
        XCTAssertTrue(result)
    }
    
    func testViewDidLoad(){
        testVC.viewDidLoad()
        XCTAssertEqual(testVC.usernameField.borderStyle, UITextBorderStyle.None)
        XCTAssertEqual(testVC.passwordField.borderStyle, UITextBorderStyle.None)
    }
    
    //login can't easily be unit tested since it calls asynchronous functions and doesn't return anything, but the functions it calls are tested and it is tested through UI testing
    
    
}
