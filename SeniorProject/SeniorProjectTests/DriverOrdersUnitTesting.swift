//
//  DriverOrdersUnitTesting.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/4/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse

class DriverOrdersUnitTesting: XCTestCase {
    
    var viewController: DriverOrdersViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("driverOrders") as! DriverOrdersViewController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoggedIn(){
        XCTAssertNotNil(PFUser.currentUser())
    }
    
    func testDriverOrdersNotNil(){
        //check that the driverOrders object has been created
        XCTAssertNotNil(viewController.driverOrders)
    }
    
    func testAnyDriverOrdersNotNil(){
        //check that the anyDriverOrders object has been created
        XCTAssertNotNil(viewController.anyDriverOrders)
    }
    
    func testDriverCellsPopulated(){
        //check that the orders for me section has been populated according to the driverOrders object
        for i in 0..<viewController.driverOrders.count{
            let cell = viewController.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! OrderCell
            //check something is actually in the label text
            XCTAssertNotNil(cell.recipient.text)
            XCTAssertNotNil(cell.restaurant.text)
            
            //check that it is equal to what is in the driverOrders object
            XCTAssert(cell.recipient.text == viewController.driverOrders[i]["recipient"] as? String)
            XCTAssert(cell.restaurant.text == viewController.driverOrders[i]["restaurant"] as? String)
            
        }
        
    }
    func testAnyDriverCellsPopulated(){
        //check that the orders for me section has been populated according to the anyDriverOrders object
        for i in 0..<viewController.driverOrders.count{
            let cell = viewController.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! OrderCell
            //check something is actually in the label text
            XCTAssertNotNil(cell.recipient.text)
            XCTAssertNotNil(cell.restaurant.text)
            
            //check that it is equal to what is in the anyDriverOrders object
            XCTAssert(cell.recipient.text == viewController.anyDriverOrders[i]["recipient"] as? String)
            XCTAssert(cell.restaurant.text == viewController.anyDriverOrders[i]["restaurant"] as? String)
            
        }
    }
    
}
