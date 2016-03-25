//
//  MyOrdersUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/1/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class MyOrdersUnitTests: XCTestCase {
    
    var viewController: MyOrdersViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("myOrders") as! MyOrdersViewController
    }
    
    func test_Instantiation() {
        XCTAssertNotNil(viewController)
        
        let currentUser = PFUser.currentUser()!
        XCTAssertEqual(currentUser, viewController.user)
        
        XCTAssertNotNil(viewController.ordersISent)
        XCTAssertNotNil(viewController.ordersIReceived)
        XCTAssertNil(viewController.current)
    }
    
    func testLoggedIn() {
        XCTAssertNotNil(PFUser.currentUser())
    }
    
    func testOrdersISentNotNil() {
        XCTAssertNotNil(viewController.ordersISent)
    }
    
    func testOrdersIReceivedNotNil() {
        XCTAssertNotNil(viewController.ordersIReceived)
    }
    
    func testOrdersISentPopulated() {
        //check that orders i sent have been properly created in the table
        for i in 0..<viewController.ordersISent.count{
            XCTAssertNotNil(viewController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)))
        }
        
    }
    
    func testOrdersIReceivedPopulated() {
        //check that orders i received have been properly created in the table
        for i in 0..<viewController.ordersIReceived.count {
            XCTAssertNotNil(viewController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 1)))
        }
        
    }
    
    func testMakeSentenceCase() {
        var test = ""
        viewController.makeSentenceCase(&test)
        XCTAssert(test == "")
        test = "test"
        viewController.makeSentenceCase(&test)
        XCTAssert(test == "Test")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
