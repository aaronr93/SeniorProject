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
        
        self.viewController.order.orderID = "vs9XmIjDNL"
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   
    //fetching an order
    func testGetThatOrder(){
        //test fetching an order
        
        //initially the order should be available
        XCTAssert(viewController.order.orderState == OrderState.Available)
        viewController.order.acquire(){
            result in
            XCTAssert(self.viewController.order.orderState == OrderState.Acquired)
        }
        
        
    }
    
    //paying for an order
    func testPayForOrder(){
        //test paying for an order
        
        //initially the order should be available
        XCTAssert(viewController.order.orderState == OrderState.Available)
        
        //order has to be acquired before it can be paid for
        viewController.order.acquire(){
            result in
            result
        }
        XCTAssert(viewController.order.orderState == OrderState.Acquired)
        
        viewController.order.payFor(){
            result in
            XCTAssert(self.viewController.order.orderState == OrderState.PaidFor)
        }
       
        
    }
   
    
}
