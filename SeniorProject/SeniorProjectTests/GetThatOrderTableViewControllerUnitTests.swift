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

class GetThatOrderTableViewControllerUnitTests: XCTestCase {
    var viewController: GetThatOrderTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Parse.setApplicationId("j28gc7OUqKZFc47nvyoRDPnZnaCRqh3mV8RiULMK", clientKey: "Il9Xid8E9BI7G6pkwUUQLKSO0kL9FKtwNtlSL1O3")
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("getThatOrder") as! GetThatOrderTableViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   
    //fetching an order
    func testGetThatOrder(){
        //test fetching an order
    }
    
    //paying for an order
    func testPayForOrder(){
        //test paying for an order
    }
   
    
}
