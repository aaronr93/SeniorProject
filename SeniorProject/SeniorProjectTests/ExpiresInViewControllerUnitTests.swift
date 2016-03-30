//
//  ExpiresInViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/24/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class ExpiresInViewControllerUnitTests: XCTestCase {
    
    let testObject = ExpiresInViewController()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        XCTAssertNotNil(testObject)
        XCTAssertNotNil(testObject.timePickerData)
        XCTAssertNotNil(testObject.selectedTime)
        XCTAssert(testObject.selectedTime == "15 Minutes")
    }
    
    //nothing that can be tested with viewDidLoad

    

}