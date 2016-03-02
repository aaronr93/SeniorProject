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
    
    var viewController : MyOrdersViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyOrdersViewController") as! MyOrdersViewController
    }
    
    func checkLoggedIn(){
        XCTAssertNotNil(PFUser.currentUser())
    }
    
    func checkOrdersISentNotNil(){
        XCTAssertNotNil(viewController.ordersISent)
    }
    
    func checkOrdersIReceivedNotNil(){
        XCTAssertNotNil(viewController.ordersIReceived)
    }
    
    func checkOrdersISentPopulated(){
        //check that orders i sent have been properly created in the table
        for i in 0..<viewController.ordersISent.count{
            XCTAssertNotNil(viewController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)))
        }
        
    }
    
    func checkOrdersIReceivedPopulated(){
        //check that orders i received have been properly created in the table
        for i in 0..<viewController.ordersIReceived.count{
            XCTAssertNotNil(viewController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 1)))
        }
        
    }
    
    func checkMakeSentenceCase(){
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
