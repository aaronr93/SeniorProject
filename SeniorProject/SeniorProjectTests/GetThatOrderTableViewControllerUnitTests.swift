//
//  GetThatOrderTableViewControllerUnitTests.swift
//  SeniorProject
//
//  Created by Zach Nafziger on 3/6/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import XCTest
@testable import SeniorProject
import Parse
import Bolts

class GetThatOrderTableViewControllerUnitTests: XCTestCase {
    var viewController: GetThatOrderTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("getThatOrder") as! GetThatOrderTableViewController
        
        viewController.order.orderID = "6cnOqhQqBC"
        viewController.order.deliverToID = "dhCgFcy0zd"
        viewController.order.deliverTo = "aaronr"
        viewController.order.isAnyDriver = false
        viewController.order.orderState = OrderState.Available
        viewController.order.destination = Destination(name: "My house", id: "jzLz3rLq0A")
        viewController.order.restaurant = Restaurant(name: "Pilot Travel Center")
        viewController.order.restaurant.loc = PFGeoPoint(latitude: 37.388702, longitude: -79.90052)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        viewController.order = Order()
    }
    
    func test_Instantiate() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("getThatOrder") as! GetThatOrderTableViewController

        XCTAssertNotNil(vc.order)
    }
   
    //fetching an order
    func testGetThatOrder(){
        //test fetching an order
        
        let readyExpectation = expectationWithDescription("ready")
        
        //initially the order should be available
        XCTAssert(viewController.order.orderState == OrderState.Available)
        viewController.order.acquire() {
            success in
            XCTAssertTrue(success)
            readyExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
        XCTAssertTrue(viewController.order.orderState == OrderState.Acquired)
    }
    
    //paying for an order
    func testPayForOrder(){
        //test paying for an order
        
        let readyExpectation = expectationWithDescription("ready")
        let currentUser = PFUser.currentUser()!
        
        //initially the order should be acquired
        viewController.order.orderState == OrderState.Acquired
        viewController.order.deliveredBy = currentUser.username!
        viewController.order.deliveredByID = currentUser.objectId!

        viewController.order.payFor() {
            success in
            XCTAssertTrue(success)
            readyExpectation.fulfill()
        }
       
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
        XCTAssert(self.viewController.order.orderState == OrderState.PaidFor)

        
    }
   
    
}
