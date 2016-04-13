//
//  DeliveryLocationTableViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/31/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import Foodini
import Parse

class DeliveryLocationTableViewControllerUnitTests: XCTestCase {
    let testObject = DeliveryLocationTableViewController()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiation(){
        //destination and delegate should be set by another viewcontroller
        XCTAssertNotNil(testObject.selectIndex)
        XCTAssertNotNil(testObject.dest)
        XCTAssertNotNil(testObject.user)
    }
    
    //nothing additional to test for ViewDidLoad
    
    //nothing else that can easily be tested in unit testing
    
}
